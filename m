Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbZDXIV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbZDXIV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 04:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbZDXIVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 04:21:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57421 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751952AbZDXIVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 04:21:39 -0400
Date: Fri, 24 Apr 2009 01:13:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, markus.t.metzger@gmail.com,
       roland@redhat.com, eranian@googlemail.com, oleg@redhat.com,
       juan.villacis@intel.com, ak@linux.jf.intel.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com
Subject: Re: [rfc 2/2] x86, bts: use physically non-contiguous trace buffer
Message-Id: <20090424011328.b5e949ce.akpm@linux-foundation.org>
In-Reply-To: <20090424100055.A30408@sedona.ch.intel.com>
References: <20090424100055.A30408@sedona.ch.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Apr 2009 10:00:55 +0200 Markus Metzger <markus.t.metzger@intel.com> wrote:

> Use vmalloc to allocate the branch trace buffer.
> 
> Peter Zijlstra suggested to use vmalloc rather than kmalloc to
> allocate the potentially multi-page branch trace buffer.

The changelog provides no reason for this change.  It should do so.

> Is there a way to have vmalloc allocate a physically non-contiguous
> buffer for test purposes? Ideally, the memory area would have big
> holes in it with sensitive data in between so I would know immediately
> when this is overwritten.

I suppose you could allocate the pages by hand and then vmap() them. 
Allocating 2* the number you need and then freeing every second one
should make them physically holey.

> --- a/arch/x86/kernel/ptrace.c
> +++ b/arch/x86/kernel/ptrace.c
> @@ -22,6 +22,7 @@
>  #include <linux/seccomp.h>
>  #include <linux/signal.h>
>  #include <linux/workqueue.h>
> +#include <linux/vmalloc.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/pgtable.h>
> @@ -626,7 +627,7 @@ static int alloc_bts_buffer(struct bts_c
>  	if (err < 0)
>  		return err;
>  
> -	buffer = kzalloc(size, GFP_KERNEL);
> +	buffer = vmalloc(size);
>  	if (!buffer)
>  		goto out_refund;
>  
> @@ -646,7 +647,7 @@ static inline void free_bts_buffer(struc
>  	if (!context->buffer)
>  		return;
>  
> -	kfree(context->buffer);
> +	vfree(context->buffer);
>  	context->buffer = NULL;
>  

The patch looks like a regression to me.  vmalloc memory is slower to
allocate, slower to free, slower to access and can exhaust or fragment
the vmalloc arena.  Confused.
