Return-Path: <linux-kernel-owner+w=401wt.eu-S964994AbXFFGVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964994AbXFFGVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 02:21:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765329AbXFFGUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 02:20:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48629 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758680AbXFFGUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 02:20:54 -0400
Subject: Re: [patch] cpusets: do not allow TIF_MEMDIE tasks to allocate
	globally
From: Peter Zijlstra <peterz@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@engr.sgi.com>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.0.99.0706051537450.13200@chino.kir.corp.google.com>
References: <alpine.DEB.0.99.0706051537450.13200@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 08:20:46 +0200
Message-Id: <1181110846.7348.154.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-05 at 15:39 -0700, David Rientjes wrote:
> Reverts git commit c596d9f320aaf30d28c1d793ff3a976dee1db8f5.
> 
> OOM-killed tasks, marked as TIF_MEMDIE, should not be able to access 
> memory outside its cpuset because it could potentially cause other 
> exclusive cpusets to OOM themselves.
> 
> Cc: Andi Kleen <ak@suse.de>
> Cc: Christoph Lameter <clameter@engr.sgi.com>
> Cc: Paul Jackson <pj@sgi.com>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  kernel/cpuset.c |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -2431,12 +2431,6 @@ int __cpuset_zone_allowed_softwall(struct zone *z, gfp_t gfp_mask)
>  	might_sleep_if(!(gfp_mask & __GFP_HARDWALL));
>  	if (node_isset(node, current->mems_allowed))
>  		return 1;
> -	/*
> -	 * Allow tasks that have access to memory reserves because they have
> -	 * been OOM killed to get memory anywhere.
> -	 */
> -	if (unlikely(test_thread_flag(TIF_MEMDIE)))
> -		return 1;
>  	if (gfp_mask & __GFP_HARDWALL)	/* If hardwall request, stop here */
>  		return 0;
>  

This seems a little pointless, since cpuset_zone_allowed_softwall() is
only effective with ALLOC_CPUSET, and the ALLOC_NO_WATERMARKS
allocations opened up by TIF_MEMDIE don't use that.

Also I agree with Christoph's reasoning; this is not for the application
but for the system. Hence the cpuset does not get violated for the
application [ something I tried to argue before, glad Christoph now
agrees with me :-) ].

