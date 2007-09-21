Return-Path: <linux-kernel-owner+w=401wt.eu-S1759624AbXIUNb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624AbXIUNb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759193AbXIUNbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:31:08 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:61428 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758877AbXIUNbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:31:05 -0400
Date: Fri, 21 Sep 2007 09:31:03 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 7/8] Immediate Values - Documentation
Message-ID: <20070921133103.GA14844@Krystal>
References: <20070827155910.336723755@polymtl.ca> <20070827160214.252315593@polymtl.ca> <200709201146.57334.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200709201146.57334.vda.linux@googlemail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:22:14 up 53 days, 13:41,  5 users,  load average: 0.41, 0.49, 0.63
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Denys Vlasenko (vda.linux@googlemail.com) wrote:
> On Monday 27 August 2007 16:59, Mathieu Desnoyers wrote:
> > +We can therefore affirm that adding 2 markers to getppid, on a system with high
> > +memory pressure, would have a performance hit of at least 6.0% on the system
> > +call time, all within the uncertainty limits of these tests. The same applies to
> > +other kernel code paths. The smaller those code paths are, the highest the
> > +impact ratio will be.
> 
> Immediates make code bigger, right?

Nope.

Example:

char x;

void testb(void)
{
        if (x > 5)
                testa();
}

Would turn into:
  56:   b0 00                   mov    $0x0,%al
  58:   3c 05                   cmp    $0x5,%al
  5a:   7e 05                   jle    61 <testb+0x11>

(6 bytes)

Rather than:

  56:   80 3d 00 00 00 00 05    cmpb   $0x5,0x0
  5d:   7e 05                   jle    64 <testb+0x14>

(9 bytes)

So actually, immediate values well used make the code smaller. By the
way, I recommend using the smallest immediate values required, which
will often be a single byte.

> What will happen on a system with high *icache* pressure?

It *helps* :) And by the way, icache on recent x86 and x86_64 is a trace
cache, so I don't see your point anyway.

> There a lot of inline happy and/or C++ folks out there
> in the userland, they routinely have programs in tens of megabytes range.
> 
> getppid is one of the lightest syscalls out there.
> What kind of speedup do you see on a real-world test
> (two processes exchaging data through pipes, for example)?
> 

With the size of the caches we currently have, that kind of workload
will not show any measurable difference: the signal/noise ratio is way
to small to detect that kind of performance difference under such
workload. Try it if you want.

The real-world speedup I am interested into is to have almost -zero-
tracer impact, which imples being undetectable even in the smallest and
shortest functions. I guess nobody is interested in adding a measurable
performance hit to kmalloc fast path, right ?


> > +Therefore, not only is it interesting to use the immediate values to dynamically
> > +activate dormant code such as the markers, but I think it should also be
> > +considered as a replacement for many of the "read mostly" static variables.
> 
> What effect that will have on "size vmlinux" on AMD64?

Without considering kernel/immediate.o, it will make the code smaller
and add 3*8bytes=24bytes of data in the __immediate section per
immediate value reference (data only used for updates).

Mathieu

> --
> vda

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
