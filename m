Return-Path: <linux-kernel-owner+w=401wt.eu-S1757878AbYGUIaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878AbYGUIaQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 04:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755408AbYGUIaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 04:30:01 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54298 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755010AbYGUIaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 04:30:00 -0400
Message-ID: <488448A1.3030608@cn.fujitsu.com>
Date: Mon, 21 Jul 2008 16:28:17 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfs: use kstrdup()
References: <4881BEF4.2020201@cn.fujitsu.com> <20080719131317.GA7027@asus> <20080719131909.GB7027@asus> <20080721052713.GY28946@ZenIV.linux.org.uk> <48842CDB.1090009@cn.fujitsu.com> <20080721070346.GA28946@ZenIV.linux.org.uk> <20080721080427.GC6662@lenovo>
In-Reply-To: <20080721080427.GC6662@lenovo>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> [Al Viro - Mon, Jul 21, 2008 at 08:03:46AM +0100]
> | 
> [...]
> | The right thing here is to consider failing allocation of ->mnt_devname
> | as failure of the entire alloc.
> | 
> 
> Al, what about the patch below? I'm not sure if Li's version already
> in someone tree so it's from-the-scratch. If this ok, i think Li could
> update his version and resend.
> 

It's already in -mm tree, but Andrew can drop it and queue the new one.

> 		- Cyrill -
> ---
> 
> Index: linux-2.6.git/fs/namespace.c
> ===================================================================
> --- linux-2.6.git.orig/fs/namespace.c	2008-07-21 11:34:37.000000000 +0400
> +++ linux-2.6.git/fs/namespace.c	2008-07-21 12:00:01.000000000 +0400
> @@ -112,9 +112,13 @@ struct vfsmount *alloc_vfsmnt(const char
>  		int err;
>  
>  		err = mnt_alloc_id(mnt);
> -		if (err) {
> -			kmem_cache_free(mnt_cache, mnt);
> -			return NULL;
> +		if (err)
> +			goto err;
> +
> +		if (name) {
> +			mnt->mnt_devname = kstrdup(name, GFP_KERNEL);
> +			if (!mnt->mnt_devname)

should call mnt_free_id() here.

> +				goto err;
>  		}
>  
>  		atomic_set(&mnt->mnt_count, 1);
> @@ -127,16 +131,12 @@ struct vfsmount *alloc_vfsmnt(const char
>  		INIT_LIST_HEAD(&mnt->mnt_slave_list);
>  		INIT_LIST_HEAD(&mnt->mnt_slave);
>  		atomic_set(&mnt->__mnt_writers, 0);
> -		if (name) {
> -			int size = strlen(name) + 1;
> -			char *newname = kmalloc(size, GFP_KERNEL);
> -			if (newname) {
> -				memcpy(newname, name, size);
> -				mnt->mnt_devname = newname;
> -			}
> -		}
>  	}
>  	return mnt;
> +
> +err:
> +	kmem_cache_free(mnt_cache, mnt);
> +	return NULL;
>  }
>  
>  /*
> 
> 
