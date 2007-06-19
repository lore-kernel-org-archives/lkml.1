Return-Path: <linux-kernel-owner+w=401wt.eu-S1754718AbXFSOFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbXFSOFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 10:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbXFSOFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 10:05:09 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:52825 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbXFSOFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 10:05:07 -0400
Message-ID: <4677E28C.5050304@fr.ibm.com>
Date: Tue, 19 Jun 2007 16:05:00 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Herbert Poetzl <herbert@13thfloor.at>, pbadari@us.ibm.com,
       containers@lists.osdl.org, ebiederm@xmission.com, serue@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] create_new_namespaces: fix improper return of NULL
References: <200705090245.l492jZwD008756@shell0.pdx.osdl.net> <20070616191742.GA13434@MAIL.13thfloor.at> <20070617143830.GA379@tv-sign.ru> <20070617163004.GA553@tv-sign.ru> <20070619135129.GA27343@tv-sign.ru>
In-Reply-To: <20070619135129.GA27343@tv-sign.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> Untested.
> 
> dup_mnt_ns() and clone_uts_ns() return NULL on failure. This is wrong,
> create_new_namespaces() uses ERR_PTR() to catch an error. This means
> that the subsequent create_new_namespaces() will hit BUG_ON() in
> copy_mnt_ns() or copy_utsname().

I sent one just like it :

	http://lkml.org/lkml/2007/6/12/142

but your changelog is worth adding. much better than mine.

thanks,

C. 

> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
> 
> --- ns/fs/namespace.c~1_NS_NULL	2007-05-21 13:57:56.000000000 +0400
> +++ ns/fs/namespace.c	2007-06-19 17:26:35.000000000 +0400
> @@ -1457,7 +1457,7 @@ static struct mnt_namespace *dup_mnt_ns(
> 
>  	new_ns = kmalloc(sizeof(struct mnt_namespace), GFP_KERNEL);
>  	if (!new_ns)
> -		return NULL;
> +		return ERR_PTR(-ENOMEM);
> 
>  	atomic_set(&new_ns->count, 1);
>  	INIT_LIST_HEAD(&new_ns->list);
> @@ -1471,7 +1471,7 @@ static struct mnt_namespace *dup_mnt_ns(
>  	if (!new_ns->root) {
>  		up_write(&namespace_sem);
>  		kfree(new_ns);
> -		return NULL;
> +		return ERR_PTR(-ENOMEM);
>  	}
>  	spin_lock(&vfsmount_lock);
>  	list_add_tail(&new_ns->list, &new_ns->root->mnt_list);
> --- ns/kernel/utsname.c~1_NS_NULL	2007-05-21 13:57:59.000000000 +0400
> +++ ns/kernel/utsname.c	2007-06-19 17:35:22.000000000 +0400
> @@ -13,6 +13,7 @@
>  #include <linux/uts.h>
>  #include <linux/utsname.h>
>  #include <linux/version.h>
> +#include <linux/err.h>
> 
>  /*
>   * Clone a new ns copying an original utsname, setting refcount to 1
> @@ -24,10 +25,11 @@ static struct uts_namespace *clone_uts_n
>  	struct uts_namespace *ns;
> 
>  	ns = kmalloc(sizeof(struct uts_namespace), GFP_KERNEL);
> -	if (ns) {
> -		memcpy(&ns->name, &old_ns->name, sizeof(ns->name));
> -		kref_init(&ns->kref);
> -	}
> +	if (!ns)
> +		return ERR_PTR(-ENOMEM);
> +
> +	memcpy(&ns->name, &old_ns->name, sizeof(ns->name));
> +	kref_init(&ns->kref);
>  	return ns;
>  }
> 
> 
> 

