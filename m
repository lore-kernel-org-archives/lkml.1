Return-Path: <linux-kernel-owner+w=401wt.eu-S1758604AbZJNLit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604AbZJNLit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 07:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbZJNLit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 07:38:49 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:40484 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbZJNLis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 07:38:48 -0400
X-SourceIP: 213.93.53.227
Subject: Re: bdi_threshold slow to reach steady state
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Wu Fengguang <fengguang.wu@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       Martin Bligh <mbligh@google.com>
In-Reply-To: <1255518586.2360.78.camel@castor>
References: <1255518586.2360.78.camel@castor>
Content-Type: text/plain
Date: Wed, 14 Oct 2009 13:37:52 +0200
Message-Id: <1255520272.8392.429.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-14 at 12:09 +0100, Richard Kennedy wrote:
> Hi Peter,
> 
> I've been running simple tests that uses fio to write 2Gb & reading the
> bdi dirty threshold once a second from debugfs. 
> 
> The graph of bdi dirty threshold is nice and smooth but takes a long
> time to reach a steady state, 60 seconds or more. (run on 2.6.32-rc4)
> 
> By eye it seems as though a first-order control system is a good model
> for its behavior, so it approximates to 1-e^(-t/T). It just seems too
> heavily damped ( at least on my machine).
> 
> For fun, I changed calc_period_shift to
> 	return ilog2(dirty_total - 1) - 2;
> 
> and it now reaches a steady state much quicker, around 4-5 seconds.
> 
> Tests that write to 2 disks at the same time show no significant
> performance differences but are much more consistent, i.e. the standard
> deviation is lower across multiple runs.
> 
> I have noticed that the first test run on a freshly booted machine is
> always the slowest of any sequence of tests, but this change to
> calc_period_shift greatly reduces this effect. 
> 
> So I wondered how you chose these values? and are there any other tests
> that are useful to explore this?

Right, so we measure time in page writeback completions, and the measure
I used was the round up power of two of the dirty_thresh. We adjust in
the same time it takes to write out a full dirty_thresh amount of data.

The idea was that people would scale their dirty thesh according to
their writeout capacity, etc..

Martin J Bligh complained about this very same issue and I told them to
experiment with that same scale function. But I guess the result of that
got lost in the google filter (stuff goes in, nothing ever comes back
out).

Anyway, the dirty_thresh relation seems sensible still, but the exact
parameters could be poked at. I have no objection to reducing the period
with a factor of 16 like you did, except that we need some more
feedback, preferably from people with more than a few spindles.

(The initial ramp will be roughly twice as slow, since the steady state
of this approximation is half-full).

> I know that my machine is getting a bit old now, it's AMDX2 & only has
> sata 150 drives, so I'm not suggesting that this change is going to be
> correct for all machines but maybe we can set a better default? or take
> more factors in to account other than just memory size. 
> 
> BTW why is it ilog2(dirty_total -1) -- what does the -1 do?

http://lkml.org/lkml/2007/1/26/143

