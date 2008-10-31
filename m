Return-Path: <linux-kernel-owner+w=401wt.eu-S1753052AbYJaSzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbYJaSzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 14:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbYJaSzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 14:55:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39283 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbYJaSzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 14:55:32 -0400
Date: Fri, 31 Oct 2008 18:55:26 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] Re: alpha: undefined reference to `save_stack_trace'
Message-ID: <20081031185526.GT28946@ZenIV.linux.org.uk>
References: <20081031165751.GA13558@x200.localdomain> <20081031182411.GR28946@ZenIV.linux.org.uk> <20081031184822.GS28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081031184822.GS28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 06:48:22PM +0000, Al Viro wrote:
> On Fri, Oct 31, 2008 at 06:24:11PM +0000, Al Viro wrote:
> > On Fri, Oct 31, 2008 at 07:57:51PM +0300, Alexey Dobriyan wrote:
> > > On alpha-smp-[ny]-debug-y:
> > > 
> > >   LD      .tmp_vmlinux1
> > > kernel/built-in.o: In function `ftrace_trace_stack':
> > > (.text+0x706fc): undefined reference to `save_stack_trace'
> > > 
> > > 
> > > Somehow STACKTRACE is set despite no STACKTRACE_SUPPORT.
> > 
> > select blows, film at 11.  TRACING blindly selects STACKTRACE, with a bunch
> > of stuff in kernel/tracing/Kconfig doing select of TRACING.  Not just an alpha
> > problem, BTW.
> 
> While we are at it, we have that particular turd on allmodconfigs on (at least)
> 	alpha
> 	blackfin
> 	cris
> 	frv
> 	h8300
> 	ia64
> 	m32r
> 	m68k
> 	m68knommu
> 	mn10300
> 	parisc
> 	sparc (32bit one, that is)
> 	uml/i386
> 	uml/amd64
> 	xtensa
> 
> We could slap && HAS_STACKTRACE_SUPPORT on all symbols that end up selecting
> TRACING, but that's almost certainly wrong; the thing won't break if we
> simply omit stack trace output on configs that do not have them supported.
> Why do we have that select STACKTRACE there, anyway?

It's too ugly for words, but it does deal with this mess ;-/

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index b58f43b..33dbefd 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -25,7 +25,7 @@ config TRACING
 	bool
 	select DEBUG_FS
 	select RING_BUFFER
-	select STACKTRACE
+	select STACKTRACE if STACKTRACE_SUPPORT
 	select TRACEPOINTS
 	select NOP_TRACER
 
