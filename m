Return-Path: <linux-kernel-owner+w=401wt.eu-S1752144Ab0AAWoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab0AAWoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 17:44:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949Ab0AAWoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 17:44:00 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:52290 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab0AAWoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 17:44:00 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       David Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH] sysfs: Cache the last sysfs_dirent to improve readdir scalability v2
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>
	<20091226094504.GA6214@liondog.tnic>
	<20091228092712.AA8C.A69D9226@jp.fujitsu.com>
	<alpine.LFD.2.00.0912301259220.11961@localhost.localdomain>
	<m11victac1.fsf@fess.ebiederm.org>
	<alpine.LFD.2.00.0912301348320.11961@localhost.localdomain>
	<m1fx6rtu31.fsf@fess.ebiederm.org>
	<alpine.LFD.2.00.0912311043330.11961@localhost.localdomain>
	<m11viaexlj.fsf_-_@fess.ebiederm.org>
	<alpine.LFD.2.00.1001011047580.3630@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 01 Jan 2010 14:43:53 -0800
In-Reply-To: <alpine.LFD.2.00.1001011047580.3630@localhost.localdomain> (Linus Torvalds's message of "Fri\, 1 Jan 2010 10\:56\:15 -0800 \(PST\)")
Message-ID: <m1y6kh30pi.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When sysfs_readdir stops short we now cache the next
sysfs_dirent to return to user space in filp->private_data.
There is no impact on the rest of sysfs by doing this and
in the common case it allows us to pick up exactly where
we left off with no seeking.

Additionally I drop and regrab the sysfs_mutex around
filldir to avoid a page fault abritrarily increasing the
hold time on the sysfs_mutex.

v2: Returned to using INT_MAX as the EOF condition.
    seekdir is ambiguous unless all directory entries have
    a unique f_pos value.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---

Linus good catch.

 fs/sysfs/dir.c |   82 +++++++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 60 insertions(+), 22 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index f05f230..5d88e30 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -827,11 +827,46 @@ static inline unsigned char dt_type(struct sysfs_dirent *sd)
 	return (sd->s_mode >> 12) & 15;
 }
 
+static int sysfs_dir_release(struct inode *inode, struct file *filp)
+{
+	sysfs_put(filp->private_data);
+	return 0;
+}
+
+static struct sysfs_dirent *sysfs_dir_pos(struct sysfs_dirent *parent_sd,
+	ino_t ino, struct sysfs_dirent *pos)
+{
+	if (pos) {
+		int valid = !(pos->s_flags & SYSFS_FLAG_REMOVED) &&
+			pos->s_parent == parent_sd &&
+			ino == pos->s_ino;
+		sysfs_put(pos);
+		if (valid)
+			return pos;
+	}
+	pos = NULL;
+	if ((ino > 1) && (ino < INT_MAX)) {
+		pos = parent_sd->s_dir.children;
+		while (pos && (ino > pos->s_ino))
+			pos = pos->s_sibling;
+	}
+	return pos;
+}
+
+static struct sysfs_dirent *sysfs_dir_next_pos(struct sysfs_dirent *parent_sd,
+	ino_t ino, struct sysfs_dirent *pos)
+{
+	pos = sysfs_dir_pos(parent_sd, ino, pos);
+	if (pos)
+		pos = pos->s_sibling;
+	return pos;
+}
+
 static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 {
 	struct dentry *dentry = filp->f_path.dentry;
 	struct sysfs_dirent * parent_sd = dentry->d_fsdata;
-	struct sysfs_dirent *pos;
+	struct sysfs_dirent *pos = filp->private_data;
 	ino_t ino;
 
 	if (filp->f_pos == 0) {
@@ -847,29 +882,31 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 		if (filldir(dirent, "..", 2, filp->f_pos, ino, DT_DIR) == 0)
 			filp->f_pos++;
 	}
-	if ((filp->f_pos > 1) && (filp->f_pos < INT_MAX)) {
-		mutex_lock(&sysfs_mutex);
-
-		/* Skip the dentries we have already reported */
-		pos = parent_sd->s_dir.children;
-		while (pos && (filp->f_pos > pos->s_ino))
-			pos = pos->s_sibling;
-
-		for ( ; pos; pos = pos->s_sibling) {
-			const char * name;
-			int len;
-
-			name = pos->s_name;
-			len = strlen(name);
-			filp->f_pos = ino = pos->s_ino;
+	mutex_lock(&sysfs_mutex);
+	for (pos = sysfs_dir_pos(parent_sd, filp->f_pos, pos);
+	     pos;
+	     pos = sysfs_dir_next_pos(parent_sd, filp->f_pos, pos)) {
+		const char * name;
+		unsigned int type;
+		int len, ret;
+
+		name = pos->s_name;
+		len = strlen(name);
+		ino = pos->s_ino;
+		type = dt_type(pos);
+		filp->f_pos = ino;
+		filp->private_data = sysfs_get(pos);
 
-			if (filldir(dirent, name, len, filp->f_pos, ino,
-					 dt_type(pos)) < 0)
-				break;
-		}
-		if (!pos)
-			filp->f_pos = INT_MAX;
 		mutex_unlock(&sysfs_mutex);
+		ret = filldir(dirent, name, len, filp->f_pos, ino, type);
+		mutex_lock(&sysfs_mutex);
+		if (ret < 0)
+			break;
+	}
+	mutex_unlock(&sysfs_mutex);
+	if ((filp->f_pos > 1) && !pos) { /* EOF */
+		filp->f_pos = INT_MAX;
+		filp->private_data = NULL;
 	}
 	return 0;
 }
@@ -878,5 +915,6 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 const struct file_operations sysfs_dir_operations = {
 	.read		= generic_read_dir,
 	.readdir	= sysfs_readdir,
+	.release	= sysfs_dir_release,
 	.llseek		= generic_file_llseek,
 };
-- 
1.6.5.2.143.g8cc62

