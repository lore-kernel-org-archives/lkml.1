Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbZIPCUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbZIPCUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 22:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbZIPCUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 22:20:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:40615 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbZIPCUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 22:20:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,394,1249282800"; 
   d="scan'208";a="188094996"
Subject: Re: +
 generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd.patch
 added to -mm tree
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AAEF5DC.4070308@cn.fujitsu.com>
References: <200907310030.n6V0Uqgw001644@imap1.linux-foundation.org>
	 <1252616988.7205.102.camel@laptop>  <4AAA0001.2060703@cn.fujitsu.com>
	 <1252696132.3756.21.camel@sbs-t61.sc.intel.com>
	 <4AADEF2F.5080504@cn.fujitsu.com>
	 <1252973802.2899.88.camel@sbs-t61.sc.intel.com>
	 <4AAEF5DC.4070308@cn.fujitsu.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 15 Sep 2009 19:20:02 -0700
Message-Id: <1253067602.2667.13.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-14 at 19:03 -0700, Xiao Guangrong wrote:
> > Your current fix is not clean and not complete in my opinion (as calling
> > interrupt handlers manually and not doing the callbacks etc might cause
> > other side affects). Thanks.
> 
> It is not the last version and doing the callbacks in another patch,
> see below URL please:
> http://marc.info/?l=linux-mm-commits&m=124900028228350&w=2

I am referring to this latest patch only. We are calling the interrupt
handler manually and not doing the callbacks in that context. In future,
we might see other side affects if we miss some of these smp ipi's.

Clean solution is to ensure that there are no unhandled smp call
function handlers and then continue with the cpu offline.

> Another problem is that all CPU must call quiesce_smp_call_functions() here, but only
> dying CPU need do it.

In stop_machine() all cpu's will wait for each other to come to the
rendezvous point. so this is completely ok (infact this is what is
happening if some cpu is already handling some ipi's etc. I am just
making it more explicit).

> 
> >  				local_irq_disable();
> >  				hard_irq_disable();
> 
> It will cause another race, if CPU A send a IPI interruption after CPU B call
> quiesce_smp_call_functions() and disable IRQ, it will case the same problem.
> (in this time, CPU B is enter stop machine, but CPU A is not)

No. By the time we call quiesce_ipis(), all the cpu's are already in
stop machine FIFO threads and no one else can send IPI (i.e, all the
cpus have moved past the STOPMACHINE_PREPARE state). This is when we are
calling the quiesce_smp_call_functions().

thanks,
suresh

