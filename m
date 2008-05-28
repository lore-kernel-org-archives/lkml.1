Return-Path: <linux-kernel-owner+w=401wt.eu-S1754260AbYE1KC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260AbYE1KC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 06:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbYE1KCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 06:02:21 -0400
Received: from gw.goop.org ([64.81.55.164]:53966 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbYE1KCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 06:02:21 -0400
Message-ID: <483D2D8A.5040800@goop.org>
Date: Wed, 28 May 2008 11:01:46 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: extend e820 ealy_res support 32bit - fix #2
References: <200805110030.15510.yhlu.kernel@gmail.com>	 <200805180118.57863.yhlu.kernel@gmail.com>	 <200805211840.18619.yhlu.kernel@gmail.com>	 <200805251000.10205.yhlu.kernel@gmail.com>	 <alpine.LFD.1.10.0805271744080.3295@apollo.tec.linutronix.de>	 <483C70F9.2030901@goop.org>	 <86802c440805271406l4348db33r5622c440b494baa2@mail.gmail.com>	 <483C7BB0.6080901@goop.org>	 <86802c440805271435l744eab84xe55ac9ce6196c03b@mail.gmail.com>	 <483C8157.7080702@goop.org> <86802c440805271552k724415a6i66686b9abb8c083f@mail.gmail.com>
In-Reply-To: <86802c440805271552k724415a6i66686b9abb8c083f@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>
> can you try attached patch?
>   

Thanks, that nearly works.  I needed the patch below to get it to 
successfully boot.

For reference, this is what the early reserve map looks like now:

(early) 256MB LOWMEM available.
(early)   low ram: 02634000 - 10000000
(early)   bootmap 02634000 - 02636000
(early)   early res: 0 [0-fff] BIOS data page
(early)   early res: 1 [1000-1fff] EX TRAMPOLINE
(early)   early res: 2 [6000-6fff] TRAMPOLINE
(early)   early res: 3 [25db000-261dfff] XEN
(early)   early res: 4 [1000000-18a8303] TEXT DATA BSS
(early)   early res: 5 [18a9000-25dafff] RAMDISK
(early)   early res: 6 [261e000-2633fff] INIT_PG_TABLE
(early)   early res: 7 [2634000-2635fff] BOOTMAP


    J


Subject: xen: reserve_early Xen-specific memory

Make sure that the start_info and pfn->mfn translation array are reserved.
i386_start_kernel will arrange to reserve the kernel code/data, initrd
and pagetable.

Also, add prototype for i386_start_kernel.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |    9 +++++++++
 include/asm-x86/setup.h  |    1 +
 2 files changed, 10 insertions(+)

===================================================================
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1266,6 +1266,15 @@
 		add_preferred_console("hvc", 0, NULL);
 	}
 
+	/*
+	 * Reserve Xen bits:
+	 *  - mfn_list
+	 *  - xen_start_info
+	 * See comment above "struct start_info" in <xen/interface/xen.h>
+	 */
+	reserve_early(__pa(xen_start_info->mfn_list),
+		      __pa(xen_start_info->pt_base), "XEN");
+
 	/* Start the world */
 	i386_start_kernel();
 }
===================================================================
--- a/include/asm-x86/setup.h
+++ b/include/asm-x86/setup.h
@@ -58,6 +58,7 @@
 int __init copy_e820_map(struct e820entry *biosmap, int nr_map);
 void __init add_memory_region(unsigned long long start,
 			      unsigned long long size, int type);
+void __init i386_start_kernel(void);
 
 extern unsigned long init_pg_tables_start;
 extern unsigned long init_pg_tables_end;


