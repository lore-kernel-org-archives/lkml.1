Return-Path: <linux-kernel-owner+w=401wt.eu-S1757641AbZHGL53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641AbZHGL53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 07:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757608AbZHGL52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 07:57:28 -0400
Received: from viefep14-int.chello.at ([62.179.121.34]:11049 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757514AbZHGL52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 07:57:28 -0400
X-SourceIP: 213.93.53.227
Subject: RE: [patch] x86, perf_counter, bts: add bts to perf_counter
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "oleg@redhat.com" <oleg@redhat.com>
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77EC1BFF07F@irsmsx504.ger.corp.intel.com>
References: <20090807092256.A6083@sedona.ch.intel.com>
	 <1249645524.32113.688.camel@twins>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF07F@irsmsx504.ger.corp.intel.com>
Content-Type: text/plain
Date: Fri, 07 Aug 2009 13:57:09 +0200
Message-Id: <1249646229.32113.692.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-07 at 12:51 +0100, Metzger, Markus T wrote:
> >-----Original Message-----
> >From: Peter Zijlstra [mailto:a.p.zijlstra@chello.nl]
> >Sent: Friday, August 07, 2009 1:45 PM
> >To: Metzger, Markus T
> >Cc: linux-kernel@vger.kernel.org; mingo@elte.hu; tglx@linutronix.de; hpa@zytor.com;
> >markus.t.metzger@gmail.com; oleg@redhat.com
> >Subject: Re: [patch] x86, perf_counter, bts: add bts to perf_counter
> >
> >On Fri, 2009-08-07 at 09:22 +0200, Markus Metzger wrote:
> >> @@ -721,9 +903,13 @@ static int __hw_perf_counter_init(struct
> >>         err = 0;
> >>         if (!atomic_inc_not_zero(&active_counters)) {
> >>                 mutex_lock(&pmc_reserve_mutex);
> >> -               if (atomic_read(&active_counters) == 0 && !reserve_pmc_hardware())
> >> -                       err = -EBUSY;
> >> -               else
> >> +               if (atomic_read(&active_counters) == 0) {
> >> +                       if (!reserve_pmc_hardware())
> >> +                               err = -EBUSY;
> >> +                       else
> >> +                               reserve_bts_hardware();
> >> +               }
> >> +               if (!err)
> >>                         atomic_inc(&active_counters);
> >>                 mutex_unlock(&pmc_reserve_mutex);
> >>         }
> >
> >You loose the reserve_bts_hardware() error case there.
> 
> 
> That had been intentional since I consider BTS somewhat optional. In case it is not available or
> fails to initialize, e.g. out of memory, we fall back to normal profiling.
> 
> Now that I think about it again, I guess that's not what a (debugger) user would expect.
> An error might be more appropriate in that case.
> 
> I'll change it.

If there's hardware that supports intel perfmon v2+ but doesn't have BTS
(I don't think so) then we shouldn't fail it hard on not present.

But if the BTS stuff should always be present on the hardware then we
can indeed unconditionally fail.

