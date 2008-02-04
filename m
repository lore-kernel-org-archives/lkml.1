Return-Path: <linux-kernel-owner+w=401wt.eu-S1756552AbYBDSV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbYBDSV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 13:21:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbYBDSVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 13:21:20 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:55390 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603AbYBDSVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 13:21:19 -0500
Message-ID: <47A7579F.2050809@oracle.com>
Date: Mon, 04 Feb 2008 10:21:19 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: Nick Piggin <npiggin@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com, mingo@elte.hu,
       ak@suse.de, jens.axboe@oracle.com, James.Bottomley@SteelEye.com,
       andrea@suse.de, clameter@sgi.com, akpm@linux-foundation.org,
       andrew.vasquez@qlogic.com, willy@linux.intel.com
Subject: Re: [rfc] direct IO submission and completion scalability issues
References: <20070728012128.GB10033@linux-os.sc.intel.com> <20080203095252.GA11043@wotan.suse.de> <20080204021052.GD155407@sgi.com>
In-Reply-To: <20080204021052.GD155407@sgi.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ ugh, still jet lagged. ]

> Hi Nick,
> 
> When Matthew was describing this work at an LCA presentation (not
> sure whether you were at that presentation or not), Zach came up
> with the idea that allowing the submitting application control the
> CPU that the io completion processing was occurring would be a good
> approach to try.  That is, we submit a "completion cookie" with the
> bio that indicates where we want completion to run, rather than
> dictating that completion runs on the submission CPU.
> 
> The reasoning is that only the higher level context really knows
> what is optimal, and that changes from application to application.
> The "complete on the submission CPU" policy _may_ be more optimal
> for database workloads, but it is definitely suboptimal for XFS and
> transaction I/O completion handling because it simply drags a bunch
> of global filesystem state around between all the CPUs running
> completions. In that case, we really only want a single CPU to be
> handling the completions.....
> 
> (Zach - please correct me if I've missed anything)

Yeah, I think Nick's patch (and Jens' approach, presumably) is just the
sort of thing we were hoping for when discussing this during Matthew's talk.

I was imagining the patch a little bit differently (per-cpu tasks, do a
wake_up from the driver instead of cpu nr testing up in blk, work
queues, whatever), but we know how to iron out these kinds of details ;).

> Looking at your patch - if you turn it around so that the
> "submission CPU" field can be specified as the "completion cpu" then
> I think the patch will expose the policy knobs needed to do the
> above.

Yeah, that seems pretty straight forward.

We might need some logic for noticing that the desired cpu has been
hot-plugged away while the IO was in flight, it occurs to me.

- z
