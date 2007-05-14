Return-Path: <linux-kernel-owner+w=401wt.eu-S1760700AbXENUWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760700AbXENUWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756412AbXENUWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:22:40 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:49451 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887AbXENUWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:22:38 -0400
Subject: Re: [RFC][PATCH  5/14] Introduce union stack
From: Badari Pulavarty <pbadari@us.ibm.com>
To: bharata@linux.vnet.ibm.com
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Jan Blunck <j.blunck@tu-harburg.de>
In-Reply-To: <20070514094047.GG4139@in.ibm.com>
References: <20070514093722.GB4139@in.ibm.com>
	 <20070514094047.GG4139@in.ibm.com>
Content-Type: text/plain
Date: Mon, 14 May 2007 13:23:06 -0700
Message-Id: <1179174187.2836.72.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-14 at 15:10 +0530, Bharata B Rao wrote:
> From: Jan Blunck <j.blunck@tu-harburg.de>
> Subject: Introduce union stack.
> 
> Adds union stack infrastructure to the dentry structure and provides
> locking routines to walk the union stack.
> 
> Signed-off-by: Jan Blunck <j.blunck@tu-harburg.de>
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
...

> +/*
> + * This is a *I can't get no sleep* helper which is called when we try
> + * to access the struct fs_struct *fs field of a struct task_struct.
> + *
> + * Yes, this is possibly starving but we have to change root, altroot
> + * or pwd in the frequency of this while loop. Don't think that this
> + * happens really often ;)
> + *
> + * This is called while holding the rwlock_t fs->lock
> + *
> + * TODO: Unlocking side of union_lock_fs() needs 3 union_unlock()s.
> + * May be introduce union_unlock_fs().
> + *
> + * FIXME: This routine is used when the caller wants to dget one or
> + * more of fs->[root, altroot, pwd]. When the caller doesn't want to
> + * dget _all_ of these, it is strictly not necessary to get union_locks
> + * on all of these. Check.
> + */
> +static inline void union_lock_fs(struct fs_struct *fs)
> +{
> +	int locked;
> +
> +	while (fs) {
> +		locked = union_trylock(fs->root);
> +		if (!locked)
> +			goto loop1;
> +		locked = union_trylock(fs->altroot);
> +		if (!locked)
> +			goto loop2;
> +		locked = union_trylock(fs->pwd);
> +		if (!locked)
> +			goto loop3;
> +		break;
> +	loop3:
> +		union_unlock(fs->altroot);
> +	loop2:
> +		union_unlock(fs->root);
> +	loop1:
> +		read_unlock(&fs->lock);
> +		UM_DEBUG_LOCK("Failed to get all semaphores in fs_struct!\n");
> +		cpu_relax();
> +		read_lock(&fs->lock);
> +		continue;

Nit.. why "continue" ?

> +	}
> +	BUG_ON(!fs);

Whats the use of BUG_ON() here ? Top of the function would be more
useful.

Thanks,
Badari

