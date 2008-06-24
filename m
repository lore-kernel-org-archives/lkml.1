Return-Path: <linux-kernel-owner+w=401wt.eu-S1757831AbYFXVdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831AbYFXVdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 17:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbYFXVdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 17:33:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756000AbYFXVdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 17:33:36 -0400
Date: Tue, 24 Jun 2008 14:31:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: <Solofo.Ramangalahy@bull.net>
Cc: linux-kernel@vger.kernel.org, matthltc@us.ibm.com, cmm@us.ibm.com,
       Nadia.Derbey@bull.net, manfred@colorfullife.com,
       nickpiggin@yahoo.com.au, Solofo.Ramangalahy@bull.net
Subject: Re: [PATCH -mm 1/3] sysv ipc: increase msgmnb default value wrt.
 the number of cpus
Message-Id: <20080624143120.9bed4f18.akpm@linux-foundation.org>
In-Reply-To: <20080624093453.201071209@bull.net>
References: <20080624093452.946878437@bull.net>
	<20080624093453.201071209@bull.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2008 11:34:53 +0200
<Solofo.Ramangalahy@bull.net> wrote:

> From: Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>
> 
> Initialize msgmnb value to
> min(MSGMNB * num_online_cpus(), MSGMNB * MSG_CPU_SCALE)
> to increase the default value for larger machines.
> 
> MSG_CPU_SCALE scaling factor is defined to be 4, as 16384 x 4 = 65536
> is an already used and recommended value.
> 
> The msgmni value is made dependant of msgmnb to keep the memory
> dedicated to message queues within the 1/MSG_MEM_SCALE of lowmem
> bound.
> 
> Unlike msgmni, the value is not scaled (down) with respect to the
> number of ipc namespaces for simplicity.
> 
> To disable recomputation when user explicitely set a value,
> we reuse the callback defined for msgmni.
> 
> As msgmni and msgmnb are correlated, user settings of any of the two
> disable recomputation of both, for now. This is refined in a later
> patch.
> 
> When a negative value is put in /proc/sys/kernel/msgmnb
> automatic recomputing is re-enabled.
> 

Thanks for taking the time to describe this work so well.

> 
> ---
>  Documentation/sysctl/kernel.txt |   28 ++++++++++++++++++++++++++++
>  include/linux/msg.h             |    6 ++++++
>  ipc/ipc_sysctl.c                |    5 +++--
>  ipc/msg.c                       |   17 +++++++++++++----
>  4 files changed, 50 insertions(+), 6 deletions(-)
> 
> Index: b/ipc/msg.c
> ===================================================================
> --- a/ipc/msg.c
> +++ b/ipc/msg.c
> @@ -38,6 +38,7 @@
>  #include <linux/rwsem.h>
>  #include <linux/nsproxy.h>
>  #include <linux/ipc_namespace.h>
> +#include <linux/cpumask.h>
>  
>  #include <asm/current.h>
>  #include <asm/uaccess.h>
> @@ -92,7 +93,7 @@ void recompute_msgmni(struct ipc_namespa
>  
>  	si_meminfo(&i);
>  	allowed = (((i.totalram - i.totalhigh) / MSG_MEM_SCALE) * i.mem_unit)
> -		/ MSGMNB;
> +		/ ns->msg_ctlmnb;
>  	nb_ns = atomic_read(&nr_ipc_ns);
>  	allowed /= nb_ns;
>  
> @@ -108,11 +109,19 @@ void recompute_msgmni(struct ipc_namespa
>  
>  	ns->msg_ctlmni = allowed;
>  }
> +/*
> + * Scale msgmnb with the number of online cpus, up to 4x MSGMNB.
> + */
> +void recompute_msgmnb(struct ipc_namespace *ns)
> +{
> +	ns->msg_ctlmnb =
> +		min(MSGMNB * num_online_cpus(), MSGMNB * MSG_CPU_SCALE);
> +}
>  
>  void msg_init_ns(struct ipc_namespace *ns)
>  {
>  	ns->msg_ctlmax = MSGMAX;
> -	ns->msg_ctlmnb = MSGMNB;
> +	recompute_msgmnb(ns);
>  
>  	recompute_msgmni(ns);
>  
> @@ -132,8 +141,8 @@ void __init msg_init(void)
>  {
>  	msg_init_ns(&init_ipc_ns);
>  
> -	printk(KERN_INFO "msgmni has been set to %d\n",
> -		init_ipc_ns.msg_ctlmni);
> +	printk(KERN_INFO "msgmni has been set to %d, msgmnb to %d\n",
> +	       init_ipc_ns.msg_ctlmni, init_ipc_ns.msg_ctlmnb);
>  
>  	ipc_init_proc_interface("sysvipc/msg",
>  				"       key      msqid perms      cbytes       qnum lspid lrpid   uid   gid  cuid  cgid      stime      rtime      ctime\n",
> Index: b/include/linux/msg.h
> ===================================================================
> --- a/include/linux/msg.h
> +++ b/include/linux/msg.h
> @@ -58,6 +58,12 @@ struct msginfo {
>   * more than 16 GB : msgmni = 32K (IPCMNI)
>   */
>  #define MSG_MEM_SCALE 32
> +/*
> + * Scaling factor to compute msgmnb: ns->msg_ctlmnb is between MSGMNB
> + * and MSGMNB * MSG_CPU_SCALE. This leads to a max msgmnb value of
> + * 65536 which is an already used and recommended value.
> + */
> +#define MSG_CPU_SCALE 4
>  
>  #define MSGMNI    16   /* <= IPCMNI */     /* max # of msg queue identifiers */
>  #define MSGMAX  8192   /* <= INT_MAX */   /* max size of message (bytes) */
> Index: b/ipc/ipc_sysctl.c
> ===================================================================
> --- a/ipc/ipc_sysctl.c
> +++ b/ipc/ipc_sysctl.c
> @@ -42,6 +42,7 @@ static void tunable_set_callback(int val
>  		 * Re-enable automatic recomputing only if not already
>  		 * enabled.
>  		 */
> +		recompute_msgmnb(current->nsproxy->ipc_ns);
>  		recompute_msgmni(current->nsproxy->ipc_ns);
>  		cond_register_ipcns_notifier(current->nsproxy->ipc_ns);
>  	}
> @@ -210,8 +211,8 @@ static struct ctl_table ipc_kern_table[]
>  		.data		= &init_ipc_ns.msg_ctlmnb,
>  		.maxlen		= sizeof (init_ipc_ns.msg_ctlmnb),
>  		.mode		= 0644,
> -		.proc_handler	= proc_ipc_dointvec,
> -		.strategy	= sysctl_ipc_data,
> +		.proc_handler	= proc_ipc_callback_dointvec,
> +		.strategy	= sysctl_ipc_registered_data,
>  	},
>  	{
>  		.ctl_name	= KERN_SEM,
> Index: b/Documentation/sysctl/kernel.txt
> ===================================================================
> --- a/Documentation/sysctl/kernel.txt
> +++ b/Documentation/sysctl/kernel.txt
> @@ -179,6 +179,34 @@ kernel stack.
>  
>  ==============================================================
>  
> +msgmnb
> +
> +Maximum size in bytes (not in message count) of a single SystemV IPC
> +message queue (b stands for bytes).
> +
> +This value is dynamic and depends on the online cpu count of the
> +machine (taking cpu hotplug into account).
> +
> +Computed values are between MSGMNB and MSGMNB*MSG_CPU_SCALE #define
> +constants (currently [16384,65536]).
> +
> +The exact value is automatically (re)computed, but:
> +. If the value is positioned from user space (via procfs or sysctl()),
> +  to a positive value then the automatic recomputation is
> +  disabled. This leaves control to user space. E.g.
> +
> +  # echo 16384 > /proc/sys/kernel/msgmnb
> +
> +. If the value is positioned from user space to a negative value, then
> +  the computation is reenabled. E.g.
> +
> +  # echo -1 > /proc/sys/kernel/msgmnb
> +
> +See recompute_msgmnb() function in ipc/ directory for details.
> +The value of msgmnb is coupled with the value of msgmni.
> +

The magical positive-versus-negative number trick is a bit obscure, and
I don't think there's any precedent for it in the kernel ABI (which is
what this is).

Is there anything we can do to reduce the unusualness of this
interface?  Say, add a new /proc/sys/kernel/automatic-msgmnb which
contains the automatic scaling and leave /proc/sys/kernel/msgmnb
containing the manual scaling?  Or something like that?
