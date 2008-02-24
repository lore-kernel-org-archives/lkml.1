Return-Path: <linux-kernel-owner+w=401wt.eu-S1758913AbYBXDJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913AbYBXDJZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 22:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754434AbYBXDJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 22:09:06 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40261 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbYBXDJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 22:09:03 -0500
Date: Sat, 23 Feb 2008 22:08:52 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 2/2] x86,fpu: lazy allocation of FPU area
Message-ID: <20080224030852.GB7282@infradead.org>
References: <20080224023547.264625000@linux-os.sc.intel.com> <20080224023547.412501000@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080224023547.412501000@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 06:34:39PM -0800, Suresh Siddha wrote:
> +	if (!tsk->thread.cntxt)
> +                tsk->thread.cntxt = alloc_cntxt_struct();

Please use tabs, not spaces for indentation.

> +union thread_cntxt *alloc_cntxt_struct(void)
> +{
> +	return kmem_cache_alloc(task_cntxt_cachep, GFP_KERNEL);
> +}

Why do you need this wrapper at all?

> +struct task_struct * alloc_task_struct(struct task_struct *src)
>  {
>  	struct task_struct *tsk;
>  	tsk = kmem_cache_alloc(task_struct_cachep, GFP_KERNEL);
> +	if (tsk && src->thread.cntxt) {
> +		tsk->thread.cntxt = alloc_cntxt_struct();
> +		if (!tsk->thread.cntxt) {
> +			kmem_cache_free(task_struct_cachep, tsk);
> +			return NULL;
> +		}
> +		WARN_ON((unsigned long)tsk->thread.cntxt & 15);
> +	} else if (tsk)
> +		tsk->thread.cntxt = NULL;
>  	return tsk;

I think passing the src here doesn't make much sense.  Copying
the fpu context structure should be done by the arch dup_task_struct
hook.  Now if you free the fpu context in free_thread_info that means
you don't have to have your own arch-specific task_struct allocator
which would be a _lot_ cleaner.  Talking about clean I think
the .cntxt field really wants a more descriptive name :)

