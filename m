Return-Path: <linux-kernel-owner+w=401wt.eu-S1161357AbXBUUut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161357AbXBUUut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 15:50:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161359AbXBUUut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 15:50:49 -0500
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:45153 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161357AbXBUUur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 15:50:47 -0500
Date: Wed, 21 Feb 2007 15:45:35 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Karim Yaghmour <karim.yaghmour@kryptiva.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@redhat.com>,
       systemtap@sources.redhat.com, ltt-dev@shafik.org
Subject: Re: [PATCH 05/05] Linux Kernel Markers, non optimized architectures
Message-ID: <20070221204535.GA616@Krystal>
References: <1171224207118-git-send-email-mathieu.desnoyers@polymtl.ca> <1171224209195-git-send-email-mathieu.desnoyers@polymtl.ca> <20070214231635.091c7169.akpm@linux-foundation.org> <20070215190919.GA31359@Krystal> <45D61361.6030200@kryptiva.com> <20070216233825.GB28087@Krystal> <45DCA6E1.7080903@kryptiva.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <45DCA6E1.7080903@kryptiva.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 15:38:08 up 19 days, 10:46,  4 users,  load average: 2.46, 2.03, 1.99
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Karim Yaghmour (karim.yaghmour@kryptiva.com) wrote:
> ----- KRYPTIVA PACKAGED MESSAGE -----
> PACKAGING TYPE: SIGNED
> 
> Hello Mathieu,
> 
> Mathieu Desnoyers wrote:
> > Yes, that was indeed the first way I implemented it, as a "disable" 
> option. One of the main thing we have to figure out before I modify this is 
> if we want to have the generic version of markers available in a "forced" 
> manner at the marker site with the GEN_MARK macro instead of the MARK macro 
> (this is the actual implementation). It has proven to be useful to 
> instrument lockdep.c irq
> > enable/disable tracing functions. The reason why is because they are 
> called just before the trap handler returns and I need it to do XMC on x86 
> and x86_64. It would therefore cause a recursive trap.
> >
> > I think it makes sense to have this kind of support for 
> hard-to-instrument sites within the marker infrastructure, but the cost is 
> to have two marker flavors : MARK and GEN_MARK (but really GEN_MARK is only 
> intended for a few sites).
> 
> I must admit that I'm unsure about the use of different marker macros.
> How about bitwise flags that could be coded as part of the marker
> at the marker site? Something like "MARKER_TYPE_FORCED". This would
> still allow some form of toplevel control at the macro definition.
> Otherwise there's some digging to be done on a per-marker
> basis ...
> 

The problem with your proposal, I guess, is that people will have to
add a supplementary parameter to the macro.

It is not uncommon to have two slightly versions of macros/functions in
the kernel (preempt_enable()/preempt_enable_no_resched(), or macros
starting with underscores). Normally, the underscore states that the
macro does not do the proper locking itself (this is not our case).
Therefore, I would suggest using a name that suggests against what the
macro is protected. For instance, a marker pointing to the generic
version is only needed to protect against the debug trap handler and
should only be used on x86 and x86_64.

So, something like MARK_NO_TRAP() would be appropriate : it would be an
optimized version for every architecture except x86 and x86_64. The
meaning of this macro is : "This is a marker that will never generate a
trap because of its activation" (just as a precision : it doesn't say
anything about the probe connected to the marker). It also acts as a
strong suggestion about what *should not* be done within the probe.

Mathieu

> Karim
> ----- KRYPTIVA SIGNED MESSAGE -----
> This email claims to have been packaged by Kryptiva.
> To process this email and authenticate its origin, get
> the free plugin from:
> http://www.kryptiva.com/downloads
> 
> ----- KRYPTIVA SIGNATURE START -----
> AvWVqAAAAAIAAAABAAAAAAAATiACAQAAAAC3AQAIAAAAAgAAAAECABTXxT4xHdR4/1uU1hL2
> +TaPrqNB0wMAFNa8GHXZWJH5Dz+D76vfh6JhvWLvBAAUpuIZcCAkCC+ldyaBuoAWxK50HiQF
> ABRI38gc/foDHQsS6X3W0VP4xTukBwYAFB0lithGcxNZYBHaLDONjp6eo/LoBwAU6OwGS0m1
> IVdBt6tKzhaPW8MOfncRABgAAAAAAABOIEXcozcACATMAAAAAAAAABkTAAQAAAAAAAAAggQA
> mHAJeFbYUzxSX+zkI0DtoVKcqqSp2Ztc9GtY7ZtuLBmeqg5pW0rIbkhutQiztTXlJQ0Ye9bV
> yzEVWd/m7GhDAgRBmyg3kCOt7g7potr1l5J3X5K8TiqtWXbNo3k6AHRlGZyn0190iIBSvf85
> nVh3hKiNPsw8DYs1NKb+KMON+4g=
> ----- KRYPTIVA SIGNATURE END -----

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Candidate, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
