Return-Path: <linux-kernel-owner+w=401wt.eu-S1757207AbZFCNXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207AbZFCNXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 09:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbZFCNXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 09:23:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47379 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbZFCNXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 09:23:10 -0400
Date: Wed, 3 Jun 2009 09:23:11 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Steven Whitehouse <swhiteho@redhat.com>
cc: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       cluster-devel@redhat.com, Christoph Hellwig <hch@infradead.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: trace: fix multiple use of __print_flags and __print_symbolic
In-Reply-To: <1244033875.29604.599.camel@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.0906030917010.14994@gandalf.stny.rr.com>
References: <1244019900.29604.588.camel@localhost.localdomain>  <4A26474C.1000900@cn.fujitsu.com> <1244033875.29604.599.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 3 Jun 2009, Steven Whitehouse wrote:

> Hi
> 
> On Wed, 2009-06-03 at 17:50 +0800, Li Zefan wrote:
> > Steven Whitehouse wrote:
> > > When using multiple calls to __print_symbolic and __print_flags in
> > > the same tracer, I noticed that the output was incorrect. I think
> > > the following patch is the correct fix (it works for me) but please
> > > check it carefully since I'm not that familiar with this code,
> > > and I may well have made a mistake somewhere.
> > > 
> > 
> > I don't see there's bug in __print_symbolic() or __print_flags():
> > 
> > enum print_line_t
> > ftrace_raw_output_##call(struct trace_iterator *iter, int flags)
> > {
> > 	...
> > 	p = &get_cpu_var(ftrace_event_seq);
> > 	/* here we call ftrace_print_flags_seq(p, ...) */
> > 	ret = trace_seq_printf(s, #call ": " print);
> > 	put_cpu();
> > 	...
> > }
> > 
> > ftrace_event_seq is percpu data, and here is used with preempt-disabled,
> > so there shouldn't be problem of concurrent accessing.
> > 
> I've double checked this now, and I'm seeing results like:
> 
> 
> glock_workqueue-2482  [001]   809.956985: gfs2_glock_state_change: 8.7 glock 2:33119 state EX => EX tgt:EX dmt:EX flags:EX
> glock_workqueue-2482  [001]   809.957155: gfs2_glock_state_change: 8.7 glock 2:33119 state NL => NL tgt:NL dmt:NL flags:NL
> glock_workqueue-2482  [001]   809.959473: gfs2_glock_state_change: 8.7 glock 1:2 state NL => NL tgt:NL dmt:NL flags:NL
> glock_workqueue-2482  [001]   809.959556: gfs2_glock_state_change: 8.7 glock 2:33119 state EX => EX tgt:EX dmt:EX flags:EX
> glock_workqueue-2482  [001]   810.008773: gfs2_glock_state_change: 8.7 glock 1:0 state EX => EX tgt:EX dmt:EX flags:EX
> 
> 
> without the patch, which is clearly wrong,

Ah, I did not account for having multiple instances of print_symbol of 
print_flags in a single print. Your patch is partialy correct. Add a:

	trace_seq_init(p);

after the "p = &get_cpu_var(ftrace_event_seq);".

-- Steve

