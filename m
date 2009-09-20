Return-Path: <linux-kernel-owner+w=401wt.eu-S1754063AbZITIpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbZITIpy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 04:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753911AbZITIpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 04:45:53 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:39614 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbZITIpw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 04:45:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=P58WVNI0b3SjtoczFVIKZlX5gfSTw0G8kSrV1+XDwZbcJEcMO0Ia/qYfB7iH+UZQby
         o5e6lmiwcePl0pq639FV5sYr8Whhoba8wUQvOuZ31v8fYoBWp6WpdWK/ctWck3OoZbsM
         3BJPKlqjmuncR+B87TCrA5TFgHAuzA6vuTDtk=
MIME-Version: 1.0
In-Reply-To: <1253302451-27740-2-git-send-email-mel@csn.ul.ie>
References: <1253302451-27740-1-git-send-email-mel@csn.ul.ie>
	 <1253302451-27740-2-git-send-email-mel@csn.ul.ie>
Date: Sun, 20 Sep 2009 11:45:54 +0300
X-Google-Sender-Auth: 857ca698cb1ad7ea
Message-ID: <84144f020909200145w74037ab9vb66dae65d3b8a048@mail.gmail.com>
Subject: Re: [PATCH 1/3] slqb: Do not use DEFINE_PER_CPU for per-node data
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Nick Piggin <npiggin@suse.de>, Christoph Lameter <cl@linux-foundation.org>,
       heiko.carstens@de.ibm.com, sachinp@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 10:34 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> SLQB used a seemingly nice hack to allocate per-node data for the statically
> initialised caches. Unfortunately, due to some unknown per-cpu
> optimisation, these regions are being reused by something else as the
> per-node data is getting randomly scrambled. This patch fixes the
> problem but it's not fully understood *why* it fixes the problem at the
> moment.

Ouch, that sounds bad. I guess it's architecture specific bug as x86
works ok? Lets CC Tejun.

Nick, are you okay with this patch being merged for now?

> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  mm/slqb.c |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/mm/slqb.c b/mm/slqb.c
> index 4ca85e2..4d72be2 100644
> --- a/mm/slqb.c
> +++ b/mm/slqb.c
> @@ -1944,16 +1944,16 @@ static void init_kmem_cache_node(struct kmem_cache *s,
>  static DEFINE_PER_CPU(struct kmem_cache_cpu, kmem_cache_cpus);
>  #endif
>  #ifdef CONFIG_NUMA
> -/* XXX: really need a DEFINE_PER_NODE for per-node data, but this is better than
> - * a static array */
> -static DEFINE_PER_CPU(struct kmem_cache_node, kmem_cache_nodes);
> +/* XXX: really need a DEFINE_PER_NODE for per-node data because a static
> + *      array is wasteful */
> +static struct kmem_cache_node kmem_cache_nodes[MAX_NUMNODES];
>  #endif
>
>  #ifdef CONFIG_SMP
>  static struct kmem_cache kmem_cpu_cache;
>  static DEFINE_PER_CPU(struct kmem_cache_cpu, kmem_cpu_cpus);
>  #ifdef CONFIG_NUMA
> -static DEFINE_PER_CPU(struct kmem_cache_node, kmem_cpu_nodes); /* XXX per-nid */
> +static struct kmem_cache_node kmem_cpu_nodes[MAX_NUMNODES]; /* XXX per-nid */
>  #endif
>  #endif
>
> @@ -1962,7 +1962,7 @@ static struct kmem_cache kmem_node_cache;
>  #ifdef CONFIG_SMP
>  static DEFINE_PER_CPU(struct kmem_cache_cpu, kmem_node_cpus);
>  #endif
> -static DEFINE_PER_CPU(struct kmem_cache_node, kmem_node_nodes); /*XXX per-nid */
> +static struct kmem_cache_node kmem_node_nodes[MAX_NUMNODES]; /*XXX per-nid */
>  #endif
>
>  #ifdef CONFIG_SMP
> @@ -2918,15 +2918,15 @@ void __init kmem_cache_init(void)
>        for_each_node_state(i, N_NORMAL_MEMORY) {
>                struct kmem_cache_node *n;
>
> -               n = &per_cpu(kmem_cache_nodes, i);
> +               n = &kmem_cache_nodes[i];
>                init_kmem_cache_node(&kmem_cache_cache, n);
>                kmem_cache_cache.node_slab[i] = n;
>  #ifdef CONFIG_SMP
> -               n = &per_cpu(kmem_cpu_nodes, i);
> +               n = &kmem_cpu_nodes[i];
>                init_kmem_cache_node(&kmem_cpu_cache, n);
>                kmem_cpu_cache.node_slab[i] = n;
>  #endif
> -               n = &per_cpu(kmem_node_nodes, i);
> +               n = &kmem_node_nodes[i];
>                init_kmem_cache_node(&kmem_node_cache, n);
>                kmem_node_cache.node_slab[i] = n;
>        }
> --
> 1.6.3.3
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
