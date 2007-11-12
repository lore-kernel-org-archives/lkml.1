Return-Path: <linux-kernel-owner+w=401wt.eu-S1758715AbXKLXml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715AbXKLXml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 18:42:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbXKLXmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 18:42:33 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565AbXKLXmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 18:42:32 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Subject: [PATCH] sigwait eats blocked default-ignore signals
X-Fcc: ~/Mail/linus
Emacs: resistance is futile; you will be assimilated and byte-compiled.
Message-Id: <20071112234155.783744D04C9@magilla.localdomain>
Date: Mon, 12 Nov 2007 15:41:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


cf http://bugzilla.kernel.org/show_bug.cgi?id=9347

While a signal is blocked, it must be posted even if its action is
SIG_IGN or is SIG_DFL with the default action to ignore.  This works
right most of the time, but is broken when a sigwait (rt_sigtimedwait)
is in progress.  This changes the early-discard check to respect
real_blocked.  ~blocked is the set to check for "should wake up now",
but ~(blocked|real_blocked) is the set for "blocked" semantics as
defined by POSIX.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 kernel/signal.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 0ac614a..9b22790 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -55,7 +55,7 @@ static int sig_ignored(struct task_struct *t, int sig)
 	 * signal handler may change by the time it is
 	 * unblocked.
 	 */
-	if (sigismember(&t->blocked, sig))
+	if (sigismember(&t->blocked, sig) || sigismember(&t->real_blocked, sig))
 		return 0;
 
 	/* Is it explicitly or implicitly ignored? */
