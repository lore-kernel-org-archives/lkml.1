Return-Path: <linux-kernel-owner+w=401wt.eu-S1753727AbYBXRqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbYBXRqc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 12:46:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbYBXRqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 12:46:22 -0500
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:13867 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbYBXRqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 12:46:21 -0500
Date: Sun, 24 Feb 2008 18:46:05 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH] Fix alignment of early reservation for EBDA
Message-ID: <20080224174605.GA21661@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Sun, 24 Feb 2008 18:46:10 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.67; VDF: 7.0.2.180; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

My eyes fell on the following table in the boot messages:

early res: 0 [0-fff] BIOS data page
early res: 1 [6000-7fff] SMP_TRAMPOLINE
early res: 2 [200000-374557] TEXT DATA BSS
early res: 3 [9fc00-a0bff] EBDA
early res: 4 [8000-afff] PGTABLE

The memory reserved for the EBDA overflows into the area normally
reserved for the VGA adaptor. It seems that you wanted to force
the allocation to cover whole pages, like:

early res: 3 [9f000-9ffff] EBDA

This is what this patch implements.

Is it really necessary to force the allocation to a page boundary?


Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

 arch/x86/kernel/head64.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index ad24408..2c52543 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -53,7 +53,7 @@ static void __init copy_bootdata(char *real_mode_data)
 
 static __init void reserve_ebda(void)
 {
-	unsigned ebda_addr, ebda_size;
+	unsigned int ebda_addr, ebda_size, ebda_end;
 
 	/*
 	 * there is a real-mode segmented pointer pointing to the
@@ -70,12 +70,14 @@ static __init void reserve_ebda(void)
 	/* Round EBDA up to pages */
 	if (ebda_size == 0)
 		ebda_size = 1;
+	if (ebda_size > 64)
+		ebda_size = 64;
 	ebda_size <<= 10;
-	ebda_size = round_up(ebda_size + (ebda_addr & ~PAGE_MASK), PAGE_SIZE);
-	if (ebda_size > 64*1024)
-		ebda_size = 64*1024;
+	
+	ebda_end = ALIGN(ebda_addr + ebda_size, PAGE_SIZE);
+	ebda_addr = ALIGN(ebda_addr - PAGE_SIZE, PAGE_SIZE);
 
-	reserve_early(ebda_addr, ebda_addr + ebda_size, "EBDA");
+	reserve_early(ebda_addr, ebda_end, "EBDA");
 }
 
 void __init x86_64_start_kernel(char * real_mode_data)
