Return-Path: <linux-kernel-owner+w=401wt.eu-S1751474AbZCYIeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbZCYIeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 04:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbZCYIe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 04:34:26 -0400
Received: from viefep12-int.chello.at ([62.179.121.32]:41608 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbZCYIe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 04:34:26 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH] perf_counter: allow and require one-page mmap on
 counting counters
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090325082844.GA11217@elte.hu>
References: <18889.59409.260586.87939@cargo.ozlabs.ibm.com>
	 <20090325082844.GA11217@elte.hu>
Content-Type: text/plain
Date: Wed, 25 Mar 2009 09:34:16 +0100
Message-Id: <1237970056.7972.614.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-25 at 09:28 +0100, Ingo Molnar wrote:
> * Paul Mackerras <paulus@samba.org> wrote:
> 
> > +++ b/kernel/perf_counter.c
> > @@ -1362,8 +1362,13 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
> >  	vma_size = vma->vm_end - vma->vm_start;
> >  	nr_pages = (vma_size / PAGE_SIZE) - 1;
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

nr_pages is the number of data pages.



