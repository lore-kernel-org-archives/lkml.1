Return-Path: <linux-kernel-owner+w=401wt.eu-S1753180AbXCPKOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbXCPKOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 06:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbXCPKOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 06:14:12 -0400
Received: from amsfep17-int.chello.nl ([213.46.243.15]:7133 "EHLO
	amsfep18-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753164AbXCPKOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 06:14:10 -0400
Subject: Re: [PATCH 2.6.21-rc3-mm2 3/4] futex_requeue_pi optimization
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Pierre.Peiffer@bull.net
Cc: akpm@linux-foundation.org, mingo@elte.hu, drepper@redhat.com,
       linux-kernel@vger.kernel.org, jean-pierre.dion@bull.net
In-Reply-To: <20070313095548.003786249@bull.net>
References: <20070313095203.154246923@bull.net>
	 <20070313095548.003786249@bull.net>
Content-Type: text/plain
Date: Fri, 16 Mar 2007 11:14:06 +0100
Message-Id: <1174040046.7124.27.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 10:52 +0100, Pierre.Peiffer@bull.net wrote:
> plain text document attachment (futex-requeue-pi.diff)
> This patch provides the futex_requeue_pi functionality.
> 
> This provides an optimization, already used for (normal) futexes, to be used for
> PI-futexes.
> 
> This optimization is currently used by the glibc in pthread_broadcast, when
> using "normal" mutexes. With futex_requeue_pi, it can be used with PRIO_INHERIT
> mutexes too.
> 
> Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>
> 
> ---

>  /*
> + * Retrieve the original address used to compute this key
> + */
> +static void *get_futex_address(union futex_key *key)
> +{
> +	void *uaddr;
> +
> +	if (key->both.offset & 1) {
> +		/* shared mapping */
> +		uaddr = (void*)((key->shared.pgoff << PAGE_SHIFT)
> +				+ key->shared.offset - 1);
> +	} else {
> +		/* private mapping */
> +		uaddr = (void*)(key->private.address + key->private.offset);
> +	}
> +
> +	return uaddr;
> +}

This will not work for nonlinear vmas, granted, not a lot of ppl stick
futexes in nonlinear vmas, but the futex_key stuff handles it, this
doesn't.


