Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298AbZIVGxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbZIVGxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 02:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755205AbZIVGxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 02:53:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63486 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754604AbZIVGxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 02:53:38 -0400
Message-ID: <4AB8743F.5080309@cn.fujitsu.com>
Date: Tue, 22 Sep 2009 14:52:47 +0800
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
References: <200907310030.n6V0Uqgw001644@imap1.linux-foundation.org>	 <1252616988.7205.102.camel@laptop>  <4AAA0001.2060703@cn.fujitsu.com>	 <1252696132.3756.21.camel@sbs-t61.sc.intel.com>	 <4AADEF2F.5080504@cn.fujitsu.com>	 <1252973802.2899.88.camel@sbs-t61.sc.intel.com>	 <4AAEF5DC.4070308@cn.fujitsu.com>	 <1253067602.2667.13.camel@sbs-t61.sc.intel.com>	 <4AB1A652.1010000@cn.fujitsu.com>	 <1253326599.3948.732.camel@sbs-t61.sc.intel.com>	 <4AB6EB1C.5090106@cn.fujitsu.com> <1253502682.2528.4.camel@sbs-t61>	 <4AB6FB62.3000605@cn.fujitsu.com> <1253597553.2519.8.camel@sbs-t61>
In-Reply-To: <1253597553.2519.8.camel@sbs-t61>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Suresh Siddha wrote:
> On Sun, 2009-09-20 at 21:04 -0700, Xiao Guangrong wrote:
>> Suresh Siddha wrote:
>>> I am referring to the missing csd_lock_wait() here that you had in the
>>> first version of your patch. Let's say, if cpu X is going offline, we
>>> need to ensure that the smp_call_function() initiated by cpu X (i.e.,
>>> smp_call_function IPI sent to some other cpu's from cpu X) got serviced
>>> before cpu X goes offline. We can't do csd_lock_wait() here, as that
>>> might deadlock (as all the other cpu's are already in stop machine with
>>> interrupts disabled).
>>>
>> It not happen because the preemption is disabled while send IPI request and
>> can't schedule to stop machine path, it also stop cpu down.
> 
> Xiao, I am getting confused. I am referring to case '1' mentioned by you
> here http://marc.info/?l=linux-kernel&m=125265516529139&w=2
> 

Ah, your meaning is that we can't do csd_lock_wait() in the CPU_DEAD
notification path in my first version patch? like below:

+static int
+hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
+{
	...
+
+#ifdef CONFIG_HOTPLUG_CPU
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
+
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		local_irq_save(flags);
+		__generic_smp_call_function_interrupt(cpu, 0);
+		__generic_smp_call_function_single_interrupt(cpu, 0);
+		local_irq_restore(flags);
+
	/* Do you mean we can't do csd_lock_wait() here??? */
+		csd_lock_wait(&cfd->csd);
+		free_cpumask_var(cfd->cpumask);
+		break;
+#endif
+	};
+
+	return NOTIFY_OK;
+}

The CPU_DEAD notification is not sent in stop machine path, you can
see _cpu_down() function in kernel/cpu.c

Suresh, If I misunderstand your words again, could your elaborate it?

My first version patch is not clean and not complete that you point out in
previous mail:
" I am referring to this latest patch only. We are calling the interrupt
  handler manually and not doing the callbacks in that context. In future,
  we might see other side affects if we miss some of these smp ipi's."
  
How about the second patch?

Thanks,
Xiao
