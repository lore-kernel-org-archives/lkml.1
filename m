Return-Path: <linux-kernel-owner+w=401wt.eu-S935584AbZLGRuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935584AbZLGRuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 12:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935574AbZLGRuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 12:50:52 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:44656 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935518AbZLGRut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 12:50:49 -0500
Date: Mon, 7 Dec 2009 11:50:47 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: [PATCH] SLAB: Fix slab_test.c CONFIG_CPUMASK_OFFSTACK build
In-Reply-To: <1260205363-6015-1-git-send-email-penberg@cs.helsinki.fi>
Message-ID: <alpine.DEB.2.00.0912071150140.1208@router.home>
References: <1260205363-6015-1-git-send-email-penberg@cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Dec 2009, Pekka Enberg wrote:

> index e97afc4..0d23dc1 100644
> --- a/tests/slab_test.c
> +++ b/tests/slab_test.c
> @@ -170,10 +170,13 @@ static int started;
>  static int test_func(void *private)
>  {
>  	struct test_struct *t = private;
> -	cpumask_t newmask = CPU_MASK_NONE;
> +	cpumask_var_t newmask;
>
> -        cpu_set(t->cpu, newmask);
> -        set_cpus_allowed(current, newmask);

Whitespace damage?

> +	if (!alloc_cpumask_var(&newmask, GFP_KERNEL))
> +		return -ENOMEM;
> +
> +        cpumask_set_cpu(t->cpu, newmask);
> +        set_cpus_allowed_ptr(current, newmask);
>  	t->v = kzalloc(t->count * sizeof(void *), GFP_KERNEL);
>
>  	atomic_inc(&tests_running);
> @@ -188,6 +191,7 @@ static int test_func(void *private)
>  		t->test_p2(t);
>  	t->stop2 = get_cycles();
>  	kfree(t->v);
> +	free_cpumask_var(newmask);
>  	atomic_dec(&tests_running);
>  	set_current_state(TASK_UNINTERRUPTIBLE);
>  	schedule();

Reviewed-by: Christoph Lameter <cl@linux-foundation.org>

