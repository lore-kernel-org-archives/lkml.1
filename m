Return-Path: <linux-kernel-owner+w=401wt.eu-S1757106AbZKWLgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106AbZKWLgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756696AbZKWLgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:36:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:59395 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585AbZKWLgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:36:13 -0500
Subject: Re: newidle balancing in NUMA domain?
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20091123112228.GA2287@wotan.suse.de>
References: <20091123112228.GA2287@wotan.suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Nov 2009 12:36:15 +0100
Message-ID: <1258976175.4531.299.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-23 at 12:22 +0100, Nick Piggin wrote:
> Hi,
> 
> I wonder why it was decided to do newidle balancing in the NUMA
> domain? And with newidle_idx == 0 at that.
> 
> This means that every time the CPU goes idle, every CPU in the
> system gets a remote cacheline or two hit. Not very nice O(n^2)
> behaviour on the interconnect. Not to mention trashing our
> NUMA locality.
> 
> And then I see some proposal to do ratelimiting of newidle
> balancing :( Seems like hack upon hack making behaviour much more
> complex.
> 
> One "symptom" of bad mutex contention can be that increasing the
> balancing rate can help a bit to reduce idle time (because it
> can get the woken thread which is holding a semaphore to run ASAP
> after we run out of runnable tasks in the system due to them 
> hitting contention on that semaphore).
> 
> I really hope this change wasn't done in order to help -rt or
> something sad like sysbench on MySQL.

IIRC this was kbuild and other spreading workloads that want this.

the newidle_idx=0 thing is because I frequently saw it make funny
balance decisions based on old load numbers, like f_b_g() selecting a
group that didn't even have tasks in anymore.

We went without newidle for a while, but then people started complaining
about that kbuild time, and there is a x264 encoder thing that looses
tons of throughput.

