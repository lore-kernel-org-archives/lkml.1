Return-Path: <linux-kernel-owner+w=401wt.eu-S932682AbZLJFLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682AbZLJFLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 00:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932639AbZLJFLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 00:11:10 -0500
Received: from casper.infradead.org ([85.118.1.10]:57659 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932635AbZLJFLJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 00:11:09 -0500
Subject: Re: [PATCH] sched: Memory leak in two error corner cases
From: Peter Zijlstra <peterz@infradead.org>
To: "Helight.Xu" <helight.xu@gmail.com>
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <4B205F73.90704@gmail.com>
References: <1260380746-4856-1-git-send-email-ext-phil.2.carmody@nokia.com>
	 <4B205F73.90704@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 10 Dec 2009 06:12:43 +0100
Message-ID: <1260421963.4165.0.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-10 at 10:39 +0800, Helight.Xu wrote:
> Phil Carmody wrote:
> > From: Phil Carmody <ext-phil.2.carmody@nokia.com>
> >
> > If the second in each of these pairs of allocations fails, then
> > the first one will not be freed in the error route out.
> >
> > Found by a static code analysis tool.
> >
> > Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
> > ---
> >  kernel/sched.c |    8 ++++++--
> >  1 files changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index e7f2cfa..29ebc4a 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -9841,8 +9841,10 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
> >  
> >  		se = kzalloc_node(sizeof(struct sched_entity),
> >  				  GFP_KERNEL, cpu_to_node(i));
> > -		if (!se)
> > +		if (!se) {
> > +			kfree(cfs_rq);
> >  			goto err;
> > +		}
> >   
> if here has menory leak, why not  here!
> 
>     tg->cfs_rq = kzalloc(sizeof(cfs_rq) * nr_cpu_ids, GFP_KERNEL);
>     if (!tg->cfs_rq)
>          goto err;
>     tg->se = kzalloc(sizeof(se) * nr_cpu_ids, GFP_KERNEL);
>     if (!tg->se)
>          goto err;
> should I fix here?

The error path deals with that.
