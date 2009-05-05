Return-Path: <linux-kernel-owner+w=401wt.eu-S1758701AbZEETbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701AbZEETbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 15:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755741AbZEETbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 15:31:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37027 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757322AbZEETbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 15:31:23 -0400
Date: Tue, 5 May 2009 21:31:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] perf_counter: ioctl(PERF_COUNTER_IOC_RESET)
Message-ID: <20090505193109.GA21749@elte.hu>
References: <20090505155020.309162852@chello.nl> <20090505155437.022272933@chello.nl> <4A0085FC.2060200@linux.vnet.ibm.com> <1241548976.8100.15.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241548976.8100.15.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2009-05-05 at 11:31 -0700, Corey Ashford wrote:
> > Hi Peter,
> > 
> > Peter Zijlstra wrote:
> > 
> > > +static void perf_counter_reset(struct perf_counter *counter)
> > > +{
> > > +	atomic_set(&counter->count, 0);
> > > +}
> > > +
> > 
> > 
> > Thanks for posting a patch for this issue.
> > 
> > As Ingo said, I think the hardware counter needs to be reset as well as 
> > the value saved in the perf_counter struct.
> > 
> 
> I don't think that's needed, we calculate a delta between prev_count and
> the current read and use that to increment counter->count. Therefore
> when we reset counter->count we should not need to touch the hardware
> counter.
> 
> However, I do think we need the below, first read the hardware counter
> to ensure that delta spoken of above is as close to zero as possible
> when we reset.
> 
> And update the user-page bits.
> 
> ---
> Index: linux-2.6/kernel/perf_counter.c
> ===================================================================
> --- linux-2.6.orig/kernel/perf_counter.c
> +++ linux-2.6/kernel/perf_counter.c
> @@ -1299,7 +1299,9 @@ static unsigned int perf_poll(struct fil
>  
>  static void perf_counter_reset(struct perf_counter *counter)
>  {
> +	(void)perf_counter_read(counter);
>  	atomic_set(&counter->count, 0);
> +	perf_counter_update_userpage(counter);
>  }

Mind sending a changelogged patch? Thanks,

	Ingo
