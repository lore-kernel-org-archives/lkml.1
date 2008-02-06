Return-Path: <linux-kernel-owner+w=401wt.eu-S1759569AbYBFVlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759569AbYBFVlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 16:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbYBFVlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 16:41:05 -0500
Received: from neuf-infra-smtp-out-sp604003av.neufgp.fr ([84.96.92.124]:39553
	"EHLO neuf-infra-smtp-out-sp604003av.neufgp.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758873AbYBFVlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 16:41:04 -0500
Message-ID: <47AA2955.50502@cosmosbay.com>
Date: Wed, 06 Feb 2008 22:40:37 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: SLUB: statistics improvements
References: <Pine.LNX.4.64.0802042217460.6801@schroedinger.engr.sgi.com> <20080206001948.6f749aa8.akpm@linux-foundation.org> <Pine.LNX.4.64.0802061259490.26108@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0802061259490.26108@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter a écrit :
> SLUB: statistics improvements
> 
> - Fix indentation in unfreeze_slab
> 
> - FREE_SLAB/ALLOC_SLAB counters were slightly misplaced and counted
>   even if the slab was kept because we were below the mininum of
>   partial slabs.
> 
> - Export per cpu statistics to user space (follow numa convention
>   but change the n character to c (no slabinfo support for display yet)
> 
> F.e.
> 
> christoph@stapp:/sys/kernel/slab/kmalloc-8$ cat alloc_fastpath
> 9968 c0=4854 c1=1050 c2=468 c3=190 c4=116 c5=1779 c6=185 c7=1326

nice :)

> 
> 
> +static int show_stat(struct kmem_cache *s, char *buf, enum stat_item si)
> +{
> +	unsigned long sum  = 0;
> +	int cpu;
> +	int len;
> +	int *data = kmalloc(nr_cpu_ids * sizeof(int), GFP_KERNEL);
> +
> +	if (!data)
> +		return -ENOMEM;
> +
> +	for_each_online_cpu(cpu) {
> +		int x = get_cpu_slab(s, cpu)->stat[si];

unsigned int x = ...

> +
> +		data[cpu] = x;
> +		sum += x;

or else x will sign extend here on 64 bit arches ?

> +	}
> +
> +	len = sprintf(buf, "%lu", sum);
> +
> +	for_each_online_cpu(cpu) {
> +		if (data[cpu] && len < PAGE_SIZE - 20)
> +			len += sprintf(buf + len, " c%d=%u", cpu, data[cpu]);
> +	}
> +	kfree(data);
> +	return len + sprintf(buf + len, "\n");
> +}
> +


