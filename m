Return-Path: <linux-kernel-owner+w=401wt.eu-S1753614AbZCMDIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbZCMDIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 23:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755677AbZCMDIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 23:08:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680AbZCMDIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 23:08:22 -0400
Date: Thu, 12 Mar 2009 23:08:19 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 08/16] tracing: have event_trace_printk use static
 tracer
In-Reply-To: <20090312194942.8348613c.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0903122301130.18396@gandalf.stny.rr.com>
References: <20090313023704.971438367@goodmis.org> <20090313023826.503765882@goodmis.org> <20090312194942.8348613c.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 12 Mar 2009, Andrew Morton wrote:

> On Thu, 12 Mar 2009 22:37:12 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > +		static const char *trace_printk_fmt			\
> > +		  __attribute__((section("__trace_printk_fmt"))) =	\
> > +			__builtin_constant_p(fmt) ? fmt : NULL;		\
> 
> hm.  Does this put trace_printk_fmt into the __trace_printk_fmt
> section, or does it put *trace_printk_fmt in there?

We save the pointer into that section:

 0xc0432100:   "my format is to print this number %d\n"

  [...]

section <__trace_printk_fmt>:
  [...]
 0xc0483210:   0xc0432100  (trace_printk_fmt)


It would be difficult to make the string be located in the section when 
the caller simply does:

   trace_printk("my format is to print this number %d\n", mynum);

Although I guess we could try by using [] = fmt, but the pointer just 
seemed easier.

Note, for modules, we have a hash of all strings/pointers. When a module 
is loaded, we copy the strings into the hash (if it is not already there) 
and keep it loaded, even if the module is removed. This is because the 
pointer to this string would still be around inside the trace buffer.

-- Steve

