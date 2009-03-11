Return-Path: <linux-kernel-owner+w=401wt.eu-S1753358AbZCKRqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbZCKRqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 13:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbZCKRqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 13:46:01 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:52341 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbZCKRqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 13:46:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=jeQ+e6sbASsSq7CkXL3vrQhJMVAU6TkJ6d/RxfeequjNCjPK/FIe4n9lI9B5hFpcZK
         I9EYtDCgm8e3KnhZWwLj0I9Vcqb5Z6jFL3TRplDkm6XqQiZrwWiCyDzo9w+5HoW3OYMj
         IWGItfCu0ax4X81dP2SDduuU921IXxaumHjdQ=
Date: Wed, 11 Mar 2009 19:45:51 +0200
From: Pekka Paalanen <pq@iki.fi>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, pq@iki.fi, tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:cpus4096] x86: cpumask: x86 mmio-mod.c use cpumask_var_t
 for downed_cpus
Message-ID: <20090311194551.53ecd866@daedalus.pq.iki.fi>
In-Reply-To: <tip-f5c14fe200f4315b305ae44e5633cbe62070aaea@git.kernel.org>
References: <200903111633.55952.rusty@rustcorp.com.au>
	<tip-f5c14fe200f4315b305ae44e5633cbe62070aaea@git.kernel.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009 11:13:59 GMT
Rusty Russell <rusty@rustcorp.com.au> wrote:

> Commit-ID:  f5c14fe200f4315b305ae44e5633cbe62070aaea
> Gitweb:     http://git.kernel.org/tip/f5c14fe200f4315b305ae44e5633cbe62070aaea
> Author:     "Rusty Russell" <rusty@rustcorp.com.au>
> AuthorDate: Wed, 11 Mar 2009 16:33:55 +1030
> Commit:     Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 11 Mar 2009 11:19:47 +0100
> 
> x86: cpumask: x86 mmio-mod.c use cpumask_var_t for downed_cpus
> 
> Impact: cleanup, reduce memory usage for CONFIG_CPUMASK_OFFSTACK=y
> 
> Part of the "getting rid of obsolete cpumask_t" patch:
> 
>  1) Use cpumask_var_t: this is a pointer if CONFIG_CPUMASK_OFFSTACK=y
>  2) Call alloc_cpumask_var() on first entry into enter_uniprocessor()
>  3) Use modern cpumask_* functions.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Pekka Paalanen <pq@iki.fi>
> LKML-Reference: <200903111633.55952.rusty@rustcorp.com.au>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Acked-by: Pekka Paalanen <pq@iki.fi>

> 
> 
> ---
>  arch/x86/mm/mmio-mod.c |   19 +++++++++++++------
>  1 files changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
> index 2c4baa8..c9342ed 100644
> --- a/arch/x86/mm/mmio-mod.c
> +++ b/arch/x86/mm/mmio-mod.c
> @@ -378,27 +378,34 @@ static void clear_trace_list(void)
>  }
>  
>  #ifdef CONFIG_HOTPLUG_CPU
> -static cpumask_t downed_cpus;
> +static cpumask_var_t downed_cpus;
>  
>  static void enter_uniprocessor(void)
>  {
>  	int cpu;
>  	int err;
>  
> +	if (downed_cpus == NULL &&
> +	    !alloc_cpumask_var(&downed_cpus, GFP_KERNEL)) {
> +		pr_notice(NAME "Failed to allocate mask\n");
> +		goto out;
> +	}
> +
>  	get_online_cpus();
> -	downed_cpus = cpu_online_map;
> -	cpu_clear(first_cpu(cpu_online_map), downed_cpus);
> +	cpumask_copy(downed_cpus, cpu_online_mask);
> +	cpumask_clear_cpu(cpumask_first(cpu_online_mask), downed_cpus);
>  	if (num_online_cpus() > 1)
>  		pr_notice(NAME "Disabling non-boot CPUs...\n");
>  	put_online_cpus();
>  
> -	for_each_cpu_mask(cpu, downed_cpus) {
> +	for_each_cpu(cpu, downed_cpus) {
>  		err = cpu_down(cpu);
>  		if (!err)
>  			pr_info(NAME "CPU%d is down.\n", cpu);
>  		else
>  			pr_err(NAME "Error taking CPU%d down: %d\n", cpu, err);
>  	}
> +out:
>  	if (num_online_cpus() > 1)
>  		pr_warning(NAME "multiple CPUs still online, "
>  						"may miss events.\n");
> @@ -411,10 +418,10 @@ static void __ref leave_uniprocessor(void)
>  	int cpu;
>  	int err;
>  
> -	if (cpus_weight(downed_cpus) == 0)
> +	if (downed_cpus == NULL || cpumask_weight(downed_cpus) == 0)
>  		return;
>  	pr_notice(NAME "Re-enabling CPUs...\n");
> -	for_each_cpu_mask(cpu, downed_cpus) {
> +	for_each_cpu(cpu, downed_cpus) {
>  		err = cpu_up(cpu);
>  		if (!err)
>  			pr_info(NAME "enabled CPU%d.\n", cpu);
> 


-- 
Pekka Paalanen
http://www.iki.fi/pq/
