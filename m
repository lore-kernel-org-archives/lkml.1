Return-Path: <linux-kernel-owner+w=401wt.eu-S1762931AbXJDQSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762931AbXJDQSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 12:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760065AbXJDQRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 12:17:35 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:41600 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760683AbXJDQRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 12:17:33 -0400
Date: Thu, 4 Oct 2007 09:11:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Takenori Nagano <t-nagano@ah.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, vgoyal@in.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, k-miyoshi@cb.jp.nec.com,
       kexec@lists.infradead.org, Bernhard Walle <bwalle@suse.de>,
       Keith Owens <kaos@ocs.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, kdb@oss.sgi.com
Subject: Re: [PATCH 1/2] add tunable_notifier function
Message-Id: <20071004091157.c35f3513.randy.dunlap@oracle.com>
In-Reply-To: <4704D0BA.4090507@ah.jp.nec.com>
References: <4704D0BA.4090507@ah.jp.nec.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Oct 2007 20:38:34 +0900 Takenori Nagano wrote:

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

> diff -uprN linux-2.6.23-rc9.orig/kernel/sys.c linux-2.6.23-rc9/kernel/sys.c
> --- linux-2.6.23-rc9.orig/kernel/sys.c	2007-10-02 12:24:52.000000000 +0900
> +++ linux-2.6.23-rc9/kernel/sys.c	2007-10-03 14:48:15.160000000 +0900
> @@ -38,6 +38,7 @@
>  #include <linux/syscalls.h>
>  #include <linux/kprobes.h>
>  #include <linux/user_namespace.h>
> +#include <linux/debugfs.h>
> 
>  #include <asm/uaccess.h>
>  #include <asm/io.h>
> @@ -393,6 +394,234 @@ int blocking_notifier_call_chain(struct

> +/**
> + *	tunable_notifier_chain_register - Add notifier to an tunable notifier chain
> + *	@nh: Pointer to head of the tunable notifier chain
> + *	@n: New entry in notifier chain
> + *	@name: Pointer to the name of this notifier chain

Is @name the name of a notifier chain or of the new notifier entry?


> + *	@desc: Pointer to the description of new entry
> + *
> + *	Adds a notifier to an tunable notifier chain and makes control dir.
> + *
> + *	Returns zero on success or %-ENODEV on failure.
> + */
> +
> +int tunable_notifier_chain_register(struct tunable_notifier_head *nh,
> +		struct tunable_notifier_block *n, char *name, char *desc)
> +{
> +	unsigned long flags;
> +	int ret = -EINVAL;
> +	struct dentry *nh_dir, *nb_dir, *pri_dentry, *desc_dentry = NULL;
> +
> +	if (!name)
> +		goto nb_fail;
> +
> +	ret = -ENOMEM;
> +	if (!nh->dir) {
> +		nh_dir = debugfs_create_dir(nh->name, NULL);
> +		if (!nh_dir)
> +			return ret;
> +		nh->dir = nh_dir;
> +	} else
> +		nh_dir = nh->dir;
> +
> +	nb_dir = debugfs_create_dir(name, nh_dir);
> +	if (!nb_dir)
> +		goto nb_fail;
> +	n->dir = nb_dir;
> +
> +	pri_dentry = debugfs_create_file("priority",0600, nb_dir, n, &pri_fops);
> +	if (!pri_dentry)
> +		goto pri_fail;
> +	n->pri_dentry = pri_dentry;
> +
> +	if (desc) {
> +		desc_dentry = debugfs_create_file("description", 0400, nb_dir,
> +							desc, &desc_fops);
> +		if (!desc_dentry)
> +			goto desc_fail;
> +		n->desc_dentry = desc_dentry;
> +	}
> +
> +	spin_lock_irqsave(&nh->lock, flags);
> +	ret = notifier_chain_register(&nh->head, n->nb);
> +	spin_unlock_irqrestore(&nh->lock, flags);
> +
> +	if (ret)
> +		goto reg_fail;
> +	
> +	n->head = nh;
> +
> +	return ret;
> +
> +reg_fail:
> +	debugfs_remove(desc_dentry);
> +desc_fail:
> +	debugfs_remove(pri_dentry);
> +pri_fail:
> +	debugfs_remove(nb_dir);
> +nb_fail:
> +	return ret;
> +}
> +
> +EXPORT_SYMBOL_GPL(tunable_notifier_chain_register);

---
~Randy
