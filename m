Return-Path: <linux-kernel-owner+w=401wt.eu-S1755424AbZIUIql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbZIUIql (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 04:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbZIUIqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 04:46:39 -0400
Received: from gir.skynet.ie ([193.1.99.77]:59299 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350AbZIUIqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 04:46:39 -0400
Date: Mon, 21 Sep 2009 09:46:44 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Tejun Heo <tj@kernel.org>, Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>, heiko.carstens@de.ibm.com,
       sachinp@in.ibm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] slqb: Do not use DEFINE_PER_CPU for per-node data
Message-ID: <20090921084644.GD12726@csn.ul.ie>
References: <1253302451-27740-1-git-send-email-mel@csn.ul.ie> <1253302451-27740-2-git-send-email-mel@csn.ul.ie> <84144f020909200145w74037ab9vb66dae65d3b8a048@mail.gmail.com> <4AB5FD4D.3070005@kernel.org> <4AB5FFF8.7000602@cs.helsinki.fi> <4AB6508C.4070602@kernel.org> <1253514240.5216.3.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1253514240.5216.3.camel@penberg-laptop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 09:24:00AM +0300, Pekka Enberg wrote:
> Hi Tejun,
> 
> On Mon, 2009-09-21 at 00:55 +0900, Tejun Heo wrote:
> > Pekka Enberg wrote:
> > > Tejun Heo wrote:
> > >> Pekka Enberg wrote:
> > >>> On Fri, Sep 18, 2009 at 10:34 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> > >>>> SLQB used a seemingly nice hack to allocate per-node data for the
> > >>>> statically
> > >>>> initialised caches. Unfortunately, due to some unknown per-cpu
> > >>>> optimisation, these regions are being reused by something else as the
> > >>>> per-node data is getting randomly scrambled. This patch fixes the
> > >>>> problem but it's not fully understood *why* it fixes the problem at the
> > >>>> moment.
> > >>> Ouch, that sounds bad. I guess it's architecture specific bug as x86
> > >>> works ok? Lets CC Tejun.
> > >>
> > >> Is the corruption being seen on ppc or s390?
> > > 
> > > On ppc.
> > 
> > Can you please post full dmesg showing the corruption?  Also, if you
> > apply the attached patch, does the added BUG_ON() trigger?
> 
> I don't have the affected machines, Sachin and Mel do.
> 

More accurately, Sachin does but he gave me access to the machine for
this bug so I can use it when it's otherwise idle.

> 			Pekka
> 
> > diff --git a/include/linux/percpu.h b/include/linux/percpu.h
> > index 878836c..fb690d2 100644
> > --- a/include/linux/percpu.h
> > +++ b/include/linux/percpu.h
> > @@ -127,7 +127,7 @@ extern int __init pcpu_page_first_chunk(size_t reserved_size,
> >   * dynamically allocated. Non-atomic access to the current CPU's
> >   * version should probably be combined with get_cpu()/put_cpu().
> >   */
> > -#define per_cpu_ptr(ptr, cpu)	SHIFT_PERCPU_PTR((ptr), per_cpu_offset((cpu)))
> > +#define per_cpu_ptr(ptr, cpu)	({ BUG_ON(!(ptr)); SHIFT_PERCPU_PTR((ptr), per_cpu_offset((cpu))); })
> > 
> >  extern void *__alloc_reserved_percpu(size_t size, size_t align);
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
