Return-Path: <linux-kernel-owner+w=401wt.eu-S1759313AbYEGREx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313AbYEGREx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 13:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbYEGREm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 13:04:42 -0400
Received: from relay1.sgi.com ([192.48.171.29]:35150 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752587AbYEGREk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 13:04:40 -0400
Date: Wed, 7 May 2008 10:04:39 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Spinlocks waiting with interrupts disabled / preempt disabled.
In-Reply-To: <20080507073017.GJ32195@elte.hu>
Message-ID: <Pine.LNX.4.64.0805071002330.3110@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0805061220570.30604@schroedinger.engr.sgi.com>
 <20080507073017.GJ32195@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2008, Ingo Molnar wrote:

> > +		return flags;
> > +	local_irq_restore(flags);
> > +	while (!write_can_lock(lock))
> > +		cpu_relax();
> > +	goto retry;
> >  }
> >  EXPORT_SYMBOL(_write_lock_irqsave);
> 
> hm, this is done on a too high level and will turn off some debugging 
> code. I.e. if we dont just loop long but truly deadlock here we wont 
> call lib/spinlock_debug.c's _raw_write_lock() code that does some sanity 
> checks in the debug case.

Right. I guessed that given the gazillion helper functions and wanted to 
know how to address this in the right way.

> so how about doing this on a deeper level and adding a new 
> __raw_write_lock_flags() primitive that would look at the flags value 
> and could enable interrupts in the lowlevel code?

Ok will look at that. Note that this is not unique to _write_lock_irqsave 
but all other locks that disable interrupts seem to have the same issue. 

We are likely going to duplicate a lot of functions.


