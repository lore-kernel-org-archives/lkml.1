Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbYI3VKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbYI3VKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 17:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbYI3VKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 17:10:25 -0400
Received: from relais.videotron.ca ([24.201.245.36]:25886 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbYI3VKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 17:10:25 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Tue, 30 Sep 2008 17:09:49 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: wrong usage of MAX_DMA_ADDRESS in bootmem.h
In-reply-to: <20080930201224.GL15911@flint.arm.linux.org.uk>
Message-id: <alpine.LFD.2.00.0809301648240.3635@xanadu.home>
References: <1222230419-15661-21-git-send-email-nico@cam.org>
 <1222230592-15868-1-git-send-email-nico@cam.org>
 <20080930162809.GD15911@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.0809301409230.3635@xanadu.home>
 <20080930184411.GJ15911@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.0809301513260.3635@xanadu.home>
 <48E2846A.4030802@linux-foundation.org>
 <20080930201224.GL15911@flint.arm.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2008, Russell King - ARM Linux wrote:

> As we have already covered in the past, CONFIG_ZONE_DMA has to always
> be enabled on ARM because ARM always puts all memory in the first zone.
> To do otherwise introduces lots of special cases, and I steadfastly
> refuse to make the memory initialisation any more complicated than it
> already is.

I just tried this:

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 70dba16..8f609cc 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -148,7 +148,6 @@ config ARCH_MAY_HAVE_PC_FDC
 
 config ZONE_DMA
 	bool
-	default y
 
 config GENERIC_ISA_DMA
 	bool

with no other changes what so ever.  And the resulting kernel still 
works fine, with this difference:

|On node 0 totalpages: 131072
|free_area_init_node: node 0, pgdat c03c5e00, node_mem_map c03e7000
|  Normal zone: 130048 pages, LIFO batch:31

instead of:

|On node 0 totalpages: 131072
|free_area_init_node: node 0, pgdat c03c7e58, node_mem_map c03e9000
|  DMA zone: 130048 pages, LIFO batch:31

And the resulting kernel is also smaller:

|   text    data     bss     dec     hex filename
|3826182  102384  111700 4040266  3da64a vmlinux
|3823593  101616  111700 4036909  3d992d vmlinux.nodmazone

So maybe CONFIG_DMA_ZONE could be selected only by those machines 
actually defining arch_adjust_zones() ?

> And besides, this has nothing to do with that issue.

Indeed.  But still...


Nicolas
