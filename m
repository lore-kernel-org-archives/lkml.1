Return-Path: <linux-kernel-owner+w=401wt.eu-S1752546AbYH2Dev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbYH2Dev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 23:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbYH2Dem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 23:34:42 -0400
Received: from mga07.intel.com ([143.182.124.22]:32938 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751274AbYH2Del (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 23:34:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,290,1217833200"; 
   d="scan'208";a="38840346"
Subject: Re: VolanoMark regression with 2.6.27-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Chris Friesen <cfriesen@nortel.com>
In-Reply-To: <1219301306.8781.55.camel@ymzhang>
References: <20080811185008.GA29291@linux.vnet.ibm.com>
	 <1912726331.25608.235.camel@ymzhang>
	 <20080817115035.GA32223@linux.vnet.ibm.com>
	 <20080818052155.GA5063@linux.vnet.ibm.com>
	 <1219217089.8781.27.camel@ymzhang> <1219218089.10800.404.camel@twins>
	 <20080820105141.GA18226@elte.hu> <1219239137.8651.52.camel@twins>
	 <20080820134708.GA20648@elte.hu> <1219285502.8781.35.camel@ymzhang>
	 <20080821061622.GC14572@elte.hu>  <1219301306.8781.55.camel@ymzhang>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 29 Aug 2008 11:35:09 +0800
Message-Id: <1219980909.8781.122.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-08-21 at 14:48 +0800, Zhang, Yanmin wrote:
> On Thu, 2008-08-21 at 08:16 +0200, Ingo Molnar wrote:
> > * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> > 
> > > > ok, i've applied this one to tip/sched/urgent instead of the 
> > > > feature-disabling patchlet. Yanmin, could you please check whether this 
> > > > one does the trick?
> > >
> > > This new patch almost doesn't help volanoMark. Pls. use the patch 
> > > which sets ﻿LB_BIAS=1 by default.
> > 
> > ok. That also removes the kernel.h complications ;-)
> Sorry, I have new update.
> Originally, I worked on 2.6.27-rc1. I just move to 2.6.27-rc3 and found
> something defferent when CONFIG_GROUP_SCHED=n.
> 
> With 2.6.27-rc3, on my 8-core stoakley, all volanoMark regression disappears,
> no matter if I enable LB_BIAS. On 16-core tigerton, the regression is still
> there if I don't enable LB_BIAS and regression becomes 11% from 65%.
I have new updates on this regression. I checked volanoMark web page and
found the client command line has option rooms and users. rooms means how many
chat room will be started. users means how many users are in 1 room. The default
rooms is 10 and users is 20, so every room has about 800 threads. As all threads of a
room just communicate within this room, so the rooms number is important.

All my previous volanoMark testing uses default rooms 10 and users 20. With wake_offine
in kernel, waker/sleeper will be moved to the same cpu gradually. However, if the
rooms is not multiple of cpu number, due to load balance, kernel will move threads from
one cpu to another cpu continually. If there are too many threads to weaken the cache-hot
effect, load balance is more important. But if there are not too many threads running,
cache-hot is more important than load balance. Should we prefer to wake_affine more?

Below is some data I collected with numerous testing on 3 machines.


On 2-quadcore processor stoakley (8-core):
kernel\rooms           |      8        |      10      |      16    |     32
-------------------------------------------------------------------------------------------
2.6.26_nogroup         |   385617      |    351247    |	323324	   |  231934
﻿-------------------------------------------------------------------------------------------
2.6.27-rc4_nogroup     |    359124     |    336984    |	335180     |  235258
﻿-------------------------------------------------------------------------------------------
﻿2.6.26group            |    ﻿﻿381425     |    ﻿﻿343636    |  ﻿﻿312280    |  ﻿179673
﻿-------------------------------------------------------------------------------------------
2.6.27-rc4group        |   212112      |   270000     |	﻿300188	    |  ﻿228465
-------------------------------------------------------------------------------------------

﻿
On 2-quadcore+HT processor new x86_64 (8-core+HT, total 16 threads):
kernel\rooms        |    10    |   16    |   24    |   32     |   64
-------------------------------------------------------------------------
2.6.26_nogroup      |  667668  | ﻿671860  | ﻿﻿671662  |  621900  | ﻿509482
﻿-------------------------------------------------------------------------
2.6.27-rc4_nogroup  |  ﻿732346  |  ﻿800290 | ﻿709272  |  ﻿648561  | ﻿497243
﻿-------------------------------------------------------------------------
﻿2.6.26group         |  ﻿705579  |  ﻿﻿﻿759464 | ﻿﻿﻿693697  |  ﻿﻿636019  | ﻿500744
﻿-------------------------------------------------------------------------
2.6.27-rc4group     |  ﻿﻿﻿572426  |  ﻿674977 | ﻿﻿627410  |  ﻿﻿590984  | ﻿445651
-------------------------------------------------------------------------

﻿
On 4-quadcore tigerton processor(16-core)(32 rooms testing isn't stable on the machine, so no 32):
kernel\rooms           |      8        |      10      |   16   
------------------------------------------------------------------
2.6.26_nogroup         |   ﻿﻿346410      |    ﻿﻿382938    | ﻿﻿349405
﻿------------------------------------------------------------------
2.6.27-rc4_nogroup     |    359124     |    336984    |	335180    
﻿------------------------------------------------------------------
﻿2.6.26group            |    ﻿﻿﻿504802     |    ﻿﻿﻿376513    | ﻿﻿﻿319020   
﻿------------------------------------------------------------------
2.6.27-rc4group        |   ﻿247652      |   ﻿284784     | ﻿355132	   
------------------------------------------------------------------

I also tried different users with rooms 8 and found the results of users 20/40/60 are very close.

With group scheduing, mostly, 2.6.26 is better than 2.6.27-rc4.
Without group scheduling, the result depends on specific machine.

I also rerun hackbench with group 10/16/32, and found the result difference between 2 kernels
varies among group 10/16/32.

What's the most reasonable group/rooms we should use to test?

In the other hand, tbench(start CPU_NUM*2 ﻿clients) has about 4~5% regression with 2.6.27-rc kernels.
With 30second schedstat data during the testing, I found there is almost no wake remote and wake
affine with 2.6.26, but there are many either wake_affine or wake remote with 2.6.27-rc.

-yanmin


