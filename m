Return-Path: <linux-kernel-owner+w=401wt.eu-S1751898AbZBNJI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbZBNJI2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 04:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750931AbZBNJIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 04:08:13 -0500
Received: from gate.crashing.org ([63.228.1.57]:40415 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbZBNJIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 04:08:09 -0500
Subject: Re: [PATCH 1/5]: drm: ati_pcigart: Do not access I/O MEM space
 using pointer derefs.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
Cc: airlied@linux.ie, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090213.220934.236067646.davem@davemloft.net>
References: <20090212.021527.12463602.davem@davemloft.net>
	 <1234434959.29851.55.camel@pasglop>
	 <20090213.220934.236067646.davem@davemloft.net>
Content-Type: text/plain
Date: Sat, 14 Feb 2009 20:07:54 +1100
Message-Id: <1234602474.26036.83.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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

That makes me wonder how the heck did it work for me ! Or maybe... I've
been using an R5xx which happens to have a bit that I haven't seen on
R3xx that allows ... to set whether the GART reads come from HDP or
directly from MC. That might be what saved my ass here.

> I have no idea how to handle this properly.  Not only does the Xorg
> ATI driver set the swapping settings at an arbitray point, it also
> mucks with them dynamically f.e. in the render helper functions.
> 
> The only way this can work properly is to choose one surface swapping
> setting, set the VRAM GART table so that the GART sees the PTEs in the
> correct format, and retain those settings throughout.

We can do that by registering a surface from the kernel to cover the
GART I suppose, and clean things a bit so that when using the DRI, X
doesn't touch the surface registers -at all- and leaves it to the
kernel.

> It seems like, in at least R5xx, they tried to add a control bit in
> the PCI-E GART registers to handle this.  Bit 6 in PCI-E indirect
> register 0x10 is named 'GART_RDREQPATH_SEL' and has description:
> 
> 	Read request path
> 	 0=HDP
> 	 1=Direct Rd Req to MC

Right. That's the one I was talking about earlier.

> This seems to be intended to be a way to have the GART PTE reads
> bypass the full Host Data Path (and thus potential surface byte
> swaps), by setting this bit to 1.
> 
> I tried doing that, but it doesn't help my RV370 so perhaps older
> chips don't support this bit.  It's hard to tell as this is the area
> where all of AMD's published GPU documents are severely lacking.

Yup.

> I tested whether reading back the PCIE_TX_GART_CNTL register shows
> bit 6 after I try to write it, and it always reads back zero.

Yes, it's likely that they added it after being bitten on Apple or
such :-)

 .../...

> 2) It doesn't check the surface byte swapping settings, so it
>    could be saving in one byte order and restoing in another.
> 
>    I guess we could force RADEON_SURFACE_CNTL to zero around
>    the two memcpy()'s done in radeon_driver.c

Either that or have the kernel do it... (ioctl's ?) which would be more
in the spirit of moving toward KMS and would avoid those blunders ...
That's my preferred approach.

But if we want to stick to the current mess, and we have a bolted
surface covering the GART, it would work fine as long as the restore
path ensures the DRM restores all surfaces before it loads it back into
vram, ie, same setting on save/restore, userspace doesn't have to care
what the swapper actually is.

> But really this whole area is a mess, and I know KMS is coming to fix
> this, but even in the traditional XORG/DRM layout XORG has no business
> keeping the GART table uptodate across VT switches.  It should be
> calling into the DRM with an ioctl to write the GART table out to VRAM
> again.

Preferably. Shouldn't even be hard in fact. Again, I haven't hit it on
my r500 tests because I let X POST the card and basically have nothing
on the VTs. I don't have a PCI-E R300 to test with, though there is
-one- model of iMac G5 with such a thing, and guess what ? It's been
troublesome for ages, though I never managed to get my hand on one to
actually debug it. It might just all be the same issues.

> Finally there is a huge issue with how the Xorg ATI driver resets the
> chip using the RBBM.  It soft resets the CP, but this resets the ring
> read pointer.  However, nothing is done to make sure the DRM resync's
> the ring write pointer (which remains unchanged by a soft CP reset) as
> well as it's internal software ring state.

Same as above, it should just not do it when the DRI's around. Just fire
an ioctl if necessary and let the DRM do it. But if it's going to do it,
bracketing it in CP stop/resume might do the trick.

> The result is that on the very next CP command submission, the CP
> re-executes everything from ring entry zero until wherever the DRM
> things the write pointer was at the time of the CP soft reset.
> 
> Any time the Xorg ATI driver does a CP soft reset, it should do
> CP stop and resume calls to the DRM to resync the ring pointers.
> And this does not appear to be happening where it needs to be
> happening.

Heh, looks like we're on the same mind set :-)

Ben.


