Return-Path: <linux-kernel-owner+w=401wt.eu-S1753274AbYK2Gl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbYK2Gl0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 01:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750901AbYK2GlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 01:41:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42221 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750856AbYK2GlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 01:41:17 -0500
Date: Fri, 28 Nov 2008 22:40:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hugh Dickins <hugh@veritas.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Miles Lane <miles.lane@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Tejun Heo <htejun@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.28-rc6-git1 -- BUG: unable to handle kernel paging request
 at ffff8800be8b0019
Message-Id: <20081128224048.dbfc9082.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0811271827490.7113@gandalf.stny.rr.com>
References: <a44ae5cd0811250850g725a5a5nd7d93a23ffd2fce6@mail.gmail.com>
	<200811270026.37941.rjw@sisk.pl>
	<84144f020811270537l3798b2f5ka63caacbee43b075@mail.gmail.com>
	<Pine.LNX.4.64.0811271349040.21910@blonde.site>
	<84144f020811270613t3f0258ddxac52abb9a447bf40@mail.gmail.com>
	<Pine.LNX.4.64.0811271643250.9618@blonde.site>
	<alpine.DEB.1.10.0811271827490.7113@gandalf.stny.rr.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2008 18:31:34 -0500 (EST) Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> [ Added Frederic ]
> 
> On Thu, 27 Nov 2008, Hugh Dickins wrote:
> >  					break;
> > --- 2.6.28-rc6/include/linux/ftrace.h	2008-11-02 23:17:56.000000000 +0000
> > +++ linux/include/linux/ftrace.h	2008-11-27 16:39:26.000000000 +0000
> > @@ -231,7 +231,7 @@ ftrace_init_module(unsigned long *start,
> >  
> >  struct boot_trace {
> >  	pid_t			caller;
> > -	char			func[KSYM_NAME_LEN];
> > +	char			func[KSYM_SYMBOL_LEN];
> >  	int			result;
> >  	unsigned long long	duration;		/* usecs */
> >  	ktime_t			calltime;
> 
> Acked-by: Steven Rostedt <srostedt@redhat.com>
> 
> The boot tracer was written by Frederic.
> 

This makes rather a mess when applied ahead of the (massive) ftrace
changes in linux-next.

afacit these two func[] arrays:

--- /dev/null
+++ b/include/trace/boot.h
@@ -0,0 +1,56 @@
+#ifndef _LINUX_TRACE_BOOT_H
+#define _LINUX_TRACE_BOOT_H
+
+/*
+ * Structure which defines the trace of an initcall
+ * while it is called.
+ * You don't have to fill the func field since it is
+ * only used internally by the tracer.
+ */
+struct boot_trace_call {
+	pid_t			caller;
+	char			func[KSYM_NAME_LEN];
+};
+
+/*
+ * Structure which defines the trace of an initcall
+ * while it returns.
+ */
+struct boot_trace_ret {
+	char			func[KSYM_NAME_LEN];
+	int				result;
+	unsigned long long	duration;		/* nsecs */
+};


will need to be changed to KSYM_SYMBOL_LEN.  I think.  Please fix it up
carefully when this all lands on your doorstep.

