Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbYDJUCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbYDJUCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 16:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756922AbYDJUCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 16:02:03 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:35489 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756847AbYDJUCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 16:02:00 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiIGABcP/kdMQWoK/2dsb2JhbACBXaol
Date: Thu, 10 Apr 2008 16:01:53 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Jason Baron <jbaron@redhat.com>,
       Adrian Bunk <bunk@stusta.de>, Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, akpm@osdl.org
Subject: Re: [patch 11/17] Implement immediate update via stop_machine_run
Message-ID: <20080410200153.GB22894@Krystal>
References: <20080409150829.855195878@polymtl.ca> <20080409152050.389300996@polymtl.ca> <20080410164159.2327.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080410164159.2327.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:56:46 up 41 days, 16:07,  6 users,  load average: 0.28, 0.38,
	0.48
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro (kosaki.motohiro@jp.fujitsu.com) wrote:
> Hi
> 
> > -Updating immediate values, cannot rely on smp_call_function() b/c synchronizing
> >  cpus using IPIs leads to deadlocks. Process A held a read lock on 
> >  tasklist_lock, then process B called apply_imv_update(). Process A received the 
> >  IPI and begins executing ipi_busy_loop(). Then process C takes a write lock 
> >  irq on the task list lock, before receiving the IPI. Thus, process A holds up 
> >  process C, and C can't get an IPI b/c interrupts are disabled. Solve this 
> >  problem by using a new 'ALL_CPUS' parameter to stop_machine_run(). Which 
> >  runs a function on all cpus after they are busy looping and have disabled 
> >  irqs. Since this is done in a new process context, we don't have to worry 
> >  about interrupted spin_locks. Also, less lines of code. Has survived 24 hours+
> >  of testing...
> 
> it seems this patch is must, Why do you separate patch [10/17] and [11/17]?
> this patch remove almost portion of [10/17].
> IMHO these patch merge into 1 patch is better.
> 

Hi Kosaki,

You are right, I will merge them and resend them in the following post.

> 
> > +static int stop_machine_imv_update(void *imv_ptr)
> > +{
> > +	struct __imv *imv = imv_ptr;
> > +
> > +	if (!wrote_text) {
> 
> it seems racy.
> Why don't need test_and_set?
> 
> I think your stop_machine_run(ALL_CPUS) call fn concurrency...
> 
The answer to this mistery is in include/linux/stop_machine.h modified
by add-all-cpus-option-to-stop-machine-run.patch :


 /**
  * stop_machine_run: freeze the machine on all CPUs and run this function
  * @fn: the function to run
  * @data: the data ptr for the @fn()
- * @cpu: the cpu to run @fn() on (or any, if @cpu == NR_CPUS.
+ * @cpu: if @cpu == n, run @fn() on cpu n
+ *       if @cpu == NR_CPUS, run @fn() on any cpu
+ *       if @cpu == ALL_CPUS, run @fn() first on the calling cpu, and then
+ *       concurrently on all the other cpus
  *
  * Description: This causes a thread to be scheduled on every other cpu,
  * each of which disables interrupts, and finally interrupts are disabled

Therefore, the first execution of the function is done before all other
executions.

Thanks,

Mathieu

> 
> > +		text_poke((void *)imv->imv, (void *)imv->var, imv->size);
> > +		wrote_text = 1;
> > +		smp_wmb(); /* make sure other cpus see that this has run */
> > +	} else
> > +		sync_core();
> > +
> > +	flush_icache_range(imv->imv, imv->imv + imv->size);
> > +
> > +	return 0;
> > +}
> > +
> 
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
