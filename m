Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954AbYJXRI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbYJXRI0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 13:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbYJXRIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 13:08:19 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:62911 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbYJXRIS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 13:08:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=Vj5rxlxmRjfPlYTSmxplbX98LliZeQobAFnosQjX1eEFHrxO8PkOJME0I/J0+EBwGe
         SmPDMp2ac4+oE6NJ5mpGI9RcMQJJqi5tes+qhmOKsnwb5Yj9qCyOzNA7aEtfTx70t/s2
         nIHLG15e59MZjnxNgZ/4I6ZiPa98CxIaVS8Dg=
Date: Fri, 24 Oct 2008 20:08:11 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] trace: add the MMIO-tracer to the tracer menu
Message-ID: <20081024200811.4609c09f@daedalus.pq.iki.fi>
In-Reply-To: <alpine.DEB.1.10.0810240755290.25677@gandalf.stny.rr.com>
References: <1224845357.4075.0.camel@twins>
	<20081024112535.GA19786@elte.hu>
	<alpine.DEB.1.10.0810240755290.25677@gandalf.stny.rr.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2008 07:56:05 -0400 (EDT)
Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Fri, 24 Oct 2008, Ingo Molnar wrote:
> > >  #
> > >  # IO delay types:
> > > Index: linux-2.6/kernel/trace/Kconfig
> > > ===================================================================
> > > --- linux-2.6.orig/kernel/trace/Kconfig
> > > +++ linux-2.6/kernel/trace/Kconfig
> > > @@ -194,4 +194,32 @@ config FTRACE_STARTUP_TEST
> > >  	  functioning properly. It will do tests on all the configured
> > >  	  tracers of ftrace.
> > >  
> > > +config MMIOTRACE_HOOKS
> > > +	bool
> > > +
> > > +config MMIOTRACE
> > > +	bool "Memory mapped IO tracing"
> > > +	depends on HAVE_MMIOTRACE_SUPPORT && DEBUG_KERNEL && PCI
> > > +	select TRACING
> > > +	select MMIOTRACE_HOOKS
> > 
> > change makes sense, but isnt MMIOTRACE_HOOKS basically overlapping 
> > HAVE_MMIOTRACE_SUPPORT? So i think we could get rid of MMIOTRACE_HOOKS 
> > altogether and just use HAVE_MMIOTRACE_SUPPORT.
> 
> And doing this will remove the need about my question on depends on X86.

Yes, we can remove MMIOTRACE_HOOKS and replace it with just MMIOTRACE.
MMIOTRACE_HOOKS is a remnant from the time when I thought that
something else could also use the kmmio facilities.

Here's a compile-tested patch against current Ingo's tip/master.

>From d4b97cd777c3382b784a9504281feccc9f2c4036 Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Fri, 24 Oct 2008 18:59:56 +0300
Subject: [PATCH] mmiotrace: Remove unneeded CONFIG_MMIOTRACE_HOOKS.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---
 arch/x86/Kconfig.debug |    4 ----
 arch/x86/mm/Makefile   |    3 +--
 arch/x86/mm/fault.c    |    2 +-
 3 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index fc58b86..01649e1 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -175,14 +175,10 @@ config IOMMU_LEAK
 	  Add a simple leak tracer to the IOMMU code. This is useful when you
 	  are debugging a buggy device driver that leaks IOMMU mappings.
 
-config MMIOTRACE_HOOKS
-	bool
-
 config MMIOTRACE
 	bool "Memory mapped IO tracing"
 	depends on DEBUG_KERNEL && PCI
 	select TRACING
-	select MMIOTRACE_HOOKS
 	help
 	  Mmiotrace traces Memory Mapped I/O access and is meant for
 	  debugging and reverse engineering. It is called from the ioremap
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index f4edb6e..617537f 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -10,9 +10,8 @@ obj-$(CONFIG_HIGHMEM)		+= highmem_32.o
 
 obj-$(CONFIG_KMEMCHECK)		+= kmemcheck/
 
-obj-$(CONFIG_MMIOTRACE_HOOKS)	+= kmmio.o
 obj-$(CONFIG_MMIOTRACE)		+= mmiotrace.o
-mmiotrace-y			:= pf_in.o mmio-mod.o
+mmiotrace-y			:= kmmio.o pf_in.o mmio-mod.o
 obj-$(CONFIG_MMIOTRACE_TEST)	+= testmmiotrace.o
 
 obj-$(CONFIG_NUMA)		+= numa_$(BITS).o
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index ed9ee30..63e9f7c 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -55,7 +55,7 @@
 
 static inline int kmmio_fault(struct pt_regs *regs, unsigned long addr)
 {
-#ifdef CONFIG_MMIOTRACE_HOOKS
+#ifdef CONFIG_MMIOTRACE
 	if (unlikely(is_kmmio_active()))
 		if (kmmio_handler(regs, addr) == 1)
 			return -1;
-- 
1.5.6.4


