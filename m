Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254AbYKJO4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbYKJO4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 09:56:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbYKJO4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 09:56:14 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:40372 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926AbYKJO4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 09:56:12 -0500
Date: Mon, 10 Nov 2008 08:55:46 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-audit@redhat.com, sgrubb@redhat.com,
       morgan@kernel.org, viro@ZenIV.linux.org.uk
Subject: Re: [PATCH -v3 5/5] AUDIT: emit new record type showing all capset
	information
Message-ID: <20081110145546.GD11561@us.ibm.com>
References: <20081107151355.9977.47852.stgit@paris.rdu.redhat.com> <20081107151416.9977.39103.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107151416.9977.39103.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric Paris (eparis@redhat.com):
> When the capset syscall is used it is not possible for audit to record the
> actual capbilities being added/removed.  This patch adds a new record type
> which emits the target pid and the eff, inh, and perm cap sets.
> 
> example output if you audit capset syscalls would be:
> 
> type=SYSCALL msg=audit(1225743140.465:76): arch=c000003e syscall=126 success=yes exit=0 a0=17f2014 a1=17f201c a2=80000000 a3=7fff2ab7f060 items=0 ppid=2160 pid=2223 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=1 comm="setcap" exe="/usr/sbin/setcap" subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=(null)
> type=UNKNOWN[1322] msg=audit(1225743140.465:76): pid=0 cap_pi=ffffffffffffffff cap_pp=ffffffffffffffff cap_pe=ffffffffffffffff
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
> 
>  include/linux/audit.h |   10 ++++++++++
>  kernel/auditsc.c      |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/capability.c   |    5 +++++
>  3 files changed, 63 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index 8cfb9fe..6fbebac 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -100,6 +100,7 @@
>  #define AUDIT_TTY		1319	/* Input on an administrative TTY */
>  #define AUDIT_EOE		1320	/* End of multi-record event */
>  #define AUDIT_BPRM_FCAPS	1321	/* Information about fcaps increasing perms */
> +#define AUDIT_CAPSET		1322	/* Record showing argument to sys_capset */
> 
>  #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
>  #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
> @@ -454,6 +455,7 @@ extern int __audit_mq_timedreceive(mqd_t mqdes, size_t msg_len, unsigned int __u
>  extern int __audit_mq_notify(mqd_t mqdes, const struct sigevent __user *u_notification);
>  extern int __audit_mq_getsetattr(mqd_t mqdes, struct mq_attr *mqstat);
>  extern void __audit_log_bprm_fcaps(struct linux_binprm *bprm, kernel_cap_t *pP, kernel_cap_t *pE);
> +extern int __audit_log_capset(pid_t pid, kernel_cap_t *eff, kernel_cap_t *inh, kernel_cap_t *perm);
> 
>  static inline int audit_ipc_obj(struct kern_ipc_perm *ipcp)
>  {
> @@ -526,6 +528,13 @@ static inline void audit_log_bprm_fcaps(struct linux_binprm *bprm, kernel_cap_t
>  		__audit_log_bprm_fcaps(bprm, pP, pE);
>  }
> 
> +static inline int audit_log_capset(pid_t pid, kernel_cap_t *eff, kernel_cap_t *inh, kernel_cap_t *perm)
> +{
> +	if (unlikely(!audit_dummy_context()))
> +		return __audit_log_capset(pid, eff, inh, perm);
> +	return 0;
> +}
> +
>  extern int audit_n_rules;
>  extern int audit_signals;
>  #else
> @@ -558,6 +567,7 @@ extern int audit_signals;
>  #define audit_mq_notify(d,n) ({ 0; })
>  #define audit_mq_getsetattr(d,s) ({ 0; })
>  #define audit_log_bprm_fcaps(b, p, e) do { ; } while (0)
> +#define audit_log_capset(pid, e, i, p) ({ 0; })
>  #define audit_ptrace(t) ((void)0)
>  #define audit_n_rules 0
>  #define audit_signals 0
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index b8b5a2a..d1d45b4 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -204,6 +204,12 @@ struct audit_aux_data_bprm_fcaps {
>  	struct audit_cap_data	new_pcap;
>  };
> 
> +struct audit_aux_data_capset {
> +	struct audit_aux_data	d;
> +	pid_t			pid;
> +	struct audit_cap_data	cap;
> +};
> +
>  struct audit_tree_refs {
>  	struct audit_tree_refs *next;
>  	struct audit_chunk *c[31];
> @@ -1397,6 +1403,14 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
>  			audit_log_cap(ab, "new_pe", &axs->new_pcap.effective);
>  			break; }
> 
> +		case AUDIT_CAPSET: {
> +			struct audit_aux_data_capset *axs = (void *)aux;
> +			audit_log_format(ab, "pid=%d", axs->pid);
> +			audit_log_cap(ab, "cap_pi", &axs->cap.inheritable);
> +			audit_log_cap(ab, "cap_pp", &axs->cap.permitted);
> +			audit_log_cap(ab, "cap_pe", &axs->cap.effective);
> +			break; }
> +
>  		}
>  		audit_log_end(ab);
>  	}
> @@ -2570,6 +2584,40 @@ void __audit_log_bprm_fcaps(struct linux_binprm *bprm, kernel_cap_t *pP, kernel_
>  }
> 
>  /**
> + * __audit_log_capset - store information about the arguments to the capset syscall
> + * @pid target pid of the capset call
> + * @eff effective cap set
> + * @inh inheritible cap set
> + * @perm permited cap set
> + *
> + * Record the aguments userspace sent to sys_capset for later printing by the
> + * audit system if applicable
> + */
> +int __audit_log_capset(pid_t pid, kernel_cap_t *eff, kernel_cap_t *inh, kernel_cap_t *perm)
> +{
> +	struct audit_aux_data_capset *ax;
> +	struct audit_context *context = current->audit_context;
> +
> +	if (likely(!audit_enabled || !context || context->dummy))
> +		return 0;
> +
> +	ax = kmalloc(sizeof(*ax), GFP_KERNEL);
> +	if (!ax)
> +		return -ENOMEM;
> +
> +	ax->d.type = AUDIT_CAPSET;
> +	ax->d.next = context->aux;
> +	context->aux = (void *)ax;
> +
> +	ax->pid = pid;
> +	ax->cap.effective = *eff;
> +	ax->cap.inheritable = *eff;
> +	ax->cap.permitted = *perm;
> +
> +	return 0;
> +}
> +
> +/**
>   * audit_core_dumps - record information about processes that end abnormally
>   * @signr: signal value
>   *
> diff --git a/kernel/capability.c b/kernel/capability.c
> index 33e51e7..aaa2262 100644
> --- a/kernel/capability.c
> +++ b/kernel/capability.c
> @@ -7,6 +7,7 @@
>   * 30 May 2002:	Cleanup, Robert M. Love <rml@tech9.net>
>   */
> 
> +#include <linux/audit.h>
>  #include <linux/capability.h>
>  #include <linux/mm.h>
>  #include <linux/module.h>
> @@ -457,6 +458,10 @@ asmlinkage long sys_capset(cap_user_header_t header, const cap_user_data_t data)
>  		i++;
>  	}
> 
> +	ret = audit_log_capset(pid, &effective, &inheritable, &permitted);
> +	if (ret)
> +		return ret;
> +
>  	if (pid && (pid != task_pid_vnr(current)))
>  		ret = do_sys_capset_other_tasks(pid, &effective, &inheritable,
>  						&permitted);
