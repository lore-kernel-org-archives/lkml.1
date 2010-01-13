Return-Path: <linux-kernel-owner+w=401wt.eu-S1756016Ab0AMQkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab0AMQkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 11:40:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755722Ab0AMQkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 11:40:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:57506 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645Ab0AMQkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 11:40:06 -0500
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier (v5)
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com
In-Reply-To: <20100113013757.GA29314@Krystal>
References: <20100113013757.GA29314@Krystal>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jan 2010 17:38:58 +0100
Message-ID: <1263400738.4244.242.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-12 at 20:37 -0500, Mathieu Desnoyers wrote:
> +       for_each_cpu(cpu, tmpmask) {
> +               spin_lock_irq(&cpu_rq(cpu)->lock);
> +               mm = cpu_curr(cpu)->mm;
> +               spin_unlock_irq(&cpu_rq(cpu)->lock);
> +               if (current->mm != mm)
> +                       cpumask_clear_cpu(cpu, tmpmask);
> +       } 

Why not:

  rcu_read_lock();
  if (current->mm != cpu_curr(cpu)->mm)
    cpumask_clear_cpu(cpu, tmpmask);
  rcu_read_unlock();

the RCU read lock ensures the task_struct obtained remains valid, and it
avoids taking the rq->lock.

