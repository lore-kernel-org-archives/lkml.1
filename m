Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907Ab0AMCGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab0AMCGN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 21:06:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500Ab0AMCGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 21:06:13 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:59043 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751249Ab0AMCGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 21:06:12 -0500
Date: Tue, 12 Jan 2010 21:06:10 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, rostedt@goodmis.org,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com
Subject: Re: [RFC PATCH 2/8] jump label v4 - x86: Introduce generic jump
	patching without stop_machine
Message-ID: <20100113020610.GB29314@Krystal>
References: <cover.1263247113.git.jbaron@redhat.com> <a4aa5bbcf5e62eaa5dd156d318a370236f28be09.1263247114.git.jbaron@redhat.com> <4B4D02B8.5020801@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4B4D02B8.5020801@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 20:39:40 up 27 days,  9:58,  4 users,  load average: 0.20, 0.22,
	0.15
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> On 01/12/2010 08:26 AM, Jason Baron wrote:
> > Add text_poke_fixup() which takes a fixup address to where a processor
> > jumps if it hits the modifying address while code modifying.
> > text_poke_fixup() does following steps for this purpose.
> > 
> >  1. Setup int3 handler for fixup.
> >  2. Put a breakpoint (int3) on the first byte of modifying region,
> >     and synchronize code on all CPUs.
> >  3. Modify other bytes of modifying region, and synchronize code on all CPUs.
> >  4. Modify the first byte of modifying region, and synchronize code
> >     on all CPUs.
> >  5. Clear int3 handler.
> > 
> 
> We (Intel OTC) have been able to get an *unofficial* answer as to the
> validity of this procedure; specifically as it applies to Intel hardware
> (obviously).  We are working on getting an officially approved answer,
> but as far as we currently know, the procedure as outlined above should
> work on all Intel hardware.  In fact, we believe the synchronization in
> step 3 is in fact unnecessary (as the synchronization in step 4 provides
> sufficient guard.)

Hi Peter,

This is great news! Thanks to Intel OTC and yourself for looking into
this. In the immediate values patches, I am doing the synchronization at
the end of step (3) to ensure that all remote CPUs issue read memory
barriers, so the stores to the instruction are done in this order:

spin lock
store int3 to 1st byte
smp_wmb()
sync all cores
store new instruction in all but 1st byte
smp_wmb()
issue smp_rmb() on all cores (a sync all cores has this effect)
store new instruction to 1st byte
send IPI to all cores (or call synchronize_sched()) to wait for all
  breakpoint handlers to complete.
spin unlock

So the question is: are these wmb/rmb pairs actually needed ?  As the
instruction fetch is not performed by instructions per se, I doubt a
rmb() will have any effect on them. I always prefer to stay on the safe
side, but it wouldn't hurt to know.

> 
> In fact, if a suitable int3 handler is left permanently in place then
> step 5 is unnecessary as well.  This would slow down other uses of int3
> slightly, but might be a worthwhile tradeoff.
> 
> Such a permanent int3 handler would need to keep track of two
> potentially-spurious breakpoints: the current and the previous.  The
> reason for needing two is that one could get a #BP from either the
> current or the previous modification site between the insertion of int3
> and the synchronization in step 2.  This, of course, assumes that the
> actual code poking is forcibly single-threaded (running under a spinlock
> or other mutex) -- if modifications are allowed to run in parallel you
> need to consider all possible current or stale #BP sites.

Hrm. Assuming we have a spinlock protecting all this, given that we
synchronize all cores at step (4) _after_ removing the breakpoint, and
given that the breakpoint handler is an interrupt gate (thus executes
with interrupts off), I am inclined to think that sending the IPIs at
the end of step (4) (and waiting for them to complete) should be enough
to ensure that all in-flight breakpoint handlers for this site have
completed their execution. This would mean that we only have to keep
track of a single site at a time. Or am I missing something ?

Thanks,

Mathieu

> 
> 	-hpa

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
