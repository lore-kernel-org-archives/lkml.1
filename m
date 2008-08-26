Return-Path: <linux-kernel-owner+w=401wt.eu-S1759475AbYHZS4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475AbYHZS4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 14:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759337AbYHZS4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 14:56:09 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:42505 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759072AbYHZS4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 14:56:08 -0400
Date: Tue, 26 Aug 2008 13:56:06 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@osdl.org>
Subject: [PATCH 3/3] user namespaces: reset task's credentials on
	CLONE_NEWUSER
Message-ID: <20080826185605.GC338@us.ibm.com>
References: <20080826185341.GA338@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080826185341.GA338@us.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, creating a new user namespace does not reset
the task's uid or gid.  Since generally that is done as
root because it requires CAP_SYS_ADMIN, and since the
first uid in the new namespace is 0, one usually doesn't
notice.  However, if one does

	capset cap_sys_admin=ep ns_exec
	su - hallyn
	  ns_exec -U /bin/sh
	  id

then one will see hallyn's userid, and all preexisting
groups.

With this patch, cloning a new user namespace will set
the task's uid and gid to 0, and reset the group_info to
the empty set assigned to init.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 kernel/user_namespace.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index d59f193..16e6296 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -10,6 +10,9 @@
 #include <linux/slab.h>
 #include <linux/user_namespace.h>
 
+/* defined in kernel/sys.c */
+extern struct group_info init_groups;
+
 /*
  * Clone a new ns copying an original user ns, setting refcount to 1
  * @old_ns: namespace to clone
@@ -47,6 +50,17 @@ int create_new_userns(int flags, struct task_struct *tsk)
 	put_user_ns(ns);
 
 	task_switch_uid(tsk, ns->root_user);
+	tsk->uid = tsk->euid = tsk->suid = tsk->fsuid = 0;
+	tsk->gid = tsk->egid = tsk->sgid = tsk->fsgid = 0;
+
+	/* this can't be safe for unshare, can it?  it's safe
+	 * for fork, though.  I'm tempted to limit clone_newuser to
+	 * fork only */
+	task_lock(tsk);
+	put_group_info(tsk->group_info);
+	tsk->group_info = &init_groups;
+	get_group_info(tsk->group_info);
+	task_unlock(tsk);
 
 	return 0;
 }
-- 
1.5.4.3

