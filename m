Return-Path: <linux-kernel-owner+w=401wt.eu-S933646AbYEVLpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933646AbYEVLpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 07:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932258AbYEVLor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 07:44:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60146 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764555AbYEVLoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 07:44:46 -0400
Subject: Re: PostgreSQL pgbench performance regression in 2.6.23+
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Greg Smith <gsmith@gregsmith.com>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <1211455553.4381.9.camel@marge.simson.net>
References: <Pine.GSO.4.64.0805211115390.8451@westnet.com>
	 <1211440207.5733.8.camel@marge.simson.net>
	 <20080522082814.GA4499@linux.vnet.ibm.com>
	 <1211447105.4823.7.camel@marge.simson.net>
	 <1211452465.7606.8.camel@marge.simson.net>
	 <1211455553.4381.9.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 22 May 2008 13:44:19 +0200
Message-Id: <1211456659.29104.20.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-22 at 13:25 +0200, Mike Galbraith wrote:
> On Thu, 2008-05-22 at 12:34 +0200, Mike Galbraith wrote:
> 
> > (Nadia's ipc/idr patches are applied though, to see if the high end
> > improves over previous runs with various kernels, and it does seem to.)
> 
> Disregard the above, no they don't.  (now removed again)
> 
> However.  The problem with 2.6.26.git running this testcase appears to
> be SYNC_WAKEUPS. No taskset, nada except echo 863 > sched_features
>  
> 2.6.26.git
> 1 8173.538610
> 2 15738.206889
> 3 23399.356839
> 4 21401.182501
> 5 21682.839897
> 6 26396.301413
> 8 29910.334798
> 10 29953.625797
> 15 29535.740343
> 20 28950.900431
> 30 27159.733949
> 40 24163.344207
> 50 23258.496794
> 
> vs
> 
> 2.6.22.17-0.1-default (opensuse 10.3 stock kernel)
> 1 7693.501369
> 2 15669.304960
> 3 25340.818410
> 4 24445.932930
> 5 22807.019544
> 6 24051.387364
> 8 22406.392813
> 10 22631.510576
> 15 21225.243584
> 20 20382.232075
> 30 18834.814588
> 40 17799.906622
> 50 17305.274561


Makes sense - I took a look at pgbench.c (and only thereafter took the
time to find the initial mail lkml where Greg rather nicely explained
its workings) - the thing with sync wakeups is that they try to pull
tasks together, but as this one task (pgbench) serves a number of
postgresql server tasks it will cluster everything.

Humm,.. how to fix this.. we'd need to somehow detect the 1:n nature of
its operation - I'm sure there are other scenarios that could benefit
from this.





