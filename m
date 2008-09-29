Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029AbYI2UkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbYI2UkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 16:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbYI2Uj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 16:39:57 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:52678 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbYI2Uj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 16:39:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ga2yPw4drH7EvleSglVnfjSTu8DI6q9nKfH8N67h7ZM71+RydBl8bpQ6HU5JKKNWkT
         9vsZZbq69mkxdLEpaWBuza3zrkL4dBZmdDepoJ0EwPCi5H8ziAaU9HCmFdn1eHl4w/As
         wgltvanA7jak+1aNYwyDGSwGBj92JOHv7PN7M=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: mtrr_cleanup safe to get more spare regs now
Date: Mon, 29 Sep 2008 13:39:17 -0700
Message-Id: <1222720757-31124-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

don't need to break earlier, could get more optimized setting automatically

results:

1. hpa
reg00: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1
reg01: base=0x13c000000 (5056MB), size=  64MB: uncachable, count=1
reg02: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
reg03: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
reg04: base=0xbf700000 (3063MB), size=   1MB: uncachable, count=1
reg05: base=0xbf800000 (3064MB), size=   8MB: uncachable, count=1

will get
Found optimal setting for mtrr clean up
gran_size: 1M   chunk_size: 128M        num_reg: 6      lose RAM: 0M
range0: 0000000000000000 - 00000000c0000000
Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
Setting variable MTRR 1, base: 2048MB, range: 1024MB, type WB
hole: 00000000bf700000 - 00000000c0000000
Setting variable MTRR 2, base: 3063MB, range: 1MB, type UC
Setting variable MTRR 3, base: 3064MB, range: 8MB, type UC
range0: 0000000100000000 - 0000000140000000
Setting variable MTRR 4, base: 4096MB, range: 1024MB, type WB
hole: 000000013c000000 - 0000000140000000
Setting variable MTRR 5, base: 5056MB, range: 64MB, type UC

2. Dylan Taft
reg00: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
reg01: base=0x100000000 (4096MB), size= 512MB: write-back, count=1
reg02: base=0x120000000 (4608MB), size= 256MB: write-back, count=1
reg03: base=0xd0000000 (3328MB), size= 256MB: uncachable, count=1
reg04: base=0xe0000000 (3584MB), size= 512MB: uncachable, count=1
reg05: base=0xc7e00000 (3198MB), size=   2MB: uncachable, count=1
reg06: base=0xc8000000 (3200MB), size= 128MB: uncachable, count=1

will get
Found optimal setting for mtrr clean up
gran_size: 1M   chunk_size: 4M  num_reg: 6      lose RAM: 0M
range0: 0000000000000000 - 00000000c8000000
Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
Setting variable MTRR 1, base: 2048MB, range: 1024MB, type WB
Setting variable MTRR 2, base: 3072MB, range: 128MB, type WB
hole: 00000000c7e00000 - 00000000c8000000
Setting variable MTRR 3, base: 3198MB, range: 2MB, type UC
rangeX: 0000000100000000 - 0000000130000000
Setting variable MTRR 4, base: 4096MB, range: 512MB, type WB
Setting variable MTRR 5, base: 4608MB, range: 256MB, type WB

3. Gabriel
reg00: base=0xd0000000 (3328MB), size= 256MB: uncachable, count=1
reg01: base=0xe0000000 (3584MB), size= 512MB: uncachable, count=1
reg02: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
reg03: base=0x100000000 (4096MB), size= 512MB: write-back, count=1
reg04: base=0x120000000 (4608MB), size= 128MB: write-back, count=1
reg05: base=0x128000000 (4736MB), size=  64MB: write-back, count=1
reg06: base=0xcf600000 (3318MB), size=   2MB: uncachable, count=1

will get
Found optimal setting for mtrr clean up
gran_size: 1M   chunk_size: 16M         num_reg: 7      lose RAM: 0M
range0: 0000000000000000 - 00000000d0000000
Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
Setting variable MTRR 1, base: 2048MB, range: 1024MB, type WB
Setting variable MTRR 2, base: 3072MB, range: 256MB, type WB
hole: 00000000cf600000 - 00000000cf800000
Setting variable MTRR 3, base: 3318MB, range: 2MB, type UC
rangeX: 0000000100000000 - 000000012c000000
Setting variable MTRR 4, base: 4096MB, range: 512MB, type WB
Setting variable MTRR 5, base: 4608MB, range: 128MB, type WB
Setting variable MTRR 6, base: 4736MB, range: 64MB, type WB

4. Mika Fischer
reg00: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1
reg01: base=0x00000000 ( 0MB), size=4096MB: write-back, count=1
reg02: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
reg03: base=0xbf700000 (3063MB), size= 1MB: uncachable, count=1
reg04: base=0xbf800000 (3064MB), size= 8MB: uncachable, count=1

will get
Found optimal setting for mtrr clean up
gran_size: 1M   chunk_size: 16M         num_reg: 5      lose RAM: 0M
range0: 0000000000000000 - 00000000c0000000
Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
Setting variable MTRR 1, base: 2048MB, range: 1024MB, type WB
hole: 00000000bf700000 - 00000000c0000000
Setting variable MTRR 2, base: 3063MB, range: 1MB, type UC
Setting variable MTRR 3, base: 3064MB, range: 8MB, type UC
rangeX: 0000000100000000 - 0000000140000000
Setting variable MTRR 4, base: 4096MB, range: 1024MB, type WB

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/cpu/mtrr/main.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
@@ -1352,10 +1352,8 @@ static int __init mtrr_cleanup(unsigned
 		nr_mtrr_spare_reg = num_var_ranges - 1;
 	num_reg_good = -1;
 	for (i = num_var_ranges - nr_mtrr_spare_reg; i > 0; i--) {
-		if (!min_loss_pfn[i]) {
+		if (!min_loss_pfn[i])
 			num_reg_good = i;
-			break;
-		}
 	}
 
 	index_good = -1;
