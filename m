Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbYLHVwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbYLHVwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 16:52:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbYLHVwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 16:52:25 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:38379 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbYLHVwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 16:52:24 -0500
Date: Mon, 8 Dec 2008 15:52:21 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: [PATCH 1/1] user namespaces: document CFS behavior
Message-ID: <20081208215221.GA3954@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documented the currently bogus state of support for CFS user groups with
user namespaces.  In particular, all users in a user namespace should be
children of the user which created the user namespace.  This is yet to
be implemented.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Acked-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 Documentation/scheduler/sched-design-CFS.txt |   21 +++++++++++++++++++++
 kernel/user.c                                |    8 +++++++-
 2 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/Documentation/scheduler/sched-design-CFS.txt b/Documentation/scheduler/sched-design-CFS.txt
index eb471c7..8398ca4 100644
--- a/Documentation/scheduler/sched-design-CFS.txt
+++ b/Documentation/scheduler/sched-design-CFS.txt
@@ -273,3 +273,24 @@ task groups and modify their CPU share using the "cgroups" pseudo filesystem.
 
 	# #Launch gmplayer (or your favourite movie player)
 	# echo <movie_player_pid> > multimedia/tasks
+
+8. Implementation note: user namespaces
+
+User namespaces are intended to be hierarchical.  But they are currently
+only partially implemented.  Each of those has ramifications for CFS.
+
+First, since user namespaces are hierarchical, the /sys/kernel/uids
+presentation is inadequate.  Eventually we will likely want to use sysfs
+tagging to provide private views of /sys/kernel/uids within each user
+namespace.
+
+Second, the hierarchical nature is intended to support completely
+unprivileged use of user namespaces.  So if using user groups, then
+we want the users in a user namespace to be children of the user
+who created it.
+
+That is currently unimplemented.  So instead, every user in a new
+user namespace will receive 1024 shares just like any user in the
+initial user namespace.  Note that at the moment creation of a new
+user namespace requires each of CAP_SYS_ADMIN, CAP_SETUID, and
+CAP_SETGID.
diff --git a/kernel/user.c b/kernel/user.c
index 6c924bc..6608a3d 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -239,7 +239,13 @@ static struct kobj_type uids_ktype = {
 	.release = uids_release,
 };
 
-/* create /sys/kernel/uids/<uid>/cpu_share file for this user */
+/*
+ * Create /sys/kernel/uids/<uid>/cpu_share file for this user
+ * We do not create this file for users in a user namespace (until
+ * sysfs tagging is implemented).
+ *
+ * See Documentation/scheduler/sched-design-CFS.txt for ramifications.
+ */
 static int uids_user_create(struct user_struct *up)
 {
 	struct kobject *kobj = &up->kobj;
-- 
1.5.4.3

