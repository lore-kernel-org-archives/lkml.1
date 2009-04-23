Return-Path: <linux-kernel-owner+w=401wt.eu-S1752552AbZDWB0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbZDWB0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 21:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbZDWB0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 21:26:34 -0400
Received: from THUNK.ORG ([69.25.196.29]:50238 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbZDWB0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 21:26:34 -0400
Date: Wed, 22 Apr 2009 21:22:54 -0400
From: Theodore Tso <tytso@mit.edu>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Righi <righi.andrea@gmail.com>, randy.dunlap@oracle.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>,
       Jens Axboe <jens.axboe@oracle.com>, eric.rannaud@gmail.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>, fernando@oss.ntt.co.jp,
       dradford@bluehost.com, Gui@smtp1.linux-foundation.org,
       agk@sourceware.org, subrata@linux.vnet.ibm.com,
       Paul Menage <menage@google.com>, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, matt@bluehost.com, roberto@unbit.it,
       ngupta@google.com
Subject: Re: [PATCH 9/9] ext3: do not throttle metadata and journal IO
Message-ID: <20090423012254.GZ15541@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Andrea Righi <righi.andrea@gmail.com>, randy.dunlap@oracle.com,
	Carl Henrik Lunde <chlunde@ping.uio.no>,
	Jens Axboe <jens.axboe@oracle.com>, eric.rannaud@gmail.com,
	Balbir Singh <balbir@linux.vnet.ibm.com>, fernando@oss.ntt.co.jp,
	dradford@bluehost.com, Gui@smtp1.linux-foundation.org,
	agk@sourceware.org, subrata@linux.vnet.ibm.com,
	Paul Menage <menage@google.com>, akpm@linux-foundation.org,
	containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	dave@linux.vnet.ibm.com, matt@bluehost.com, roberto@unbit.it,
	ngupta@google.com
References: <20090421163537.GI19186@mit.edu> <20090421172317.GM19637@balbir.in.ibm.com> <20090421174620.GD15541@mit.edu> <20090421181429.GO19637@balbir.in.ibm.com> <20090421191401.GF15541@mit.edu> <20090421204905.GA5573@linux> <20090422093349.1ee9ae82.kamezawa.hiroyu@jp.fujitsu.com> <20090422102153.9aec17b9.kamezawa.hiroyu@jp.fujitsu.com> <20090422102239.GA1935@linux> <20090423090535.ec419269.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423090535.ec419269.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 09:05:35AM +0900, KAMEZAWA Hiroyuki wrote:
> So, current status is.
> 
>   A. memcg should support dirty_ratio for its own memory reclaim.
>      in plan.
> 
>   B. another cgroup can be implemnted to support cgroup_dirty_limit().
>      But relationship with "A" should be discussed.
>      no plan yet.
> 
>   C. I/O cgroup and bufferred I/O tracking system.
>      Now under patch review.
> 
> And this I/O throttle is mainly for "C" discussion. 

How much testing has been done in terms of whether the I/O throttling
actually works?  Not just, "the kernel doesn't crash", but that where
you have one process generating a large amount of I/O load, in various
different ways, and whether the right things happens?  If so, how has
this been measured?

I'm really concerned that given some of the ways that I/O will "leak"
out --- the via pdflush, swap writeout, etc., that without the rest of
the pieces in place, I/O throttling by itself might not prove to be
very effective.  Sure, if the workload is only doing direct I/O, life
is pretty easy and it shouldn't be hard to throttle the cgroup.

But in the case where there is bufferred I/O, without write
throttling, it's hard to see how well the I/O controller will work in
practice.  In fact, I wouldn't be that surprised if it's possible to
trigger the OOM killer.......

Regards,

						- Ted
