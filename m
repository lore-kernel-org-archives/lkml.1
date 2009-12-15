Return-Path: <linux-kernel-owner+w=401wt.eu-S1759241AbZLOEKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241AbZLOEKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:10:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759233AbZLOEJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:09:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932387AbZLOEHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:07:22 -0500
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       Dor Laor <dlaor@redhat.com>
Subject: [PATCH RFC: kvm tsc virtualization 13/20] Combine observed TSC deviation into moving average
Date: Mon, 14 Dec 2009 18:08:40 -1000
Message-Id: <1260850127-9766-14-git-send-email-zamsden@redhat.com>
In-Reply-To: <1260850127-9766-13-git-send-email-zamsden@redhat.com>
References: <1260850127-9766-1-git-send-email-zamsden@redhat.com>
 <1260850127-9766-2-git-send-email-zamsden@redhat.com>
 <1260850127-9766-3-git-send-email-zamsden@redhat.com>
 <1260850127-9766-4-git-send-email-zamsden@redhat.com>
 <1260850127-9766-5-git-send-email-zamsden@redhat.com>
 <1260850127-9766-6-git-send-email-zamsden@redhat.com>
 <1260850127-9766-7-git-send-email-zamsden@redhat.com>
 <1260850127-9766-8-git-send-email-zamsden@redhat.com>
 <1260850127-9766-9-git-send-email-zamsden@redhat.com>
 <1260850127-9766-10-git-send-email-zamsden@redhat.com>
 <1260850127-9766-11-git-send-email-zamsden@redhat.com>
 <1260850127-9766-12-git-send-email-zamsden@redhat.com>
 <1260850127-9766-13-git-send-email-zamsden@redhat.com>
Organization: Frobozz Magic Timekeeping Company
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c66dede..8bd362b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -914,6 +914,7 @@ static void sync_tsc_helper(int measure_cpu, s64 *delta, atomic_t *ready)
 /*
  * Average and trim the samples of any outliers; we use > 2 x sigma
  */
+static u64 tsc_deviation;
 static s64 average_samples(s64 *samples, unsigned num_samples)
 {
 	unsigned i, j;
@@ -936,6 +937,11 @@ static s64 average_samples(s64 *samples, unsigned num_samples)
 	stddev = stddev / (num_samples - 1);
 	stddev = int_sqrt(stddev);
 
+	/* Accumulate deviation measurement into a moving average */
+	tsc_deviation = tsc_deviation ?
+		((tsc_deviation << 4) - tsc_deviation + stddev) >> 4 :
+		stddev;
+
 	/* Throw out anything outside 2x stddev */
 	stddev <<= 1;
 	average = 0, j = 0;
@@ -950,10 +956,12 @@ static s64 average_samples(s64 *samples, unsigned num_samples)
 	}
 	if (j > 0)
 		average = average / j;
-	else
+	else {
 		printk(KERN_ERR "kvm: TSC samples failed to converge!\n");
-	pr_debug("%s: mean = %lld, stddev = %llu, average = %lld\n",
-		 __func__, mean, stddev, average);
+		average = mean;
+	}
+	pr_debug("%s: mean=%lld, stddev=%llu, average=%lld hdev=%llu\n",
+		 __func__, mean, stddev, average, tsc_deviation);
 
 	return average;
 }
-- 
1.6.5.2

