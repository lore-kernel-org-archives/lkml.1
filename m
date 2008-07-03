Return-Path: <linux-kernel-owner+w=401wt.eu-S1757077AbYGCVUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077AbYGCVUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 17:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbYGCVUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 17:20:25 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:50939 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022AbYGCVUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 17:20:24 -0400
Subject: Re: [PATCH 1/1] IPC - Do not use a negative value to re-enable
	msgmni automatic recomputing
From: Matt Helsley <matthltc@us.ibm.com>
To: Nadia.Derbey@bull.net
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Solofo.Ramangalahy@bull.net
In-Reply-To: <20080703121555.386008000@bull.net>
References: <20080703121515.554681000@bull.net>
	 <20080703121555.386008000@bull.net>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Thu, 03 Jul 2008 14:20:21 -0700
Message-Id: <1215120021.14808.176.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-07-03 at 14:15 +0200, Nadia.Derbey@bull.net wrote:
> plain text document attachment (auto_msgmni_proc_file.patch)
> [PATCH 01/01]
> 
> This patch proposes an alternative to the "magical positive-versus-negative
> number trick" Andrew complained about last week in
> http://lkml.org/lkml/2008/6/24/418
> 
> This had been introduced with the patches that scale msgmni to the amount of
> lowmem. With these patches, msgmni has a registered notification routine
> that recomputes msgmni value upon memory add/remove or ipc namespace creation/
> removal.
> 
> When msgmni is changed from user space (i.e. value written to the proc file),
> that notification routine is unregistered, and the way to make it registered
> back is to write a negative value into the proc file. This is the "magical
> positive-versus-negative number trick".
> 
> To fix this, a new proc file is introduced: /proc/sys/kernel/auto_msgmni.
> This file acts as ON/OFF for msgmni automatic recomputing.
> 
> With this patch, the process is the following:
> 1) kernel boots in "automatic recomputing mode"
>    /proc/sys/kernel/msgmni contains the value that has been computed (depends
>                            on lowmem)
>    /proc/sys/kernel/automatic_msgmni contains "1"
> 
> 2) echo <val> > /proc/sys/kernel/msgmni
>    . sets msg_ctlmni to <val>
>    . de-activates automatic recomputing (i.e. if, say, some memory is added
>      msgmni won't be recomputed anymore)
>    . /proc/sys/kernel/automatic_msgmni now contains "0"
> 
> 3) echo "0" > /proc/sys/kernel/automatic_msgmni
>    . de-activates msgmni automatic recomputing
>      this has the same effect as 2) except that msg_ctlmni's value stays
>      blocked at its current value)
> 
> 3) echo "1" > /proc/sys/kernel/automatic_msgmni
>    . recomputes msgmni's value based on the current available memory size
>      and number of ipc namespaces
>    . re-activates automatic recomputing for msgmni.
> 
> This patch applies to 2.6.26-rc5-mm3.

This makes sense to me.

> Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
> 
> ---
>  include/linux/ipc_namespace.h |    1 
>  ipc/ipc_sysctl.c              |   75 ++++++++++++++++++++++++++++++++++--------
>  ipc/ipcns_notifier.c          |   19 ++++++++--
>  3 files changed, 78 insertions(+), 17 deletions(-)
> 
> Index: linux-2.6.26-rc5-mm3/ipc/ipc_sysctl.c
> ===================================================================
> --- linux-2.6.26-rc5-mm3.orig/ipc/ipc_sysctl.c	2008-06-16 09:12:57.000000000 +0200
> +++ linux-2.6.26-rc5-mm3/ipc/ipc_sysctl.c	2008-07-03 13:29:50.000000000 +0200
> @@ -27,15 +27,17 @@ static void *get_ipc(ctl_table *table)
>  }
> 
>  /*
> - * Routine that is called when a tunable has successfully been changed by
> - * hand and it has a callback routine registered on the ipc namespace notifier
> - * chain: we don't want such tunables to be recomputed anymore upon memory
> - * add/remove or ipc namespace creation/removal.
> - * They can come back to a recomputable state by being set to a <0 value.
> + * Routine that is called when the file "auto_msgmni" has successfully been
> + * written.
> + * Two values are allowed:
> + * 0: unregister msgmni's callback routine from the ipc namespace notifier
> + *    chain. This means that msgmni won't be recomputed anymore upon memory
> + *    add/remove or ipc namespace creation/removal.
> + * 1: register back the callback routine.
>   */
> -static void tunable_set_callback(int val)
> +static void ipc_auto_callback(int val)
>  {
> -	if (val >= 0)
> +	if (!val)
>  		unregister_ipcns_notifier(current->nsproxy->ipc_ns);
>  	else {
>  		/*
> @@ -71,7 +73,15 @@ static int proc_ipc_callback_dointvec(ct
>  	rc = proc_dointvec(&ipc_table, write, filp, buffer, lenp, ppos);
> 
>  	if (write && !rc && lenp_bef == *lenp)
> -		tunable_set_callback(*((int *)(ipc_table.data)));
> +		/*
> +		 * Tunable has successfully been changed by hand and it has a
> +		 * callback routine registered on the ipc namespace notifier
> +		 * chain: we don't want this tunable to be recomputed anymore
> +		 * upon memory add/remove or ipc namespace creation/removal.
> +		 * It can come back to a recomputable state if the
> +		 * corresponding auto_ file is set to 1.
> +		 */

The register_ipcns_notifier() code tells us what will trigger the
recalculation. If that code gets changed you'd need to update this
comment. Also your comment at the top of the function describes what 0/1
mean when written to this file. So I think this comment could be greatly
simplified:

/*
 * Disabling automatic adjustment of msgmni simply requires
 * unregistering the notifiers that trigger recalculation.
 */

> +		unregister_ipcns_notifier(current->nsproxy->ipc_ns);
> 
>  	return rc;
>  }
> @@ -87,10 +97,39 @@ static int proc_ipc_doulongvec_minmax(ct
>  					lenp, ppos);
>  }
> 
> +static int proc_ipcauto_dointvec_minmax(ctl_table *table, int write,
> +	struct file *filp, void __user *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	struct ctl_table ipc_table;
> +	size_t lenp_bef = *lenp;
> +	int oldval;
> +	int rc;
> +
> +	memcpy(&ipc_table, table, sizeof(ipc_table));
> +	ipc_table.data = get_ipc(table);
> +	oldval = *((int *)(ipc_table.data));
> +
> +	rc = proc_dointvec_minmax(&ipc_table, write, filp, buffer, lenp, ppos);
> +
> +	if (write && !rc && lenp_bef == *lenp) {
> +		int newval = *((int *)(ipc_table.data));
> +		/*
> +		 * The file "auto_msgmni" has correctly been set.
> +		 * React by (un)registering the corresponding tunable, if the
> +		 * value has changed.
> +		 */
> +		if (newval != oldval)
> +			ipc_auto_callback(newval);
> +	}
> +
> +	return rc;
> +}
> +
>  #else
>  #define proc_ipc_doulongvec_minmax NULL
>  #define proc_ipc_dointvec	   NULL
>  #define proc_ipc_callback_dointvec NULL
> +#define proc_ipcauto_dointvec_minmax NULL
>  #endif
> 
>  #ifdef CONFIG_SYSCTL_SYSCALL
> @@ -142,14 +181,11 @@ static int sysctl_ipc_registered_data(ct
>  	rc = sysctl_ipc_data(table, name, nlen, oldval, oldlenp, newval,
>  		newlen);
> 
> -	if (newval && newlen && rc > 0) {
> +	if (newval && newlen && rc > 0)
>  		/*
>  		 * Tunable has successfully been changed from userland
>  		 */
> -		int *data = get_ipc(table);
> -
> -		tunable_set_callback(*data);
> -	}
> +		unregister_ipcns_notifier(current->nsproxy->ipc_ns);
> 
>  	return rc;
>  }
> @@ -158,6 +194,9 @@ static int sysctl_ipc_registered_data(ct
>  #define sysctl_ipc_registered_data NULL
>  #endif
> 
> +static int zero;
> +static int one = 1;
> +
>  static struct ctl_table ipc_kern_table[] = {
>  	{
>  		.ctl_name	= KERN_SHMMAX,
> @@ -222,6 +261,16 @@ static struct ctl_table ipc_kern_table[]
>  		.proc_handler	= proc_ipc_dointvec,
>  		.strategy	= sysctl_ipc_data,
>  	},
> +	{
> +		.ctl_name	= CTL_UNNUMBERED,
> +		.procname	= "auto_msgmni",
> +		.data		= &init_ipc_ns.auto_msgmni,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_ipcauto_dointvec_minmax,
> +		.extra1		= &zero,
> +		.extra2		= &one,
> +	},
>  	{}
>  };
> 
> Index: linux-2.6.26-rc5-mm3/include/linux/ipc_namespace.h
> ===================================================================
> --- linux-2.6.26-rc5-mm3.orig/include/linux/ipc_namespace.h	2008-06-16 09:12:03.000000000 +0200
> +++ linux-2.6.26-rc5-mm3/include/linux/ipc_namespace.h	2008-07-03 08:33:56.000000000 +0200
> @@ -36,6 +36,7 @@ struct ipc_namespace {
>  	int		msg_ctlmni;
>  	atomic_t	msg_bytes;
>  	atomic_t	msg_hdrs;
> +	int		auto_msgmni;
> 
>  	size_t		shm_ctlmax;
>  	size_t		shm_ctlall;
> Index: linux-2.6.26-rc5-mm3/ipc/ipcns_notifier.c
> ===================================================================
> --- linux-2.6.26-rc5-mm3.orig/ipc/ipcns_notifier.c	2008-06-16 09:12:57.000000000 +0200
> +++ linux-2.6.26-rc5-mm3/ipc/ipcns_notifier.c	2008-07-03 11:38:07.000000000 +0200
> @@ -55,25 +55,36 @@ static int ipcns_callback(struct notifie
> 
>  int register_ipcns_notifier(struct ipc_namespace *ns)
>  {
> +	int rc;
> +
>  	memset(&ns->ipcns_nb, 0, sizeof(ns->ipcns_nb));
>  	ns->ipcns_nb.notifier_call = ipcns_callback;
>  	ns->ipcns_nb.priority = IPCNS_CALLBACK_PRI;
> -	return blocking_notifier_chain_register(&ipcns_chain, &ns->ipcns_nb);
> +	rc = blocking_notifier_chain_register(&ipcns_chain, &ns->ipcns_nb);
> +	if (!rc)
> +		ns->auto_msgmni = 1;
> +	return rc;
>  }
> 
>  int cond_register_ipcns_notifier(struct ipc_namespace *ns)
>  {
> +	int rc;
> +
>  	memset(&ns->ipcns_nb, 0, sizeof(ns->ipcns_nb));
>  	ns->ipcns_nb.notifier_call = ipcns_callback;
>  	ns->ipcns_nb.priority = IPCNS_CALLBACK_PRI;
> -	return blocking_notifier_chain_cond_register(&ipcns_chain,
> +	rc = blocking_notifier_chain_cond_register(&ipcns_chain,
>  							&ns->ipcns_nb);
> +	if (!rc)
> +		ns->auto_msgmni = 1;
> +	return rc;
>  }
> 
>  int unregister_ipcns_notifier(struct ipc_namespace *ns)
>  {
> -	return blocking_notifier_chain_unregister(&ipcns_chain,
> -						&ns->ipcns_nb);
> +	blocking_notifier_chain_unregister(&ipcns_chain, &ns->ipcns_nb);
> +	ns->auto_msgmni = 0;
> +	return 0;
>  }

This looks odd -- we're no longer returning the return code from
blocking_notifier_chain_unregister(). From what I can see in the patch,
the return value is unused. Perhaps it ought to be removed? Otherwise it
might make sense to do the same as you did with "register":

        rc = blocking_notifier_chain_unregister(&ipcns_chain, &ns->ipcns_nb);
        if (!rc)
        	ns->auto_msgmni = 0;
        return rc;

Cheers,
	-Matt Helsley

