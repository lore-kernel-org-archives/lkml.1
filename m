Return-Path: <linux-kernel-owner+w=401wt.eu-S1753137AbYGTVRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbYGTVRR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 17:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750719AbYGTVRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 17:17:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:58958 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbYGTVRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 17:17:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=mm/9YEqWKZCmYtUMl5x43J99ak3VbdXc1qLLx7IH7qMMyVFrD3vrNZ4kPOtxCzXtef
         FmcojBe1rF2bidK4JT7SmtgPaOrSSCGrF0I3M+MMa+yyQsP1dyG7A0b2wUNHAIixHEh8
         X/8YJwtQLGpGKd/RE1HGtFJsKZtEWB5HDxRlo=
Message-ID: <48f7fe350807201416v55b12dacq99e1922b56f02b37@mail.gmail.com>
Date: Sun, 20 Jul 2008 17:16:59 -0400
From: "Ryan Hope" <rmh3093@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>
Subject: [-rt][patches] fix compilation errors
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had some issues compiling the master branch of the -rt kernel today,
the following patches should fix the issues that I encountered:

diff --git a/6b92edd2d46e88c69b3979c4f5f55aba974775e8:arch/x86/kernel/io_apic_32.c
b/f4b693300667c67b9236454f1076ecdc1c3543aa:arch/x86/kernel/io_apic_32.c
index 167ebcbe7a4e96aa1e4140b59972de820465e32a..d3531ee6e0ddcdb6291cc570a500b30cb4c0ca28
100644
--- a/6b92edd2d46e88c69b3979c4f5f55aba974775e8:arch/x86/kernel/io_apic_32.c
+++ b/f4b693300667c67b9236454f1076ecdc1c3543aa:arch/x86/kernel/io_apic_32.c
@@ -1319,7 +1319,7 @@ static void __init setup_IO_APIC_irqs(void)
 		if (IO_APIC_IRQ(irq)) {
 			vector = assign_irq_vector(irq);
 			entry.vector = vector;
-			ioapic_register_intr(irq, vector, IOAPIC_AUTO);
+			ioapic_register_intr(irq, vector, IOAPIC_AUTO, apic > 0);

 			if (!apic && (irq < 16))
 				disable_8259A_irq(irq);
@@ -1358,7 +1358,7 @@ static void __init setup_timer_IRQ0_pin(unsigned
int apic, unsigned int pin,
 	 * The timer IRQ doesn't have to know that behind the
 	 * scene we may have a 8259A-master in AEOI mode ...
 	 */
-	ioapic_register_intr(0, vector, IOAPIC_EDGE);
+	ioapic_register_intr(0, vector, IOAPIC_EDGE, apic > 0);

 	/*
 	 * Add it to the IO-APIC irq-routing table:

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8ca2763..f80c649 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2182,7 +2182,7 @@ static int ext4_da_writepages(struct
address_space *mapping,
 	 * a transaction for special inodes like journal inode on last iput()
 	 * because that could violate lock ordering on umount
 	 */
-	if (!mapping->nrpages)
+	if (!mapping_nrpages(mapping))
 		return 0;

 	/*
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index f8b3be8..9f98f63 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -197,7 +197,7 @@ static int
journal_submit_inode_data_buffers(struct address_space *mapping)
 	int ret;
 	struct writeback_control wbc = {
 		.sync_mode =  WB_SYNC_ALL,
-		.nr_to_write = mapping->nrpages * 2,
+		.nr_to_write = mapping_nrpages(mapping) * 2,
 		.range_start = 0,
 		.range_end = i_size_read(mapping->host),
 		.for_writepages = 1,
