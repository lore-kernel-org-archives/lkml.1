Return-Path: <linux-kernel-owner+w=401wt.eu-S1756768AbXFUN4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768AbXFUN4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 09:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbXFUNzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 09:55:55 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:55695 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751319AbXFUNzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 09:55:54 -0400
Date: Thu, 21 Jun 2007 09:55:51 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Adrian Bunk <bunk@stusta.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mbligh@google.com
Subject: Re: [patch 1/9] Conditional Calls - Architecture Independent Code
Message-ID: <20070621135551.GA21601@Krystal>
References: <20070530140025.917261793@polymtl.ca> <20070530140227.070136408@polymtl.ca> <20070604190102.GY5500@stusta.de> <20070613155724.GA8703@Krystal> <20070613215104.GK3588@stusta.de> <20070614160241.GA21119@Krystal> <20070614210643.GW3588@stusta.de> <20070620215927.GA25495@Krystal> <20070621130037.GM12950@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070621130037.GM12950@stusta.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:24:48 up 23 days, 22:03,  3 users,  load average: 1.26, 0.84, 0.49
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Adrian Bunk (bunk@stusta.de) wrote:
> On Wed, Jun 20, 2007 at 05:59:27PM -0400, Mathieu Desnoyers wrote:
> > * Adrian Bunk (bunk@stusta.de) wrote:
> > > On Thu, Jun 14, 2007 at 12:02:42PM -0400, Mathieu Desnoyers wrote:
> > > >...
> > > > Well, we must take into account where these markers are added and how
> > > > often the marked code is run. Since I mark very highly used code paths
> > > > (interrupt handlers, page faults, lockdep code) and also plan to mark
> > > > other code paths like the VM subsystem, adding cycles to these code
> > > > paths seems like a no-go solution for standard distribution kernels.
> > > >...
> > > > People can get really picky when they have to decide wether or not they
> > > > compile-in a profiling or tracing infrastructure in a distribution
> > > > kernel.  If the impact is detectable when they are not doing any tracing
> > > > nor profiling, their reflex will be to compile it out so they can have
> > > > the "maximum performance". This is why I am going through the trouble of
> > > > making the markers impact as small as possible.
> > > 
> > > Now that we finally hear what this code is required for, can we discuss 
> > > on this basis whether this is wanted and required?
> > > 
> > > Including the question which abuse possibilities such an infrastructure 
> > > offers, and whether this is wanted in distribution kernels.
> > 
> > Hi Adrian,
> 
> Hi Mathieu,
> 
> > The purpose of this infrastructure has never been a secret; it is a
> > piece taken from the Linux Kernel Markers. I proposed the first
> > implementation of markers in December 2006.
> > 
> > Please use the following link as a starting point to the thorough
> > discussion that has already been held on this matter.
> > 
> > First, a huge discussion thread back in November 2006, where the need
> > for a marker infrastructure has been recognized:
> > http://lwn.net/Articles/200059/
> > 
> > A good summary of my recent previous post on kerneltrap:
> > http://kerneltrap.org/node/8186
> > 
> > If you have new specific concerns to bring forward, I will be glad to
> > discuss them with you.
> 
> sorry if I was a bit harsh, but at least for me it wasn't clear that the 
> main (and perhaps only) reasonable use case for your conditional calls 
> was to get markers enabled in distribution kernels.
> 
> Please correct me, but my understanding is:
> - conditional calls aim at getting markers enabled in distribution
>   kernels

Hi Adrian,

Putting markers in a distribution kernel would be of great benefit to
many users, this is true. The issue is not whether distros use it or
not, but whether we can allow users, poweruser to senior kernel
developer, even if they compile their own kernel, to turn on a tracing
infrastructure on-the-fly to study a problem in their system (problem
coming either from user-space, kernel, hypervisor...).

The key aspect here is to provide instrumentation of every privilege
level.

> - markers are a valuable debugging tool

If ptrace() is also called a valuable debugging tool, then yes. Does it
make it less suitable for distributions ? The main goal here is not to
be used as a debugging tool by kernel developers, this is just a nice
side-effect.  The main purpose of this tracer is to give an overall view
of the system activity to help _userspace_ developers determine what is
going wrong with the complex interactions between their multithreaded
application, X server and network sockets running 8 CPUs and using a
distributed FS...  the more interaction we have between (many) processes
and the OS, the harder it becomes to study that with the traditional
ptrace() approach. When looking for the cause of a slowdown, people
often just does not know even _which_ process is guilty for the problem,
or if they should blame the kernel.


> - you don't need markers during normal operation

False. Considering that application development is part of what I call
"normal operation", these tools are needed not just as part of a
particular kernel debug option.

Moreover, we have some stories ready (see upcoming Martin Bligh's
presentation/paper next week at OLS2007 "Linux Kernel Debugging on
Google-Sized Clusters") showing that some nasty problems a reproducible
so rarely, and only when monitored on such a great number of machines,
that they become nearly impossible to track without a preexisting
tracing infrastructure deployed on production machines.


> - markers allow normal modules doing things they shouldn't be doing,
>   implying that markers should _not_ be enabled in normal distribution
>   kernels
> 

Not exactly.

1 - Markers are flexible enough to permit defining a custom probe that
can be loaded dynamically as a module, but the "standard" probe will be
coming in some of my awaiting patches : it parses the format string to
serialize the information into trace buffers. Therefore, the "standard"
marker usage won't require people to write their own module; just to
enable which marker they want.

2 - kprobes is an example of an infrastructure enabled in distribution
kernels (Redhat at least) that permits calling modules from arbitrary
breakpoints. Markers somewhat limits this by specifying where the
markers are, therefore making the mechanism faster, offers better
reentrancy characteristics and is better suited to a kernel tree in
constant evolution (markers follow the kernel code and are not
maintained as a separate mapping to fixed kernel symbols/addresses).

3 - Providing a probe implies using a function that is exported as
*_GPL(). What exactly is such a module not supposed to be doing? Are
your expressing some kind of twisted pseudo-security concern? Once your
are executing code in kernel space with write access in memory, you can
do pretty much anything. I think that the right way to do it is to
provide the flexibility required to help users do what they need to do
(along with guide lines to help them not shoot themselves in the foot),
but not _restrict_ what is exported to GPL modules just because one
_can_ shoot himself in the foot. Since when are we supposed to provide
protection against modules? Should they run in user-space?

Redards,

Mathieu


> > Regards,
> > 
> > Mathieu
> 
> cu
> Adrian
> 
> -- 
> 
>        "Is there not promise of rain?" Ling Tan asked suddenly out
>         of the darkness. There had been need of rain for many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck - Dragon Seed
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
