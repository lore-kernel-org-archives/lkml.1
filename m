Return-Path: <linux-kernel-owner+w=401wt.eu-S1758945AbZEEUCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945AbZEEUCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 16:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758663AbZEEUAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 16:00:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33213 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700AbZEEUAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 16:00:22 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com,
       snitzer@redhat.com, m-ikeda@ds.jp.nec.com
Cc: vgoyal@redhat.com, akpm@linux-foundation.org
Subject: [PATCH 11/18] io-controller: noop changes for hierarchical fair queuing
Date: Tue,  5 May 2009 15:58:38 -0400
Message-Id: <1241553525-28095-12-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1241553525-28095-1-git-send-email-vgoyal@redhat.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes noop to use queue scheduling code from elevator layer.
One can go back to old noop by deselecting CONFIG_IOSCHED_NOOP_HIER.

Signed-off-by: Nauman Rafique <nauman@google.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/Kconfig.iosched |   11 +++++++++++
 block/noop-iosched.c  |    3 +++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/block/Kconfig.iosched b/block/Kconfig.iosched
index a91a807..9da6657 100644
--- a/block/Kconfig.iosched
+++ b/block/Kconfig.iosched
@@ -25,6 +25,17 @@ config IOSCHED_NOOP
 	  that do their own scheduling and require only minimal assistance from
 	  the kernel.
 
+config IOSCHED_NOOP_HIER
+	bool "Noop Hierarchical Scheduling support"
+	depends on IOSCHED_NOOP && CGROUPS
+	select ELV_FAIR_QUEUING
+	select GROUP_IOSCHED
+	default n
+	---help---
+	  Enable hierarhical scheduling in noop. In this mode noop keeps
+	  one IO queue per cgroup instead of a global queue. Elevator
+	  fair queuing logic ensures fairness among various queues.
+
 config IOSCHED_AS
 	tristate "Anticipatory I/O scheduler"
 	default y
diff --git a/block/noop-iosched.c b/block/noop-iosched.c
index d587832..73e571d 100644
--- a/block/noop-iosched.c
+++ b/block/noop-iosched.c
@@ -92,6 +92,9 @@ static struct elevator_type elevator_noop = {
 		.elevator_alloc_sched_queue_fn	= noop_alloc_noop_queue,
 		.elevator_free_sched_queue_fn	= noop_free_noop_queue,
 	},
+#ifdef CONFIG_IOSCHED_NOOP_HIER
+	.elevator_features = ELV_IOSCHED_NEED_FQ | ELV_IOSCHED_SINGLE_IOQ,
+#endif
 	.elevator_name = "noop",
 	.elevator_owner = THIS_MODULE,
 };
-- 
1.6.0.1

