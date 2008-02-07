Return-Path: <linux-kernel-owner+w=401wt.eu-S1757752AbYBGPRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757752AbYBGPRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 10:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759624AbYBGPQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 10:16:38 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:6932 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758921AbYBGPQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 10:16:36 -0500
Message-ID: <47AB20D6.2000200@hp.com>
Date: Thu, 07 Feb 2008 10:16:38 -0500
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, arjan@linux.intel.com, dgc@sgi.com,
       npiggin@suse.de
Subject: Re: [PATCH 0/8] IO queuing and complete affinity
References: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> Hi,
> 
> Since I'll be on vacation next week, I thought I'd send this out in
> case people wanted to play with it. It works here, but I haven't done
> any performance numbers at all.
> 
> Patches 1-7 are all preparation patches for #8, which contains the
> real changes. I'm not particularly happy with the arch implementation
> for raising a softirq on another CPU, but it should be fast enough
> so suffice for testing.
> 
> Anyway, this patchset is mainly meant as a playground for testing IO
> affinity. It allows you to set three values per queue, see the files
> in the /sys/block/<dev>/queue directory:
> 
> completion_affinity
> 	Only allow completions to happen on the defined CPU mask.
> queue_affinity
> 	Only allow queuing to happen on the defined CPU mask.
> rq_affinity
> 	Always complete a request on the same CPU that queued it.
> 
> As you can tell, there's some overlap to allow for experimentation.
> rq_affinity will override completion_affinity, so it's possible to
> have completions on a CPU that isn't set in that mask. The interface
> is currently limited to all CPUs or a specific CPU, but the implementation
> is supports (and works with) cpu masks. The logic is in
> blk_queue_set_cpumask(), it should be easy enough to change this to
> echo a full mask, or allow OR'ing of CPU masks when a new CPU is passed in.
> For now, echo a CPU number to set that CPU, or use -1 to set all CPUs.
> The default is all CPUs for no change in behaviour.
> 
> Patch set is against current git as of this morning. The code is also in
> the block git repo, branch is io-cpu-affinity.
> 
> git://git.kernel.dk/linux-2.6-block.git io-cpu-affinity
> 

FYI: on a kernel with this patch set, running on a 4-way ia64 (non-NUMA) w/ a FC disk, I crafted a test with 135 combinations:

o  Having the issuing application pegged on each CPU - or - left alone (run on any CPU), yields 5 possibilities
o  Having the queue affinity on each CPU, or any (-1), yields 5 possibilities
o  Having the completion affinity on each CPU, or any (-1), yields 5 possibilities

and

o  Having the issuing application pegged on each CPU - or - left alone (run on ay CPU), yields 5 possibilities
o  Having rq_affinity set to 0 or 1, yields 2 possibilities.

Each test was for 10 minutes, and ran overnight just fine. The difference amongst the 135 resulting values (based upon latency per-IO seen at the application layer) was <<1% (0.32% to be exact). This would seem to indicate that there isn't a penalty for running with this code, and it seems relatively stable given this.

The application used was doing 64KiB asynchronous direct reads, and had a minimum average per-IO latency of 42.426310 milliseconds, and average of 42.486557 milliseconds (std dev of 0.0041561), and a max of 42.561360 milliseconds

I'm going to do some runs on a 16-way NUMA box, w/ a lot of disks today, to see if we see gains in that environment.

Alan D. Brunelle
HP OSLO S&P
