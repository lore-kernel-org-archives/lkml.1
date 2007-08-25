Return-Path: <linux-kernel-owner+w=401wt.eu-S934243AbXHYLPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934243AbXHYLPr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 07:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933189AbXHYLPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 07:15:38 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:34432 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932116AbXHYLPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 07:15:38 -0400
Date: Sat, 25 Aug 2007 15:18:28 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Cliff Wickman <cpw@sgi.com>
Cc: akpm@linux-foundation.org, ego@in.ibm.com, mingo@elte.hu, vatsa@in.ibm.com,
       pj@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] hotplug cpu: migrate a task within its cpuset
Message-ID: <20070825111828.GA246@tv-sign.ru>
References: <20070824221806.GA3602@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070824221806.GA3602@sgi.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24, Cliff Wickman wrote:
> 
> @@ -5091,6 +5092,17 @@ restart:
>  	if (dest_cpu == NR_CPUS)
>  		dest_cpu = any_online_cpu(p->cpus_allowed);
>  
> +	/* try to stay on the same cpuset */
> +	if (dest_cpu == NR_CPUS) {
> +		/*
> +		 * The cpuset_cpus_allowed_lock() variant of
> +		 * cpuset_cpus_allowed() will not block
> +		 * It must be called within calls to cpuset_lock/cpuset_unlock.
> +		 */
> +		p->cpus_allowed = cpuset_cpus_allowed_lock(p);
> +		dest_cpu = any_online_cpu(p->cpus_allowed);

Ugh, didn't notice while reading this patch.

We shouldn't change ->cpus_allowed without rq->lock. Please look what
the current code does in "/* No more Mr. Nice Guy. */" case.

Oleg.

