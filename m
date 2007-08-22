Return-Path: <linux-kernel-owner+w=401wt.eu-S1759132AbXHVADe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759132AbXHVADe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 20:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbXHVADZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 20:03:25 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:35314 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752914AbXHVADZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 20:03:25 -0400
Date: Tue, 21 Aug 2007 20:03:23 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
Message-ID: <20070822000323.GG29691@Krystal>
References: <20070820215413.GA28452@Krystal> <Pine.LNX.4.64.0708201506010.32213@schroedinger.engr.sgi.com> <20070821173849.GA8360@Krystal> <Pine.LNX.4.64.0708211404290.3082@schroedinger.engr.sgi.com> <20070821231216.GA29691@Krystal> <Pine.LNX.4.64.0708211614370.6062@schroedinger.engr.sgi.com> <20070821233938.GD29691@Krystal> <Pine.LNX.4.64.0708211640430.6225@schroedinger.engr.sgi.com> <20070821234702.GE29691@Krystal> <Pine.LNX.4.64.0708211649260.6886@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708211649260.6886@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:57:15 up 23 days, 16 min,  3 users,  load average: 0.81, 0.55, 0.42
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (clameter@sgi.com) wrote:
> On Tue, 21 Aug 2007, Mathieu Desnoyers wrote:
> 
> > Are you running a UP or SMP kernel ? If you run a UP kernel, the
> > cmpxchg_local and cmpxchg are identical.
> 
> UP.
> 
> > Oh, and if you run your tests at boot time, the alternatives code may
> > have removed the lock prefix, therefore making cmpxchg and cmpxchg_local
> > exactly the same.
> 
> Tests were run at boot time.
> 
> That still does not explain kmalloc not showing improvements.
> 

Hrm, weird.. because it should. Here are the numbers I posted
previously:


The measurements I get (in cycles):
             enable interrupts (STI)   disable interrupts (CLI)   local CMPXCHG
IA32 (P4)    112                        82                         26
x86_64 AMD64 125                       102                         19

So both AMD64 and IA32 should be improved.

So why those improvements are not shown in your test ? A few possible
causes:

- Do you have any CONFIG_DEBUG_* options activated ? smp_processor_id()
  may end up being more expensive in these cases.
- Rounding error.. you seem to round at 0.1ms, but I keep the values in
  cycles. The times that you get (1.1ms) seems strangely higher than
  mine, which are under 1000 cycles on a 3GHz system (less than 333ns).
  I guess there is both a ms - ns error there and/or not enough
  precision in your numbers.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
