Return-Path: <linux-kernel-owner+w=401wt.eu-S1751973Ab0AZILB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab0AZILB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 03:11:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342Ab0AZILA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 03:11:00 -0500
Received: from ozlabs.org ([203.10.76.45]:48095 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756Ab0AZIK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 03:10:59 -0500
Date: Tue, 26 Jan 2010 19:07:48 +1100
From: Anton Blanchard <anton@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: balbir@linux.vnet.ibm.com, Bharata B Rao <bharata@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       schwidefsky@de.ibm.com, balajirrao@gmail.com, dhaval@linux.vnet.ibm.com,
       tglx@linutronix.de, kamezawa.hiroyu@jp.fujitsu.com,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com
Subject: Re: [PATCH] sched: cpuacct: Use bigger percpu counter batch values
 for stats counters
Message-ID: <20100126080748.GD2996@kryten>
References: <20090512102412.GG6351@balbir.in.ibm.com>
 <20090512102939.GB11714@elte.hu>
 <20090512193656.D647.A69D9226@jp.fujitsu.com>
 <20090716081010.GB3134@in.ibm.com>
 <20090716083948.GA2950@kryten>
 <20090820051038.GF21100@kryten>
 <20100118044142.GS12666@kryten>
 <20100125151404.7b7e6970.akpm@linux-foundation.org>
 <4B5E88EB.4020001@linux.vnet.ibm.com>
 <20100125223513.dd82e260.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100125223513.dd82e260.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andrew,

> > I guess a lot of the changelog and comments are in the email history,
> 
> Not a very useful location for it!

Good point, I'll work on a useful comment.

> > Why does it look quite wrong to you?
> 
> Because it computes the correct value and then if it's larger than
> INT_MAX, it inexplicably assigns INT_MAX to it, giving a wrong result!
>
> Does that code actually work, btw?  percpu_counter_batch has type `int'
> and cputime_one_jiffy has type `int' so their product has type `int'. 
> So by the time min_t performs its comparison, the upper 32 bits of the
> product are already lost.

On ppc64, s390 and ia64 cputime_one_jiffy is 64bit and I want to prevent us
creating too large a batch value:

void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)

If we pass in something bigger than INT_MAX we could end up with 0 after
truncation which will turn the percpu counter into a single spinlock global
counter.

Anton
