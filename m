Return-Path: <linux-kernel-owner+w=401wt.eu-S1758387AbZEEGwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758387AbZEEGwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 02:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbZEEGwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 02:52:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44841 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613AbZEEGwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 02:52:23 -0400
Date: Tue, 5 May 2009 08:52:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: perf_counter: resetting a event counter
Message-ID: <20090505065206.GB27191@elte.hu>
References: <49FF68EF.40300@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49FF68EF.40300@linux.vnet.ibm.com>
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


* Corey Ashford <cjashfor@linux.vnet.ibm.com> wrote:

> Hi,
>
> In implementing the PAPI_reset function, whose purpose is to reset 
> all of the counters in an event set, I found that [it appears] 
> there is no straight-forward way to implement this function using 
> "Performance Couunters for Linux".  My current implementation just 
> closes the counters and reopens them again.  This is not a elegant 
> solution, nor is the other alternative that occurred to me: 
> maintain a "virtual" counter in user space, maintained using a 
> base count, which is subtracted off of the current perf_counter 
> value of a particular counter.
>
> Is there a way that I missed to reset an event counter?  If not, 
> I'd like to request that a new ioctl command be added to support 
> this ability.

We already have such ioctl actions:

        case PERF_COUNTER_IOC_ENABLE:
        case PERF_COUNTER_IOC_DISABLE:
        case PERF_COUNTER_IOC_REFRESH:

It would be a pretty natural addition to also have a reset method 
there. Would you like to take a stab at it and send a patch? A 
first-level approximation would be to do something like:

	perf_counter_disable(counter);
	atomic64_set(&counter->count, 0);
	perf_counter_enable(counter);

btw, the reset code should probably take the counter->mutex lock as 
well, because parallel resets done from multiple contexts are 
otherwise not well-defined.

	Ingo
