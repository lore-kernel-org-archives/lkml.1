Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbYGVI76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbYGVI76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 04:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbYGVI7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 04:59:50 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:1247 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbYGVI7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 04:59:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=I9GBPjJbV0pGrRbAae38LkRx3841X4DwlE1Q0LLTBndR/mqtBa3c/M1Uu5F/SpMXOa
         S3GcaWeEFt2svuYYY4V+nnWpRZUnlBJgmpgsDtVBdQJcpKy2hesHOYEARxk5B4HBnQsp
         egaNNJrV+X9ucxyyb46/ZnzJ2wFhiFYXpSl7c=
Date: Tue, 22 Jul 2008 17:59:38 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: +
	workqueue-proper-error-unwinding-in-cpu-hotplug-error-path.patch
	added to -mm tree
Message-ID: <20080722085938.GA5857@localhost.localdomain>
References: <200807220826.m6M8Q4I6018588@imap1.linux-foundation.org> <20080722084526.GA165@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080722084526.GA165@tv-sign.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 12:45:26PM +0400, Oleg Nesterov wrote:
> On 07/22, Andrew Morton wrote:
> > 
> > From: Akinobu Mita <akinobu.mita@gmail.com>
> > 
> > Add proper error unwinding in error path in CPU_UP_PREPARE notifier.
> 
> Could you clarify?

Sure.

> > --- a/kernel/workqueue.c~workqueue-proper-error-unwinding-in-cpu-hotplug-error-path
> > +++ a/kernel/workqueue.c
> > @@ -928,6 +928,15 @@ static int __devinit workqueue_cpu_callb
> >  				break;
> >  			printk(KERN_ERR "workqueue [%s] for %i failed\n",
> >  				wq->name, cpu);
> > +
> > +			list_for_each_entry_continue_reverse(wq, &workqueues,
> > +							list) {
> > +				cwq = per_cpu_ptr(wq->cpu_wq, cpu);
> > +				start_workqueue_thread(cwq, -1);
> > +				cleanup_workqueue_thread(cwq);
> > +			}
> > +			cpu_clear(cpu, cpu_populated_map);
> > +
> >  			return NOTIFY_BAD;
> 
> If CPU_UP_PREPARE fails, _cpu_up() sends CPU_UP_CANCELED, and afaics
> workqueue_cpu_callback() correctly cleanups cwq->thread's.

_cpu_up() does not send CPU_UP_CANCELED to the callback which has
returned NOTIFY_BAD.

The behavior was changed by this commit:

commit a0d8cdb652d35af9319a9e0fb7134de2a276c636
Author: Akinobu Mita <akinobu.mita@gmail.com>
Date:   Thu Oct 18 03:05:12 2007 -0700

    cpu hotplug: cpu: deliver CPU_UP_CANCELED only to NOTIFY_OKed callbacks with CPU_UP_PREPARE
    
    The functions in a CPU notifier chain is called with CPU_UP_PREPARE event
    before making the CPU online.  If one of the callback returns NOTIFY_BAD, it
    stops to deliver CPU_UP_PREPARE event, and CPU online operation is canceled.
    Then CPU_UP_CANCELED event is delivered to the functions in a CPU notifier
    chain again.
    
    This CPU_UP_CANCELED event is delivered to the functions which have been
    called with CPU_UP_PREPARE, not delivered to the functions which haven't been
    called with CPU_UP_PREPARE.
    
    The problem that makes existing cpu hotplug error handlings complex is that
    the CPU_UP_CANCELED event is delivered to the function that has returned
    NOTIFY_BAD, too.
    
    Usually we don't expect to call destructor function against the object that
    has failed to initialize.  It is like:
    
    	err = register_something();
    	if (err) {
    		unregister_something();
    		return err;
    	}
    
    So it is natural to deliver CPU_UP_CANCELED event only to the functions that
    have returned NOTIFY_OK with CPU_UP_PREPARE event and not to call the function
    that have returned NOTIFY_BAD.  This is what this patch is doing.
    
    Otherwise, every cpu hotplug notifiler has to track whether notifiler event is
    failed or not for each cpu.  (drivers/base/topology.c is doing this with
    topology_dev_map)
    
    Similary this patch makes same thing with CPU_DOWN_PREPARE and CPU_DOWN_FAILED
    evnets.
    
    Acked-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
    Cc: Gautham R Shenoy <ego@in.ibm.com>
    Cc: Oleg Nesterov <oleg@tv-sign.ru>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 38033db..a21f71a 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -150,6 +150,7 @@ static int _cpu_down(unsigned int cpu, int tasks_frozen)
 	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
 					hcpu, -1, &nr_calls);
 	if (err == NOTIFY_BAD) {
+		nr_calls--;
 		__raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED | mod,
 					  hcpu, nr_calls, NULL);
 		printk("%s: attempt to take down CPU %u failed\n",
@@ -233,6 +234,7 @@ static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
 	ret = __raw_notifier_call_chain(&cpu_chain, CPU_UP_PREPARE | mod, hcpu,
 							-1, &nr_calls);
 	if (ret == NOTIFY_BAD) {
+		nr_calls--;
 		printk("%s: attempt to bring up CPU %u failed\n",
 				__FUNCTION__, cpu);
 		ret = -EINVAL;
