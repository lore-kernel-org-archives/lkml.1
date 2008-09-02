Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbYIBGPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbYIBGPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 02:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbYIBGPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 02:15:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49558 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbYIBGPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 02:15:06 -0400
Date: Tue, 2 Sep 2008 08:18:06 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, mingo@elte.hu, akpm@linux-foundation.org,
       manfred@colorfullife.com, dipankar@in.ibm.com, josht@linux.vnet.ibm.com,
       schamp@sgi.com, niv@us.ibm.com, dvhltc@us.ibm.com, ego@in.ibm.com,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org
Subject: Re: [PATCH, RFC, tip/core/rcu] v3 scalable classic RCU implementation
Message-ID: <20080902061806.GJ18288@one.firstfloor.org>
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com> <87ej44xl2i.fsf@basil.nowhere.org> <20080902010544.GA6902@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080902010544.GA6902@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > It would be better if you hung rcu_irq_enter in the irq_enter() if 
> > statement that checks if the task was idle or not. This way it would
> > be zero overhead for interruptions of non busy CPUs, keeping 

Sorry that should have been "non idle CPUs" of course.

> > it out of many fast paths.
> > 
> > Haven't read everything, sorry.
> 
> So that I lose the #else above, and so that irq_enter() and irq_exit()
> look something like the following (with additional adjustments to suit)?

Yes looks good.

BTW I wonder if the compiler CSEs the idle_cpu() check properly.

> void irq_enter(void)
> {
> #ifdef CONFIG_NO_HZ
> 	int cpu = smp_processor_id();
> 	if (idle_cpu(cpu) && !in_interrupt())
> 		tick_nohz_stop_idle(cpu);
> #endif
> 	__irq_enter();
> #ifdef CONFIG_NO_HZ
> 	if (idle_cpu(cpu)) {
> 		rcu_irq_enter();
> 		tick_nohz_update_jiffies();
> 	}
> #endif


-Andi
