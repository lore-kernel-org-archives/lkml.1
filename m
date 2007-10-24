Return-Path: <linux-kernel-owner+w=401wt.eu-S1760714AbXJXSQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760714AbXJXSQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 14:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755928AbXJXSQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 14:16:41 -0400
Received: from xenotime.net ([66.160.160.81]:42628 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755518AbXJXSQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 14:16:40 -0400
Date: Wed, 24 Oct 2007 11:16:29 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Takenori Nagano <t-nagano@ah.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, vgoyal@in.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, k-miyoshi@cb.jp.nec.com,
       kexec@lists.infradead.org, Bernhard Walle <bwalle@suse.de>,
       Keith Owens <kaos@ocs.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, kdb@oss.sgi.com
Subject: Re: [PATCH 1/2] add tunable_notifier function ,take2
Message-Id: <20071024111629.3e28b452.rdunlap@xenotime.net>
In-Reply-To: <47171EEC.4030408@ah.jp.nec.com>
References: <4716FFDB.7090502@ah.jp.nec.com>
	<47171EEC.4030408@ah.jp.nec.com>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2007 17:53:00 +0900 Takenori Nagano wrote:

> This patch adds new notifier function tunable_notifier_chain. Its base is
> atomic_notifier_chain.
> 
> Thanks,
> 
> ---
> 
> Signed-off-by: Takenori Nagano <t-nagano@ah.jp.nec.com>
> 
> ---
> diff -uprN linux-2.6.23.orig/kernel/sys.c linux-2.6.23/kernel/sys.c
> --- linux-2.6.23.orig/kernel/sys.c	2007-10-10 05:31:38.000000000 +0900
> +++ linux-2.6.23/kernel/sys.c	2007-10-18 10:08:52.728000000 +0900
> @@ -38,6 +38,7 @@
>  #include <linux/syscalls.h>
>  #include <linux/kprobes.h>
>  #include <linux/user_namespace.h>
> +#include <linux/debugfs.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/io.h>
> @@ -393,6 +394,243 @@ int blocking_notifier_call_chain(struct 
>  EXPORT_SYMBOL_GPL(blocking_notifier_call_chain);

> +/**
> + *	tunable_atomic_notifier_chain_register
> + *				- Add notifier to an tunable notifier chain

Function name & short description must be on one (long?) line.  :(

> + *	@nh: Pointer to head of the tunable notifier chain
> + *	@n: New entry in notifier chain
> + *	@name: Pointer to the name of the new notifier entry
> + *	@desc: Pointer to the description of new entry
> + *
> + *	Adds a notifier to an tunable notifier chain and makes control dir.
> + *
> + *	Returns zero on success or %-ENODEV on failure.
> + */
> +
> +int tunable_atomic_notifier_chain_register(
> +		struct tunable_atomic_notifier_head *nh,
> +		struct tunable_atomic_notifier_block *n, char *name, char *desc)
> +{

> +}
> +
> +EXPORT_SYMBOL_GPL(tunable_atomic_notifier_chain_register);
> +
> +/**
> + *	tunable_atomic_notifier_chain_unregister
> + *				- Remove notifier from a tunable notifier chain

Ditto.

> + *	@nh: Pointer to head of the tunable notifier chain
> + *	@n: Entry to remove from notifier chain
> + *
> + *	Removes a notifier from a tunable notifier chain.
> + *
> + *	Retunrns zero on success or %-ENOENT on failure.
> + */
> +
> +int tunable_atomic_notifier_chain_unregister(
> +				struct tunable_atomic_notifier_head *nh,
> +				struct tunable_atomic_notifier_block *n)
> +{

> +}
> +
> +EXPORT_SYMBOL_GPL(tunable_atomic_notifier_chain_unregister);
> +
> +/**
> + *	__tunable_atomic_notifier_call_chain
> + *				- Call functions in a tunable notifier chain

Same.

> + *	@nh: Pointer to head of the tunable notifier chain
> + *	@val: Value passed unmodified to notifier function
> + *	@v: Pointer passed unmodified to notifier function
> + *	@nt_to_call: See the comment for notifier_call_chain

	@nr_to_call: ...

> + *	@nr_calls: See the comment for notifier_call_chain
> + *
> + *	Calls each function in a notifier chain in turn. The functions
> + *	run in an atomic context, so they must not block.
> + *	This routine uses RCU to synchronize with changes to the chain.
> + *
> + *	If the return value of the notifier can be and'ed
> + *	with %NOTIFY_STOP_MASK then tunable_atomic_notifier_call_chain()
> + *	will return immediately, with the return value of
> + *	the notifier function which halted execution.
> + *	Otherwise the return value is the return value
> + *	of the last notifier function called.
> + */
> +
> +int __kprobes __tunable_atomic_notifier_call_chain(
> +					struct tunable_atomic_notifier_head *nh,
> +					unsigned long val, void *v,
> +					int nr_to_call, int *nr_calls)
> +{
> +	int ret;
> +
> +	rcu_read_lock();
> +	ret = notifier_call_chain(&nh->head, val, v, nr_to_call, nr_calls);
> +	rcu_read_unlock();
> +	return ret;
> +}
> +
> +EXPORT_SYMBOL_GPL(__tunable_atomic_notifier_call_chain);

Blank line is usually omitted before EXPORT_SYMBOL....

---
~Randy
