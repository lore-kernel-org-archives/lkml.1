Return-Path: <linux-kernel-owner+w=401wt.eu-S1759579AbZKKWj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759579AbZKKWj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 17:39:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759571AbZKKWj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 17:39:56 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:54859 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759570AbZKKWjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 17:39:54 -0500
Date: Wed, 11 Nov 2009 14:40:34 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Andrew Morton <akpm@osdl.org>
Cc: mtk.manpages@googlemail.com, arnd@arndb.de,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, matthltc@suka.localdomain,
       "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       linux-api@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
       roland@redhat.com, Pavel Emelyanov <xemul@openvz.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [v12][PATCH 7/9] Define do_fork_with_pids()
Message-ID: <20091111224034.GH24988@suka>
References: <20091111043440.GA9377@suka> <20091111044438.GG11393@suka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091111044438.GG11393@suka>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc: lkml

Sukadev Bhattiprolu [sukadev@linux.vnet.ibm.com] wrote:
| 
| Subject: [v12][PATCH 7/9] Define do_fork_with_pids()
| 
| do_fork_with_pids() is same as do_fork(), except that it takes an
| additional, 'pid_set', parameter. This parameter, currently unused,
| specifies the set of target pids of the process in each of its pid
| namespaces.
| 
| Changelog[v7]:
| 	- Drop 'struct pid_set' object and pass in 'pid_t *target_pids'
| 	  instead of 'struct pid_set *'.
| 
| Changelog[v6]:
| 	- (Nathan Lynch, Arnd Bergmann, H. Peter Anvin, Linus Torvalds)
| 	  Change 'pid_set.pids' to a 'pid_t pids[]' so size of 'struct pid_set'
| 	  is constant across architectures.
| 	- (Nathan Lynch) Change 'pid_set.num_pids' to 'unsigned int'.
| 
| Changelog[v4]:
| 	- Rename 'struct target_pid_set' to 'struct pid_set' since it may
| 	  be useful in other contexts.
| 
| Changelog[v3]:
| 	- Fix "long-line" warning from checkpatch.pl
| 
| Changelog[v2]:
| 	- To facilitate moving architecture-inpdendent code to kernel/fork.c
| 	  pass in 'struct target_pid_set __user *' to do_fork_with_pids()
| 	  rather than 'pid_t *' (next patch moves the arch-independent
| 	  code to kernel/fork.c)
| 
| Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
| Acked-by: Serge Hallyn <serue@us.ibm.com>
| Reviewed-by: Oren Laadan <orenl@cs.columbia.edu>
| ---
|  include/linux/sched.h |    3 +++
|  kernel/fork.c         |   17 +++++++++++++++--
|  2 files changed, 18 insertions(+), 2 deletions(-)
| 
| diff --git a/include/linux/sched.h b/include/linux/sched.h
| index a4d2c23..85e971a 100644
| --- a/include/linux/sched.h
| +++ b/include/linux/sched.h
| @@ -2153,6 +2153,9 @@ extern int disallow_signal(int);
| 
|  extern int do_execve(char *, char __user * __user *, char __user * __user *, struct pt_regs *);
|  extern long do_fork(unsigned long, unsigned long, struct pt_regs *, unsigned long, int __user *, int __user *);
| +extern long do_fork_with_pids(unsigned long, unsigned long, struct pt_regs *,
| +				unsigned long, int __user *, int __user *,
| +				unsigned int, pid_t __user *);
|  struct task_struct *fork_idle(int);
| 
|  extern void set_task_comm(struct task_struct *tsk, char *from);
| diff --git a/kernel/fork.c b/kernel/fork.c
| index 11f77ed..210e841 100644
| --- a/kernel/fork.c
| +++ b/kernel/fork.c
| @@ -1377,12 +1377,14 @@ struct task_struct * __cpuinit fork_idle(int cpu)
|   * It copies the process, and if successful kick-starts
|   * it and waits for it to finish using the VM if required.
|   */
| -long do_fork(unsigned long clone_flags,
| +long do_fork_with_pids(unsigned long clone_flags,
|  	      unsigned long stack_start,
|  	      struct pt_regs *regs,
|  	      unsigned long stack_size,
|  	      int __user *parent_tidptr,
| -	      int __user *child_tidptr)
| +	      int __user *child_tidptr,
| +	      unsigned int num_pids,
| +	      pid_t __user *upids)
|  {
|  	struct task_struct *p;
|  	int trace = 0;
| @@ -1485,6 +1487,17 @@ long do_fork(unsigned long clone_flags,
|  	return nr;
|  }
| 
| +long do_fork(unsigned long clone_flags,
| +	      unsigned long stack_start,
| +	      struct pt_regs *regs,
| +	      unsigned long stack_size,
| +	      int __user *parent_tidptr,
| +	      int __user *child_tidptr)
| +{
| +	return do_fork_with_pids(clone_flags, stack_start, regs, stack_size,
| +			parent_tidptr, child_tidptr, 0, NULL);
| +}
| +
|  #ifndef ARCH_MIN_MMSTRUCT_ALIGN
|  #define ARCH_MIN_MMSTRUCT_ALIGN 0
|  #endif
| -- 
| 1.6.0.4
| 
| _______________________________________________
| Containers mailing list
| Containers@lists.linux-foundation.org
| https://lists.linux-foundation.org/mailman/listinfo/containers
