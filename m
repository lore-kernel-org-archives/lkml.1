Return-Path: <linux-kernel-owner+w=401wt.eu-S1750833AbXDKRvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750833AbXDKRvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 13:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbXDKRvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 13:51:14 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:54949 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750833AbXDKRvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 13:51:13 -0400
Date: Wed, 11 Apr 2007 13:51:11 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] markers-linker-generic
Message-ID: <20070411175110.GA30879@Krystal>
References: <20070410223658.GC7092@Krystal> <20070411074414.GC3752@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070411074414.GC3752@flint.arm.linux.org.uk>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 12:57:01 up 68 days,  7:04,  4 users,  load average: 1.29, 1.42, 1.42
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King (rmk+lkml@arm.linux.org.uk) wrote:
> On Tue, Apr 10, 2007 at 06:36:58PM -0400, Mathieu Desnoyers wrote:
> > Defines the linker marcro EXTRA_RWDATA for marker data section. It
> > puts the marker data in a separate section that will not pollute the
> > normal .data section, which minimize the cache impact. Markers need such
> > a special section because they define a lot of spreaded and small data
> > structures at multiple sites.
> > 
> > This patch also creates the __markers_strings section (ro marker
> > strings) and makes sure the __markers section is aligned by putting it
> > before the __ksymtab_strings (not after).
> 
> What's this marker stuff about?
> 

Hi Russel,

Here is an overview :

This marker infrastructure is a hook-callback mechanism. It is 
meant to have an impact as low as possible on the system performances
when no callback (probe) is connected so markers (hooks) can be
compiled into a production kernel without noticeable slowdown.

The rationale behind this mechanism the following :
1 - It makes sense to have instrumentation (for tracing, profiling)
    within the kernel source tree so that it can follow its evolution.
    Other options, such as kprobes, imply maintaining an external set of
    instrumentation that must be adapted to each kernel version.
    Although it may make sense for distributions, it is not well suited
    for kernel developers, since they rarely work on a major
    distribution image.
2 - kprobes, although being a very good attempt at providing a dynamic
    hooking mechanism that has no impact when disabled, suffers from
    important limitations :
  a - It cannot access local variables of a function at a particular
      point within its body that will be consistent thorough the kernel
      versions without involving a lot of recurrent hair-pulling.
  b - Kprobes is slow, since it involves going though a trap each time
      a probe site is executed. Even though the djprobes project made a
      good effort to make things faster, it cannot currently instrument
      fully-preemptible kernels and does not solve (1), (2a) and (2c).
  c - On the reentrancy side, going though a trap (thus playing with
      interrupt enable/disable) and taking spinlocks are not suited to
      some code paths, i.e. :
      kernel/lockdep.c, printk (within the lockdep_on()/lockdep_off()).
      It must be understood that some code paths interesting for
      instrumentation often present a particular reentrancy challenge.

Some more details :

The probe callback connection to its markers is done dynamically. A
predicted branch is used to skip the hook stack setup and function call
when the marker is "disabled" (no probe is connected). Further
optimizations can be implemented for each architecture to make this
branch faster.

Instrumentation of a subsystem becomes therefore a straightforward task.
One has to add instrumentation within the key locations of the kernel
code in the following form :

MARK(subsystem_event, "%d %p", myint, myptr);

I will be glad to discuss more specific questions that may arise about
the markers.

Regards,

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
