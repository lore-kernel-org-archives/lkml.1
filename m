Return-Path: <linux-kernel-owner+w=401wt.eu-S1751846AbZJWK33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbZJWK33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 06:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbZJWK33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 06:29:29 -0400
Received: from mailgw.miraclelinux.com ([122.216.84.157]:10513 "EHLO
	mailgw.miraclelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbZJWK32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 06:29:28 -0400
X-Greylist: delayed 1346 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Oct 2009 06:29:28 EDT
Message-ID: <4AE1804A.2050404@miraclelinux.com>
Date: Fri, 23 Oct 2009 19:07:06 +0900
From: Naohiro Ooiwa <nooiwa@miraclelinux.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: akpm@linux-foundation.org, oleg@redhat.com, roland@redhat.com
CC: LKML <linux-kernel@vger.kernel.org>, h-shimamoto@ct.jp.nec.com
Subject: [PATCH] show message when exceeded rlimit of pending signals
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

I was glad to talk to you in Japan Linux Symposium.
I'm writing about it.


I'm working to support kernel.
Recently, I got a inquiry about unexpected system behavior.
I analyzed application of our customer includeing kernel.

Eventually, there was no bug in application or kernel.
I found the cause was the limit of pending signals.
I ran following command. and system behaved expectedly.
   # ulimit -i unlimited

When system behaved unexpectedly, the timer_create() in application
had returned -EAGAIN value.
But we can't imagine the -EAGAIN means that it exceeded limit of
pending signals at all.

Then I thought kernel should at least show some message about it.
And I tried to create a patch.

I'm sure that system engineeres will not have to have the same experience as I did.
How do you think about this idea ?

Thank you
Naohiro Ooiwa.

Signed-off-by: Naohiro Ooiwa <nooiwa@miraclelinux.com>
---
 kernel/signal.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 6705320..0bc4934 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -188,6 +188,9 @@ int next_signal(struct sigpending *pending, sigset_t *mask)
 	return sig;
 }

+#define MAX_RLIMIT_CAUTION 5
+static int rlimit_caution_count = 0;
+
 /*
  * allocate a new signal queue record
  * - this may be called without locks if and only if t == current, otherwise an
@@ -211,6 +214,16 @@ static struct sigqueue *__sigqueue_alloc(struct task_struct *t, gfp_t flags,
 	    atomic_read(&user->sigpending) <=
 			t->signal->rlim[RLIMIT_SIGPENDING].rlim_cur)
 		q = kmem_cache_alloc(sigqueue_cachep, flags);
+	else {
+		if (rlimit_caution_count <= MAX_RLIMIT_CAUTION ){
+			printk(KERN_WARNING "reached the limit of pending signalis on pid %d\n", current->pid);
+			/* Last time, show the advice */
+			if (rlimit_caution_count == MAX_RLIMIT_CAUTION)
+				printk(KERN_WARNING "If unexpected your system behavior, you can try ulimit -i unlimited\n");
+			rlimit_caution_count++;
+		}
+	}
+
 	if (unlikely(q == NULL)) {
 		atomic_dec(&user->sigpending);
 		free_uid(user);
-- 
1.5.4.1

