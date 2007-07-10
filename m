Return-Path: <linux-kernel-owner+w=401wt.eu-S1752080AbXGJEST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbXGJEST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 00:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750846AbXGJESG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 00:18:06 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:45387 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbXGJESD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 00:18:03 -0400
Date: Mon, 9 Jul 2007 21:18:00 -0700
From: sukadev@us.ibm.com
To: Pavel Emelianov <xemul@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>, Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@openvz.org>
Subject: Re: [PATCH 8/16] Masquerade the siginfo when sending a pid to a foreign namespace
Message-ID: <20070710041800.GB15214@us.ibm.com>
References: <468DF6F7.1010906@openvz.org> <468DF849.9080404@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <468DF849.9080404@openvz.org>
User-Agent: Mutt/1.4.2.2i
X-Operating-System: Linux 2.0.32 on an i486
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelianov [xemul@openvz.org] wrote:
| When user send signal from (say) init namespace to any task in a sub
| namespace the siginfo struct must not carry the sender's pid value, as
| this value may refer to some task in the destination namespace and thus
| may confuse the application.

Also, do you prevent signals to the child reaper of a container from within
its container ? If so, can you show me where you handle it ? I can't
seem to find it.

And I guess you do allow signals to the child-reaper of a container from
its parent container.

| 
| The consensus was to pretend in this case as if it is the kernel who
| sends the signal.
| 
| The pid_ns_accessible() call is introduced to check this pid-to-ns
| accessibility.
| 
| Signed-off-by: Pavel Emelianov <xemul@openvz.org>
| 
| ---
| 
|  include/linux/pid.h |   10 ++++++++++
|  kernel/signal.c     |   34 ++++++++++++++++++++++++++++------
|  2 files changed, 38 insertions(+), 6 deletions(-)
| 
| diff -upr linux-2.6.22-rc4-mm2.orig/include/linux/pid.h linux-2.6.22-rc4-mm2-2/include/linux/pid.h
| --- linux-2.6.22-rc4-mm2.orig/include/linux/pid.h	2007-06-14 12:14:29.000000000 +0400
| +++ linux-2.6.22-rc4-mm2-2/include/linux/pid.h	2007-07-04 19:00:38.000000000 +0400
| @@ -83,6 +89,16 @@ extern void FASTCALL(detach_pid(struct t
|  	return nr;
|  }
| 
| +/*
| + * checks whether the pid actually lives in the namespace ns, i.e. it was
| + * created in this namespace or it was moved there.
| + */
| +
| +static inline int pid_ns_accessible(struct pid_namespace *ns, struct pid *pid)
| +{
| +	return pid->numbers[pid->level].ns == ns;
| +}
| +
|  #define do_each_pid_task(pid, type, task)				\
|  	do {								\
|  		struct hlist_node *pos___;				\
| diff -upr linux-2.6.22-rc4-mm2.orig/kernel/signal.c linux-2.6.22-rc4-mm2-2/kernel/signal.c
| --- linux-2.6.22-rc4-mm2.orig/kernel/signal.c	2007-07-04 19:00:38.000000000 +0400
| +++ linux-2.6.22-rc4-mm2-2/kernel/signal.c	2007-07-04 19:00:38.000000000 +0400
| @@ -1124,13 +1124,31 @@ EXPORT_SYMBOL_GPL(kill_pid_info_as_uid);
|   * is probably wrong.  Should make it like BSD or SYSV.
|   */
| 
| -static int kill_something_info(int sig, struct siginfo *info, int pid)
| +static inline void masquerade_siginfo(struct pid_namespace *src_ns,
| +		struct pid *tgt_pid, struct siginfo *info)
| +{
| +	if (tgt_pid != NULL && !pid_ns_accessible(src_ns, tgt_pid)) {
| +		/*
| +		 * current namespace is not seen from the taks we
| +		 * want to send the signal to, so pretend as if it
| +		 * is the kernel who does this to avoid pid messing
| +		 * by the target
| +		 */
| +
| +		info->si_pid = 0;
| +		info->si_code = SI_KERNEL;
| +	}
| +}
| +
| +static int kill_something_info(int sig, struct siginfo *info, int pid_nr)
|  {
|  	int ret;
| +	struct pid *pid;
| +
|  	rcu_read_lock();
| -	if (!pid) {
| +	if (!pid_nr) {
|  		ret = kill_pgrp_info(sig, info, task_pgrp(current));
| -	} else if (pid == -1) {
| +	} else if (pid_nr == -1) {
|  		int retval = 0, count = 0;
|  		struct task_struct * p;

So what happens if we run "kill -s <sig> -1" from within a container ?
Do you terminate all processes in the system or just the process in
the container ?
