Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbZFAV4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbZFAV4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 17:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbZFAVwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 17:52:20 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35900 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873AbZFAVvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 17:51:00 -0400
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
Date: Mon,  1 Jun 2009 14:50:42 -0700
Message-Id: <1243893048-17031-17-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1oct739xu.fsf@fess.ebiederm.org>
References: <m1oct739xu.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, hugh@veritas.com, tj@kernel.org, adobriyan@gmail.com, torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk, gregkh@suse.de, npiggin@suse.de, akpm@linux-foundation.org, hch@infradead.org, ebiederm@maxwell.arastra.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 17/23] proc: Teach /proc/<pid>/fd to use file_hotplug_lock
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@maxwell.arastra.com>

I have taken the opportunity to modify proc_fd_info to have
a single exit point.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/proc/base.c |   29 ++++++++++++++++-------------
 1 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index fb45615..ee4cdc2 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1626,6 +1626,7 @@ static int proc_fd_info(struct inode *inode, struct path *path, char *info)
 	struct files_struct *files = NULL;
 	struct file *file;
 	int fd = proc_fd(inode);
+	int retval = -ENOENT;
 
 	if (task) {
 		files = get_files_struct(task);
@@ -1639,24 +1640,26 @@ static int proc_fd_info(struct inode *inode, struct path *path, char *info)
 		spin_lock(&files->file_lock);
 		file = fcheck_files(files, fd);
 		if (file) {
-			if (path) {
-				*path = file->f_path;
-				path_get(&file->f_path);
+			retval = -EIO;
+			if (file_hotplug_read_trylock(file)) {
+				retval = 0;
+				if (path) {
+					*path = file->f_path;
+					path_get(&file->f_path);
+				}
+				if (info)
+					snprintf(info, PROC_FDINFO_MAX,
+						"pos:\t%lli\n"
+						"flags:\t0%o\n",
+						(long long) file->f_pos,
+						file->f_flags);
+				file_hotplug_read_unlock(file);
 			}
-			if (info)
-				snprintf(info, PROC_FDINFO_MAX,
-					 "pos:\t%lli\n"
-					 "flags:\t0%o\n",
-					 (long long) file->f_pos,
-					 file->f_flags);
-			spin_unlock(&files->file_lock);
-			put_files_struct(files);
-			return 0;
 		}
 		spin_unlock(&files->file_lock);
 		put_files_struct(files);
 	}
-	return -ENOENT;
+	return retval;
 }
 
 static int proc_fd_link(struct inode *inode, struct path *path)
-- 
1.6.3.1.54.g99dd.dirty

