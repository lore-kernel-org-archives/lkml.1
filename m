Return-Path: <linux-kernel-owner+w=401wt.eu-S1759020AbZFAVzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759020AbZFAVzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 17:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756372AbZFAVvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 17:51:44 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43366 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698AbZFAVu6 (ORCPT
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
Date: Mon,  1 Jun 2009 14:50:34 -0700
Message-Id: <1243893048-17031-9-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1oct739xu.fsf@fess.ebiederm.org>
References: <m1oct739xu.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, hugh@veritas.com, tj@kernel.org, adobriyan@gmail.com, torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk, gregkh@suse.de, npiggin@suse.de, akpm@linux-foundation.org, hch@infradead.org, ebiederm@maxwell.arastra.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 09/23] vfs: Teach poll and select to use file_hotplug_lock
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@maxwell.arastra.com>

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/select.c          |   24 +++++++++++++++++-------
 include/linux/poll.h |    1 +
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/fs/select.c b/fs/select.c
index 99e4145..fd68da0 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -416,10 +416,15 @@ int do_select(int n, fd_set_bits *fds, struct timespec *end_time)
 					continue;
 				file = fget_light(i, &fput_needed);
 				if (file) {
-					f_op = file->f_op;
-					mask = DEFAULT_POLLMASK;
-					if (f_op && f_op->poll)
-						mask = (*f_op->poll)(file, retval ? NULL : wait);
+					mask = DEAD_POLLMASK;
+					if (file_hotplug_read_trylock(file)) {
+						f_op = file->f_op;
+						mask = DEFAULT_POLLMASK;
+						if (f_op && f_op->poll)
+							mask = (*f_op->poll)(file, retval ? NULL : wait);
+
+						file_hotplug_read_unlock(file);
+					}
 					fput_light(file, fput_needed);
 					if ((mask & POLLIN_SET) && (in & bit)) {
 						res_in |= bit;
@@ -684,9 +689,14 @@ static inline unsigned int do_pollfd(struct pollfd *pollfd, poll_table *pwait)
 		file = fget_light(fd, &fput_needed);
 		mask = POLLNVAL;
 		if (file != NULL) {
-			mask = DEFAULT_POLLMASK;
-			if (file->f_op && file->f_op->poll)
-				mask = file->f_op->poll(file, pwait);
+			mask = DEAD_POLLMASK;
+			if (file_hotplug_read_trylock(file)) {
+				mask = DEFAULT_POLLMASK;
+				if (file->f_op && file->f_op->poll)
+					mask = file->f_op->poll(file, pwait);
+
+				file_hotplug_read_unlock(file);
+			}
 			/* Mask out unneeded events. */
 			mask &= pollfd->events | POLLERR | POLLHUP;
 			fput_light(file, fput_needed);
diff --git a/include/linux/poll.h b/include/linux/poll.h
index d388620..f0512f4 100644
--- a/include/linux/poll.h
+++ b/include/linux/poll.h
@@ -22,6 +22,7 @@
 #define N_INLINE_POLL_ENTRIES	(WQUEUES_STACK_ALLOC / sizeof(struct poll_table_entry))
 
 #define DEFAULT_POLLMASK (POLLIN | POLLOUT | POLLRDNORM | POLLWRNORM)
+#define DEAD_POLLMASK (DEFAULT_POLLMASK | POLLERR)
 
 struct poll_table_struct;
 
-- 
1.6.3.1.54.g99dd.dirty

