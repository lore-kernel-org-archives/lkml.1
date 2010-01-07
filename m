Return-Path: <linux-kernel-owner+w=401wt.eu-S1752206Ab0AGLGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab0AGLGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 06:06:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182Ab0AGLGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 06:06:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178Ab0AGLGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 06:06:08 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100107044007.GA22863@Krystal>
References: <20100107044007.GA22863@Krystal>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory barrier
Date: Thu, 07 Jan 2010 11:04:57 +0000
Message-ID: <15142.1262862297@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> The current implementation simply executes a memory barrier in an IPI
> handler on each active cpu. Going through the hassle of taking run queue
> locks and checking if the thread running on each online CPU belongs to
> the current thread seems more heavyweight than the cost of the IPI
> itself (not measured though).

There's another way to do this:

 (1) For each threads you want to execute a memory barrier, mark in its
     task_struct that you want it to do a memory barrier and set
     TIF_NOTIFY_RESUME.

 (2) Interrupt all CPUs.  The interrupt handler doesn't have to do anything.

 (3) When any of the threads marked in (1) gain CPU time, do_notify_resume()
     will be executed, and the do-memory-barrier flag can be tested and if it
     was set, the flag can be cleared and a memory barrier can be
     interpolated.

The current thread will also pass through stage (3) on its way out, if it's
marked in stage (1).

David
