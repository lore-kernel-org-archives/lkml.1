Return-Path: <linux-kernel-owner+w=401wt.eu-S1759219AbXENWk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759219AbXENWk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 18:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756205AbXENWkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 18:40:16 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:53504 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775AbXENWkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 18:40:14 -0400
Subject: Re: [RFC][PATCH  5/14] Introduce union stack
From: Badari Pulavarty <pbadari@us.ibm.com>
To: bharata@linux.vnet.ibm.com
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Jan Blunck <j.blunck@tu-harburg.de>
In-Reply-To: <20070514094047.GG4139@in.ibm.com>
References: <20070514093722.GB4139@in.ibm.com>
	 <20070514094047.GG4139@in.ibm.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 14 May 2007 15:40:57 -0700
Message-Id: <1179182457.2836.92.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-14 at 15:10 +0530, Bharata B Rao wrote:
> From: Jan Blunck <j.blunck@tu-harburg.de>
> Subject: Introduce union stack.
> 
> Adds union stack infrastructure to the dentry structure and provides
> locking routines to walk the union stack.
...

> --- /dev/null
> +++ b/include/linux/dcache_union.h
> @@ -0,0 +1,248 @@
> +/*
> + * VFS based union mount for Linux
> + *
> + * Copyright © 2004-2007 IBM Corporation
> + *   Author(s): Jan Blunck (j.blunck@tu-harburg.de)
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation; either version 2 of the License, or (at your option)
> + * any later version.
> + *
> + */
> +#ifndef __LINUX_DCACHE_UNION_H
> +#define __LINUX_DCACHE_UNION_H
> +#ifdef __KERNEL__
> +
> +#include <linux/union_debug.h>
> +#include <linux/fs_struct.h>
> +#include <asm/atomic.h>
> +#include <asm/semaphore.h>
> +
> +#ifdef CONFIG_UNION_MOUNT
> +
> +/*
> + * This is the union info object, that describes general information about this
> + * union directory
> + *
> + * u_mutex protects the union stack against modification. You can reach it
> + * through the d_union field in struct dentry. Hold it when you are walking
> + * or modifing the union stack !
> + */
> +struct union_info {
> +	atomic_t u_count;
> +	struct mutex u_mutex;
> +};
> +
> +/* allocate/de-allocate */
> +extern struct union_info *union_alloc(void);
> +extern struct union_info *union_get(struct union_info *);
> +extern void union_put(struct union_info *);
> +
> +/*
> + * These are the functions for locking a dentry's union. When one
> + * want to acquire a denties union lock, use:
> + *
> + * - union_lock() when you can sleep,
> + * - union_lock_spinlock() when you are holding a spinlock (that
> + *   you CAN savely give up and reacquire again)
> + * - union_lock_readlock() when you are holding a readlock (that
> + *   you CAN savely give up and reacquire again)
> + *
> + * Otherwise get the union lock early before you enter your
> + * "no sleeping here" code.
> + *
> + * NOTES: union_info structure is reference counted using u_count member.
> + * union_get() and union_put() which get and put references on union_info
> + * should be done under union_info's u_mutex. Since the last union_put() frees
> + * the union_info structure itself it can't obviously be done under u_mutex.
> + * union_release() should be used in such cases (Eg. dput(), umount()) where
> + * union_info is disassociated from the dentries, and it becomes safe
> + * to free the union_info.
> + */
> +static inline void __union_lock(struct union_info *uinfo)
> +{
> +	BUG_ON(!atomic_read(&uinfo->u_count));
> +	mutex_lock(&uinfo->u_mutex);
> +}
> +
> +static inline void union_lock(struct dentry *dentry)
> +{
> +	if (unlikely(dentry && dentry->d_union)) {
> +		struct union_info *ui = dentry->d_union;
> +
> +		UM_DEBUG_LOCK("\"%s\" locking %p (count=%d)\n",
> +			      dentry->d_name.name, ui,
> +			      atomic_read(&ui->u_count));
> +		__union_lock(dentry->d_union);
> +	}
> +}
> +
> +static inline void __union_unlock(struct union_info *uinfo)
> +{
> +	BUG_ON(!atomic_read(&uinfo->u_count));
> +	mutex_unlock(&uinfo->u_mutex);
> +}
> +
> +static inline void union_unlock(struct dentry *dentry)
> +{
> +	if (unlikely(dentry && dentry->d_union)) {
> +		struct union_info *ui = dentry->d_union;
> +
> +		UM_DEBUG_LOCK("\"%s\" unlocking %p (count=%d)\n",
> +			      dentry->d_name.name, ui,
> +			      atomic_read(&ui->u_count));
> +		__union_unlock(dentry->d_union);
> +	}
> +}
> +
> +static inline void union_alloc_dentry(struct dentry *dentry)
> +{
> +	spin_lock(&dentry->d_lock);
> +	if (!dentry->d_union) {
> +		dentry->d_union = union_alloc();
> +		spin_unlock(&dentry->d_lock);
> +	} else {
> +		spin_unlock(&dentry->d_lock);
> +		union_lock(dentry);
> +	}
> +}
> +
> +static inline struct union_info *union_lock_and_get(struct dentry *dentry)
> +{
> +	union_lock(dentry);
> +	return union_get(dentry->d_union);
> +}
> +
> +/* Shouldn't be called with last reference to union_info */
> +static inline void union_put_and_unlock(struct union_info *uinfo)
> +{
> +	union_put(uinfo);
> +	__union_unlock(&uinfo->u_mutex);
	               ^^^^^^^^^^^^^^^^^^^

It should be
	
	__union_unlock(uinfo);

Thanks,
Badari



