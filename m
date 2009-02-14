Return-Path: <linux-kernel-owner+w=401wt.eu-S1753223AbZBNGJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbZBNGJu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 01:09:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750880AbZBNGJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 01:09:41 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49608
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750727AbZBNGJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 01:09:40 -0500
Date: Fri, 13 Feb 2009 22:09:34 -0800 (PST)
Message-Id: <20090213.220934.236067646.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: airlied@linux.ie, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5]: drm: ati_pcigart: Do not access I/O MEM space
 using pointer derefs.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1234434959.29851.55.camel@pasglop>
References: <20090212.021527.12463602.davem@davemloft.net>
	<1234434959.29851.55.camel@pasglop>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 12 Feb 2009 21:35:59 +1100

> Oh BTW something else to be careful with, though I suppose it's working
> some what by accident right now... when the GART is in the frame buffer
> it gets applied the current fb swapper setting... ouch !
> 
> So it might be a good idea, if we're going to use DRM_READ/WRITE32 which
> afaik are readl/writel (ie, swapping) to make sure we at least
> temporarily disable that swapper while whacking the GART.

So I've narrowed down the final problems I'm having.  It's the surface
swapping settings indeed.

Running Xorg at depth 8, the CP can execute indirect buffers just
fine, no code changes necessary.

However, the CP hangs on indirect execution for depth 16 and 24.  But
these depths work if I hard disable the surface byte swapping settings
in the radeon Xorg driver.

I did some research, and it does appear that the GART does read the
PTEs from the VRAM using the Host Data Path.  This means the surface
control byte swapping settings are applied.

So for depths of 16 and 24, the GART is reading garbage PTEs.  And
that's why the CP hangs.

I have no idea how to handle this properly.  Not only does the Xorg
ATI driver set the swapping settings at an arbitray point, it also
mucks with them dynamically f.e. in the render helper functions.

The only way this can work properly is to choose one surface swapping
setting, set the VRAM GART table so that the GART sees the PTEs in the
correct format, and retain those settings throughout.

It seems like, in at least R5xx, they tried to add a control bit in
the PCI-E GART registers to handle this.  Bit 6 in PCI-E indirect
register 0x10 is named 'GART_RDREQPATH_SEL' and has description:

	Read request path
	 0=HDP
	 1=Direct Rd Req to MC

This seems to be intended to be a way to have the GART PTE reads
bypass the full Host Data Path (and thus potential surface byte
swaps), by setting this bit to 1.

I tried doing that, but it doesn't help my RV370 so perhaps older
chips don't support this bit.  It's hard to tell as this is the area
where all of AMD's published GPU documents are severely lacking.

I tested whether reading back the PCIE_TX_GART_CNTL register shows
bit 6 after I try to write it, and it always reads back zero.

There are even more complications, the VT enter/exit code in the Xorg
ATI driver tries to save and restore the VRAM GART table for PCI-E
cards.  But this:

1) Mis-sizes the GART table save buffer, it uses PAGE_SIZE instead
   of the constant 4096 to determine how many GART entries there
   are.  The PCI GART entries map 4096 bytes, always.  So using
   getpagesize() is wrong.  (see RADEONDRIGetPciAperTableSize)

   I have this fixed in my local tree.

2) It doesn't check the surface byte swapping settings, so it
   could be saving in one byte order and restoing in another.

   I guess we could force RADEON_SURFACE_CNTL to zero around
   the two memcpy()'s done in radeon_driver.c

But really this whole area is a mess, and I know KMS is coming to fix
this, but even in the traditional XORG/DRM layout XORG has no business
keeping the GART table uptodate across VT switches.  It should be
calling into the DRM with an ioctl to write the GART table out to VRAM
again.

Finally there is a huge issue with how the Xorg ATI driver resets the
chip using the RBBM.  It soft resets the CP, but this resets the ring
read pointer.  However, nothing is done to make sure the DRM resync's
the ring write pointer (which remains unchanged by a soft CP reset) as
well as it's internal software ring state.

The result is that on the very next CP command submission, the CP
re-executes everything from ring entry zero until wherever the DRM
things the write pointer was at the time of the CP soft reset.

Any time the Xorg ATI driver does a CP soft reset, it should do
CP stop and resume calls to the DRM to resync the ring pointers.
And this does not appear to be happening where it needs to be
happening.
