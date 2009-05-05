Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbZEEHee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbZEEHee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 03:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751807AbZEEHeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 03:34:25 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:64097 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbZEEHeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 03:34:24 -0400
X-SourceIP: 213.93.53.227
Subject: Re: perf_counter: resetting a event counter
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <20090505065206.GB27191@elte.hu>
References: <49FF68EF.40300@linux.vnet.ibm.com>
	 <20090505065206.GB27191@elte.hu>
Content-Type: text/plain
Date: Tue, 05 May 2009 09:34:20 +0200
Message-Id: <1241508860.11059.24.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-05 at 08:52 +0200, Ingo Molnar wrote:
> * Corey Ashford <cjashfor@linux.vnet.ibm.com> wrote:
> 
> > Hi,
> >
> > In implementing the PAPI_reset function, whose purpose is to reset 
> > all of the counters in an event set, I found that [it appears] 
> > there is no straight-forward way to implement this function using 
> > "Performance Couunters for Linux".  My current implementation just 
> > closes the counters and reopens them again.  This is not a elegant 
> > solution, nor is the other alternative that occurred to me: 
> > maintain a "virtual" counter in user space, maintained using a 
> > base count, which is subtracted off of the current perf_counter 
> > value of a particular counter.
> >
> > Is there a way that I missed to reset an event counter?  If not, 
> > I'd like to request that a new ioctl command be added to support 
> > this ability.
> 
> We already have such ioctl actions:
> 
>         case PERF_COUNTER_IOC_ENABLE:
>         case PERF_COUNTER_IOC_DISABLE:
>         case PERF_COUNTER_IOC_REFRESH:
> 
> It would be a pretty natural addition to also have a reset method 
> there. Would you like to take a stab at it and send a patch? A 
> first-level approximation would be to do something like:
> 
> 	perf_counter_disable(counter);
> 	atomic64_set(&counter->count, 0);
> 	perf_counter_enable(counter);
> 
> btw, the reset code should probably take the counter->mutex lock as 
> well, because parallel resets done from multiple contexts are 
> otherwise not well-defined.

I would suggest simply bailing when the counter is active when trying to
reset if anything.

A plain: atomic64_set(&counter->count, 0), sounds attractive too.

The trouble with putting in those disable/enable calls is that you
cannot use the ioctl on an already disabled call, since it will
immediately enable it. Also, using it on an active counter is racy in
nature so the disable/enable cycle (or the proposed mutex) doesn't buy
you anything.


