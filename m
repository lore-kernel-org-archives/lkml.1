Return-Path: <linux-kernel-owner+w=401wt.eu-S1761658AbZJIXRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761658AbZJIXRa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761635AbZJIXR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:17:28 -0400
Received: from kroah.org ([198.145.64.141]:36847 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761631AbZJIXR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:17:26 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:10:01 2009
Message-Id: <20091009231001.140032602@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:08:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>, Anirban Sinha <ani@anirban.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [patch 08/26] futex: Move exit_pi_state() call to release_mm()
References: <20091009230836.316410305@mini.kroah.org>
Content-Disposition: inline; filename=futex-move-exit_pi_state-call-to-release_mm.patch
In-Reply-To: <20091009231249.GA31084@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Thomas Gleixner <tglx@linutronix.de>

commit 322a2c100a8998158445599ea437fb556aa95b11 upstream.

exit_pi_state() is called from do_exit() but not from do_execve().
Move it to release_mm() so it gets called from do_execve() as well.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Cc: Anirban Sinha <ani@anirban.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/exit.c |    2 --
 kernel/fork.c |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -987,8 +987,6 @@ NORET_TYPE void do_exit(long code)
 	tsk->mempolicy = NULL;
 #endif
 #ifdef CONFIG_FUTEX
-	if (unlikely(!list_empty(&tsk->pi_state_list)))
-		exit_pi_state_list(tsk);
 	if (unlikely(current->pi_state_cache))
 		kfree(current->pi_state_cache);
 #endif
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -550,6 +550,8 @@ void mm_release(struct task_struct *tsk,
 	if (unlikely(tsk->compat_robust_list))
 		compat_exit_robust_list(tsk);
 #endif
+	if (unlikely(!list_empty(&tsk->pi_state_list)))
+		exit_pi_state_list(tsk);
 #endif
 
 	/* Get rid of any cached register state */


