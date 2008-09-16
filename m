Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbYIPI6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbYIPI6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 04:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbYIPI5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 04:57:54 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:58927 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbYIPI5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 04:57:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xRH00ounXt9ezv7u4L8LqyTP/12eYYkVHaQeAvqbzNy/dE/2qUR7TlrTP0bOHpYvrC
         x5CT+GJlOmny/HajwWvcOBQ8cuSUPNqnpJXyGhCEBRG9DdxJQDf7rWIlCivxnBwZWiyd
         8tx1fX2O3zK5z1BHn1TEDB8eJ0Qb3obv+3FIE=
Message-ID: <c62985530809160157n5ca5cfa0m1a4865aeb710a74a@mail.gmail.com>
Date: Tue, 16 Sep 2008 10:57:51 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Pekka Paalanen" <pq@iki.fi>
Subject: Re: Tracing/ftrace: trouble with trace_entries and trace_pipe
Cc: "Steven Rostedt" <rostedt@goodmis.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080915224707.76b2cca0@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48B1D5CA.8000607@gmail.com>
	 <c62985530808270259i491e32e2r40adf719e32e4086@mail.gmail.com>
	 <20080827212130.4b8365a8@daedalus.pq.iki.fi>
	 <c62985530808280304x389cb958vff24b5d11f22d35c@mail.gmail.com>
	 <20080828214256.296e34ec@daedalus.pq.iki.fi>
	 <c62985530809040920v3c47b57ds40dfd400168bd501@mail.gmail.com>
	 <20080904203058.7e57729e@daedalus.pq.iki.fi>
	 <alpine.DEB.1.10.0809041407140.2431@gandalf.stny.rr.com>
	 <20080915224707.76b2cca0@daedalus.pq.iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/15 Pekka Paalanen <pq@iki.fi>:
> My other problem is with trace_pipe. It is again making 'cat' quit too
> early. The condition triggered is
>        if (!tracer_enabled && iter->pos) {
> in tracing_read_pipe(), and it is followed by triggering
>        /* stop when tracing is finished */
>        if (trace_empty(iter)) {
> and then sret=0, so read returns 0 and 'cat' exits.
>
> Now, I am trying my mmiotrace marker patches, but as far as I can tell,
> nothing I modified is the reason for this. I didn't yet explicitly test
> for it, though. I'll send these patches after I hear from Frederic.
>
> The cat-quit problem is not a constant state. After boot, I could play
> with my markers and testmmiotrace without cat quitting. Then something
> happens, and cat starts the quitting behaviour, and won't get to normal
> by disabling and enabling mmiotrace.
>
> I have a couple of wild guesses of what might be related:
> - ring buffer wrap-around
> - ring buffer overflow (at first try I hit these, the second try
> after putting debug-pr_info's in place I don't hit this)
> - ring buffer resize (after playing with trace_entries, cat-quit
> problem was present, though it might have been present before)
>
> After viewing the git history, I have some more guesses, mainly
> related to setting tracer_enabled to 0.
> - commit 2b1bce1787700768cbc87c8509851c6f49d252dc
> I don't see where tracer_enabled would be set to 1, when
> mmiotrace is enabled. It used to default to 1 and mmiotrace was happy.
> - __tracing_open() sets it to 0 (not called for the pipe)
> - tracing_release() sets it to 1
> - tracing_ctrl_write() toggles it
> - tracing_read_pipe() tests it
> - tracer_alloc_buffers() uses it
> And other tracers seem to use it a lot.
>
> Mmiotrace does use the tracer::ctrl_update hook, and allow/disallow
> calls to __trace_mmiotrace_{rw,map}() via enabling/disabling the whole
> mmiotrace core. Is this not enough, or is it inappropriate?
>
> It seems tracer_enabled is used by the trace framework itself to
> enable/disable... what? Hmm, maybe nothing I care about.
>
> Should mmiotrace simply do
>        tracer_enabled = 1;
> in mmio_trace_init()?
>
> Should mmiotrace test tracer_enabled, and if so, when?


As I said to you, I met the same bug of this early quit of the pipe.
But I should give here more details.
This bug occurs with -tip (a version pulled 2 days ago so trace.c
didn't change).
I never saw it with other tracers than mmiotrace. I had no problem
with sched_switch or function tracer.

It happened when I was writing the tracer marker. So I'm not sure if
the origin is here. If I'm not wrong it happened whithout adding mark
messages too.
Can you tell me if your pipe quits when you add a mark or if this bug
occurs on other cases too?

I will try to reproduce the bug this evening.
