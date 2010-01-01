Return-Path: <linux-kernel-owner+w=401wt.eu-S1751726Ab0AAN6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726Ab0AAN6O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 08:58:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651Ab0AAN6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 08:58:14 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:54001 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab0AAN6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 08:58:13 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       David Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH] sysfs: Cache the last sysfs_dirent to improve readdir scalability
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>
	<20091226094504.GA6214@liondog.tnic>
	<20091228092712.AA8C.A69D9226@jp.fujitsu.com>
	<alpine.LFD.2.00.0912301259220.11961@localhost.localdomain>
	<m11victac1.fsf@fess.ebiederm.org>
	<alpine.LFD.2.00.0912301348320.11961@localhost.localdomain>
	<m1fx6rtu31.fsf@fess.ebiederm.org>
	<alpine.LFD.2.00.0912311043330.11961@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 01 Jan 2010 05:58:00 -0800
In-Reply-To: <alpine.LFD.2.00.0912311043330.11961@localhost.localdomain> (Linus Torvalds's message of "Thu\, 31 Dec 2009 11\:04\:48 -0800 \(PST\)")
Message-ID: <m11viaexlj.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When sysfs_readdir stops short we now cache the next sysfs_dirent to
return to user space in filp->private_data.  There is no impact on the
rest of sysfs by doing this and in the common case it allows us to
pick up exactly where we left off with no seeking.

Additionally I drop and regrab the sysfs_mutex around filldir to avoid
a page fault arbitrarily increasing the hold time on the sysfs_mutex.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---

I haven't stressed this patch but it is sound in principle, and is a
general sysfs improvement, regardless of any locking issues.

 fs/sysfs/dir.c |   85 ++++++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 62 insertions(+), 23 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index f05f230..ad8a57e 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -827,19 +827,51 @@ static inline unsigned char dt_type(struct sysfs_dirent *sd)
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
+	pos = parent_sd->s_dir.children;
+	while (pos && (ino > pos->s_ino))
+		pos = pos->s_sibling;
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
 
-	if (filp->f_pos == 0) {
+	if (!pos && filp->f_pos == 0) {
 		ino = parent_sd->s_ino;
 		if (filldir(dirent, ".", 1, filp->f_pos, ino, DT_DIR) == 0)
 			filp->f_pos++;
 	}
-	if (filp->f_pos == 1) {
+	if (!pos && filp->f_pos == 1) {
 		if (parent_sd->s_parent)
 			ino = parent_sd->s_parent->s_ino;
 		else
@@ -847,29 +879,35 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
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
+	/* EOF? */
+	if (!pos && filp->f_pos > 2)
+		return 0;
 
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
+	if (!pos) { /* EOF */
+		filp->f_pos = 3;
+		filp->private_data = NULL;
 	}
 	return 0;
 }
@@ -878,5 +916,6 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 const struct file_operations sysfs_dir_operations = {
 	.read		= generic_read_dir,
 	.readdir	= sysfs_readdir,
+	.release	= sysfs_dir_release,
 	.llseek		= generic_file_llseek,
 };
-- 
1.6.5.2.143.g8cc62

