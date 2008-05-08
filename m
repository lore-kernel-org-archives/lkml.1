Return-Path: <linux-kernel-owner+w=401wt.eu-S1765284AbYEHRqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765284AbYEHRqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 13:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755582AbYEHRna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 13:43:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:47720 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761485AbYEHRnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 13:43:25 -0400
Date: Thu, 8 May 2008 10:42:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Kara <jack@suse.cz>, Jeff Mahoney <jeffm@suse.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: [patch 06/16] reiserfs: Unpack tails on quota files
Message-ID: <20080508174209.GG855@suse.de>
References: <20080508173436.454278564@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="reiserfs-unpack-tails-on-quota-files.patch"
In-Reply-To: <20080508174122.GA855@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Jan Kara <jack@suse.cz>

commit d5dee5c395062a55236318ac4eec1f4ebb9de6db upstream

Quota files cannot have tails because quota_write and quota_read functions do
not support them. So far when quota files did have tail, we just refused to
turn quotas on it. Sadly this check has been wrong and so there are now plenty
installations where quota files don't have NOTAIL flag set and so now after
fixing the check, they suddently fail to turn quotas on. Since it's easy to
unpack the tail from kernel, do this from reiserfs_quota_on() which solves the
problem and is generally nicer to users anyway.

Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: <urhausen@urifabi.net>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/reiserfs/ioctl.c         |    4 +---
 fs/reiserfs/super.c         |   17 ++++++++++++-----
 include/linux/reiserfs_fs.h |    1 +
 3 files changed, 14 insertions(+), 8 deletions(-)

--- a/fs/reiserfs/ioctl.c
+++ b/fs/reiserfs/ioctl.c
@@ -11,8 +11,6 @@
 #include <linux/smp_lock.h>
 #include <linux/compat.h>
 
-static int reiserfs_unpack(struct inode *inode, struct file *filp);
-
 /*
 ** reiserfs_ioctl - handler for ioctl for inode
 ** supported commands:
@@ -140,7 +138,7 @@ int reiserfs_prepare_write(struct file *
 ** Function try to convert tail from direct item into indirect.
 ** It set up nopack attribute in the REISERFS_I(inode)->nopack
 */
-static int reiserfs_unpack(struct inode *inode, struct file *filp)
+int reiserfs_unpack(struct inode *inode, struct file *filp)
 {
 	int retval = 0;
 	int index;
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -2019,6 +2019,7 @@ static int reiserfs_quota_on(struct supe
 {
 	int err;
 	struct nameidata nd;
+	struct inode *inode;
 
 	if (!(REISERFS_SB(sb)->s_mount_opt & (1 << REISERFS_QUOTA)))
 		return -EINVAL;
@@ -2030,12 +2031,18 @@ static int reiserfs_quota_on(struct supe
 		path_put(&nd.path);
 		return -EXDEV;
 	}
+	inode = nd.path.dentry->d_inode;
 	/* We must not pack tails for quota files on reiserfs for quota IO to work */
-	if (!(REISERFS_I(nd.path.dentry->d_inode)->i_flags & i_nopack_mask)) {
-		reiserfs_warning(sb,
-				 "reiserfs: Quota file must have tail packing disabled.");
-		path_put(&nd.path);
-		return -EINVAL;
+	if (!(REISERFS_I(inode)->i_flags & i_nopack_mask)) {
+		err = reiserfs_unpack(inode, NULL);
+		if (err) {
+			reiserfs_warning(sb,
+				"reiserfs: Unpacking tail of quota file failed"
+				" (%d). Cannot turn on quotas.", err);
+			path_put(&nd.path);
+			return -EINVAL;
+		}
+		mark_inode_dirty(inode);
 	}
 	/* Not journalling quota? No more tests needed... */
 	if (!REISERFS_SB(sb)->s_qf_names[USRQUOTA] &&
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -2176,6 +2176,7 @@ int reiserfs_ioctl(struct inode *inode, 
 		   unsigned int cmd, unsigned long arg);
 long reiserfs_compat_ioctl(struct file *filp,
 		   unsigned int cmd, unsigned long arg);
+int reiserfs_unpack(struct inode *inode, struct file *filp);
 
 /* ioctl's command */
 #define REISERFS_IOC_UNPACK		_IOW(0xCD,1,long)

-- 
