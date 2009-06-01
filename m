Return-Path: <linux-kernel-owner+w=401wt.eu-S1758715AbZFAVy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715AbZFAVy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 17:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbZFAVv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 17:51:58 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43399 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082AbZFAVu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 17:50:59 -0400
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
Date: Mon,  1 Jun 2009 14:50:38 -0700
Message-Id: <1243893048-17031-13-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1oct739xu.fsf@fess.ebiederm.org>
References: <m1oct739xu.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, hugh@veritas.com, tj@kernel.org, adobriyan@gmail.com, torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk, gregkh@suse.de, npiggin@suse.de, akpm@linux-foundation.org, hch@infradead.org, ebiederm@maxwell.arastra.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 13/23] vfs: Teach ioctl to use file_hotplug_lock
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@maxwell.arastra.com>

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/compat_ioctl.c |   14 ++++++++++----
 fs/ioctl.c        |    8 +++++++-
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index b83f6bc..fa654c5 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -2796,10 +2796,14 @@ asmlinkage long compat_sys_ioctl(unsigned int fd, unsigned int cmd,
 	if (!filp)
 		goto out;
 
+	error = -EIO;
+	if (!file_hotplug_read_trylock(filp))
+		goto out_fput;
+
 	/* RED-PEN how should LSM module know it's handling 32bit? */
 	error = security_file_ioctl(filp, cmd, arg);
 	if (error)
-		goto out_fput;
+		goto out_unlock;
 
 	/*
 	 * To allow the compat_ioctl handlers to be self contained
@@ -2825,7 +2829,7 @@ asmlinkage long compat_sys_ioctl(unsigned int fd, unsigned int cmd,
 		if (filp->f_op && filp->f_op->compat_ioctl) {
 			error = filp->f_op->compat_ioctl(filp, cmd, arg);
 			if (error != -ENOIOCTLCMD)
-				goto out_fput;
+				goto out_unlock;
 		}
 
 		if (!filp->f_op ||
@@ -2853,18 +2857,20 @@ asmlinkage long compat_sys_ioctl(unsigned int fd, unsigned int cmd,
 		error = -EINVAL;
 	}
 
-	goto out_fput;
+	goto out_unlock;
 
  found_handler:
 	if (t->handler) {
 		lock_kernel();
 		error = t->handler(fd, cmd, arg, filp);
 		unlock_kernel();
-		goto out_fput;
+		goto out_unlock;
 	}
 
  do_ioctl:
 	error = do_vfs_ioctl(filp, fd, cmd, arg);
+ out_unlock:
+	file_hotplug_read_unlock(filp);
  out_fput:
 	fput_light(filp, fput_needed);
  out:
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 82d9c42..2dad7ba 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -577,11 +577,17 @@ SYSCALL_DEFINE3(ioctl, unsigned int, fd, unsigned int, cmd, unsigned long, arg)
 	if (!filp)
 		goto out;
 
+	error = -EIO;
+	if (!file_hotplug_read_trylock(filp))
+		goto out_fput;
+
 	error = security_file_ioctl(filp, cmd, arg);
 	if (error)
-		goto out_fput;
+		goto out_unlock;
 
 	error = do_vfs_ioctl(filp, fd, cmd, arg);
+ out_unlock:
+	file_hotplug_read_unlock(filp);
  out_fput:
 	fput_light(filp, fput_needed);
  out:
-- 
1.6.3.1.54.g99dd.dirty

