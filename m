Return-Path: <linux-kernel-owner+w=401wt.eu-S1754941AbZIAOfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941AbZIAOfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 10:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbZIAOfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 10:35:51 -0400
Received: from viefep15-int.chello.at ([62.179.121.35]:13772 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbZIAOfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 10:35:50 -0400
X-SourceIP: 213.93.53.227
Subject: RE: [discuss] BTS overflow handling, was: [PATCH] perf_counter:
 Fix a race on perf_counter_ctx
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77EC46CF2A6@irsmsx504.ger.corp.intel.com>
References: <20090808120315.GA14086@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF464@irsmsx504.ger.corp.intel.com>
	 <20090810134608.GA8295@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF78D@irsmsx504.ger.corp.intel.com>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1CB7725@irsmsx504.ger.corp.intel.com>
	 <1250600348.7583.280.camel@twins> <1250600385.7583.281.camel@twins>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1CB7775@irsmsx504.ger.corp.intel.com>
	 <1250602664.7583.293.camel@twins>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1CB77C8@irsmsx504.ger.corp.intel.com>
	 <20090818140022.GB13013@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1CB77FF@irsmsx504.ger.corp.intel.com>
	 <928CFBE8E7CB0040959E56B4EA41A77EC465EFC5@irsmsx504.ger.corp.intel.com>
	 <928CFBE8E7CB0040959E56B4EA41A77EC465F989@irsmsx504.ger.corp.intel.com>
	 <1251810046.7547.13.camel@twins>
	 <928CFBE8E7CB0040959E56B4EA41A77EC46CF212@irsmsx504.ger.corp.intel.com>
	 <1251813197.7547.27.camel@twins>
	 <928CFBE8E7CB0040959E56B4EA41A77EC46CF2A6@irsmsx504.ger.corp.intel.com>
Content-Type: text/plain
Date: Tue, 01 Sep 2009 16:35:45 +0200
Message-Id: <1251815745.7547.33.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-01 at 15:27 +0100, Metzger, Markus T wrote:

> >> >> I do need 3 buffers of 2048 entries = 3x48 pages per cpu, though.
> >> >
> >> >And those pages have to be contiguous too, right? That's an order-6
> >> >alloc, painful.
> >>
> >>
> >> According to an earlier discussion with Roland, they don't have to.
> >> They still need to be locked, though.
> >> According to some other discussion with Andrew and Ingo, I still use
> >> kmalloc to allocate those buffers.
> >
> >Section 18.18.5 of book 3B says the DS buffer base is a linear address.
> >This suggests each buffer does need contiguous pages.
> >
> >48 contiguous pages constitutes an order-6 allocation (64 pages), which
> >is unreliable at best.
> 
> Roland argued that this means virtually contiguous, not physically.

Sure it does, but either you use the linear kernel map, or use vmap.

vmap doesn't sound like very good idea.

> >> When I use schedule_work() instead, how would I ensure that the work is done
> >> before the traced (or tracing) task is rescheduled?
> >
> >No, basically the only thing left is softirqs, which can be preempted by
> >hardirqs, but that's a horrid hack too, esp since processing the BTS
> >outside of the handler will basically result in the BTS tracing its own
> >processing, generating even more data to process.
> 
> I would have disabled perf on that cpu; it won't work, otherwise,
> since the draining code alone would generate more trace than fits into
> a buffer. I would need to disable preemption, though.
> 
> Are you saying that schedule_work() won't work? It will quite likely be very
> lossy, but why won't it work at all?
> 
> How would that softirq approach work? Could you point me to some reference
> code?

Look at the tasklet stuff I guess. Look at tasklet_hi_schedule() and co.

