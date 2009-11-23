Return-Path: <linux-kernel-owner+w=401wt.eu-S1757260AbZKWMA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260AbZKWMA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 07:00:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757119AbZKWMAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 07:00:55 -0500
Received: from cantor.suse.de ([195.135.220.2]:46662 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756489AbZKWMAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 07:00:54 -0500
Date: Mon, 23 Nov 2009 13:01:00 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: newidle balancing in NUMA domain?
Message-ID: <20091123120100.GC2287@wotan.suse.de>
References: <20091123112228.GA2287@wotan.suse.de> <1258976175.4531.299.camel@laptop> <20091123114550.GB25575@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123114550.GB25575@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 12:45:50PM +0100, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Mon, 2009-11-23 at 12:22 +0100, Nick Piggin wrote:
> > > Hi,
> > > 
> > > I wonder why it was decided to do newidle balancing in the NUMA
> > > domain? And with newidle_idx == 0 at that.
> > > 
> > > This means that every time the CPU goes idle, every CPU in the
> > > system gets a remote cacheline or two hit. Not very nice O(n^2)
> > > behaviour on the interconnect. Not to mention trashing our
> > > NUMA locality.
> > > 
> > > And then I see some proposal to do ratelimiting of newidle
> > > balancing :( Seems like hack upon hack making behaviour much more
> > > complex.
> > > 
> > > One "symptom" of bad mutex contention can be that increasing the
> > > balancing rate can help a bit to reduce idle time (because it
> > > can get the woken thread which is holding a semaphore to run ASAP
> > > after we run out of runnable tasks in the system due to them 
> > > hitting contention on that semaphore).
> > > 
> > > I really hope this change wasn't done in order to help -rt or
> > > something sad like sysbench on MySQL.
> > 
> > IIRC this was kbuild and other spreading workloads that want this.
> > 
> > the newidle_idx=0 thing is because I frequently saw it make funny 
> > balance decisions based on old load numbers, like f_b_g() selecting a 
> > group that didn't even have tasks in anymore.
> > 
> > We went without newidle for a while, but then people started 
> > complaining about that kbuild time, and there is a x264 encoder thing 
> > that looses tons of throughput.
> 
> Yep, i too reacted in a similar way to Nick initially - but i think you 
> are right, we really want good, precise metrics and want to be 
> optional/fuzzy in our balancing _decisions_, not in our metrics.

Well to be fair, the *decision* is to use a longer-term weight for
the runqueue to reduce balancing (seeing as we naturally do far more
balancing on conditions means that we tend to look at our instant
runqueue weight when it is 0).

