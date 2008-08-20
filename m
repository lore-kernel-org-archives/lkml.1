Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbYHTTOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbYHTTOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 15:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbYHTTOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 15:14:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:20085 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977AbYHTTOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 15:14:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,240,1217833200"; 
   d="scan'208";a="430851959"
Date: Wed, 20 Aug 2008 12:14:37 -0700
From: mark gross <mgross@linux.intel.com>
To: John Kacur <jkacur@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, arjan <arjan@infradead.org>
Subject: Re: [PATCH RFC] pm_qos_requirement might sleep
Message-ID: <20080820191437.GA12415@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <520f0cf10808041352h78bd4319x1802f018aeffe6dc@mail.gmail.com> <1217921101.3589.98.camel@twins> <20080805204901.GA31132@linux.intel.com> <1217970588.29415.36.camel@lappy.programming.kicks-ass.net> <520f0cf10808051518h1459d353r8de78e98f79ec57c@mail.gmail.com> <20080812224926.GA20652@linux.intel.com> <520f0cf10808130124o301b6691ra37ac9007120b9df@mail.gmail.com> <20080814155241.GA31050@linux.intel.com> <1218736137.10800.234.camel@twins> <520f0cf10808141551k283aecb8y647d0f5ae321b81f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520f0cf10808141551k283aecb8y647d0f5ae321b81f@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 12:51:11AM +0200, John Kacur wrote:
> On Thu, Aug 14, 2008 at 7:48 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Thu, 2008-08-14 at 08:52 -0700, mark gross wrote:
> >
> >> Keeping a lock around the different "target_value"s may not be so
> >> important.  Its just a 32bit scaler value, and perhaps we can make it an
> >> atomic type?  That way we loose the raw_spinlock.
> >
> > My suggestion was to keep the locking for the write side - so as to
> > avoid stuff stomping on one another, but drop the read side as:
> >
> >  spin_lock
> >  foo = var;
> >  spin_unlock
> >  return foo;
> >
> > is kinda useless, it doesn't actually serialize against the usage of
> > foo, that is, once it gets used, var might already have acquired a new
> > value.
> >
> > The only thing it would protect is reading var, but since that is a
> > machine sized read, its atomic anyway (assuming its naturally aligned).
> >
> > So no need for atomic_t (its read-side is just a read too), just drop
> > the whole lock usage from pq_qos_requirement().
> >
> 
> Thanks Peter.
> 
> Mark, is the following patch ok with you? This should be applied to
> mainline, and then after that no special patches are necessary for
> real-time.

It looks ok to me, do I need to add a compiler declaration to the
structure to make sure the target_value is word aligned?

thanks,

--mgross


> 
> Thanks
> 
> John Kacur

> Subject: Remove unnecessary lock in pm_qos_requirement
> 
> Signed-off-by: John Kacur <jkacur at gmail dot com>
> 
> Index: linux-2.6/kernel/pm_qos_params.c
> ===================================================================
> --- linux-2.6.orig/kernel/pm_qos_params.c
> +++ linux-2.6/kernel/pm_qos_params.c
> @@ -193,14 +193,7 @@ static int find_pm_qos_object_by_minor(i
>   */
>  int pm_qos_requirement(int pm_qos_class)
>  {
> -	int ret_val;
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&pm_qos_lock, flags);
> -	ret_val = pm_qos_array[pm_qos_class]->target_value;
> -	spin_unlock_irqrestore(&pm_qos_lock, flags);
> -
> -	return ret_val;
> +	return pm_qos_array[pm_qos_class]->target_value;
>  }
>  EXPORT_SYMBOL_GPL(pm_qos_requirement);
>  

