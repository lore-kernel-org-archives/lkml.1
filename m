Return-Path: <linux-kernel-owner+w=401wt.eu-S1757207AbYIPSBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207AbYIPSBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 14:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbYIPSBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 14:01:23 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:39093 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbYIPSBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 14:01:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=LYTCL0Rj16gZt4j7Z/DmcD+vw01Al2cvFdjsFNlUvHvDLSonGSiUo2WzCsXoOhtmzb
         i7/KYrmi46x8aA0ckmtuegqLDlc1icaMQJDRzaAAD3xi0+hVQ9j9x1llaTJRjClExu6f
         Fmivo9HYPuckWziazHohzXPBawzPXWijA5CrU=
Date: Tue, 16 Sep 2008 21:01:14 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Tracing/ftrace: trouble with trace_entries and trace_pipe
Message-ID: <20080916210114.7679a0dc@daedalus.pq.iki.fi>
In-Reply-To: <alpine.DEB.1.10.0809151556260.22620@gandalf.stny.rr.com>
References: <48B1D5CA.8000607@gmail.com>
	<c62985530808270259i491e32e2r40adf719e32e4086@mail.gmail.com>
	<20080827212130.4b8365a8@daedalus.pq.iki.fi>
	<c62985530808280304x389cb958vff24b5d11f22d35c@mail.gmail.com>
	<20080828214256.296e34ec@daedalus.pq.iki.fi>
	<c62985530809040920v3c47b57ds40dfd400168bd501@mail.gmail.com>
	<20080904203058.7e57729e@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0809041407140.2431@gandalf.stny.rr.com>
	<20080915224707.76b2cca0@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0809151556260.22620@gandalf.stny.rr.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Sep 2008 17:14:34 -0400 (EDT)
Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Mon, 15 Sep 2008, Pekka Paalanen wrote:
> 
> > Hi Steven and others,
> > 
> > first a minor bug: it seems the units of /debug/tracing/trace_entries
> > is different for read and write. This is confusing for the users, since
> > I can't say "if you have problems, double it". If I read from it
> > something like 16422, then write back 16422, next I read 214. I can't
> > recall the exact numbers, but the difference really is two orders of
> > magnitude. I have 1 GB RAM in this box, so that shouldn't be an issue.
> 
> You write to it the same number that you read from and it returned 
> something different?? That is indeed a bug, since it should definitely 
> detect that. Is this linux-tip? I'll have to play with it to make sure 
> nothing broke it recently.
> 
> I just tried the latest mainline, and it seemed to work there.

Yes, it returned a very different number. This is Ingo's tip/master,
sorry for not being explicit. Checked-out on Sunday.

Echoing the following numbers to trace_entries triggers it:
200, 64, 640, 16422, 16422, 16422, 164220...
so the ridiculously small number 64 does something bad. After 640,
I read back something less than 200. Each following write increases
that number by 46.
16422 is the default before writing anything.
That is even stranger than I thought. :-o

I was going to test the buffer overflow with mmiotrace.

> > My other problem is with trace_pipe. It is again making 'cat' quit too
> > early. The condition triggered is
> > 	if (!tracer_enabled && iter->pos) {
> > in tracing_read_pipe(), and it is followed by triggering
> >         /* stop when tracing is finished */
> >         if (trace_empty(iter)) {
> > and then sret=0, so read returns 0 and 'cat' exits.
> > 
> > Now, I am trying my mmiotrace marker patches, but as far as I can tell,
> > nothing I modified is the reason for this. I didn't yet explicitly test
> > for it, though. I'll send these patches after I hear from Frederic.
> > 
> > The cat-quit problem is not a constant state. After boot, I could play
> > with my markers and testmmiotrace without cat quitting. Then something
> > happens, and cat starts the quitting behaviour, and won't get to normal
> > by disabling and enabling mmiotrace.
> > 
> > I have a couple of wild guesses of what might be related:
> > - ring buffer wrap-around
> > - ring buffer overflow (at first try I hit these, the second try
> > after putting debug-pr_info's in place I don't hit this)
> > - ring buffer resize (after playing with trace_entries, cat-quit
> > problem was present, though it might have been present before)
> > 
> > After viewing the git history, I have some more guesses, mainly
> > related to setting tracer_enabled to 0.
> > - commit 2b1bce1787700768cbc87c8509851c6f49d252dc
> > I don't see where tracer_enabled would be set to 1, when
> > mmiotrace is enabled. It used to default to 1 and mmiotrace was happy.
> > - __tracing_open() sets it to 0 (not called for the pipe)
> > - tracing_release() sets it to 1
> > - tracing_ctrl_write() toggles it
> > - tracing_read_pipe() tests it
> > - tracer_alloc_buffers() uses it
> > And other tracers seem to use it a lot.
> > 
> > Mmiotrace does use the tracer::ctrl_update hook, and allow/disallow
> > calls to __trace_mmiotrace_{rw,map}() via enabling/disabling the whole
> > mmiotrace core. Is this not enough, or is it inappropriate?
> > 
> > It seems tracer_enabled is used by the trace framework itself to
> > enable/disable... what? Hmm, maybe nothing I care about.
> > 
> > Should mmiotrace simply do
> > 	tracer_enabled = 1;
> > in mmio_trace_init()?
> > 
> > Should mmiotrace test tracer_enabled, and if so, when?
> 
> No, tracer_enabled is something that is internal to the tracer 
> infrastructure. 
> 
> if you read from either tracing/trace or tracing/latency_trace it will 
> disable the tracer while you dump. But you should not be doing that. The 
> trace_pipe should not disable that either.

Ok, so the problem is probably the commit I mentioned. It makes the
no_tracer tracer to set tracer_enabled to 0, and I can't find where
it would be set to 1 for mmiotrace. And this interferes with
tracing_read_pipe(), making it quit when iter->pos is non-zero.
See no_trace_init() in trace.c. According to this, the cat-quit
occurs when the buffer gets empty after first data, but this isn't
totally in agreement with what I recall from my experiments. And it
does happen also on other times than injecting markers.

So either it is wrong to check tracer_enabled in tracing_read_pipe(),
or no_trace_init() should not touch it.

Steven, what do you think?

-- 
Pekka Paalanen
http://www.iki.fi/pq/
