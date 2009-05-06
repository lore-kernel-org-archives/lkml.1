Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbZEFIB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbZEFIB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 04:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbZEFIBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 04:01:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32881 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbZEFIBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 04:01:45 -0400
Date: Wed, 6 May 2009 10:00:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/3a] ptrace: add _ptrace_may_access()
Message-ID: <20090506080050.GF17457@elte.hu>
References: <20090505224729.GA965@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090505224729.GA965@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> +	task_lock(task);
>  	retval = __ptrace_may_access(task, PTRACE_MODE_ATTACH);
> +	task_unlock(task);
>  	if (retval)
> -		goto bad;
> +		goto unlock_creds;

Hm, that's a bit ugly - why dont you reuse ptrace_may_access(), 
which does much of this already?

That way we could save a little bit of code size.

Something like the patch below allows the reuse of the locked 
version of __ptrace_may_access and pushes the int->bool conversion 
into an inline.

Note that this will also be a micro-optimization: the compiler will 
be able to eliminate the inlined negation in the call sites (most of 
which use the value directly) - and thus we save the negation.

( Untested - if you test it then it has my signoff. Patch also does 
  a small cleanup in _ptrace_may_access() )

Hm?

	Ingo

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 59e133d..2cc01ec 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -99,8 +99,13 @@ extern void exit_ptrace(struct task_struct *tracer);
 #define PTRACE_MODE_ATTACH 2
 /* Returns 0 on success, -errno on denial. */
 extern int __ptrace_may_access(struct task_struct *task, unsigned int mode);
-/* Returns true on success, false on denial. */
-extern bool ptrace_may_access(struct task_struct *task, unsigned int mode);
+/* Also takes the task lock: */
+extern int _ptrace_may_access(struct task_struct *task, unsigned int mode);
+/* True on success, false on denial: */
+static inline bool ptrace_may_access(struct task_struct *task, unsigned int mode)
+{
+	return !_ptrace_may_access(task, mode);
+}
 
 static inline int ptrace_reparented(struct task_struct *child)
 {
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index e950805..f7efcc9 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -155,13 +155,15 @@ int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 	return security_ptrace_may_access(task, mode);
 }
 
-bool ptrace_may_access(struct task_struct *task, unsigned int mode)
+int _ptrace_may_access(struct task_struct *task, unsigned int mode)
 {
 	int err;
+
 	task_lock(task);
 	err = __ptrace_may_access(task, mode);
 	task_unlock(task);
-	return !err;
+
+	return err;
 }
 
 int ptrace_attach(struct task_struct *task)
