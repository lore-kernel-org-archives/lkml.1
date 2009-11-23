Return-Path: <linux-kernel-owner+w=401wt.eu-S1756944AbZKWLWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944AbZKWLWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:22:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756307AbZKWLWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:22:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40889 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755586AbZKWLWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:22:23 -0500
Date: Mon, 23 Nov 2009 12:22:28 +0100
From: Nick Piggin <npiggin@suse.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: newidle balancing in NUMA domain?
Message-ID: <20091123112228.GA2287@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I wonder why it was decided to do newidle balancing in the NUMA
domain? And with newidle_idx == 0 at that.

This means that every time the CPU goes idle, every CPU in the
system gets a remote cacheline or two hit. Not very nice O(n^2)
behaviour on the interconnect. Not to mention trashing our
NUMA locality.

And then I see some proposal to do ratelimiting of newidle
balancing :( Seems like hack upon hack making behaviour much more
complex.

One "symptom" of bad mutex contention can be that increasing the
balancing rate can help a bit to reduce idle time (because it
can get the woken thread which is holding a semaphore to run ASAP
after we run out of runnable tasks in the system due to them 
hitting contention on that semaphore).

I really hope this change wasn't done in order to help -rt or
something sad like sysbench on MySQL.

And btw, I'll stay out of mentioning anything about CFS development,
but it really sucks to be continually making significant changes to
domains balancing *and* per-runqueue scheduling at the same time :(
It makes it even difficult to bisect things.

Thanks,
Nick

