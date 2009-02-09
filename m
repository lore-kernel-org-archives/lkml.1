Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbZBIBF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbZBIBF0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 20:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbZBIBFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 20:05:12 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48016 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbZBIBFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 20:05:11 -0500
Date: Mon, 9 Feb 2009 02:02:33 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Markus Metzger <markus.t.metzger@intel.com>,
       Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH, for 2.6.29] ptrace: fix the usage of ptrace_fork()
Message-ID: <20090209010233.GA26444@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed by pure accident we have ptrace_fork() and friends. This was
added by "x86, bts: add fork and exit handling", commit
bf53de907dfdaac178c92d774aae7370d7b97d20

I can't test this, ds_request_bts() returns -EOPNOTSUPP, but I strongly
believe this needs the fix. I think something like this program

	int main(void)
	{
		int pid = fork();

		if (!pid) {
			ptrace(PTRACE_TRACEME, 0, NULL, NULL);
			kill(getpid(), SIGSTOP);
			fork();
		} else {
			struct ptrace_bts_config bts = {
				.flags = PTRACE_BTS_O_ALLOC,
				.size  = 4 * 4096,
			};

			wait(NULL);

			ptrace(PTRACE_SETOPTIONS, pid, NULL, PTRACE_O_TRACEFORK);
			ptrace(PTRACE_BTS_CONFIG, pid, &bts, sizeof(bts));
			ptrace(PTRACE_CONT, pid, NULL, NULL);

			sleep(1);
		}

		return 0;
	}

should crash the kernel.

If the task is traced by its natural parent ptrace_reparented() returns 0
but we should clear ->btsxxx anyway.

This is a minimal fix for 2.6.29, we need further cleanups imho.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.29-rc3/kernel/fork.c~BTS_FIX	2009-01-29 01:13:55.000000000 +0100
+++ 6.29-rc3/kernel/fork.c	2009-02-09 01:03:48.000000000 +0100
@@ -1093,7 +1093,7 @@ static struct task_struct *copy_process(
 #ifdef CONFIG_DEBUG_MUTEXES
 	p->blocked_on = NULL; /* not blocked yet */
 #endif
-	if (unlikely(ptrace_reparented(current)))
+	if (unlikely(current->ptrace))
 		ptrace_fork(p, clone_flags);
 
 	/* Perform scheduler related setup. Assign this task to a CPU. */

