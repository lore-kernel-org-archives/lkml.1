Return-Path: <linux-kernel-owner+w=401wt.eu-S1753024AbZKVLZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbZKVLZN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 06:25:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbZKVLZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 06:25:12 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43543 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbZKVLZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 06:25:11 -0500
Subject: Re: [PATCH 1/4] tracing: Use the perf recursion protection from
 trace event
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <rostedt@goodmis.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>
In-Reply-To: <20091122112259.GA24741@elte.hu>
References: <1258863695-10464-1-git-send-email-fweisbec@gmail.com>
	 <1258887614.28730.353.camel@laptop>  <20091122112259.GA24741@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 Nov 2009 12:24:53 +0100
Message-ID: <1258889093.28730.380.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-22 at 12:22 +0100, Ingo Molnar wrote:

> > > +void perf_swevent_put_recursion_context(int *recursion)
> > >  {
> > > -       struct perf_cpu_context *cpuctx = &get_cpu_var(perf_cpu_context);
> > > -       int *recursion = perf_swevent_recursion_context(cpuctx);
> > > -       struct perf_event_context *ctx;
> > > -
> > > -       if (*recursion)
> > > -               goto out;
> > > +       (*recursion)--;
> > > +}
> > 
> > And here as well.
> 
> Global functions are in essence a barrier() to GCC but yeah.

Can't rely on that, because if the thing decides to inline this function
it looses that barrier semantic.

And it being such a small function with a few callsites in the same
translation unit, there's a fair chance it will actually inline.

