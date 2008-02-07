Return-Path: <linux-kernel-owner+w=401wt.eu-S1758451AbYBGEQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451AbYBGEQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 23:16:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754839AbYBGEQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 23:16:24 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:52559 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806AbYBGEQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 23:16:22 -0500
Date: Wed, 06 Feb 2008 20:22:43 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: fix page table size
In-reply-to: <20080206231226.GA6417@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802062022.44069.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802061246.43413.yinghai.lu@sun.com>
 <200802061501.26533.yinghai.lu@sun.com> <20080206231226.GA6417@elte.hu>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: fix page table size

Command line: apic=debug acpi.debug_level=0x0000000F debug initcall_debug pci=routeirq ramdisk_size=131072 root=/dev/ram0 rw ip=dhcp console=uart8250,io,0x3f8,115200n8
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000100 - 000000000009bc00 (usable)
 BIOS-e820: 000000000009bc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000dffe0000 (usable)
 BIOS-e820: 00000000dffe0000 - 00000000dffee000 (ACPI data)
 BIOS-e820: 00000000dffee000 - 00000000dffff050 (ACPI NVS)
 BIOS-e820: 00000000dffff050 - 00000000e0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000004020000000 (usable)
Early serial console at I/O port 0x3f8 (options '115200n8')
console [uart0] enabled
Entering add_active_range(0, 1, 155) 0 entries of 3200 used
Entering add_active_range(0, 256, 917472) 1 entries of 3200 used
Entering add_active_range(0, 1048576, 67239936) 2 entries of 3200 used
end_pfn_map = 67239936
Kernel panic - not syncing: Overlapping early reservations 8000-109fff PGTABLE to 9bc00-9dbff EBDA

change back the logic. we DO need extra space for pmds when direct_gbpages is not there.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index eb376b5..31f0e82 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -370,7 +370,7 @@ static void __init find_early_table_space(unsigned long end)
 
 	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
 	tables = round_up(puds * sizeof(pud_t), PAGE_SIZE);
-	if (direct_gbpages) {
+	if (!direct_gbpages) {
 		pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
 		tables += round_up(pmds * sizeof(pmd_t), PAGE_SIZE);
 	}
