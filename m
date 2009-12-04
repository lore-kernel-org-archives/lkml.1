Return-Path: <linux-kernel-owner+w=401wt.eu-S1755620AbZLDJ3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbZLDJ3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 04:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbZLDJ3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 04:29:19 -0500
Received: from cantor.suse.de ([195.135.220.2]:36310 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbZLDJ3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 04:29:18 -0500
Message-ID: <4B18D66E.8020905@suse.de>
Date: Fri, 04 Dec 2009 14:59:18 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: mingo@elte.hu, Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] sched: fix GENTLE_FAIR_SLEEPERS dependency
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The newly introduced GENTLE_FAIR_SLEEPERS does not seem to have any
effect without FAIR_SLEEPERS. Fix sysctl.sched_features to reflect
this. Without this change, a user who sets GENTLE_FAIR_SLEEPERS
without FAIR_SLEEPERS would assume gentle sleeper fairness which
is not guaranteed.

Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
---

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -761,10 +761,22 @@ sched_feat_write(struct file *filp, cons
 		int len = strlen(sched_feat_names[i]);
 
 		if (strncmp(cmp, sched_feat_names[i], len) == 0) {
-			if (neg)
+			if (neg) {
 				sysctl_sched_features &= ~(1UL << i);
-			else
+				/*
+				 * GENTLE_FAIR_SLEEPERS have no effect without
+				 * FAIR_SLEEPERS.
+				 */
+				if (strncmp(cmp, "FAIR_SLEEPERS",
+					    strlen("FAIR_SLEEPERS")) == 0)
+					sysctl_sched_features &= ~(1UL << i+1);
+			} else {
 				sysctl_sched_features |= (1UL << i);
+				if (strncmp(cmp, "GENTLE_FAIR_SLEEPERS",
+					    strlen("GENTLE_FAIR_SLEEPERS"))
+						== 0)
+					sysctl_sched_features |= (1UL << i-1);
+			}
 			break;
 		}
 	}
