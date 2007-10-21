Return-Path: <linux-kernel-owner+w=401wt.eu-S1754465AbXJULKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465AbXJULKv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 07:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbXJULIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 07:08:00 -0400
Received: from il.qumranet.com ([82.166.9.18]:58447 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbXJULHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 07:07:55 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Laurent Vivier <Laurent.Vivier@bull.net>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 09/11] KVM: Move kvm_guest_exit() after local_irq_enable()
Date: Sun, 21 Oct 2007 13:08:10 +0200
Message-Id: <11929648921683-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <1192964892617-git-send-email-avi@qumranet.com>
References: <1192964892617-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Vivier <Laurent.Vivier@bull.net>

We need to make sure that the timer interrupt happens before we clear
PF_VCPU, so the accounting code actually sees guest mode.

http://lkml.org/lkml/2007/10/15/114

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index af2d288..8c458f2 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -2054,12 +2054,21 @@ again:
 
 	kvm_x86_ops->run(vcpu, kvm_run);
 
-	kvm_guest_exit();
 	vcpu->guest_mode = 0;
 	local_irq_enable();
 
 	++vcpu->stat.exits;
 
+	/*
+	 * We must have an instruction between local_irq_enable() and
+	 * kvm_guest_exit(), so the timer interrupt isn't delayed by
+	 * the interrupt shadow.  The stat.exits increment will do nicely.
+	 * But we need to prevent reordering, hence this barrier():
+	 */
+	barrier();
+
+	kvm_guest_exit();
+
 	preempt_enable();
 
 	/*
-- 
1.5.3

