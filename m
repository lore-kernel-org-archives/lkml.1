Return-Path: <linux-kernel-owner+w=401wt.eu-S1761560AbZDQQYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761560AbZDQQYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 12:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761884AbZDQQX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 12:23:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:50431 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758050AbZDQQX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 12:23:58 -0400
Subject: Re: Scheduler regression: Too frequent timer interrupts(?)
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0904171142050.13734@qirst.com>
References: <alpine.DEB.1.10.0904161539130.23632@qirst.com>
	 <1239951613.23397.4107.camel@laptop>
	 <alpine.DEB.1.10.0904170941020.11877@qirst.com>
	 <1239977776.23397.4590.camel@laptop>
	 <alpine.DEB.1.10.0904171021360.20239@qirst.com>
	 <1239979901.23397.4638.camel@laptop>
	 <alpine.DEB.1.10.0904171100510.21575@qirst.com>
	 <20090417153520.GA29968@elte.hu>
	 <alpine.DEB.1.10.0904171142050.13734@qirst.com>
Content-Type: text/plain
Date: Fri, 17 Apr 2009 18:23:46 +0200
Message-Id: <1239985426.23397.4757.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-17 at 11:55 -0400, Christoph Lameter wrote:

> Futher details are included in the document that I pointed him to. The
> "workload" is a synthetic test of a busy loop continually reading the TSC
> register.
> 
> http://www.kernel.org/pub/linux/kernel/people/christoph/collab-spring-2009/Latencharts.ods

You're really going to make me open that thing eh..

As we've constituted, graph 1 is useless.

I'm still not quite sure why you couldn't provide the data for the other
graphs in email. They are not at all that much:

Graph 2: Noise Length

Kernel          Test 1  Test 2  Test 3  Interruption(AVG)
2.6.22          2.55    2.61    1.92    2.36
2.6.23          1.33    1.38    1.34    1.35
2.6.24          1.97    1.86    1.87    1.90
2.6.25          2.09    2.29    2.09    2.16
2.6.26          1.49    1.22    1.22    1.31
2.6.27          1.67    1.28    1.18    1.38
2.6.28          1.27    1.21    1.14    1.21
2.6.29          1.44    1.33    1.54    1.44
2.6.30-rc2      2.06    1.49    1.24    1.60

Is pretty useless too, since it only counts >1us events. Hence it will
always be biased.

Much better would have been a graph constructed from a histrogram that
plots all lengths (say in 10ns) buckets. There you would have had a few
(at least 2) peaks, one around the time it takes to complete the
userspace loop, and one around the time it takes to do this interrupt
thing -- and maybe some other smaller ones. But now we're clueless.

Combined with graph 1, we can only compare 26+, and there we can see
there is some variance in how long a tick takes between kernels -- but a
std-dev along with this avg, would have been even better.

For the past few releases I cannot remember anything that would
immediately affect the tick length. Nothing structural was changed
around that code.

> > Is the overhead 1%? 2%? 0.5%? And how did it change from 2.6.22
> > onwards? Did it go up by 0.1%, from 1% to 1.1%? Or did the average
> > go down by 0.05%, while increasing the spread of events (thus
> > fooling your cutoff)?
> 
> As you see in the diagrams provided there is a 4 fold increase in the
> number of interrupts >1usecs when going from 2.6.22 to 2.6.23. How would
> you measure the overhead? Time spent in the OS? Disturbance of the caches
> by the OS that cause the application to have to refetch data from Ram?

You could for example run an NMI profiler at 10000 Hz and collect
samples. Or use PMU hardware to collect numbers

