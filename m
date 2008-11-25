Return-Path: <linux-kernel-owner+w=401wt.eu-S1755258AbYKYBGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbYKYBGl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 20:06:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbYKYBGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 20:06:33 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:59324 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbYKYBGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 20:06:32 -0500
Date: Mon, 24 Nov 2008 19:06:30 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Linux Containers <containers@lists.osdl.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: [PATCH 3/3] user namespaces: let user_ns be cloned with fairsched
Message-ID: <20081125010630.GA12548@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fairsched creates a per-uid directory under /sys/kernel/uids/.
So when you clone(CLONE_NEWUSER), it tries to create
/sys/kernel/uids/0, which already exists, and you get back
-ENOMEM.

This was supposed to be fixed by sysfs tagging, but that
was postponed (ok, rejected until sysfs locking is fixed).
So, just as with network namespaces, we just don't create
those directories for user namespaces other than the init.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>

---

 kernel/user.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

2d00643e7a4eda47526be7bca9600fda0d96c1c0
diff --git a/kernel/user.c b/kernel/user.c
index 97202cb..6c924bc 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -246,6 +246,8 @@ static int uids_user_create(struct user_
 	int error;
 
 	memset(kobj, 0, sizeof(struct kobject));
+	if (up->user_ns != &init_user_ns)
+		return 0;
 	kobj->kset = uids_kset;
 	error = kobject_init_and_add(kobj, &uids_ktype, NULL, "%d", up->uid);
 	if (error) {
@@ -281,6 +283,8 @@ static void remove_user_sysfs_dir(struct
 	unsigned long flags;
 	int remove_user = 0;
 
+	if (up->user_ns != &init_user_ns)
+		return;
 	/* Make uid_hash_remove() + sysfs_remove_file() + kobject_del()
 	 * atomic.
 	 */
-- 
1.1.6
