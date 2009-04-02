Return-Path: <linux-kernel-owner+w=401wt.eu-S932669AbZDBSLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669AbZDBSLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765346AbZDBSKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:10:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765785AbZDBSKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:10:51 -0400
Date: Thu, 2 Apr 2009 11:08:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: npiggin@suse.de, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/2] fs: mnt_want_write speedup
Message-Id: <20090402110824.e0c1ec72.akpm@linux-foundation.org>
In-Reply-To: <1236809477.30142.83.camel@nimitz>
References: <20090310143718.GB15977@wotan.suse.de>
	<1236809477.30142.83.camel@nimitz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009 15:11:17 -0700
Dave Hansen <dave@linux.vnet.ibm.com> wrote:

> I'm feeling a bit better about these, although I am still honestly quite
> afraid of the barriers.  I also didn't like all the #ifdefs much, but
> here's some help on that.

Do we need the ifdefs at all?

> How about this on top of what you have as a bit of a cleanup?  It gets
> rid of all the new #ifdefs in .c files?
> 
> Did I miss the use of get_mnt_writers_ptr()?  I don't think I actually
> saw it used anywhere in this pair of patches, so I've stolen it.  I
> think gcc should compile all this new stuff down to be basically the
> same as you had before.  The one thing I'm not horribly sure of is the
> "out_free_devname:" label.  It shouldn't be reachable in the !SMP case. 
> 
> I could also consolidate the header #ifdefs into a single one if you
> think that looks better.
> 
> This is just compile tested, btw.  
> 
> ---
> 
>  linux-2.6.git-dave/fs/namespace.c        |   35 ++++++-------------------------
>  linux-2.6.git-dave/include/linux/mount.h |   30 ++++++++++++++++++++++++--
>  2 files changed, 35 insertions(+), 30 deletions(-)
> 
> diff -puN include/linux/mount.h~move-ifdefs-take2 include/linux/mount.h
> --- linux-2.6.git/include/linux/mount.h~move-ifdefs-take2	2009-03-11 15:01:10.000000000 -0700
> +++ linux-2.6.git-dave/include/linux/mount.h	2009-03-11 15:02:01.000000000 -0700
> @@ -71,15 +71,41 @@ struct vfsmount {
>  #endif
>  };
>  
> -static inline int *get_mnt_writers_ptr(struct vfsmount *mnt)
> +static inline int *get_mnt_writers_ptr_cpu(struct vfsmount *mnt,
> +					   int cpu)
>  {
>  #ifdef CONFIG_SMP
> -	return mnt->mnt_writers;
> +	return per_cpu_ptr(mnt->mnt_writers, cpu);
>  #else
>  	return &mnt->mnt_writers;
>  #endif
>  }
>  
> +static inline int *get_mnt_writers_ptr(struct vfsmount *mnt)
> +{
> +	return get_mnt_writers_ptr_cpu(mnt, smp_processor_id());
> +}
> +
> +static inline int alloc_mnt_writers(struct vfsmount *mnt)
> +{
> +#ifdef CONFIG_SMP
> +	mnt->mnt_writers = alloc_percpu(int);
> +	if (!mnt->mnt_writers)
> +		return -ENOMEM;
> +#else
> +	mnt->mnt_writers = 0;
> +#endif
> +	return 0;
> +}

If the CONFIG_SMP=n code is just removed, the percpu code should dtrt
with CONFIG_SMP=n.  There is the additional pointer indirection though,
I guess.  Do we do it often enough to be concerned about the cost?


