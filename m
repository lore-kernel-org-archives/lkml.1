Return-Path: <linux-kernel-owner+w=401wt.eu-S1758224AbYCDBTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224AbYCDBTL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 20:19:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754730AbYCDBTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 20:19:01 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57418 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680AbYCDBTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 20:19:00 -0500
Date: Mon, 3 Mar 2008 20:18:49 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
       hch@infradead.org, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 1/2] x86, fpu: split FPU state from task struct - v3
Message-ID: <20080304011849.GA22431@infradead.org>
References: <20080303230335.892214000@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303230335.892214000@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 03:02:45PM -0800, Suresh Siddha wrote:
> +void __attribute__((weak)) arch_task_cache_init(void)
> +{
> +}
> +
>  void __init fork_init(unsigned long mempages)
>  {
>  #ifndef __HAVE_ARCH_TASK_STRUCT_ALLOCATOR
> @@ -144,6 +148,9 @@
>  			ARCH_MIN_TASKALIGN, SLAB_PANIC | SLAB_NOTRACK, NULL);
>  #endif
>  
> +	/* do the arch specific task caches init */
> +	arch_task_cache_init();

Why can't this just be a normal initcall (with the right level)?

> +int __attribute__((weak)) arch_dup_task_struct(struct task_struct *dst,
> +					       struct task_struct *src)
> +{
> +	*dst = *src;
> +	return 0;
> +}
> +
>  static struct task_struct *dup_task_struct(struct task_struct *orig)
>  {
>  	struct task_struct *tsk;
> @@ -181,15 +195,15 @@
>  		return NULL;
>  	}
>  
> -	*tsk = *orig;
> + 	err = arch_dup_task_struct(tsk, orig);
> +	if (err)
> +		goto out;
> +

You're still adding a second hook instead of re-using or re-naming
setup_thread_stack.  Did I miss a good explanation for that
or was this just an oversight?

Also this weak linkage stuff creaping in is really ugly.

