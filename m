Return-Path: <linux-kernel-owner+w=401wt.eu-S1759359AbXH1Lbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359AbXH1Lbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 07:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbXH1Lb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 07:31:28 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:61353 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752653AbXH1Lb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 07:31:27 -0400
Date: Tue, 28 Aug 2007 07:31:22 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, clameter@sgi.com,
       mingo@redhat.com
Subject: Re: [patch 01/28] Fall back on interrupt disable in cmpxchg8b on 80386 and 80486
Message-ID: <20070828113122.GA12241@Krystal>
References: <20070827155234.062715780@polymtl.ca> <20070827155523.916345864@polymtl.ca> <46D37D0A.905@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <46D37D0A.905@yahoo.com.au>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 07:29:27 up 29 days, 11:48,  5 users,  load average: 1.05, 1.45, 1.29
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Nick Piggin (nickpiggin@yahoo.com.au) wrote:
> Mathieu Desnoyers wrote:
> 
> >Q:
> >What's the reason to have cmpxchg64_local on 32 bit architectures?
> >Without that need all this would just be a few simple defines.
> >
> >A:
> >cmpxchg64_local on 32 bits architectures takes unsigned long long
> >parameters, but cmpxchg_local only takes longs. Since we have cmpxchg8b
> >to execute a 8 byte cmpxchg atomically on pentium and +, it makes sense
> >to provide a flavor of cmpxchg and cmpxchg_local using this instruction.
> >
> >Also, for 32 bits architectures lacking the 64 bits atomic cmpxchg, it
> >makes sense _not_ to define cmpxchg64 while cmpxchg could still be
> >available.
> >
> >Moreover, the fallback for cmpxchg8b on i386 for 386 and 486 is a
> >different case than cmpxchg (which is only required for 386). Using
> >different code makes this easier.
> >
> >However, cmpxchg64_local will be emulated by disabling interrupts on all
> >architectures where it is not supported atomically.
> >
> >Therefore, we *could* turn cmpxchg64_local into a cmpxchg_local, but it
> >would make the 386/486 fallbacks ugly, make its design different from
> >cmpxchg/cmpxchg64 (which really depends on atomic operations and cannot
> >be emulated) and require the __cmpxchg_local to be expressed as a macro
> >rather than an inline function so the parameters would not be fixed to
> >unsigned long long in every case.
> >
> >So I think cmpxchg64_local makes sense there, but I am open to
> >suggestions.
> 
> Every new thing like this (especially 64 bit operation on 32 bit
> architectures) adds a tiny bit more burden for maintainers. Are
> there any callers? If not, don't add it. It's simple to add if we
> do get a good reason.
> 

I am actually using it in LTTng in my timestamping code. I use it to
work around CPUs with asynchronous TSCs. I need to update 64 bits
values atomically on this 32 bits architecture.

I plan to submit this timestamping code soon.

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
