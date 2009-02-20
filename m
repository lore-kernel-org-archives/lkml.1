Return-Path: <linux-kernel-owner+w=401wt.eu-S1755736AbZBTW3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736AbZBTW3Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 17:29:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbZBTW3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 17:29:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753471AbZBTW3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 17:29:14 -0500
Date: Fri, 20 Feb 2009 14:28:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: a.beregalov@gmail.com, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, xfs@oss.sgi.com, jmorris@namei.org
Subject: Re: next-20090220: XFS, IMA: BUG: sleeping function called from
 invalid  context at mm/slub.c:1613
Message-Id: <20090220142807.a28734a8.akpm@linux-foundation.org>
In-Reply-To: <1235168219.3019.4.camel@localhost.localdomain>
References: <a4423d670902200300n1d1bfdeeg6daca4b32989c9d3@mail.gmail.com>
	<20090220122242.b36a778f.akpm@linux-foundation.org>
	<1235168219.3019.4.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Feb 2009 17:16:59 -0500
Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> integrity: ima iint radix_tree_lookup locking fix
> 
> Based on Andrew Morton's comments:
> - add missing locks around radix_tree_lookup in ima_iint_insert()
> 
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> 
> Index: security-testing-2.6/security/integrity/ima/ima_iint.c
> ===================================================================
> --- security-testing-2.6.orig/security/integrity/ima/ima_iint.c
> +++ security-testing-2.6/security/integrity/ima/ima_iint.c
> @@ -73,8 +73,10 @@ out:
>  	if (rc < 0) {
>  		kmem_cache_free(iint_cache, iint);
>  		if (rc == -EEXIST) {
> +			spin_lock(&ima_iint_lock);
>  			iint = radix_tree_lookup(&ima_iint_store,
>  						 (unsigned long)inode);
> +			spin_unlock(&ima_iint_lock);
>  		} else
>  			iint = NULL;
>  	}

Can the -EEXIST ever actually happen?

On the inode_init_always() path (at least), I don't think that any
other thread of control can have access to this inode*, so there is no
way in which a race can result in someone else adding this inode
first?


Also, idle question: why does the radix tree exist at all?  Would it
have been possible to just add a `struct ima_iint_cache *' field to the
inode instead?

