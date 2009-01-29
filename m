Return-Path: <linux-kernel-owner+w=401wt.eu-S1756815AbZA2JfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815AbZA2JfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 04:35:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbZA2Jey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 04:34:54 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42363 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363AbZA2Jex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 04:34:53 -0500
Date: Thu, 29 Jan 2009 10:32:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] reparent_thread: fix a zombie leak if /sbin/init
	ignores SIGCHLD
Message-ID: <20090129093230.GA30844@redhat.com>
References: <20090129080600.GA26878@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129080600.GA26878@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29, Oleg Nesterov wrote:
>
> If /sbin/init ignores SIGCHLD and we re-parent a zombie, it is leaked.
> reparent_thread() does do_notify_parent() which sets ->exit_signal = -1
> in this case. This means that nobody except us can reap it, the detached
> task is not visible to do_wait().

Just in case, for reviewers...

To verify that the problem does exist and it is really fixed, I used the
stupid patch below, it allows to change init's SIGCHLD handler to SIG_IGN
and then restore it via prctl(1000, 0/1).	

Oleg.

--- kernel/sys.c~	2009-01-19 10:44:33.000000000 +0100
+++ kernel/sys.c	2009-01-29 07:37:09.000000000 +0100
@@ -1703,6 +1703,9 @@ SYSCALL_DEFINE1(umask, int, mask)
 	return mask;
 }
 
+void __user *I_SC;
+#include <linux/pid_namespace.h>
+
 SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		unsigned long, arg4, unsigned long, arg5)
 {
@@ -1716,6 +1719,17 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 
 	error = 0;
 	switch (option) {
+		case 1000: {
+			struct task_struct *i = init_pid_ns.child_reaper;
+
+			if (!I_SC) I_SC = i->sighand->action[SIGCHLD-1].sa.sa_handler;
+
+			i->sighand->action[SIGCHLD-1].sa.sa_handler =
+				arg2 ? I_SC : SIG_IGN;
+
+			break;
+		}
+
 		case PR_SET_PDEATHSIG:
 			if (!valid_signal(arg2)) {
 				error = -EINVAL;

