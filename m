Return-Path: <linux-kernel-owner+w=401wt.eu-S1758485AbZCYI5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758485AbZCYI5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 04:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbZCYI4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 04:56:55 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:56866 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211AbZCYI4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 04:56:54 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18889.61903.636761.471281@cargo.ozlabs.ibm.com>
Date: Wed, 25 Mar 2009 19:56:47 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counter: allow and require one-page mmap on
	counting counters
In-Reply-To: <20090325082844.GA11217@elte.hu>
References: <18889.59409.260586.87939@cargo.ozlabs.ibm.com>
	<20090325082844.GA11217@elte.hu>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> * Paul Mackerras <paulus@samba.org> wrote:
> 
> > +++ b/kernel/perf_counter.c
> > @@ -1362,8 +1362,13 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
> >  	vma_size = vma->vm_end - vma->vm_start;
> >  	nr_pages = (vma_size / PAGE_SIZE) - 1;

To answer your question below... this:    ^^^

> >  
> > -	if (nr_pages == 0 || !is_power_of_2(nr_pages))
> > -		return -EINVAL;
> > +	if (counter->hw_event.record_type == PERF_RECORD_SIMPLE) {
> > +		if (nr_pages)
> > +			return -EINVAL;
> > +	} else {
> > +		if (nr_pages == 0 || !is_power_of_2(nr_pages))
> > +			return -EINVAL;
> > +	}
> 
> Hm, is_power_of_2() is buggy then as 1 page is a power of two as 
> well: 1 == 2^0.
> 
> Hm, it seems fine:
> 
>  static inline __attribute__((const))
>  bool is_power_of_2(unsigned long n)
>  {
>          return (n != 0 && ((n & (n - 1)) == 0));
>  }
> 
> that should return true for an input of 1.
> 
> What am i missing?
> 
> 	Ingo

We have one page as a header that contains the info for reading the
counter value in userspace plus the head pointer, followed by (for a
sampling counter) 2^N pages of ring buffer.

Paul.
