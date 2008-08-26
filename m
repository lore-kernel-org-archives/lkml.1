Return-Path: <linux-kernel-owner+w=401wt.eu-S1755766AbYHZVgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbYHZVgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 17:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbYHZVgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 17:36:04 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:49522 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751085AbYHZVgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 17:36:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhwFAMEOtEhMRKxB/2dsb2JhbACBZbkfgWs
Date: Tue, 26 Aug 2008 17:35:59 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Gerhard Brauer <gerhard.brauer@web.de>
Cc: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
Message-ID: <20080826213559.GA27498@Krystal>
References: <48AF2ABD.9070100@zytor.com> <20080826141851.GA5300@tux1.brauer.lan> <20080826145338.GA8601@Krystal> <20080826131354.356ae11d@doriath.conectiva> <20080826171822.GB14906@Krystal> <20080826150222.0cf1542c@doriath.conectiva> <20080826181558.GA16887@Krystal> <20080826203449.GD5300@tux1.brauer.lan> <20080826204814.GB23544@Krystal> <20080826212549.GE5300@tux1.brauer.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080826212549.GE5300@tux1.brauer.lan>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:34:31 up 83 days,  2:14,  6 users,  load average: 0.33, 0.42,
	0.56
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gerhard Brauer (gerhard.brauer@web.de) wrote:
> On Tue, Aug 26, 2008 at 04:48:14PM -0400, Mathieu Desnoyers wrote:
> > 
> > OK, so we have a problem with interrupts coming while we are doing the
> > alternatives patching.
> > 
> > First thing, I wonder if Virtualbox expects the OS to patch all its
> > paravirt instructions in one go ?
> > 
> > Also, could you then try to :
> > - to revert all those changes
> > - Do this to text_poke_early and text_poke :
> > 
> > - put the sync_core() within the irq off critical section
> > (test)
> 
> Could you please explain more what to change? I don't see where to put
> sync_core(), i not found this section in both functions. (I'm not a developer)
> 

Sure,

First patch to test :

x86 alternative text_poke move sync_core

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/x86/kernel/alternative.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/arch/x86/kernel/alternative.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/alternative.c	2008-08-26 17:26:41.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kernel/alternative.c	2008-08-26 17:26:58.000000000 -0400
@@ -488,8 +488,8 @@ void *text_poke_early(void *addr, const 
 	unsigned long flags;
 	local_irq_save(flags);
 	memcpy(addr, opcode, len);
-	local_irq_restore(flags);
 	sync_core();
+	local_irq_restore(flags);
 	/* Could also do a CLFLUSH here to speed up CPU recovery; but
 	   that causes hangs on some VIA CPUs. */
 	return addr;
@@ -529,9 +529,9 @@ void *__kprobes text_poke(void *addr, co
 	BUG_ON(!vaddr);
 	local_irq_save(flags);
 	memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
+	sync_core();
 	local_irq_restore(flags);
 	vunmap(vaddr);
-	sync_core();
 	/* Could also do a CLFLUSH here to speed up CPU recovery; but
 	   that causes hangs on some VIA CPUs. */
 	for (i = 0; i < len; i++)


> > - add a wbinvd();  just after the sync_core() in both functions
> > (test).
> 
> Also verbose please...
> 

Second patch to apply on top of the first one :


x86 alternative text_poke add wbinvd

Add a cache flush instruction before reenabling interrupts in text_poke.

If this works, we could use clflush() (which is sadly buggy on some archs) which
is faster since it only clear a cacheline instead of the entire cache.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/x86/kernel/alternative.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6-lttng/arch/x86/kernel/alternative.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/alternative.c	2008-08-26 17:27:33.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kernel/alternative.c	2008-08-26 17:27:53.000000000 -0400
@@ -489,6 +489,7 @@ void *text_poke_early(void *addr, const 
 	local_irq_save(flags);
 	memcpy(addr, opcode, len);
 	sync_core();
+	wbinvd();
 	local_irq_restore(flags);
 	/* Could also do a CLFLUSH here to speed up CPU recovery; but
 	   that causes hangs on some VIA CPUs. */
@@ -530,6 +531,7 @@ void *__kprobes text_poke(void *addr, co
 	local_irq_save(flags);
 	memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
 	sync_core();
+	wbinvd();
 	local_irq_restore(flags);
 	vunmap(vaddr);
 	/* Could also do a CLFLUSH here to speed up CPU recovery; but



Thanks,

Mathieu

> > Thanks,
> > 
> > Mathieu
> 
> Thank you
> 	Gerhard
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
