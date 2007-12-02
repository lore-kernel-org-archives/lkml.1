Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbXLBLUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbXLBLUl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 06:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbXLBLSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 06:18:17 -0500
Received: from il.qumranet.com ([82.166.9.18]:41439 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540AbXLBLSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 06:18:10 -0500
From: Avi Kivity <avi@qumranet.com>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net,
       Marko Kohtala <marko.kohtala@gmail.com>, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 06/10] KVM: Fix hang on uniprocessor
Date: Sun,  2 Dec 2007 13:18:43 +0200
Message-Id: <1196594327723-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <1196594327338-git-send-email-avi@qumranet.com>
References: <1196594327338-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marko Kohtala <marko.kohtala@gmail.com>

first_cpu(cpus) returns the only CPU when NR_CPUS is 1 regardless of
the cpus mask. Therefore we avoid a kernel hang in
KVM_SET_MEMORY_REGION ioctl on uniprocessor by not entering the loop at
all.

Signed-off-by: Marko Kohtala <marko.kohtala@gmail.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index cd05579..b514dfb 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -273,6 +273,11 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 			}
 	}
 
+	/* Uniprocessor kernel does not respect cpus in first_cpu. So
+	 * do not go there if we have nothing to do. */
+	if (cpus_empty(cpus))
+		return;
+
 	/*
 	 * We really want smp_call_function_mask() here.  But that's not
 	 * available, so ipi all cpus in parallel and wait for them
-- 
1.5.3

