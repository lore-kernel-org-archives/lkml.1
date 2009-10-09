Return-Path: <linux-kernel-owner+w=401wt.eu-S1761803AbZJIXUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761803AbZJIXUQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761644AbZJIXR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:17:29 -0400
Received: from kroah.org ([198.145.64.141]:36849 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761601AbZJIXR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:17:28 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:10:01 2009
Message-Id: <20091009231001.277012503@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:08:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 09/26] futex: Nullify robust lists after cleanup
References: <20091009230836.316410305@mini.kroah.org>
Content-Disposition: inline; filename=futex-nullify-robust-lists-after-cleanup.patch
In-Reply-To: <20091009231249.GA31084@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Peter Zijlstra <peterz@infradead.org>

commit fc6b177dee33365ccb29fe6d2092223cf8d679f9 upstream.

The robust list pointers of user space held futexes are kept intact
over an exec() call. When the exec'ed task exits exit_robust_list() is
called with the stale pointer. The risk of corruption is minimal, but
still it is incorrect to keep the pointers valid. Actually glibc
should uninstall the robust list before calling exec() but we have to
deal with it anyway.

Nullify the pointers after [compat_]exit_robust_list() has been
called.

Reported-by: Anirban Sinha <ani@anirban.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/fork.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -544,11 +544,15 @@ void mm_release(struct task_struct *tsk,
 
 	/* Get rid of any futexes when releasing the mm */
 #ifdef CONFIG_FUTEX
-	if (unlikely(tsk->robust_list))
+	if (unlikely(tsk->robust_list)) {
 		exit_robust_list(tsk);
+		tsk->robust_list = NULL;
+	}
 #ifdef CONFIG_COMPAT
-	if (unlikely(tsk->compat_robust_list))
+	if (unlikely(tsk->compat_robust_list)) {
 		compat_exit_robust_list(tsk);
+		tsk->compat_robust_list = NULL;
+	}
 #endif
 	if (unlikely(!list_empty(&tsk->pi_state_list)))
 		exit_pi_state_list(tsk);


