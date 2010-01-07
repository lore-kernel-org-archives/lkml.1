Return-Path: <linux-kernel-owner+w=401wt.eu-S1753134Ab0AGPP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab0AGPP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 10:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099Ab0AGPP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 10:15:27 -0500
Received: from tomts10.bellnexxia.net ([209.226.175.54]:60101 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753059Ab0AGPP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 10:15:26 -0500
Date: Thu, 7 Jan 2010 10:15:23 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100107151523.GD14259@Krystal>
References: <20100107044007.GA22863@Krystal> <15142.1262862297@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <15142.1262862297@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 10:12:36 up 21 days, 23:31,  6 users,  load average: 0.81, 0.37,
	0.21
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Howells (dhowells@redhat.com) wrote:
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > The current implementation simply executes a memory barrier in an IPI
> > handler on each active cpu. Going through the hassle of taking run queue
> > locks and checking if the thread running on each online CPU belongs to
> > the current thread seems more heavyweight than the cost of the IPI
> > itself (not measured though).
> 
> There's another way to do this:
> 
>  (1) For each threads you want to execute a memory barrier, mark in its
>      task_struct that you want it to do a memory barrier and set
>      TIF_NOTIFY_RESUME.
> 
>  (2) Interrupt all CPUs.  The interrupt handler doesn't have to do anything.

AFAIK, the smp_mb() is not very costly compared to the IPI. So as your
proposal implies sending an IPI to the remote threads anyway, I don't
see how adding thread flags and extra tests in return to userland paths
will help us... it will just add extra tests and branches doing exactly
nothing.

Or am I missing your point entirely ?

Thanks,

Mathieu

> 
>  (3) When any of the threads marked in (1) gain CPU time, do_notify_resume()
>      will be executed, and the do-memory-barrier flag can be tested and if it
>      was set, the flag can be cleared and a memory barrier can be
>      interpolated.
> 
> The current thread will also pass through stage (3) on its way out, if it's
> marked in stage (1).
> 
> David

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
