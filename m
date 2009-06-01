Return-Path: <linux-kernel-owner+w=401wt.eu-S1757682AbZFAVxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682AbZFAVxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 17:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756223AbZFAVve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 17:51:34 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43355 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbZFAVu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 17:50:58 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
       <linux-mm@kvack.org>, <linux-fsdevel@vger.kernel.org>,
       Hugh Dickins <hugh@veritas.com>, Tejun Heo <tj@kernel.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@maxwell.arastra.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Date: Mon,  1 Jun 2009 14:50:33 -0700
Message-Id: <1243893048-17031-8-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1oct739xu.fsf@fess.ebiederm.org>
References: <m1oct739xu.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, hugh@veritas.com, tj@kernel.org, adobriyan@gmail.com, torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk, gregkh@suse.de, npiggin@suse.de, akpm@linux-foundation.org, hch@infradead.org, ebiederm@maxwell.arastra.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 08/23] vfs: Teach readdir to use file_hotplug_lock
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@maxwell.arastra.com>

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/readdir.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/readdir.c b/fs/readdir.c
index 7723401..2e147cf 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -21,18 +21,26 @@
 
 int vfs_readdir(struct file *file, filldir_t filler, void *buf)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
-	int res = -ENOTDIR;
-	if (!file->f_op || !file->f_op->readdir)
+	struct inode *inode;
+	int res;
+
+	res = -EIO;
+	if (!file_hotplug_read_trylock(file))
 		goto out;
 
+	inode = file->f_path.dentry->d_inode;
+
+	res = -ENOTDIR;
+	if (!file->f_op || !file->f_op->readdir)
+		goto out_unlock;
+
 	res = security_file_permission(file, MAY_READ);
 	if (res)
-		goto out;
+		goto out_unlock;
 
 	res = mutex_lock_killable(&inode->i_mutex);
 	if (res)
-		goto out;
+		goto out_unlock;
 
 	res = -ENOENT;
 	if (!IS_DEADDIR(inode)) {
@@ -40,6 +48,8 @@ int vfs_readdir(struct file *file, filldir_t filler, void *buf)
 		file_accessed(file);
 	}
 	mutex_unlock(&inode->i_mutex);
+out_unlock:
+	file_hotplug_read_unlock(file);
 out:
 	return res;
 }
-- 
1.6.3.1.54.g99dd.dirty

