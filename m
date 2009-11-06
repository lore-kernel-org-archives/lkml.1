Return-Path: <linux-kernel-owner+w=401wt.eu-S1759234AbZKFAvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234AbZKFAvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 19:51:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756728AbZKFAvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 19:51:32 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39655 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbZKFAvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 19:51:31 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 6 Nov 2009 09:49:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       akpm@linux-foundation.org,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] lib: generic percpu counter array
Message-Id: <20091106094903.5ede138d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.1.10.0911051013080.25718@V090114053VZO-1>
References: <20091104152426.eacc894f.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.1.10.0911041414560.7409@V090114053VZO-1>
	<20091105090659.9a5d17b1.kamezawa.hiroyu@jp.fujitsu.com>
	<20091105141653.132d4977.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.1.10.0911051013080.25718@V090114053VZO-1>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thank you for review.

On Thu, 5 Nov 2009 10:15:36 -0500 (EST)
Christoph Lameter <cl@linux-foundation.org> wrote:

> On Thu, 5 Nov 2009, KAMEZAWA Hiroyuki wrote:
> 
> > +static inline void
> > +counter_array_add(struct counter_array *ca, int idx, int val)
> > +{
> > +	ca->counters[idx] += val;
> > +}
> 
> This is not a per cpu operation and therefore expensive. The new percpu
> this_cpu_inc f.e. generates a single x86 instruction for an increment.
> 
This code is for !SMP.


> > +void __counter_array_add(struct counter_array *ca, int idx, int val, int batch)
> > +{
> > +	long count, *pcount;
> > +
> > +	preempt_disable();
> > +
> > +	pcount = this_cpu_ptr(ca->v.array);
> > +	count = pcount[idx] + val;
> > +	if (!ca->v.nosync && ((count > batch) || (count < -batch))) {
> > +		atomic_long_add(count, &ca->counters[idx]);
> > +		pcount[idx] = 0;
> > +	} else
> > +		pcount[idx] = count;
> > +	preempt_enable();
> > +}
> 
> Too expensive to use in critical VM paths. The percpu operations generate
> a single instruction instead of the code above. No need for preempt etc.
> 
Hmm, ok. I'll have to see your patch, more.
I wonder how to use indexed-array and ops like add_return..


Thanks,
-Kame



