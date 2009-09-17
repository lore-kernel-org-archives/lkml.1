Return-Path: <linux-kernel-owner+w=401wt.eu-S1759715AbZIQDBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759715AbZIQDBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 23:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758068AbZIQDBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 23:01:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62731 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754503AbZIQDBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 23:01:22 -0400
Message-ID: <4AB1A652.1010000@cn.fujitsu.com>
Date: Thu, 17 Sep 2009 11:00:34 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: + generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd.patch
 added to -mm tree
References: <200907310030.n6V0Uqgw001644@imap1.linux-foundation.org>	 <1252616988.7205.102.camel@laptop>  <4AAA0001.2060703@cn.fujitsu.com>	 <1252696132.3756.21.camel@sbs-t61.sc.intel.com>	 <4AADEF2F.5080504@cn.fujitsu.com>	 <1252973802.2899.88.camel@sbs-t61.sc.intel.com>	 <4AAEF5DC.4070308@cn.fujitsu.com> <1253067602.2667.13.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1253067602.2667.13.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Suresh Siddha wrote:
> On Mon, 2009-09-14 at 19:03 -0700, Xiao Guangrong wrote:
>>> Your current fix is not clean and not complete in my opinion (as calling
>>> interrupt handlers manually and not doing the callbacks etc might cause
>>> other side affects). Thanks.
>> It is not the last version and doing the callbacks in another patch,
>> see below URL please:
>> http://marc.info/?l=linux-mm-commits&m=124900028228350&w=2
> 
> I am referring to this latest patch only. We are calling the interrupt
> handler manually and not doing the callbacks in that context. In future,
> we might see other side affects if we miss some of these smp ipi's.
> 

um, maybe you are right.

> Clean solution is to ensure that there are no unhandled smp call
> function handlers and then continue with the cpu offline.
> 

Yeah, I agree it.

>> Another problem is that all CPU must call quiesce_smp_call_functions() here, but only
>> dying CPU need do it.
> 
> In stop_machine() all cpu's will wait for each other to come to the
> rendezvous point. so this is completely ok (infact this is what is
> happening if some cpu is already handling some ipi's etc. I am just
> making it more explicit).

Waiting all cpu handle its IPI interruption in stop_machine() path will make 
it slower, I'm not sure it's OK.

> 
>>>  				local_irq_disable();
>>>  				hard_irq_disable();
>> It will cause another race, if CPU A send a IPI interruption after CPU B call
>> quiesce_smp_call_functions() and disable IRQ, it will case the same problem.
>> (in this time, CPU B is enter stop machine, but CPU A is not)
> 
> No. By the time we call quiesce_ipis(), all the cpu's are already in
> stop machine FIFO threads and no one else can send IPI (i.e, all the
> cpus have moved past the STOPMACHINE_PREPARE state). This is when we are
> calling the quiesce_smp_call_functions().
> 

Sorry for let you misunderstand, It's not clear explanation here.

The preempt is enabled when CPU enter STOPMACHINE_DISABLE_IRQ state, so
other task will preempt it and send IPI interruption.
But, Andrew point out my mistake that the stop machine workqueue thread
is the highest priority and with "SCHED_FIFO" scheduler, so It not happen,
please ignore this comment.

How about manual check/handle pending IPI interruption in the CPU context?
like this:

---
 include/linux/smp.h |    3 +++
 kernel/cpu.c        |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 9e3d8af..a9ea518 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -95,6 +95,9 @@ void ipi_call_lock(void);
 void ipi_call_unlock(void);
 void ipi_call_lock_irq(void);
 void ipi_call_unlock_irq(void);
+#else
+static inline void generic_smp_call_function_single_interrupt(void) { }
+static inline void generic_smp_call_function_interrupt(void) { }
 #endif
 
 /*
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 6ba0f1e..4ba7f92 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -173,6 +173,9 @@ static int __ref take_cpu_down(void *_param)
 	struct take_cpu_down_param *param = _param;
 	int err;
 
+	generic_smp_call_function_interrupt();
+	generic_smp_call_function_single_interrupt();
+
 	/* Ensure this CPU doesn't handle any more interrupts. */
 	err = __cpu_disable();
 	if (err < 0)
-- 
1.6.1.2

Thanks,
Xiao
