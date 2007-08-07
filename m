Return-Path: <linux-kernel-owner+w=401wt.eu-S935237AbXHGVMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935237AbXHGVMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965023AbXHGUyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:54:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59571 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965001AbXHGUyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:54:18 -0400
Date: Tue, 7 Aug 2007 13:47:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, mhalcrow@us.ibm.com
Subject: [2.6.22.2 review 50/84] eCryptfs: ecryptfs_setattr() bugfix
Message-ID: <20070807204725.GZ23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ecryptfs-ecryptfs_setattr-bugfix.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Michael Halcrow <mhalcrow@us.ibm.com>

There is another bug recently introduced into the ecryptfs_setattr()
function in 2.6.22.  eCryptfs will attempt to treat special files like
regular eCryptfs files on chmod, chown, and so forth.  This leads to a NULL
pointer dereference.  This patch validates that the file is a regular file
before proceeding with operations related to the inode's crypt_stat.

Thanks to Ryusuke Konishi for finding this bug and suggesting the fix.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ecryptfs/inode.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -902,8 +902,9 @@ static int ecryptfs_setattr(struct dentr
 	mutex_lock(&crypt_stat->cs_mutex);
 	if (S_ISDIR(dentry->d_inode->i_mode))
 		crypt_stat->flags &= ~(ECRYPTFS_ENCRYPTED);
-	else if (!(crypt_stat->flags & ECRYPTFS_POLICY_APPLIED)
-		 || !(crypt_stat->flags & ECRYPTFS_KEY_VALID)) {
+	else if (S_ISREG(dentry->d_inode->i_mode)
+		 && (!(crypt_stat->flags & ECRYPTFS_POLICY_APPLIED)
+		     || !(crypt_stat->flags & ECRYPTFS_KEY_VALID))) {
 		struct vfsmount *lower_mnt;
 		struct file *lower_file = NULL;
 		struct ecryptfs_mount_crypt_stat *mount_crypt_stat;

-- 
