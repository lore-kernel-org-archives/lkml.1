Return-Path: <linux-kernel-owner+w=401wt.eu-S1758848AbZFQQiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848AbZFQQiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758188AbZFQQhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:37:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45911 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755474AbZFQQha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:37:30 -0400
Date: Wed, 17 Jun 2009 18:37:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christian Engelmayer <christian.engelmayer@frequentis.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] scheduler: access to variable out of scope in
	sched_slice()
Message-ID: <20090617163723.GB16128@elte.hu>
References: <20090616103512.0c846e51@frequentis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616103512.0c846e51@frequentis.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0989]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christian Engelmayer <christian.engelmayer@frequentis.com> wrote:

> From: Christian Engelmayer <christian.engelmayer@frequentis.com>
> 
> Access to local variable lw is aliased by usage of pointer load. Access to
> pointer load in calc_delta_mine() happens when lw is already out of scope.
> 
> Signed-off-by: Christian Engelmayer <christian.engelmayer@frequentis.com>
> --
> Reported by static code analysis. 
> 
> --- linux-2.6.30/kernel/sched_fair.c.orig	2009-06-16 10:01:50.000000000 +0200
> +++ linux-2.6.30/kernel/sched_fair.c	2009-06-16 10:02:39.000000000 +0200
> @@ -430,12 +430,13 @@ static u64 sched_slice(struct cfs_rq *cf
>  
>  	for_each_sched_entity(se) {
>  		struct load_weight *load;
> +		struct load_weight lw;
>  
>  		cfs_rq = cfs_rq_of(se);
>  		load = &cfs_rq->load;
>  
>  		if (unlikely(!se->on_rq)) {
> -			struct load_weight lw = cfs_rq->load;
> +			lw = cfs_rq->load;
>  
>  			update_load_add(&lw, se->load.weight);
>  			load = &lw;

Good one!

I suspect it doesnt matter in practice because GCC will just have 
them all on the same stack frame?

	Ingo
