Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbYFEOft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbYFEOft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 10:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbYFEOfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 10:35:41 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:42765 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbYFEOfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 10:35:40 -0400
X-BigFish: VPS-13(z2d9boz98dR7efVzz10d3izzz32i6bh43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0K1ZV6Z-02-HP4-01
Date: Thu, 5 Jun 2008 16:35:10 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Jack Steiner <steiner@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix compile warning in io_apic_{32,64}.c
Message-ID: <20080605143510.GA8372@alberich.amd.com>
References: <20080605120557.GB14755@alberich.amd.com> <20080605123910.GA5938@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080605123910.GA5938@sgi.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 05 Jun 2008 14:35:05.0630 (UTC) FILETIME=[58B313E0:01C8C719]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2008 at 02:39:10PM +0200, Jack Steiner wrote:
> I have not seen the compiler warning. What tree/options cause the error???

Sure. It's currently dead code. I use it from time to time for debugging.
At least you have to do something like

diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index ef1a8df..ddfdabd 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -1045,7 +1045,6 @@ void __apicdebuginit print_IO_APIC(void)
        return;
 }
 
-#if 0
 
 static __apicdebuginit void print_APIC_bitfield (int base)
 {
@@ -1181,7 +1180,6 @@ void __apicdebuginit print_PIC(void)
        printk(KERN_DEBUG "... PIC ELCR: %04x\n", v);
 }
 
-#endif  /*  0  */
 
 void __init enable_IO_APIC(void)
 {


to compile it.

> I don't think this work on UV systems. Because of processor limitations, not
> all of the APICID bits are contained in the hardware APIC_ID register. See
> read_apic_id() in arch/x86/kernel/genapic_64.c.

I am not that familar with UV. So can't really comment on that.
But then it seems that the proper adaption for print_local_APIC to avoid the warning is
---
[PATCH] x86: fix compile warning in io_apic_{32,64}.c

Commit 05f2d12c3563dea8c81b301f9f3cf7919af23b13
(x86: change GET_APIC_ID() from an inline function to an out-of-line function)
introduced a compile warning:

arch/x86/kernel/io_apic_64.c: In function 'print_local_APIC':
arch/x86/kernel/io_apic_64.c:1152: warning: 'v' is used uninitialized in this function

in some debug code -- which is disabled by default.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
--
diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index a40d54f..4fbf656 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -1489,6 +1489,7 @@ void /*__init*/ print_local_APIC(void * dummy)
 
 	printk("\n" KERN_DEBUG "printing local APIC contents on CPU#%d/%d:\n",
 		smp_processor_id(), hard_smp_processor_id());
+	v = apic_read(APIC_ID);
 	printk(KERN_INFO "... APIC ID:      %08x (%01x)\n", v,
 			GET_APIC_ID(read_apic_id()));
 	v = apic_read(APIC_LVR);
diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index ef1a8df..c7c6b00 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -1077,6 +1077,7 @@ void __apicdebuginit print_local_APIC(void * dummy)
 
 	printk("\n" KERN_DEBUG "printing local APIC contents on CPU#%d/%d:\n",
 		smp_processor_id(), hard_smp_processor_id());
+	v = apic_read(APIC_ID);
 	printk(KERN_INFO "... APIC ID:      %08x (%01x)\n", v, GET_APIC_ID(read_apic_id()));
 	v = apic_read(APIC_LVR);
 	printk(KERN_INFO "... APIC VERSION: %08x\n", v);





