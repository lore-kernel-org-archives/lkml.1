Return-Path: <linux-kernel-owner+w=401wt.eu-S1759579AbZFAV5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759579AbZFAV5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 17:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756886AbZFAVw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 17:52:27 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43437 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687AbZFAVvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 17:51:01 -0400
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
Date: Mon,  1 Jun 2009 14:50:43 -0700
Message-Id: <1243893048-17031-18-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1oct739xu.fsf@fess.ebiederm.org>
References: <m1oct739xu.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, hugh@veritas.com, tj@kernel.org, adobriyan@gmail.com, torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk, gregkh@suse.de, npiggin@suse.de, akpm@linux-foundation.org, hch@infradead.org, ebiederm@maxwell.aristanetworks.com, ebiederm@aristanetworks.com
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
Subject: [PATCH 18/23] vfs: Teach epoll to use file_hotplug_lock
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@maxwell.aristanetworks.com>

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/eventpoll.c |   39 ++++++++++++++++++++++++++++++++-------
 1 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index a89f370..eabb167 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -627,8 +627,13 @@ static int ep_read_events_proc(struct eventpoll *ep, struct list_head *head,
 	struct epitem *epi, *tmp;
 
 	list_for_each_entry_safe(epi, tmp, head, rdllink) {
-		if (epi->ffd.file->f_op->poll(epi->ffd.file, NULL) &
-		    epi->event.events)
+		int events = DEAD_POLLMASK;
+		
+		if (file_hotplug_read_trylock(epi->ffd.file)) {
+			events = epi->ffd.file->f_op->poll(epi->ffd.file, NULL);
+			file_hotplug_read_unlock(epi->ffd.file);
+		}
+		if (events & epi->event.events)
 			return POLLIN | POLLRDNORM;
 		else {
 			/*
@@ -1060,8 +1065,12 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 
 		list_del_init(&epi->rdllink);
 
-		revents = epi->ffd.file->f_op->poll(epi->ffd.file, NULL) &
-			epi->event.events;
+		revents = DEAD_POLLMASK;
+		if (file_hotplug_read_trylock(epi->ffd.file)) {
+			revents = epi->ffd.file->f_op->poll(epi->ffd.file, NULL);
+			file_hotplug_read_unlock(epi->ffd.file);
+		}
+		revents &= epi->event.events;
 
 		/*
 		 * If the event mask intersect the caller-requested one,
@@ -1248,10 +1257,17 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	if (!tfile)
 		goto error_fput;
 
+	error = -EIO;
+	if (!file_hotplug_read_trylock(file))
+		goto error_tgt_fput;
+
+	if (!file_hotplug_read_trylock(tfile))
+		goto error_file_unlock;
+
 	/* The target file descriptor must support poll */
 	error = -EPERM;
 	if (!tfile->f_op || !tfile->f_op->poll)
-		goto error_tgt_fput;
+		goto error_tgt_unlock;
 
 	/*
 	 * We have to check that the file structure underneath the file descriptor
@@ -1260,7 +1276,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	 */
 	error = -EINVAL;
 	if (file == tfile || !is_file_epoll(file))
-		goto error_tgt_fput;
+		goto error_tgt_unlock;
 
 	/*
 	 * At this point it is safe to assume that the "private_data" contains
@@ -1302,6 +1318,10 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	}
 	mutex_unlock(&ep->mtx);
 
+error_tgt_unlock:
+	file_hotplug_read_unlock(tfile);
+error_file_unlock:
+	file_hotplug_read_unlock(file);
 error_tgt_fput:
 	fput(tfile);
 error_fput:
@@ -1338,13 +1358,16 @@ SYSCALL_DEFINE4(epoll_wait, int, epfd, struct epoll_event __user *, events,
 	if (!file)
 		goto error_return;
 
+	error = -EIO;
+	if (!file_hotplug_read_trylock(file))
+		goto error_fput;
 	/*
 	 * We have to check that the file structure underneath the fd
 	 * the user passed to us _is_ an eventpoll file.
 	 */
 	error = -EINVAL;
 	if (!is_file_epoll(file))
-		goto error_fput;
+		goto error_unlock;
 
 	/*
 	 * At this point it is safe to assume that the "private_data" contains
@@ -1355,6 +1378,8 @@ SYSCALL_DEFINE4(epoll_wait, int, epfd, struct epoll_event __user *, events,
 	/* Time to fish for events ... */
 	error = ep_poll(ep, events, maxevents, timeout);
 
+error_unlock:
+	file_hotplug_read_unlock(file);
 error_fput:
 	fput(file);
 error_return:
-- 
1.6.3.1.54.g99dd.dirty

