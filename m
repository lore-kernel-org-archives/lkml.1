Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbYLUAza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbYLUAza (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 19:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYLUAzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 19:55:13 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:44648 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbYLUAzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 19:55:10 -0500
Date: Sat, 20 Dec 2008 16:53:54 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com,
       bastian@waldi.eu.org
Cc: daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, sukadev@us.ibm.com
Subject: [RFC][PATCH 3/6][v3] Define/set SIGNAL_UNKILLABLE_FROM_NS
Message-ID: <20081221005354.GC5025@us.ibm.com>
References: <20081221005106.GA4912@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081221005106.GA4912@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Sat, 20 Dec 2008 12:27:47 -0800
Subject: [RFC][PATCH 3/6][v3] Define/set SIGNAL_UNKILLABLE_FROM_NS

Define and set the SIGNAL_UNKILLABLE_FROM_NS flags for container-inits.
This flag will be used in follow-on patches to ignore/drop fatal sigals
to container-init from within the container but process the signals from
an ancestor container.

Based on discussions on earlier version of this patchset:
	http://lkml.org/lkml/2008/11/25/462

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 include/linux/sched.h |    3 +++
 kernel/fork.c         |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 96c6703..19c4311 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -604,6 +604,9 @@ struct signal_struct {
 
 #define SIGNAL_UNKILLABLE	0x00000040 /* for init: ignore fatal signals */
 
+/* for container-init: ignore fatal signals from within container */
+#define SIGNAL_UNKILLABLE_FROM_NS 0x00000080
+
 /* If true, all threads except ->group_exit_task have pending SIGKILL */
 static inline int signal_group_exit(const struct signal_struct *sig)
 {
diff --git a/kernel/fork.c b/kernel/fork.c
index dba2d3f..0a959f5 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -812,6 +812,8 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	atomic_set(&sig->live, 1);
 	init_waitqueue_head(&sig->wait_chldexit);
 	sig->flags = 0;
+	if (clone_flags & CLONE_NEWPID)
+		sig->flags |= SIGNAL_UNKILLABLE_FROM_NS;
 	sig->group_exit_code = 0;
 	sig->group_exit_task = NULL;
 	sig->group_stop_count = 0;
-- 
1.5.2.5

