Return-Path: <linux-kernel-owner+w=401wt.eu-S1755515AbYEXJub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbYEXJub (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 05:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754051AbYEXJuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 05:50:22 -0400
Received: from gw.goop.org ([64.81.55.164]:33138 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372AbYEXJuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 05:50:22 -0400
Message-ID: <4837E4BF.6050604@goop.org>
Date: Sat, 24 May 2008 10:49:51 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen: boot via i386_start_kernel to get early reservations
References: <200805110030.15510.yhlu.kernel@gmail.com> <200805180118.57863.yhlu.kernel@gmail.com> <200805211840.18619.yhlu.kernel@gmail.com> <200805221520.19259.yhlu.kernel@gmail.com> <4837D7DD.7000204@goop.org>
In-Reply-To: <4837D7DD.7000204@goop.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boot Xen via i386_start_kernel so that all the early reservations are
made properly; without these, it will start using the kernel and
pagetables as early heap memory, which is a bit suboptimal.

One tricky part is that reserve_early() will just panic if any of the
early reservations overlap any others.  When a Xen domain is built, it
constructs the initial address space as:

  kernel text+data+bss
  initrd
  initial pagetable

Therefore, when reserving the pagetable (from &_end to
init_pg_tables_end), it covers the whole initrd area.  If it then
tries to reserve the initrd, it will panic because of the overlap.

The simple fix here is to reserve INIT_PG_TABLE first, and then only
reserve the ramdisk if it doesn't overlap with the previous
reservations.  A better/more complex fix might be to make
reserve_early() deal with overlapping reservations.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/head32.c |    6 ++++--
 arch/x86/xen/enlighten.c |    2 +-
 include/asm-x86/setup.h  |    1 +
 3 files changed, 6 insertions(+), 3 deletions(-)

===================================================================
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -66,6 +66,7 @@ void __init i386_start_kernel(void)
 void __init i386_start_kernel(void)
 {
 	reserve_early(__pa_symbol(&_text), __pa_symbol(&_end), "TEXT DATA BSS");
+	reserve_early(__pa_symbol(&_end), init_pg_tables_end, "INIT_PG_TABLE");
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	/* Reserve INITRD */
@@ -73,10 +74,11 @@ void __init i386_start_kernel(void)
 		u64 ramdisk_image = boot_params.hdr.ramdisk_image;
 		u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
 		u64 ramdisk_end   = ramdisk_image + ramdisk_size;
-		reserve_early(ramdisk_image, ramdisk_end, "RAMDISK");
+		if (ramdisk_end <= __pa_symbol(&_text) ||
+		    ramdisk_image > init_pg_tables_end)
+			reserve_early(ramdisk_image, ramdisk_end, "RAMDISK");
 	}
 #endif
-	reserve_early(__pa_symbol(&_end), init_pg_tables_end, "INIT_PG_TABLE");
 
 	reserve_ebda_region();
 
===================================================================
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1264,5 +1264,5 @@ asmlinkage void __init xen_start_kernel(
 	}
 
 	/* Start the world */
-	start_kernel();
+	i386_start_kernel();
 }
===================================================================
--- a/include/asm-x86/setup.h
+++ b/include/asm-x86/setup.h
@@ -58,6 +58,7 @@ int __init copy_e820_map(struct e820entr
 int __init copy_e820_map(struct e820entry *biosmap, int nr_map);
 void __init add_memory_region(unsigned long long start,
 			      unsigned long long size, int type);
+void __init i386_start_kernel(void);
 
 extern unsigned long init_pg_tables_end;
 


