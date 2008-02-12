Return-Path: <linux-kernel-owner+w=401wt.eu-S1764722AbYBLUtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764722AbYBLUtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 15:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752876AbYBLUtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 15:49:10 -0500
Received: from www.tglx.de ([62.245.132.106]:57616 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbYBLUtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 15:49:09 -0500
Date: Tue, 12 Feb 2008 21:48:45 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: ying.huang@intel.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [8/8] RFC: Fix some EFI problems
In-Reply-To: <200802122123.08732.ak@suse.de>
Message-ID: <alpine.LFD.1.00.0802122145050.12988@apollo.tec.linutronix.de>
References: <200802111034.764275766@suse.de> <20080211093436.EAFB11B41CE@basil.firstfloor.org> <alpine.LFD.1.00.0802122043460.12988@apollo.tec.linutronix.de> <200802122123.08732.ak@suse.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008, Andi Kleen wrote:

> On Tuesday 12 February 2008 21:04:06 Thomas Gleixner wrote:
> 
> > 
> > And you just copied the real bug in that logic as well:
> > 
> >           set_memory_uc(md->virt_addr, size);
> 
> Oops you're right. I wanted to fix that, but didn't. Ok I'll put up
> my brown paper back tonight when I go out.
>  
> > ------------------------^^^^^^^^
> > 
> > which is initialized a couple of lines down.
> > 
> > 	md->virt_addr = (u64) (unsigned long) va;
> > 
> > The reordering/optimizing needs to be a separate patch.
> 
> What optimizing? It wasn't intended to be an optimization.
> It fixes a bug.

No, it does not. Please go back and read my mail.
 
The code had exactly two bugs:

1) the logic of checking EFI_MEMORY_WB was wrong
2) the uninitialized variable

The fix is:

 arch/x86/kernel/efi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/kernel/efi.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/efi.c
+++ linux-2.6/arch/x86/kernel/efi.c
@@ -428,9 +428,6 @@ void __init efi_enter_virtual_mode(void)
 		else
 			va = efi_ioremap(md->phys_addr, size);
 
-		if (md->attribute & EFI_MEMORY_WB)
-			set_memory_uc(md->virt_addr, size);
-
 		md->virt_addr = (u64) (unsigned long) va;
 
 		if (!va) {
@@ -439,6 +436,9 @@ void __init efi_enter_virtual_mode(void)
 			continue;
 		}
 
+		if (!(md->attribute & EFI_MEMORY_WB))
+			set_memory_uc(md->virt_addr, size);
+
 		systab = (u64) (unsigned long) efi_phys.systab;
 		if (md->phys_addr <= systab && systab < end) {
 			systab += md->virt_addr - md->phys_addr;

The reordering of code is completely irrelevant. It can be done, but
in a separate patch.

Thanks,

	tglx
