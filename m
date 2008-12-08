Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbYLHWnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbYLHWnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 17:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbYLHWno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 17:43:44 -0500
Received: from smtp-out.google.com ([216.239.45.13]:16941 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156AbYLHWno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 17:43:44 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:content-transfer-encoding;
	b=oinxN49LwwLU2JcwQ94vO7OCjO5C5lbilnmOylMvU/JBy9cGkvQ+DhyzoGw5Yy482
	a+HkG40d/eONyGcuAvu/Q==
Date: Mon, 8 Dec 2008 14:43:31 -0800
From: Andrew Morton <akpm@google.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PACH] smp: uninline num_online_cpus() & num_possible_cpus()
Message-Id: <20081208144331.03888b1b.akpm@google.com>
In-Reply-To: <493965F8.6060407@cosmosbay.com>
References: <493965F8.6060407@cosmosbay.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Dec 2008 18:33:44 +0100
Eric Dumazet <dada1@cosmosbay.com> wrote:

> num_online_cpus() and num_possible_cpus() are not performance
> critical and are quite large.
> 
> Unlining them shrinks kernel text size by 7523 bytes on x86,
> if NR_CPUS>32
> 
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> ---
>  include/linux/cpumask.h |    4 ++--
>  init/main.c             |   12 ++++++++++++
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
> index 21e1dd4..f9b2b51 100644
> --- a/include/linux/cpumask.h
> +++ b/include/linux/cpumask.h
> @@ -507,8 +507,8 @@ extern cpumask_t cpu_present_map;
>  extern cpumask_t cpu_active_map;
>  
>  #if NR_CPUS > 1
> -#define num_online_cpus()	cpus_weight_nr(cpu_online_map)
> -#define num_possible_cpus()	cpus_weight_nr(cpu_possible_map)
> +extern int num_online_cpus(void);
> +extern int num_possible_cpus(void);
>  #define num_present_cpus()	cpus_weight_nr(cpu_present_map)
>  #define cpu_online(cpu)		cpu_isset((cpu), cpu_online_map)
>  #define cpu_possible(cpu)	cpu_isset((cpu), cpu_possible_map)
> diff --git a/init/main.c b/init/main.c
> index 7e117a2..a1a3e55 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -376,6 +376,18 @@ EXPORT_SYMBOL(cpu_mask_all);
>  int nr_cpu_ids __read_mostly = NR_CPUS;
>  EXPORT_SYMBOL(nr_cpu_ids);
>  
> +int num_online_cpus(void)
> +{
> +	return cpus_weight_nr(cpu_online_map);
> +}
> +EXPORT_SYMBOL(num_online_cpus);
> +
> +int num_possible_cpus(void)
> +{
> +	return cpus_weight_nr(cpu_possible_map);
> +}
> +EXPORT_SYMBOL(num_possible_cpus);
> +
>  /* An arch may set nr_cpu_ids earlier if needed, so this would be redundant */
>  static void __init setup_nr_cpu_ids(void)
>  {
	
Looks OK.

That area in init/main.c is horrid - it took quite some staring through
the ifdef tangle for me to convince myself that the code you added was
reliably SMP-only.

Perhaps sometime a lot of this cpu masky code should be moved over to
kernel/cpu.c and cleaned up.

