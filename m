Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbZJCRLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbZJCRLL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 13:11:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbZJCRLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 13:11:11 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:60776 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbZJCRLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 13:11:09 -0400
Date: Sat, 3 Oct 2009 10:10:29 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Daniel Lezcano <dlezcano@fr.ibm.com>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>, oleg@redhat.com,
       roland@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: pidns : PR_SET_PDEATHSIG + SIGKILL regression
Message-ID: <20091003171029.GA30442@us.ibm.com>
References: <4AC608BE.9020805@fr.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <4AC608BE.9020805@fr.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Cc Oleg and Roland and moving discussion to LKML.

Daniel Lezcano [dlezcano@fr.ibm.com] wrote:
> Hi,
>
> I noticed a changed behaviour with the PR_SET_PDEATHSIG and SIGKILL  
> between different kernel versions.
>
> With a kernel 2.6.27.21-78.2.41.fc9.x86_64, the SIGKILL signal is  
> delivered to the child process when the parent dies but with a 2.6.31  
> kernel version that don't happen.
>
> The program below shows the problem. I remember there was were some  
> modifications about not killing the init process of the container from  
> inside, but in this case, that happens _conceptually_ from outside.  
> Keeping this feature is very important to be able to wipe out the  
> container when the parent process of the container dies.

(Test case moved to attachment).

---
Container init must not be immune to signals from parent. But as pointed
out by Daniel Lezcano: 

https://lists.linux-foundation.org/pipermail/containers/2009-October/021121.html

container-init is currently immune to signals from parent, if sent via
->pdeath_signal. This is because the siginfo for ->pdeath_signal is set to
SEND_SIG_NOINFO which is considered special.

This quick patch passes in siginfo explicitly (just like we do when sending
SIGCHLD to parent) and seems to fix the problem. Not though sure if
->pdeath_signal needs to be 'is_si_special()'.

Changelog [v2]:
	- [Oleg Nesterov] Add missing initializer, ->si_code = SI_USER
	- [Sukadev Bhattiprolu] Use 'tgid' of parent instead of 'pid'.

---
 kernel/exit.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/exit.c
===================================================================
--- linux-2.6.orig/kernel/exit.c	2009-10-02 19:23:00.000000000 -0700
+++ linux-2.6/kernel/exit.c	2009-10-03 10:02:42.000000000 -0700
@@ -738,8 +738,20 @@ static struct task_struct *find_new_reap
 static void reparent_thread(struct task_struct *father, struct task_struct *p,
 				struct list_head *dead)
 {
-	if (p->pdeath_signal)
-		group_send_sig_info(p->pdeath_signal, SEND_SIG_NOINFO, p);
+	if (p->pdeath_signal) {
+		struct siginfo info;
+
+		info.si_code = SI_USER;
+		info.si_signo = p->pdeath_signal;
+		info.si_errno = 0;
+
+		rcu_read_lock();
+		info.si_pid = task_tgid_nr_ns(father, task_active_pid_ns(p));
+		info.si_uid = __task_cred(father)->uid;
+		rcu_read_unlock();
+
+		group_send_sig_info(p->pdeath_signal, &info, p);
+	}
 
 	list_move_tail(&p->sibling, &p->real_parent->children);
 

--liOOAslEiF7prFVr
Content-Type: text/x-csrc; charset=us-ascii
Content-Description: pdeath.c
Content-Disposition: attachment; filename="pdeath.c"

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/prctl.h>
#include <sys/param.h>
#include <sys/poll.h>
#include <signal.h>
#include <sched.h>

#ifndef CLONE_NEWPID
#  define CLONE_NEWPID            0x20000000
#endif

int child(void *arg)
{
    if (prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0)) {
        perror("prctl");
        return -1;
    }

    sleep(3);
    printf("I should have gone with my parent\n");
    return -1;
}

pid_t clonens(int (*fn)(void *), void *arg, int flags)
{
    long stack_size = sysconf(_SC_PAGESIZE);
     void *stack = alloca(stack_size) + stack_size;
    return clone(fn, stack, flags | SIGCHLD, arg);
}

int main(int argc, char *argv[])
{
    pid_t pid;

    pid = clonens(child, NULL, CLONE_NEWNS|CLONE_NEWPID);
    if (pid < 0) {
        perror("clone");
        return -1;
    }

    /* let the child to be ready, ugly but simple code */
    sleep(1);
    
    return 0;
}

--liOOAslEiF7prFVr--
