Return-Path: <linux-kernel-owner+w=401wt.eu-S1764897AbZLQU0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764897AbZLQU0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 15:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764572AbZLQU0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 15:26:14 -0500
Received: from tomts43.bellnexxia.net ([209.226.175.110]:54645 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764894AbZLQU0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 15:26:11 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgEFADIeKkuuWOl3/2dsb2JhbACBS9UNhC0E
Date: Thu, 17 Dec 2009 15:25:58 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [this_cpu_xx V7 0/8] Per cpu atomics in core allocators and
	cleanup
Message-ID: <20091217202558.GA21713@Krystal>
References: <20091214220320.665065925@quilx.com> <20091215174302.GA3928@Krystal> <4B2830CC.7040309@kernel.org> <20091216014031.GA12282@Krystal> <4B283BFE.2040005@kernel.org> <20091217133958.GA21618@Krystal> <alpine.DEB.2.00.0912171327220.3638@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0912171327220.3638@router.home>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 15:15:20 up 1 day,  4:33,  3 users,  load average: 0.12, 0.09,
	0.03
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux-foundation.org) wrote:
> > However, I would need:
> >
> > this_cpu_cmpxchg(scalar, oldv, newv)
> >   (maps to x86 cmpxchg)
> >
> > this_cpu_add_return(scalar, value)
> >   (maps to x86 xadd)
> >
> > too. Is that a planned addition ?
> 
> It was not necessary. Its easy to add though.
> 
> > (while we are at it, we might as will add the xchg instruction,
> > althrough it has an implied LOCK prefix on x86).
> 
> Well yeah thats a thorny one. One could use the cmpxchg instead?

Yes, although maybe it would make sense to encapsulate it in a xchg
primitive anyway, in case some architecture has a better xchg than x86.
For instance, powerpc, with its linked load/store conditional, can skip
a comparison for xchg that's otherwise required for cmpxchg.

Some quick test on my Intel Xeon E5405:

local cmpxchg:  14 cycles
xchg:           18 cycles

So yes, indeed, the non-LOCK prefixed local cmpxchg seems a bit faster
than the xchg, given the latter has an implied LOCK prefix.

Code used for local cmpxchg:
                old = var;
                do {
                        ret = cmpxchg_local(&var, old, 4);
                        if (likely(ret == old))
                                break;
                        old = ret;
                } while (1);

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
