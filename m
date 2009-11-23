Return-Path: <linux-kernel-owner+w=401wt.eu-S1757095AbZKWLp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095AbZKWLp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:45:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756950AbZKWLp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:45:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52424 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756658AbZKWLp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:45:56 -0500
Date: Mon, 23 Nov 2009 12:45:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: newidle balancing in NUMA domain?
Message-ID: <20091123114550.GB25575@elte.hu>
References: <20091123112228.GA2287@wotan.suse.de>
 <1258976175.4531.299.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258976175.4531.299.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, 2009-11-23 at 12:22 +0100, Nick Piggin wrote:
> > Hi,
> > 
> > I wonder why it was decided to do newidle balancing in the NUMA
> > domain? And with newidle_idx == 0 at that.
> > 
> > This means that every time the CPU goes idle, every CPU in the
> > system gets a remote cacheline or two hit. Not very nice O(n^2)
> > behaviour on the interconnect. Not to mention trashing our
> > NUMA locality.
> > 
> > And then I see some proposal to do ratelimiting of newidle
> > balancing :( Seems like hack upon hack making behaviour much more
> > complex.
> > 
> > One "symptom" of bad mutex contention can be that increasing the
> > balancing rate can help a bit to reduce idle time (because it
> > can get the woken thread which is holding a semaphore to run ASAP
> > after we run out of runnable tasks in the system due to them 
> > hitting contention on that semaphore).
> > 
> > I really hope this change wasn't done in order to help -rt or
> > something sad like sysbench on MySQL.
> 
> IIRC this was kbuild and other spreading workloads that want this.
> 
> the newidle_idx=0 thing is because I frequently saw it make funny 
> balance decisions based on old load numbers, like f_b_g() selecting a 
> group that didn't even have tasks in anymore.
> 
> We went without newidle for a while, but then people started 
> complaining about that kbuild time, and there is a x264 encoder thing 
> that looses tons of throughput.

Yep, i too reacted in a similar way to Nick initially - but i think you 
are right, we really want good, precise metrics and want to be 
optional/fuzzy in our balancing _decisions_, not in our metrics.

	Ingo
