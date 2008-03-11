Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbYCKH7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbYCKH7I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 03:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbYCKH64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 03:58:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52571 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbYCKH64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 03:58:56 -0400
Date: Tue, 11 Mar 2008 08:58:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Poor PostgreSQL scaling on Linux 2.6.25-rc5 (vs 2.6.22)
Message-ID: <20080311075845.GA13758@elte.hu>
References: <200803111749.29143.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803111749.29143.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0164]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> PostgreSQL is different. It has zero idle time when running this 
> workload. It actually scaled "super linearly" on my system here, from 
> single threaded performance to 8 cores (giving an 8.2x performance 
> increase)!
> 
> So PostgreSQL performance profile is actually much more interesting. 
> To my dismay, I found that Linux 2.6.25-rc5 performs really badly 
> after saturating the runqueues and subsequently increasing threads. 
> 2.6.22 drops a little bit, but basically settles near the peak 
> performance. With 2.6.25-rc5, throughput seems to be falling off 
> linearly with the number of threads.

thanks Nick, i'll check this - and i agree that this very much looks 
like a scheduler regression. Just a quick suggestion, does a simple 
runtime tune like this fix the workload:

  for N in /proc/sys/kernel/sched_domain/*/*/flags; do
     echo $[`cat $N`|16] > N
  done

this sets SD_WAKE_IDLE for all the nodes in the scheduler domains tree. 
(doing this results in over-agressive idle balancing - but if this fixes 
your testcase it shows that we were balancing under-agressively for this 
workload.) Thanks,

	Ingo
