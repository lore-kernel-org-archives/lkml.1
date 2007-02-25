Return-Path: <linux-kernel-owner+w=401wt.eu-S964893AbXBYM4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964893AbXBYM4K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 07:56:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964888AbXBYM4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 07:56:10 -0500
Received: from il.qumranet.com ([82.166.9.18]:37862 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964892AbXBYM4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 07:56:08 -0500
Subject: [PATCH 2/4] KVM: Fix dirty page log bitmap size/access calculation
From: Avi Kivity <avi@qumranet.com>
Date: Sun, 25 Feb 2007 12:56:07 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45E186FE.2000909@qumranet.com>
In-Reply-To: <45E186FE.2000909@qumranet.com>
Content-Type: text/plain; charset=UTF-8
Message-Id: <20070225125607.221E5250196@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since dirty_bitmap is an unsigned long array, the alignment and size need
to take that into account.

Signed-off-by: Uri Lublin <uril@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index edff405..e710810 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -792,9 +792,9 @@ static int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 	if (!memslot->dirty_bitmap)
 		goto out;
 
-	n = ALIGN(memslot->npages, 8) / 8;
+	n = ALIGN(memslot->npages, BITS_PER_LONG) / 8;
 
-	for (i = 0; !any && i < n; ++i)
+	for (i = 0; !any && i < n/sizeof(long); ++i)
 		any = memslot->dirty_bitmap[i];
 
 	r = -EFAULT;
