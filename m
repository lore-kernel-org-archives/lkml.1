Return-Path: <linux-kernel-owner+w=401wt.eu-S1757682AbZKERxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682AbZKERxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 12:53:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755273AbZKERxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 12:53:11 -0500
Received: from smtp4.ultrahosting.com ([74.213.175.253]:58392 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757398AbZKERxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 12:53:10 -0500
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Nov 2009 12:53:10 EST
Date: Thu, 5 Nov 2009 10:15:36 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       akpm@linux-foundation.org,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] lib: generic percpu counter array
In-Reply-To: <20091105141653.132d4977.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0911051013080.25718@V090114053VZO-1>
References: <20091104152426.eacc894f.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.1.10.0911041414560.7409@V090114053VZO-1> <20091105090659.9a5d17b1.kamezawa.hiroyu@jp.fujitsu.com> <20091105141653.132d4977.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Nov 2009, KAMEZAWA Hiroyuki wrote:

> +static inline void
> +counter_array_add(struct counter_array *ca, int idx, int val)
> +{
> +	ca->counters[idx] += val;
> +}

This is not a per cpu operation and therefore expensive. The new percpu
this_cpu_inc f.e. generates a single x86 instruction for an increment.

> +void __counter_array_add(struct counter_array *ca, int idx, int val, int batch)
> +{
> +	long count, *pcount;
> +
> +	preempt_disable();
> +
> +	pcount = this_cpu_ptr(ca->v.array);
> +	count = pcount[idx] + val;
> +	if (!ca->v.nosync && ((count > batch) || (count < -batch))) {
> +		atomic_long_add(count, &ca->counters[idx]);
> +		pcount[idx] = 0;
> +	} else
> +		pcount[idx] = count;
> +	preempt_enable();
> +}

Too expensive to use in critical VM paths. The percpu operations generate
a single instruction instead of the code above. No need for preempt etc.
