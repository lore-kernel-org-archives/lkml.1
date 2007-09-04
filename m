Return-Path: <linux-kernel-owner+w=401wt.eu-S1755811AbXIDXqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbXIDXqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 19:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbXIDXq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 19:46:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:53991 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022AbXIDXq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 19:46:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,208,1186383600"; 
   d="scan'208";a="125028297"
Date: Tue, 4 Sep 2007 16:46:26 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Chuck Ebbert <cebbert@redhat.com>, mingo@elte.hu
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, mingo@elte.hu,
       nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch] sched: fix broken smt/mc optimizations with CFS
Message-ID: <20070904234626.GB5187@linux-os.sc.intel.com>
References: <20070816010150.GG10033@linux-os.sc.intel.com> <20070823115416.GA31027@elte.hu> <20070823121341.GA5775@elte.hu> <20070827191905.GE1894@linux-os.sc.intel.com> <20070827192324.GA29441@elte.hu> <20070827193103.GF1894@linux-os.sc.intel.com> <20070828222718.GI1894@linux-os.sc.intel.com> <46DDEBB9.3080501@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46DDEBB9.3080501@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2007 at 07:35:21PM -0400, Chuck Ebbert wrote:
> On 08/28/2007 06:27 PM, Siddha, Suresh B wrote:
> > Try to fix MC/HT scheduler optimization breakage again, with out breaking
> > the FUZZ logic.
> > 
> > First fix the check
> > 	if (*imbalance + SCHED_LOAD_SCALE_FUZZ < busiest_load_per_task)
> > with this
> > 	if (*imbalance < busiest_load_per_task)
> > 
> > As the current check is always false for nice 0 tasks (as SCHED_LOAD_SCALE_FUZZ
> > is same as busiest_load_per_task for nice 0 tasks).
> > 
> > With the above change, imbalance was getting reset to 0 in the corner case
> > condition, making the FUZZ logic fail. Fix it by not corrupting the
> > imbalance and change the imbalance, only when it finds that the
> > HT/MC optimization is needed.
> > 
> > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > ---
> > 
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 9fe473a..03e5e8d 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -2511,7 +2511,7 @@ group_next:
> >  	 * a think about bumping its value to force at least one task to be
> >  	 * moved
> >  	 */
> > -	if (*imbalance + SCHED_LOAD_SCALE_FUZZ < busiest_load_per_task) {
> > +	if (*imbalance < busiest_load_per_task) {
> >  		unsigned long tmp, pwr_now, pwr_move;
> >  		unsigned int imbn;
> >  
> > @@ -2563,10 +2563,8 @@ small_imbalance:
> >  		pwr_move /= SCHED_LOAD_SCALE;
> >  
> >  		/* Move if we gain throughput */
> > -		if (pwr_move <= pwr_now)
> > -			goto out_balanced;
> > -
> > -		*imbalance = busiest_load_per_task;
> > +		if (pwr_move > pwr_now)
> > +			*imbalance = busiest_load_per_task;
> >  	}
> >  
> >  	return busiest;
> 
> Seems this didn't get merged? Latest git as of today still has the code
> as it was before this patch.

This is must fix for .23 and Ingo previously mentioned that he will push it
for .23

Ingo?
