Return-Path: <linux-kernel-owner+w=401wt.eu-S935990AbXHJLwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935990AbXHJLwF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 07:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935887AbXHJLvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 07:51:25 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:28592 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932356AbXHJLvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 07:51:24 -0400
Date: Fri, 10 Aug 2007 15:48:01 +0400
From: xemul@openvz.org
To: akpm@osdl.org
Cc: xemul@openvz.org, devel@openvz.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, oleg@tv-sign.ru, sukadev@us.ibm.com
Subject: [PATCH 6/20] Add support for pid namespaces hierarchy
Message-ID: <46BC5071.mailGJD1M0IFY@openvz.org>
User-Agent: nail 11.4 8/29/04
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Each namespace has a parent and is characterized by its "level".
Level is the number of the namespace generation. E.g. init namespace
has level 0, after cloning new one it will have level 1, the next
one - 2 and so on and so forth. This level is not explicitly limited.

True hierarchy must have some way to find each namespace's children,
but it is not used in the patches, so this ability is not added (yet).

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>

---

 include/linux/pid_namespace.h |    2 ++
 kernel/pid.c                  |    3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- ./include/linux/pid_namespace.h.ve5	2007-08-09 17:54:49.000000000 +0400
+++ ./include/linux/pid_namespace.h	2007-08-10 12:39:22.000000000 +0400
@@ -21,6 +21,8 @@ struct pid_namespace {
 	int last_pid;
 	struct task_struct *child_reaper;
 	struct kmem_cache *pid_cachep;
+	int level;
+	struct pid_namespace *parent;
 };
 
 extern struct pid_namespace init_pid_ns;
--- ./kernel/pid.c.ve5	2007-08-09 17:54:51.000000000 +0400
+++ ./kernel/pid.c	2007-08-10 12:39:57.000000000 +0400
@@ -67,7 +67,8 @@ struct pid_namespace init_pid_ns = {
 		[ 0 ... PIDMAP_ENTRIES-1] = { ATOMIC_INIT(BITS_PER_PAGE), NULL }
 	},
 	.last_pid = 0,
-	.child_reaper = &init_task
+	.level = 0,
+	.child_reaper = &init_task,
 };
 
 int is_global_init(struct task_struct *tsk)
