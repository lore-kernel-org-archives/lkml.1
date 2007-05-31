Return-Path: <linux-kernel-owner+w=401wt.eu-S1760160AbXEaQee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760160AbXEaQee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 12:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759514AbXEaQeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 12:34:18 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:54772 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758715AbXEaQeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 12:34:16 -0400
Date: Thu, 31 May 2007 12:34:15 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 1/9] Conditional Calls - Architecture Independent Code
Message-ID: <20070531163415.GA20834@Krystal>
References: <20070530140025.917261793@polymtl.ca> <20070530140227.070136408@polymtl.ca> <20070530133242.9a0d2c71.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070530133242.9a0d2c71.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:26:16 up 3 days,  1:04,  3 users,  load average: 0.08, 0.12, 0.25
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> > +#ifdef CONFIG_COND_CALL_ENABLE_OPTIMIZATION
> > +#include <asm/condcall.h>		/* optimized cond_call flavor */
> > +#else
> > +#include <asm-generic/condcall.h>	/* fallback on generic cond_call */
> > +#endif
> 
> The preferred way to do this is to give every architecture an
> asm/condcall.h and from within that, include asm-generic/condcall.h.  Your
> [patch 3/9] does most of that, but it didn't remove the above ifdef, and I
> don't think it removed the should-be-unneeded
> CONFIG_COND_CALL_ENABLE_OPTIMIZATION either?
> 

Conditional calls works just like the previous markers in this aspect :
in order to support embedded systems with read-only memory for the text
segment, I leave the choice to disable the "optimized" cond_call as a
config option even if the architecture has the optimized marker flavor.

I use this include scheme because I want to support both the generic and
optimized version at the same time : if a _cond_call is declared with
the CF_OPTIMIZED flags unset, it will use the generic version. This is
useful when we must place cond_calls in locations that present specific
reentrancy issues, such as cond_call, printk, some trap handlers. The
optimized version, when it uses the i386 mechanism to insure correct
code modification, can trigger a trap, which will call into lockdep and
might have other side-effects.

(I am adding this text in the condcall.h header)

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
