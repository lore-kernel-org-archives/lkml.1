Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbYIIN4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbYIIN4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 09:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbYIIN4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 09:56:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbYIIN4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 09:56:12 -0400
Date: Tue, 9 Sep 2008 09:56:08 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, dzickus@redhat.com, nhorman@redhat.com,
       vgoyal@redhat.com
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20080909134858.20868.51265.sendpatchset@prarit.bos.redhat.com>
Subject: [PATCH] Fix memmap=exactmap boot argument
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using kdump modifying the e820 map is yielding strange results.

For example starting with

BIOS-provided physical RAM map:
BIOS-e820: 0000000000000100 - 0000000000093400 (usable)
BIOS-e820: 0000000000093400 - 00000000000a0000 (reserved)
BIOS-e820: 0000000000100000 - 000000003fee0000 (usable)
BIOS-e820: 000000003fee0000 - 000000003fef3000 (ACPI data)
BIOS-e820: 000000003fef3000 - 000000003ff80000 (ACPI NVS)
BIOS-e820: 000000003ff80000 - 0000000040000000 (reserved)
BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)

and booting with args

memmap=exactmap memmap=640K@0K memmap=5228K@16384K memmap=125188K@22252K memmap=76K#1047424K memmap=564K#1047500K

resulted in:

user-defined physical RAM map:
user: 0000000000000000 - 0000000000093400 (usable)
user: 0000000000093400 - 00000000000a0000 (reserved)
user: 0000000000100000 - 000000003fee0000 (usable)
user: 000000003fee0000 - 000000003fef3000 (ACPI data)
user: 000000003fef3000 - 000000003ff80000 (ACPI NVS)
user: 000000003ff80000 - 0000000040000000 (reserved)
user: 00000000e0000000 - 00000000f0000000 (reserved)
user: 00000000fec00000 - 00000000fec10000 (reserved)
user: 00000000fee00000 - 00000000fee01000 (reserved)
user: 00000000ff000000 - 0000000100000000 (reserved)

But should have resulted in:

user-defined physical RAM map:
user: 0000000000000000 - 00000000000a0000 (usable)
user: 0000000001000000 - 000000000151b000 (usable)
user: 00000000015bb000 - 0000000008ffc000 (usable)
user: 000000003fee0000 - 000000003ff80000 (ACPI data)

This is happening because of an improper usage of strcmp() in the
e820 parsing code.  The strcmp() always returns !0 and never resets the
value for e820.nr_map and returns an incorrect user-defined map.

This patch fixes the problem.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 9af8907..66e48aa 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1203,7 +1203,7 @@ static int __init parse_memmap_opt(char *p)
 	if (!p)
 		return -EINVAL;
 
-	if (!strcmp(p, "exactmap")) {
+	if (!strncmp(p, "exactmap", 8)) {
 #ifdef CONFIG_CRASH_DUMP
 		/*
 		 * If we are doing a crash dump, we still need to know
