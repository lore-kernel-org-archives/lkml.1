Return-Path: <linux-kernel-owner+w=401wt.eu-S1761778AbYDQJKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761778AbYDQJKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756008AbYDQJKC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:10:02 -0400
Received: from smtp2.sssup.it ([193.205.80.100]:47105 "EHLO smtp2.sssup.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755524AbYDQJKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:10:01 -0400
Date: Thu, 17 Apr 2008 11:14:55 +0200
From: Fabio Checconi <fchecconi@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, paolo.valente@unimore.it
Subject: Re: [RESEND][RFC] BFQ I/O Scheduler
Message-ID: <20080417091455.GJ62286@gandalf.sssup.it>
References: <20080401152903.GB34860@gandalf.sssup.it> <20080416184441.GA3923@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080416184441.GA3923@ucw.cz>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Pavel Machek <pavel@ucw.cz>
> Date: Wed, Apr 16, 2008 08:44:41PM +0200
>
> On Tue 2008-04-01 17:29:03, Fabio Checconi wrote:
> ...
> > In the first type of tests, to achieve a higher throughput than CFQ
> > (with the default 100 ms time slice), the maximum budget for BFQ
> > had to be set to at least 4k sectors.  Using the same value for the
> 
> Hmm, 4k sectors is ~40 seconds worst case, no? That's quite long...


A process with such a low throughput would be marked as seeky from
the heuristics implemented in cfq/bfq.  Seeky processes are not
treated in the same way as sequential ones and they should not get
their full slice allocated, since they idle only for very short
periods.

BTW looking at the code they can get a full slice, if they always
reissue requests fast enough - within BFQ_MIN_TT - and this is
definitely an issue/error in the current implementation (and we
didn't notice it when converting the code from time-based to
service-based allocation :) ).

An easy solution (without changing the nature of bfq) would be
to use shorter slices for seeky queues, with the same mechanism
we already use for the async ones.
