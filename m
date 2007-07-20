Return-Path: <linux-kernel-owner+w=401wt.eu-S1761700AbXGTFrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761700AbXGTFrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 01:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbXGTFrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 01:47:43 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:60115 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751595AbXGTFrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 01:47:42 -0400
Date: Fri, 20 Jul 2007 01:47:40 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andi Kleen <ak@suse.de>, patches@x86-64.org, linux-kernel@vger.kernel.org,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH] [15/58] i386: Rewrite sched_clock (cmpxchg8b)
Message-ID: <20070720054740.GA13555@Krystal>
References: <200707191154.642492000@suse.de> <20070719095459.E60AD14E11@wotan.suse.de> <1184863904.6458.17.camel@dhcp193.mvista.com> <20070720031105.GA8237@Krystal> <20070720034757.GA9093@Krystal> <20070720041839.GA11217@Krystal> <46A0432C.8090207@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <46A0432C.8090207@yahoo.com.au>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 01:31:04 up 3 days, 5 min,  1 user,  load average: 0.53, 0.33, 0.23
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Nick Piggin (nickpiggin@yahoo.com.au) wrote:
> Mathieu Desnoyers wrote:
> 
> >I tried it with and without the LOCK prefix on my Pentium 4.
> >
> >Locked cmpxchg8b : 90 cycles
> >Non locked cmpxchg8b: 30 cycles
> >sti: 166 cycles
> >cli: 159 cycles
> >
> >So, hrm, even if we use the locked version, it is still much faster than
> >the sti/cli. I am thoughtful about the comment in asm-i386/system.h:
> 
> Curious: what does it look like if the memory is not in cache? I
> found that cmpxchg is relatively slower than other rmw instructions
> in that case.
> 

Actually, I have just seen that cmpxchg64 and cmpxchg64_local are
doing exactly this and they are already implemented in asm-i386/system.h.

A quick test: I am doing clflush in a loop (substracting its time from the
following loops) to have a memory hit when I do cmpxchg. This is the
result of just the cmpxchg8b:

non locked cmpxchg8b: 583.37 cycles
locked cmpxchg8b: 650.48 cycles
rmw in 3 operations: 581.43 cycles

So the locked cmpxchg is 67 cycles slower than the non locked cmpxchg,
which fits with my 30 vs 90 cycles. rmw is a tiny bit faster than
cmpxchg8b (2 cycles), but nothing to call home about.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
