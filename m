Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab0CNW3f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 18:29:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60349 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab0CNW3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 18:29:34 -0400
X-Authority-Analysis: v=1.0 c=1 a=pnHbx7LlBzgA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=B0irsJ7iK2wbAqCF7FkA:9 a=iHfVaaaos424fu0zGgcjMIzzjV0A:4 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 5/5] tracing: Do not record user stack trace from NMI 
 context
From: Steven Rostedt <rostedt@goodmis.org>
To: John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       stable@kernel.org
In-Reply-To: <520f0cf11003141505l607f2f3bxa36a9cffd82cab50@mail.gmail.com>
References: <20100313025655.104950166@goodmis.org>
	 <20100313025855.495916344@goodmis.org>
	 <520f0cf11003141505l607f2f3bxa36a9cffd82cab50@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Mar 2010 18:29:30 -0400
Message-ID: <1268605770.13400.688.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-03-14 at 23:05 +0100, John Kacur wrote:
> On Sat, Mar 13, 2010 at 3:57 AM, Steven Rostedt <rostedt@goodmis.org> wrote:

> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > index 484337d..e52683f 100644
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -1284,6 +1284,13 @@ ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
> >        if (!(trace_flags & TRACE_ITER_USERSTACKTRACE))
> >                return;
> >
> > +       /*
> > +        * NMIs can not handle page faults, even with fix ups.
> > +        * The save user stack can (and often does) fault.
> > +        */
> > +       if (unlikely(in_nmi()))
> > +               return;
> > +
> >        event = trace_buffer_lock_reserve(buffer, TRACE_USER_STACK,
> >                                          sizeof(*entry), flags, pc);
> >        if (!event)
> > --
> > 1.7.0
> >
> 
> That is some awfully cool detective work. Just one question, if it is
> so easy to trigger, why did you wrap it in "unlikely"?

It was not easy to trigger until I had a case to trigger it. Currently,
the only time that this should trigger is for the lockdep tracing, which
only happens when lockdep is enabled. Most of the time, this should
never trigger.

-- Steve


