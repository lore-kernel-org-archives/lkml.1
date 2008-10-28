Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbYJ1Rfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbYJ1Rfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 13:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbYJ1Rfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 13:35:33 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:51482 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbYJ1Rfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 13:35:33 -0400
Date: Tue, 28 Oct 2008 10:35:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, schamp@sgi.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, penberg@cs.helsinki.fi,
       andi@firstfloor.org, tglx@linutronix.de
Subject: Re: [PATCH, RFC] v7 scalable classic RCU implementation
Message-ID: <20081028173508.GI6779@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081015152637.GA6739@linux.vnet.ibm.com> <48FF73C7.90709@colorfullife.com> <20081022210254.GE6766@linux.vnet.ibm.com> <48FF9A0E.90205@colorfullife.com> <20081027164529.GC6783@linux.vnet.ibm.com> <49061AF0.8070106@colorfullife.com> <20081027235201.GK6783@linux.vnet.ibm.com> <4906A370.3000502@colorfullife.com> <20081028151738.GB6779@linux.vnet.ibm.com> <49074A02.4080703@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49074A02.4080703@colorfullife.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 06:21:06PM +0100, Manfred Spraul wrote:
> Paul E. McKenney wrote:
>>> How do you intend to handle nohz cpus?
>>
>> In which variant of RCU?  My current thought is to apply the rcutree.c
>> version to rcupreempt.c.  If rcuclassic.c can be dropped, my thought
>> would be to leave it alone -- it is unnecessarily awakening CPUs, but
>> this is a non-fatal issue.
>>   
> For rcuclassic.

If we were to keep rcuclassic for any length of time, I would modify
rcu_pending() and rcu_check_callbacks() to invoke force_quiescent_state()
if there was a longish (say 3-5 jiffies) delay in the RCU grace period.

> As far as  I can see, rcuclassic treats nohz cpus as always outside 
> rcu_read_lock():
> rcu_start_batch() contains
> >
> >                cpus_andnot(rcp->cpumask, cpu_online_map, nohz_cpu_mask);
> >
> As soon as all cpus from rcp->cpumask reported a grace period, the 
> callbacks are called.
> That a bug, therefore I would drop rcuclassic as soon as rcutree is merged.

Good point, I had forgotten that issue.  Making this modification would
cause the resulting rcuclassic to be just as suspect as is rcutree,
I suppose.

A strong argument for moving to rcutree.c quickly rather than slowly,
I must admit!

							Thanx, Paul
