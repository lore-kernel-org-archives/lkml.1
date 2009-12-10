Return-Path: <linux-kernel-owner+w=401wt.eu-S1759333AbZLJAzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333AbZLJAzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 19:55:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbZLJAzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 19:55:10 -0500
Received: from www.tglx.de ([62.245.132.106]:54092 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759097AbZLJAyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 19:54:23 -0500
Message-Id: <20091210004703.187264393@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 10 Dec 2009 00:53:12 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-security-module@vger.kernel.org
Subject: [patch 5/9] security: Use get_task_cred() in
	keyctl_session_to_parent()
References: <20091210001308.247025548@linutronix.de>
Content-Disposition: inline;
	filename=security-fix-missing-rcu-protection-of-__task_cred.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Strictly this is not necessary today, but according to Paul McKenney
it's not guaranteed that irq disabled regions will prevent RCU
progress. That's a property of the current implementation. In
preempt-rt this assumption is not true anymore.

Use get_task_cred() to make this future proof.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org
---
 security/keys/keyctl.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6-tip/security/keys/keyctl.c
===================================================================
--- linux-2.6-tip.orig/security/keys/keyctl.c
+++ linux-2.6-tip/security/keys/keyctl.c
@@ -1237,7 +1237,7 @@ long keyctl_get_security(key_serial_t ke
 long keyctl_session_to_parent(void)
 {
 	struct task_struct *me, *parent;
-	const struct cred *mycred, *pcred;
+	const struct cred *mycred, *pcred = NULL;
 	struct cred *cred, *oldcred;
 	key_ref_t keyring_r;
 	int ret;
@@ -1274,7 +1274,7 @@ long keyctl_session_to_parent(void)
 	/* the parent and the child must have different session keyrings or
 	 * there's no point */
 	mycred = current_cred();
-	pcred = __task_cred(parent);
+	pcred = get_task_cred(parent);
 	if (mycred == pcred ||
 	    mycred->tgcred->session_keyring == pcred->tgcred->session_keyring)
 		goto already_same;
@@ -1312,6 +1312,7 @@ long keyctl_session_to_parent(void)
 	set_ti_thread_flag(task_thread_info(parent), TIF_NOTIFY_RESUME);
 
 	write_unlock_irq(&tasklist_lock);
+	put_cred(pcred);
 	if (oldcred)
 		put_cred(oldcred);
 	return 0;
@@ -1321,6 +1322,8 @@ already_same:
 not_permitted:
 	write_unlock_irq(&tasklist_lock);
 	put_cred(cred);
+	if (pcred)
+		put_cred(pcred);
 	return ret;
 
 error_keyring:


