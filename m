Return-Path: <linux-kernel-owner+w=401wt.eu-S1758153AbXKUOIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153AbXKUOIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 09:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbXKUOIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 09:08:09 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:63311 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753624AbXKUOIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 09:08:07 -0500
Subject: [patch 1/1] selinux:  do not clear f_op when removing entries
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Christoph Hellwig <hch@infradead.org>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, devel@openvz.org,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>
In-Reply-To: <20071120151731.GA20322@infradead.org>
References: <20071116150651.GC19517@localhost.sw.ru>
	 <20071119125139.GB15942@infradead.org>
	 <1195571105.20910.31.camel@moss-spartans.epoch.ncsc.mil>
	 <20071120151731.GA20322@infradead.org>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 21 Nov 2007 09:01:36 -0500
Message-Id: <1195653696.759.29.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-20 at 15:17 +0000, Christoph Hellwig wrote:
> On Tue, Nov 20, 2007 at 10:05:05AM -0500, Stephen Smalley wrote:
> > > Nice, getting rid of this is a very good step formwards.  Unfortunately
> > > we have another copy of this junk in
> > > security/selinux/selinuxfs.c:sel_remove_entries() which would need the
> > > same treatment.
> > 
> > Can't just be dropped completely for selinux - we need a way to drop
> > obsolete entries from the prior policy when we load a new policy.
> > 
> > Is the only real problem here the clearing of f_op?  If so, we can
> > likely remove that from sel_remove_entries() without harm, and fix the
> > checks for it to use something more reliable.
> 
> f_op removal is the biggest issue.  It can't really work and this is the
> last instance.  But in general having some half-backed attempts at revoke
> is never a good idea.

Do not clear f_op when removing entries since it isn't safe to do.

Signed-off-by:  Stephen Smalley <sds@tycho.nsa.gov>

---

 security/selinux/selinuxfs.c |   28 +---------------------------
 1 file changed, 1 insertion(+), 27 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index f5f3e6d..ac6fe99 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -838,10 +838,6 @@ static ssize_t sel_read_bool(struct file *filep, char __user *buf,
 
 	ret = -EFAULT;
 
-	/* check to see if this file has been deleted */
-	if (!filep->f_op)
-		goto out;
-
 	if (count > PAGE_SIZE) {
 		ret = -EINVAL;
 		goto out;
@@ -882,10 +878,6 @@ static ssize_t sel_write_bool(struct file *filep, const char __user *buf,
 	if (length)
 		goto out;
 
-	/* check to see if this file has been deleted */
-	if (!filep->f_op)
-		goto out;
-
 	if (count >= PAGE_SIZE) {
 		length = -ENOMEM;
 		goto out;
@@ -940,10 +932,6 @@ static ssize_t sel_commit_bools_write(struct file *filep,
 	if (length)
 		goto out;
 
-	/* check to see if this file has been deleted */
-	if (!filep->f_op)
-		goto out;
-
 	if (count >= PAGE_SIZE) {
 		length = -ENOMEM;
 		goto out;
@@ -982,11 +970,9 @@ static const struct file_operations sel_commit_bools_ops = {
 	.write          = sel_commit_bools_write,
 };
 
-/* partial revoke() from fs/proc/generic.c proc_kill_inodes */
 static void sel_remove_entries(struct dentry *de)
 {
-	struct list_head *p, *node;
-	struct super_block *sb = de->d_sb;
+	struct list_head *node;
 
 	spin_lock(&dcache_lock);
 	node = de->d_subdirs.next;
@@ -1006,18 +992,6 @@ static void sel_remove_entries(struct dentry *de)
 	}
 
 	spin_unlock(&dcache_lock);
-
-	file_list_lock();
-	list_for_each(p, &sb->s_files) {
-		struct file * filp = list_entry(p, struct file, f_u.fu_list);
-		struct dentry * dentry = filp->f_path.dentry;
-
-		if (dentry->d_parent != de) {
-			continue;
-		}
-		filp->f_op = NULL;
-	}
-	file_list_unlock();
 }
 
 #define BOOL_DIR_NAME "booleans"


-- 
Stephen Smalley
National Security Agency

