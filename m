Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbYGVJNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbYGVJNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 05:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbYGVJM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 05:12:58 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:58094 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbYGVJM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 05:12:57 -0400
Date: Tue, 22 Jul 2008 13:16:36 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: + workqueue-proper-error-unwinding-in-cpu-hotplug-error-path.patch added to -mm tree
Message-ID: <20080722091636.GA241@tv-sign.ru>
References: <200807220826.m6M8Q4I6018588@imap1.linux-foundation.org> <20080722084526.GA165@tv-sign.ru> <20080722085938.GA5857@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080722085938.GA5857@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22, Akinobu Mita wrote:
>
> On Tue, Jul 22, 2008 at 12:45:26PM +0400, Oleg Nesterov wrote:
> > > 
> > > From: Akinobu Mita <akinobu.mita@gmail.com>
> > > 
> > > --- a/kernel/workqueue.c~workqueue-proper-error-unwinding-in-cpu-hotplug-error-path
> > > +++ a/kernel/workqueue.c
> > > @@ -928,6 +928,15 @@ static int __devinit workqueue_cpu_callb
> > >  				break;
> > >  			printk(KERN_ERR "workqueue [%s] for %i failed\n",
> > >  				wq->name, cpu);
> > > +
> > > +			list_for_each_entry_continue_reverse(wq, &workqueues,
> > > +							list) {
> > > +				cwq = per_cpu_ptr(wq->cpu_wq, cpu);
> > > +				start_workqueue_thread(cwq, -1);
> > > +				cleanup_workqueue_thread(cwq);
> > > +			}
> > > +			cpu_clear(cpu, cpu_populated_map);
> > > +
> > >  			return NOTIFY_BAD;
> > 
> > If CPU_UP_PREPARE fails, _cpu_up() sends CPU_UP_CANCELED, and afaics
> > workqueue_cpu_callback() correctly cleanups cwq->thread's.
> 
> _cpu_up() does not send CPU_UP_CANCELED to the callback which has
> returned NOTIFY_BAD.
>
> The behavior was changed by this commit:
> 
> commit a0d8cdb652d35af9319a9e0fb7134de2a276c636
> Author: Akinobu Mita <akinobu.mita@gmail.com>
> Date:   Thu Oct 18 03:05:12 2007 -0700
>
>     cpu hotplug: cpu: deliver CPU_UP_CANCELED only to NOTIFY_OKed callbacks with CPU_UP_PREPARE

Thanks Akinobu!

Can't we simplify the fix? I don't like the fact that the CPU_UP_CANCELED
logic is duplicated.

What do you think about the patch below?

Oleg.

--- 26-rc2/kernel/workqueue.c~WQ_CPU_UP_PREPARE	2008-07-12 19:40:57.000000000 +0400
+++ 26-rc2/kernel/workqueue.c	2008-07-22 13:15:16.000000000 +0400
@@ -911,6 +911,7 @@ static int __devinit workqueue_cpu_callb
 	unsigned int cpu = (unsigned long)hcpu;
 	struct cpu_workqueue_struct *cwq;
 	struct workqueue_struct *wq;
+	int ret = NOTIFY_OK;
 
 	action &= ~CPU_TASKS_FROZEN;
 
@@ -919,6 +920,7 @@ static int __devinit workqueue_cpu_callb
 		cpu_set(cpu, cpu_populated_map);
 	}
 
+cancel:
 	list_for_each_entry(wq, &workqueues, list) {
 		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
 
@@ -928,7 +930,9 @@ static int __devinit workqueue_cpu_callb
 				break;
 			printk(KERN_ERR "workqueue [%s] for %i failed\n",
 				wq->name, cpu);
-			return NOTIFY_BAD;
+			action = CPU_UP_CANCELED;
+			ret = NOTIFY_BAD;
+			goto cancel;
 
 		case CPU_ONLINE:
 			start_workqueue_thread(cwq, cpu);
@@ -948,7 +952,7 @@ static int __devinit workqueue_cpu_callb
 		cpu_clear(cpu, cpu_populated_map);
 	}
 
-	return NOTIFY_OK;
+	return ret;
 }
 
 void __init init_workqueues(void)

