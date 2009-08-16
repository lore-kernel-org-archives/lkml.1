Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbZHPJha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbZHPJha (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755141AbZHPJh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:37:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45346 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990AbZHPJaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:12 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 15/48] KVM: s390: fix signal handling
Date: Sun, 16 Aug 2009 12:29:35 +0300
Message-Id: <1250415008-17175-16-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

If signal pending is true we exit without updating kvm_run, userspace
currently just does nothing and jumps to kvm_run again.
Since we did not set an exit_reason we might end up with a random one
(whatever was the last exit). Therefore it was possible to e.g. jump to
the psw position the last real interruption set.
Setting the INTR exit reason ensures that no old psw data is swapped
in on reentry.

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/s390/kvm/kvm-s390.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 1d65f62..5c1c302 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -527,8 +527,10 @@ rerun_vcpu:
 	if (rc == SIE_INTERCEPT_RERUNVCPU)
 		goto rerun_vcpu;
 
-	if (signal_pending(current) && !rc)
+	if (signal_pending(current) && !rc) {
+		kvm_run->exit_reason = KVM_EXIT_INTR;
 		rc = -EINTR;
+	}
 
 	if (rc == -ENOTSUPP) {
 		/* intercept cannot be handled in-kernel, prepare kvm-run */
-- 
1.6.3.3

