Return-Path: <linux-kernel-owner+w=401wt.eu-S1764064AbYEPAJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764064AbYEPAJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 20:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757634AbYEPAJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 20:09:25 -0400
Received: from ozlabs.org ([203.10.76.45]:42906 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757690AbYEPAJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 20:09:25 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH] modules: Use a better scheme for refcounting
Date: Fri, 16 May 2008 10:09:11 +1000
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Mike Travis <travis@sgi.com>
References: <482C9FC5.2070508@cosmosbay.com>
In-Reply-To: <482C9FC5.2070508@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805161009.12142.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 May 2008 06:40:37 Eric Dumazet wrote:
> Current refcounting for modules (done if CONFIG_MODULE_UNLOAD=y)
> is using a lot of memory.

Hi Eric,

   I like this patch!  The plan was always to create a proper dynamic per-cpu
allocator which used the normal per-cpu offsets, but I think module refcounts
are worthwhile as a special case.

   Any chance I can ask you look at the issue of full dynamic per-cpu
allocation?  The problem of allocating memory which is laid out precisely
as the original per-cpu alloc is vexing on NUMA, and probably requires
reserving virtual address space and remapping into it, but the rewards
would be maximally-efficient per-cpu accessors, and getting rid of that
boutique allocator in module.c.

Only minor commentry on the patch itself:

> +#ifdef CONFIG_SMP
> +       char *refptr;
> +#else

void * would seem more natural here (love those gcc'isms)

> +#if defined(CONFIG_MODULE_UNLOAD) && defined(CONFIG_SMP)
> +       void *refptr = NULL;
> +#endif

Looks like you can skip this if you assign to mod->refptr directly below:

> +#if defined(CONFIG_MODULE_UNLOAD) && defined(CONFIG_SMP)
> +       refptr = percpu_modalloc(sizeof(local_t), sizeof(local_t), mod->name);
> +       if (!refptr)
> +               goto free_mod;
> +       mod->refptr = refptr;
> +#endif

And finally:

> +#if defined(CONFIG_MODULE_UNLOAD) && defined(CONFIG_SMP)
> +       if (refptr)
> +               percpu_modfree(refptr);
> +#endif

This if (refptr) seems redundant.

Thanks!
Rusty.
