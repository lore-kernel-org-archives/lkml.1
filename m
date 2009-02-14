Return-Path: <linux-kernel-owner+w=401wt.eu-S1752724AbZBNHmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbZBNHmT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 02:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbZBNHmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 02:42:07 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:52054 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbZBNHmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 02:42:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cpZ8lUjB+QSjbJ3gq9z1ZRzdEXyVvJNC2wYgRwiJnOivDvUmroAOlOXC0CwLD91mZo
         8U4a3iNuEnATRSYGAstuQ88D9TtZUN0u8sf4ClJQaQhJ+sks4a0l1Iib9x/lVBQRKC9s
         gDl4jXRIDxo2G7ZyBt8QfkAokcB6vAYyp56rE=
MIME-Version: 1.0
In-Reply-To: <20090213.220934.236067646.davem@davemloft.net>
References: <20090212.021527.12463602.davem@davemloft.net>
	 <1234434959.29851.55.camel@pasglop>
	 <20090213.220934.236067646.davem@davemloft.net>
Date: Sat, 14 Feb 2009 17:42:02 +1000
Message-ID: <21d7e9970902132342k1a756475t91ede4baf571c563@mail.gmail.com>
Subject: Re: [PATCH 1/5]: drm: ati_pcigart: Do not access I/O MEM space using 
	pointer derefs.
From: Dave Airlie <airlied@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: benh@kernel.crashing.org, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 14, 2009 at 4:09 PM, David Miller <davem@davemloft.net> wrote:
> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Date: Thu, 12 Feb 2009 21:35:59 +1100
>
>> Oh BTW something else to be careful with, though I suppose it's working
>> some what by accident right now... when the GART is in the frame buffer
>> it gets applied the current fb swapper setting... ouch !
>>
>> So it might be a good idea, if we're going to use DRM_READ/WRITE32 which
>> afaik are readl/writel (ie, swapping) to make sure we at least
>> temporarily disable that swapper while whacking the GART.
>
> So I've narrowed down the final problems I'm having.  It's the surface
> swapping settings indeed.
>
> Running Xorg at depth 8, the CP can execute indirect buffers just
> fine, no code changes necessary.
>
> However, the CP hangs on indirect execution for depth 16 and 24.  But
> these depths work if I hard disable the surface byte swapping settings
> in the radeon Xorg driver.
>
> I did some research, and it does appear that the GART does read the
> PTEs from the VRAM using the Host Data Path.  This means the surface
> control byte swapping settings are applied.
>
> So for depths of 16 and 24, the GART is reading garbage PTEs.  And
> that's why the CP hangs.

Wow that is ugly, truly ugly. I'm going to say I've little idea how to
fix this outside KMS,

The only think I can think to do is use a surface instead of the
aperture swappers
and make the surface cover all the VRAM except the GART table which is
at the end.

> I have no idea how to handle this properly.  Not only does the Xorg
> ATI driver set the swapping settings at an arbitray point, it also
> mucks with them dynamically f.e. in the render helper functions.
>
> The only way this can work properly is to choose one surface swapping
> setting, set the VRAM GART table so that the GART sees the PTEs in the
> correct format, and retain those settings throughout
>
> It seems like, in at least R5xx, they tried to add a control bit in
> the PCI-E GART registers to handle this.  Bit 6 in PCI-E indirect
> register 0x10 is named 'GART_RDREQPATH_SEL' and has description:
>
>        Read request path
>         0=HDP
>         1=Direct Rd Req to MC
>
> This seems to be intended to be a way to have the GART PTE reads
> bypass the full Host Data Path (and thus potential surface byte
> swaps), by setting this bit to 1.
>
> I tried doing that, but it doesn't help my RV370 so perhaps older
> chips don't support this bit.  It's hard to tell as this is the area
> where all of AMD's published GPU documents are severely lacking.

You don't get this bit until rv515 and above so no pony for you.

>
> I tested whether reading back the PCIE_TX_GART_CNTL register shows
> bit 6 after I try to write it, and it always reads back zero.
>
> There are even more complications, the VT enter/exit code in the Xorg
> ATI driver tries to save and restore the VRAM GART table for PCI-E
> cards.  But this:
>
> 1) Mis-sizes the GART table save buffer, it uses PAGE_SIZE instead
>   of the constant 4096 to determine how many GART entries there
>   are.  The PCI GART entries map 4096 bytes, always.  So using
>   getpagesize() is wrong.  (see RADEONDRIGetPciAperTableSize)
>
>   I have this fixed in my local tree.

Oops.

>
> 2) It doesn't check the surface byte swapping settings, so it
>   could be saving in one byte order and restoing in another.
>
>   I guess we could force RADEON_SURFACE_CNTL to zero around
>   the two memcpy()'s done in radeon_driver.c

Might be a good plan.

>
> But really this whole area is a mess, and I know KMS is coming to fix
> this, but even in the traditional XORG/DRM layout XORG has no business
> keeping the GART table uptodate across VT switches.  It should be
> calling into the DRM with an ioctl to write the GART table out to VRAM
> again.

You can draw an arbitrary line anywhere you want really, its all an unholy mess,
ever since people decided userspace drivers were a good idea.

>
> Finally there is a huge issue with how the Xorg ATI driver resets the
> chip using the RBBM.  It soft resets the CP, but this resets the ring
> read pointer.  However, nothing is done to make sure the DRM resync's
> the ring write pointer (which remains unchanged by a soft CP reset) as
> well as it's internal software ring state.
>
> The result is that on the very next CP command submission, the CP
> re-executes everything from ring entry zero until wherever the DRM
> things the write pointer was at the time of the CP soft reset.
>
> Any time the Xorg ATI driver does a CP soft reset, it should do
> CP stop and resume calls to the DRM to resync the ring pointers.
> And this does not appear to be happening where it needs to be
> happening.

That's interesting, it could explain why things never work again after a reset
or at least proceed to hang straight away.

Dave.
