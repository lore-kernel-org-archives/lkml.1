Return-Path: <linux-kernel-owner+w=401wt.eu-S1030685AbXDULA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030685AbXDULA4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 07:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030686AbXDULAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 07:00:55 -0400
Received: from amsfep19-int.chello.nl ([213.46.243.16]:64602 "EHLO
	amsfep11-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030685AbXDULAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 07:00:55 -0400
Subject: Re: [PATCH 03/10] lib: dampen the percpu_counter FBC_BATCH
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       neilb@suse.de, dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com
In-Reply-To: <20070421025510.41f97a6a.akpm@linux-foundation.org>
References: <20070420155154.898600123@chello.nl>
	 <20070420155502.679143273@chello.nl>
	 <20070421025510.41f97a6a.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 21 Apr 2007 12:58:57 +0200
Message-Id: <1177153137.2934.31.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-21 at 02:55 -0700, Andrew Morton wrote:
> On Fri, 20 Apr 2007 17:51:57 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > With the current logic the percpu_counter's accuracy delta is quadric
> > wrt the number of cpus in the system, reduce this to O(n ln n).
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > ---
> >  include/linux/percpu_counter.h |    7 ++-----
> >  1 file changed, 2 insertions(+), 5 deletions(-)
> > 
> > Index: linux-2.6-mm/include/linux/percpu_counter.h
> > ===================================================================
> > --- linux-2.6-mm.orig/include/linux/percpu_counter.h
> > +++ linux-2.6-mm/include/linux/percpu_counter.h
> > @@ -11,6 +11,7 @@
> >  #include <linux/threads.h>
> >  #include <linux/percpu.h>
> >  #include <linux/types.h>
> > +#include <linux/log2.h>
> >  
> >  #ifdef CONFIG_SMP
> >  
> > @@ -20,11 +21,7 @@ struct percpu_counter {
> >  	s32 *counters;
> >  };
> >  
> > -#if NR_CPUS >= 16
> > -#define FBC_BATCH	(NR_CPUS*2)
> > -#else
> > -#define FBC_BATCH	(NR_CPUS*4)
> > -#endif
> > +#define FBC_BATCH	(8*ilog2(NR_CPUS))
> >  
> >  static inline void percpu_counter_init(struct percpu_counter *fbc, s64 amount)
> >  {
> 
> I worry that this might be too small when there are hundreds of CPUs online.
> 
> With 1024 CPUs we go for the lock once per 80 counts.  That's not much. 
> 
> If we have 1024 CPUs, each one of which is incrementing this counter at N
> Hz, we have 1024/80=12 CPUs all going for the same lock at N Hz.  It could
> get bad.
> 
> But I don't know what the gain is for this loss.  Your changelog should
> have told us.
> 
> What problem is this patch solving?

In 10/10 I introduce bdi_stat_delta() which gives the maximum error of a
single counter. That is used to switch between precise
(percpu_counter_sum) and imprecise (percpu_counter_read) accesses of the
stats.

I worried that the current quadric error would be too large; and as the
ZVC counters also use a logarithmic error bound I thought it would be
good to have here as well.

