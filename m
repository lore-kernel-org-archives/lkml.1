Return-Path: <linux-kernel-owner+w=401wt.eu-S1759443AbXIQJEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759443AbXIQJEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755022AbXIQIeC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:34:02 -0400
Received: from il.qumranet.com ([82.166.9.18]:45258 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623AbXIQIc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:28 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 043/104] KVM: SVM: Make set_msr_interception more reliable
Date: Mon, 17 Sep 2007 10:31:25 +0200
Message-Id: <11900179473819-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

set_msr_interception() is used by svm to set up which MSRs should be
intercepted.  It can only fail if someone has changed the code to try
to intercept an MSR without updating the array of ranges.

The return value is ignored anyway: it should just BUG() if it doesn't
work.  (A build-time failure would be better, but that's tricky).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/svm.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 827bc27..7beaff1 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -359,8 +359,8 @@ err_1:
 
 }
 
-static int set_msr_interception(u32 *msrpm, unsigned msr,
-				int read, int write)
+static void set_msr_interception(u32 *msrpm, unsigned msr,
+				 int read, int write)
 {
 	int i;
 
@@ -375,11 +375,10 @@ static int set_msr_interception(u32 *msrpm, unsigned msr,
 			u32 mask = ((write) ? 0 : 2) | ((read) ? 0 : 1);
 			*base = (*base & ~(0x3 << msr_shift)) |
 				(mask << msr_shift);
-			return 1;
+			return;
 		}
 	}
-	printk(KERN_DEBUG "%s: not found 0x%x\n", __FUNCTION__, msr);
-	return 0;
+	BUG();
 }
 
 static __init int svm_hardware_setup(void)
-- 
1.5.3

