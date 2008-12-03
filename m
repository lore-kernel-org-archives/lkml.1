Return-Path: <linux-kernel-owner+w=401wt.eu-S1754451AbYLCTRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbYLCTRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 14:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbYLCTR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:17:27 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49417 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbYLCTR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:17:26 -0500
Date: Wed, 3 Dec 2008 13:17:06 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       David Howells <dhowells@redhat.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       James Morris <jmorris@namei.org>
Subject: [PATCH 1/2] user namespaces: let user_ns be cloned with fairsched
Message-ID: <20081203191706.GA16433@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(These two patches are in the next-unacked branch of
git://git.kernel.org/pub/scm/linux/kernel/git/sergeh/userns-2.6.
If they get some ACKs, then I hope to feed this into security-next.
After these two, I think we're ready to tackle userns+capabilities)

Fairsched creates a per-uid directory under /sys/kernel/uids/.
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

diff --git a/kernel/user.c b/kernel/user.c
index 97202cb..6c924bc 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -246,6 +246,8 @@ static int uids_user_create(struct user_struct *up)
 	int error;
 
 	memset(kobj, 0, sizeof(struct kobject));
+	if (up->user_ns != &init_user_ns)
+		return 0;
 	kobj->kset = uids_kset;
 	error = kobject_init_and_add(kobj, &uids_ktype, NULL, "%d", up->uid);
 	if (error) {
@@ -281,6 +283,8 @@ static void remove_user_sysfs_dir(struct work_struct *w)
 	unsigned long flags;
 	int remove_user = 0;
 
+	if (up->user_ns != &init_user_ns)
+		return;
 	/* Make uid_hash_remove() + sysfs_remove_file() + kobject_del()
 	 * atomic.
 	 */
-- 
1.5.4.3

