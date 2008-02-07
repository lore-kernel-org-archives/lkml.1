Return-Path: <linux-kernel-owner+w=401wt.eu-S1759783AbYBGEQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759783AbYBGEQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 23:16:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755029AbYBGEQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 23:16:25 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:52560 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831AbYBGEQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 23:16:22 -0500
Date: Wed, 06 Feb 2008 20:23:30 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: clean up find_e820_area
In-reply-to: <200802062022.44069.yinghai.lu@sun.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802062023.30427.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802061246.43413.yinghai.lu@sun.com>
 <20080206231226.GA6417@elte.hu> <200802062022.44069.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: clean up find_e820_area

change size to unsigned long, becase caller and user all used unsigned long.
also make bad_addr take align.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>


Index: linux-2.6/arch/x86/kernel/e820_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_64.c
+++ linux-2.6/arch/x86/kernel/e820_64.c
@@ -95,7 +95,7 @@ void __init early_res_to_bootmem(void)
 }
 
 /* Check for already reserved areas */
-static inline int bad_addr(unsigned long *addrp, unsigned long size)
+static inline int bad_addr(unsigned long *addrp, unsigned long size, unsigned long align)
 {
 	int i;
 	unsigned long addr = *addrp, last;
@@ -105,7 +105,7 @@ again:
 	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
 		struct early_res *r = &early_res[i];
 		if (last >= r->start && addr < r->end) {
-			*addrp = addr = r->end;
+			*addrp = addr = round_up(r->end, align);
 			changed = 1;
 			goto again;
 		}
@@ -174,26 +174,27 @@ int __init e820_all_mapped(unsigned long
  * Find a free area with specified alignment in a specific range.
  */
 unsigned long __init find_e820_area(unsigned long start, unsigned long end,
-				    unsigned size, unsigned long align)
+				    unsigned long size, unsigned long align)
 {
 	int i;
-	unsigned long mask = ~(align - 1);
 
 	for (i = 0; i < e820.nr_map; i++) {
 		struct e820entry *ei = &e820.map[i];
-		unsigned long addr = ei->addr, last;
+		unsigned long addr, last;
+		unsigned long ei_last;
 
 		if (ei->type != E820_RAM)
 			continue;
+		addr = round_up(ei->addr, align);
+		ei_last = ei->addr + ei->size;
 		if (addr < start)
-			addr = start;
-		if (addr > ei->addr + ei->size)
+			addr = round_up(start, align);
+		if (addr > ei_last)
 			continue;
-		while (bad_addr(&addr, size) && addr+size <= ei->addr+ei->size)
+		while(bad_addr(&addr, size, align) && addr+size <= ei_last)
 			;
-		addr = (addr + align - 1) & mask;
 		last = addr + size;
-		if (last > ei->addr + ei->size)
+		if (last > ei_last)
 			continue;
 		if (last > end)
 			continue;
Index: linux-2.6/include/asm-x86/e820_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820_64.h
+++ linux-2.6/include/asm-x86/e820_64.h
@@ -15,7 +15,7 @@
 
 #ifndef __ASSEMBLY__
 extern unsigned long find_e820_area(unsigned long start, unsigned long end, 
-				    unsigned size, unsigned long align);
+				    unsigned long size, unsigned long align);
 extern void add_memory_region(unsigned long start, unsigned long size, 
 			      int type);
 extern void setup_memory_region(void);
