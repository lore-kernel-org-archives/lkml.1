Return-Path: <linux-kernel-owner+w=401wt.eu-S1756430AbZFAVvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430AbZFAVvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 17:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755848AbZFAVvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 17:51:04 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43321 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbZFAVu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 17:50:57 -0400
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
       "Eric W. Biederman" <ebiederm@maxwell.aristanetworks.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Date: Mon,  1 Jun 2009 14:50:27 -0700
Message-Id: <1243893048-17031-2-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1oct739xu.fsf@fess.ebiederm.org>
References: <m1oct739xu.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, hugh@veritas.com, tj@kernel.org, adobriyan@gmail.com, torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk, gregkh@suse.de, npiggin@suse.de, akpm@linux-foundation.org, hch@infradead.org, ebiederm@maxwell.aristanetworks.com, ebiederm@aristanetworks.com
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
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 02/23] vfs: Implement unpoll_file.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@maxwell.aristanetworks.com>

During a revoke operation it is necessary to stop using all state that is managed
by the underlying file operations implementation.  The poll wait queue is one part
of that state.

unpoll_file achieves that by walking through a specified waitqueue.  Finding
any entries that were added by select or poll of that file descriptor and
awakening them.  If action was taken unpoll sleeps and repeats until
the waitqueue has no entries for the spcified file.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/select.c          |   31 +++++++++++++++++++++++++++++++
 include/linux/poll.h |    2 ++
 2 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/fs/select.c b/fs/select.c
index 0fe0e14..bd30fe8 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -941,3 +941,34 @@ SYSCALL_DEFINE5(ppoll, struct pollfd __user *, ufds, unsigned int, nfds,
 	return ret;
 }
 #endif /* HAVE_SET_RESTORE_SIGMASK */
+
+#ifdef CONFIG_FILE_HOTPLUG
+static int unpoll_file_once(wait_queue_head_t *q, struct file *file)
+{
+	unsigned long flags;
+	wait_queue_t *curr, *next;
+	int found = 0;
+
+	spin_lock_irqsave(&q->lock, flags);
+	list_for_each_entry_safe(curr, next, &q->task_list, task_list) {
+		struct poll_table_entry *entry;
+		if (curr->func != pollwake)
+			continue;
+		entry = container_of(curr, struct poll_table_entry, wait);
+		if (entry->filp != file)
+			continue;
+		curr->func(curr, TASK_NORMAL, 0, NULL);
+		found = 1;
+	}
+	spin_unlock_irqrestore(&q->lock, flags);
+
+	return found;
+}
+
+void unpoll_file(wait_queue_head_t *q, struct file *file)
+{
+	while (unpoll_file_once(q, file))
+		schedule_timeout_uninterruptible(1);
+}
+EXPORT_SYMBOL(unpoll_file);
+#endif
diff --git a/include/linux/poll.h b/include/linux/poll.h
index 8c24ef8..d388620 100644
--- a/include/linux/poll.h
+++ b/include/linux/poll.h
@@ -131,6 +131,8 @@ extern int core_sys_select(int n, fd_set __user *inp, fd_set __user *outp,
 
 extern int poll_select_set_timeout(struct timespec *to, long sec, long nsec);
 
+extern void unpoll_file(wait_queue_head_t *q, struct file *file);
+
 #endif /* KERNEL */
 
 #endif /* _LINUX_POLL_H */
-- 
1.6.3.1.54.g99dd.dirty

