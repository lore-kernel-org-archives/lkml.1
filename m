Return-Path: <linux-kernel-owner+w=401wt.eu-S1760891AbXFTBcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760891AbXFTBcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 21:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758040AbXFTBck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 21:32:40 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:61049 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757701AbXFTBcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 21:32:39 -0400
Date: Tue, 19 Jun 2007 21:32:31 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mbligh@google.com
Subject: Re: Problem with global_flush_tlb() on i386 in 2.6.22-rc4-mm2
Message-ID: <20070620013231.GA18305@Krystal>
References: <20070619170914.GA30623@Krystal> <46788188.1040403@codemonkey.ws>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <46788188.1040403@codemonkey.ws>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:29:12 up 22 days, 10:07,  2 users,  load average: 0.85, 0.75, 0.63
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Anthony Liguori (anthony@codemonkey.ws) wrote:
> Mathieu Desnoyers wrote:
> >Hi,
> >
> >Trying to test my "Text Edit Lock" patches, I ran into a problem related
> >to global_flush_tlb() not doing its job at updating the page flags when,
> >it seems, the page has been recently accessed. Therefore, it can only be
> >reproduced by doing a couple of iterations.
> >
....
> >This is clearly the memory write I am trying to do in the page of
> >which I just changed the attributes to RWX.
> >
> >If I remove the variable read before I change the flags, it starts
> >working correctly (as far as I have tested...).
> >
> >If I use my own my_local_tlb_flush() function (not SMP aware) instead of
> >global_flush_tlb(), it works correctly.
> >
> 
> What is your my_local_tlb_flush() and are you calling with preemption 
> disabled?
> 

The implementation was below in the email. Full preemption was enabled.

> >I also tried just calling clflush on the modified page just after the
> >global_flush_tlb(), and the problem was still there.
> >
> >I therefore suspect that
> >
> >include/asm-i386/tlbflush.h:
> >#define __native_flush_tlb_global()                                     \
> >        do {                                                            \
> >                unsigned int tmpreg, cr4, cr4_orig;                     \
> >                                                                        \
> >                __asm__ __volatile__(                                   \
> >                        "movl %%cr4, %2;  # turn off PGE     \n"        \
> >                        "movl %2, %1;                        \n"        \
> >                        "andl %3, %1;                        \n"        \
> >                        "movl %1, %%cr4;                     \n"        \
> >                        "movl %%cr3, %0;                     \n"        \
> >                        "movl %0, %%cr3;  # flush TLB        \n"        \
> >                        "movl %2, %%cr4;  # turn PGE back on \n"        \
> >                        : "=&r" (tmpreg), "=&r" (cr4), "=&r" (cr4_orig) \
> >                        : "i" (~X86_CR4_PGE)                            \
> >                        : "memory");                                    \
> >        } while (0)
> >
> >is not doing its job correctly. The problem does not seem to be caused
> >by PARAVIRT, because it is still buggy even if I disable the PARAVIRT
> >config option.
> 
> This is actually very conservative seeing as how disabling CR4.PGE 
> should be sufficient to flush global pages on modern processors.  I 
> suspect you're getting preempted while it's running.
> 

Thanks for the advice, but please have a look at my follow-up on the
issue, where I spotted the problem more precisely. It also affects
ioremap, which also uses global_flush_tlb(). I guess this bug is worth
being fixed quickly, even if it is just by applying my workaround (which
is _really_ conservative).

Regards,

Mathieu

> Regards,
> 
> Anthony Liguori

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
