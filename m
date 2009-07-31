Return-Path: <linux-kernel-owner+w=401wt.eu-S1752009AbZGaKBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbZGaKBD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 06:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZGaKBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 06:01:01 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:50325 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbZGaKBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 06:01:00 -0400
Message-ID: <4A72C0A3.1070508@gmail.com>
Date: Fri, 31 Jul 2009 12:00:03 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jens Rosenboom <jens@mcbone.net>, Peter Zijlstra <peterz@infradead.org>,
       Sonny Rao <sonnyrao@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Ulrich Drepper <drepper@redhat.com>
Subject: [ PATCH]  execve: must clear current->clear_child_tid
References: <1248681637.7279.12.camel@fnki-nb00130>	 <1248694266.6987.1594.camel@twins>  <1248697004.7279.31.camel@fnki-nb00130>	 <1248697409.6987.1617.camel@twins>  <1248698755.7279.47.camel@fnki-nb00130>	 <1248701812.6987.1637.camel@twins>  <1248848568.6757.13.camel@fnki-nb00130> <1248861443.6757.20.camel@fnki-nb00130> <4A7023BC.6000109@cosmosbay.com> <4A702AC2.2060003@gmail.com>
In-Reply-To: <4A702AC2.2060003@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 31 Jul 2009 12:00:04 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While looking at Jens Rosenboom bug report about strange sys_futex call done
from a dying "ps" program, we found following problem.

clone() syscall has special support for TID of created threads.
This support includes two features.

One (CLONE_CHILD_SETTID) is to set an integer into user memory
with the TID value.

One (CLONE_CHILD_CLEARTID) is to clear this same integer once
the created thread dies.

The integer location is a user provided pointer, provided at clone()
time.

kernel keeps this pointer value into current->clear_child_tid.

At execve() time, we should make sure kernel doesnt keep
this user provided pointer, as full user memory is replaced by a new one.

As glibc fork() actually uses clone() syscall with CLONE_CHILD_SETTID
and CLONE_CHILD_CLEARTID set, chances are high that we might corrupt
user memory in forked processes.

Following sequence could happen:

1) bash (or any program) starts a new process, by a fork() call
that glibc maps to a clone( ... CLONE_CHILD_SETTID
| CLONE_CHILD_CLEARTID ...) syscall

2) When new process starts, its current->clear_child_tid is set to a location
that has a meaning only in bash (or initial program) context  (&THREAD_SELF->tid)

3) This new process does the execve() syscall to start a new program.
   current->clear_child_tid is left unchanged (a non NULL value)

4) If this new program creates some threads, and initial thread exits,
kernel will attempt to clear the integer pointed by current->clear_child_tid
from mm_release() :

        if (tsk->clear_child_tid
            && !(tsk->flags & PF_SIGNALED)
            && atomic_read(&mm->mm_users) > 1) {
                u32 __user * tidptr = tsk->clear_child_tid;
                tsk->clear_child_tid = NULL;

                /*
                 * We don't check the error code - if userspace has
                 * not set up a proper pointer then tough luck.
                 */
<< here >>      put_user(0, tidptr);
                sys_futex(tidptr, FUTEX_WAKE, 1, NULL, NULL, 0);
        }

5) OR : if new program is not multi-threaded, but spied by /proc/pid users
(ps command for example), mm_users > 1, and the exiting program could
corrupt 4 bytes in a persistent memory area (shm or memory mapped file)

If current->clear_child_tid points to a writeable portion of memory
of the new program, kernel happily and silently corrupts 4 bytes of memory,
with unexpected effects.

Fix is straightforward and should not break any sane program.

Reported-by: Jens Rosenboom <jens@mcbone.net>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Tested-by: Jens Rosenboom <jens@mcbone.net>
---
 fs/compat.c |    1 +
 fs/exec.c   |    1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/compat.c b/fs/compat.c
index 94502da..deb1049 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1550,6 +1550,7 @@ int compat_do_execve(char * filename,
 	mutex_unlock(&current->cred_guard_mutex);
 	acct_update_integrals(current);
 	free_bprm(bprm);
+	current->clear_child_tid = NULL;
 	if (displaced)
 		put_files_struct(displaced);
 	return retval;
diff --git a/fs/exec.c b/fs/exec.c
index 4a8849e..e275652 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1343,6 +1343,7 @@ int do_execve(char * filename,
 	mutex_unlock(&current->cred_guard_mutex);
 	acct_update_integrals(current);
 	free_bprm(bprm);
+	current->clear_child_tid = NULL;
 	if (displaced)
 		put_files_struct(displaced);
 	return retval;
