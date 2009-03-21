Return-Path: <linux-kernel-owner+w=401wt.eu-S1754387AbZCUJqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbZCUJqU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 05:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbZCUJqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 05:46:11 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:58584 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbZCUJqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 05:46:10 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18884.46934.898678.53966@cargo.ozlabs.ibm.com>
Date: Sat, 21 Mar 2009 20:45:58 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 3/3] perf_counter: new output ABI - part 1
In-Reply-To: <20090320190912.GF6224@elte.hu>
References: <20090320151547.937040269@chello.nl>
	<20090320151735.008338484@chello.nl>
	<20090320190912.GF6224@elte.hu>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> i think it would still be nice to allow plain old-fashioned 
> poll()+read() loops ... but the logistics of that seem difficult. 
> mmap() seems to fit this better - and it's probably faster as well. 
> (as we have to construct the kernel-space pages anyway, so mapping 
> them isnt that big of an issue)
> 
> per-CPU-ness will be handled naturally via per-cpu counters.
> 
> Paul, can you see any hole/quirkiness in this scheme?

The one thing I can see that we would lose is the ability to have a
signal delivered on every event.  The PAPI developers want to be able
to get a signal generated every time the counter overflows, and
previously we could do that using the O_ASYNC flag, but now we'll only
get a signal every page's worth of events.

So I think we want userspace to be able to say how often we should
generate a poll event, i.e. provide a way for userspace to say "please
generate a poll event every N counter events".  That would also solve
the problem of 1 page not being a valid configuration - you could set
the poll interval to the number of events that fit in half a page, for
instance.

Paul.
