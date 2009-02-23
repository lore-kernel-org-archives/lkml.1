Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbZBWXVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbZBWXVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 18:21:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbZBWXVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 18:21:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:59970 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbZBWXVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 18:21:42 -0500
Message-ID: <49A32F40.7080403@kernel.org>
Date: Mon, 23 Feb 2009 15:20:32 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: check range in reserve_early()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

one 32bit system report:

BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001c000000 (usable)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
DMI 2.0 present.
last_pfn = 0x1c000 max_arch_pfn = 0x100000
kernel direct mapping tables up to 1c000000 @ 7000-c000
...
RAMDISK: 1bc69000 - 1bfef4fa
...
0MB HIGHMEM available.
448MB LOWMEM available.
  mapped low ram: 0 - 1c000000
  low ram: 00000000 - 1c000000
  bootmap 00002000 - 00005800
(9 early reservations) ==> bootmem [0000000000 - 001c000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0000400000 - 00009ed14c]    TEXT DATA BSS ==> [0000400000 - 00009ed14c]
  #4 [001bc69000 - 001bfef4fa]          RAMDISK ==> [001bc69000 - 001bfef4fa]
  #5 [00009ee000 - 00009f2000]    INIT_PG_TABLE ==> [00009ee000 - 00009f2000]
  #6 [000009f400 - 0000100000]    BIOS reserved ==> [000009f400 - 0000100000]
  #7 [0000007000 - 0000007000]          PGTABLE
  #8 [0000002000 - 0000006000]          BOOTMAP ==> [0000002000 - 0000006000]

got strange blank entry with PGTABLE

the reason is init_pg_table is big enough, and zero range is called with
init_memory_mapping/reserve_early()

so try to check the range in reserve_early()

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/e820.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -858,6 +858,9 @@ void __init reserve_early_overlap_ok(u64
  */
 void __init reserve_early(u64 start, u64 end, char *name)
 {
+	if (start <= end)
+		return;
+
 	drop_overlaps_that_are_ok(start, end);
 	__reserve_early(start, end, name, 0);
 }
