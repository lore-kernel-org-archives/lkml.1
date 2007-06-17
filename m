Return-Path: <linux-kernel-owner+w=401wt.eu-S1759565AbXFQJoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565AbXFQJoy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757927AbXFQJok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:44:40 -0400
Received: from il.qumranet.com ([82.166.9.18]:55131 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757699AbXFQJoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:39 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Anthony Liguori <aliguori@us.ibm.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 02/58] KVM: SVM: Allow direct guest access to PC debug port
Date: Sun, 17 Jun 2007 12:43:43 +0300
Message-Id: <11820734792649-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anthony Liguori <aliguori@us.ibm.com>

The PC debug port is used for IO delay and does not require emulation.

Signed-off-by: Anthony Liguori <aliguori@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/svm.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index fa17d6d..6cd6a50 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -378,7 +378,7 @@ static __init int svm_hardware_setup(void)
 	int cpu;
 	struct page *iopm_pages;
 	struct page *msrpm_pages;
-	void *msrpm_va;
+	void *iopm_va, *msrpm_va;
 	int r;
 
 	kvm_emulator_want_group7_invlpg();
@@ -387,8 +387,10 @@ static __init int svm_hardware_setup(void)
 
 	if (!iopm_pages)
 		return -ENOMEM;
-	memset(page_address(iopm_pages), 0xff,
-					PAGE_SIZE * (1 << IOPM_ALLOC_ORDER));
+
+	iopm_va = page_address(iopm_pages);
+	memset(iopm_va, 0xff, PAGE_SIZE * (1 << IOPM_ALLOC_ORDER));
+	clear_bit(0x80, iopm_va); /* allow direct access to PC debug port */
 	iopm_base = page_to_pfn(iopm_pages) << PAGE_SHIFT;
 
 
-- 
1.5.0.6

