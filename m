Return-Path: <linux-kernel-owner+w=401wt.eu-S1753761AbYHTDnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbYHTDnD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 23:43:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753845AbYHTDmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 23:42:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641AbYHTDmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 23:42:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: [PATCH] tracehook: fix SA_NOCLDWAIT
In-Reply-To: Andi Kleen's message of  Tuesday, 19 August 2008 17:57:22 +0200 <20080819155722.GA25695@basil.nowhere.org>
References: <20080819155722.GA25695@basil.nowhere.org>
X-Zippy-Says: The fact that 47 PEOPLE are yelling and sweat is cascading down my
    SPINAL COLUMN is fairly enjoyable!!
Message-Id: <20080820034229.43C7215449D@magilla.localdomain>
Date: Tue, 19 Aug 2008 20:42:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 1fca25427482387689fa27594c992a961d98768f:
  Linus Torvalds (1):
        Merge branch 'release' of git://git.kernel.org/.../aegl/linux-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-utrace.git tracehook

Roland McGrath (1):
      tracehook: fix SA_NOCLDWAIT

 kernel/signal.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)


Thanks,
Roland
---
[PATCH] tracehook: fix SA_NOCLDWAIT

I outwitted myself again in commit 2b2a1ff64afbadac842bbc58c5166962cf4f7664,
and broke the SA_NOCLDWAIT behavior so it leaks zombies.  This fixes it.

Reported-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Roland McGrath <roland@redhat.com>
---
 kernel/signal.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index c539f60..e661b01 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1338,6 +1338,7 @@ int do_notify_parent(struct task_struct *tsk, int sig)
 	struct siginfo info;
 	unsigned long flags;
 	struct sighand_struct *psig;
+	int ret = sig;
 
 	BUG_ON(sig == -1);
 
@@ -1402,7 +1403,7 @@ int do_notify_parent(struct task_struct *tsk, int sig)
 		 * is implementation-defined: we do (if you don't want
 		 * it, just use SIG_IGN instead).
 		 */
-		tsk->exit_signal = -1;
+		ret = tsk->exit_signal = -1;
 		if (psig->action[SIGCHLD-1].sa.sa_handler == SIG_IGN)
 			sig = -1;
 	}
@@ -1411,7 +1412,7 @@ int do_notify_parent(struct task_struct *tsk, int sig)
 	__wake_up_parent(tsk, tsk->parent);
 	spin_unlock_irqrestore(&psig->siglock, flags);
 
-	return sig;
+	return ret;
 }
 
 static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
