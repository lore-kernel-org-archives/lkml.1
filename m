Return-Path: <linux-kernel-owner+w=401wt.eu-S1753300AbZCYJEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbZCYJEG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbZCYJDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:03:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32843 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbZCYJDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:03:53 -0400
Date: Wed, 25 Mar 2009 10:03:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counter: allow and require one-page mmap on
	counting counters
Message-ID: <20090325090336.GC2341@elte.hu>
References: <18889.59409.260586.87939@cargo.ozlabs.ibm.com> <20090325082844.GA11217@elte.hu> <18889.61903.636761.471281@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18889.61903.636761.471281@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo Molnar writes:
> 
> > * Paul Mackerras <paulus@samba.org> wrote:
> > 
> > > +++ b/kernel/perf_counter.c
> > > @@ -1362,8 +1362,13 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
> > >  	vma_size = vma->vm_end - vma->vm_start;
> > >  	nr_pages = (vma_size / PAGE_SIZE) - 1;
> 
> To answer your question below... this:    ^^^
> 
> > >  
> > > -	if (nr_pages == 0 || !is_power_of_2(nr_pages))
> > > -		return -EINVAL;
> > > +	if (counter->hw_event.record_type == PERF_RECORD_SIMPLE) {
> > > +		if (nr_pages)
> > > +			return -EINVAL;
> > > +	} else {
> > > +		if (nr_pages == 0 || !is_power_of_2(nr_pages))
> > > +			return -EINVAL;
> > > +	}
> > 
> > Hm, is_power_of_2() is buggy then as 1 page is a power of two as 
> > well: 1 == 2^0.
> > 
> > Hm, it seems fine:
> > 
> >  static inline __attribute__((const))
> >  bool is_power_of_2(unsigned long n)
> >  {
> >          return (n != 0 && ((n & (n - 1)) == 0));
> >  }
> > 
> > that should return true for an input of 1.
> > 
> > What am i missing?
> > 
> > 	Ingo
> 
> We have one page as a header that contains the info for reading 
> the counter value in userspace plus the head pointer, followed by 
> (for a sampling counter) 2^N pages of ring buffer.

ah - ok. Morning confusion. (any email from me that comes at single 
digit hour local time should be considered fundamentally suspect ;-)

Wouldnt it still be better to keep the symmetry between counting and 
sampling counters? In theory we could transit between these stags 
and 'switch off' a sampling counter or 'switch on' a counting 
counter - via an ioctl or so. Shouldnt counting counters be sampling 
counters that were created while disabled temporarily?

	Ingo
