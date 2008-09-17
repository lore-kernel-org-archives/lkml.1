Return-Path: <linux-kernel-owner+w=401wt.eu-S1753256AbYIQMlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbYIQMlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 08:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbYIQMlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 08:41:32 -0400
Received: from gv-out-0910.google.com ([216.239.58.191]:63646 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbYIQMlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 08:41:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=N6LRqX54bMeQvc94HwiOH1EgXaG/xBkxUSlA5ShlV0lAimAcd1DnGxJWXoS2idJao6
         0eFc5FEvIZFKrD2Owey32wdKBA+IvoPwvDszThGG5BkEZ5tRQDtVrQaoVM/AYDF2MV/N
         k66dgJkA6FsGLizkgk4JnRSHFQs1IBAGFvV4Y=
Message-ID: <c62985530809170541p5bdcbfb4xf21232842e7b8b9@mail.gmail.com>
Date: Wed, 17 Sep 2008 14:41:29 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Pekka Paalanen" <pq@iki.fi>
Subject: Re: Tracing/ftrace: trouble with trace_entries and trace_pipe
Cc: "Steven Rostedt" <rostedt@goodmis.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080916210114.7679a0dc@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48B1D5CA.8000607@gmail.com>
	 <20080827212130.4b8365a8@daedalus.pq.iki.fi>
	 <c62985530808280304x389cb958vff24b5d11f22d35c@mail.gmail.com>
	 <20080828214256.296e34ec@daedalus.pq.iki.fi>
	 <c62985530809040920v3c47b57ds40dfd400168bd501@mail.gmail.com>
	 <20080904203058.7e57729e@daedalus.pq.iki.fi>
	 <alpine.DEB.1.10.0809041407140.2431@gandalf.stny.rr.com>
	 <20080915224707.76b2cca0@daedalus.pq.iki.fi>
	 <alpine.DEB.1.10.0809151556260.22620@gandalf.stny.rr.com>
	 <20080916210114.7679a0dc@daedalus.pq.iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/16 Pekka Paalanen <pq@iki.fi>:
> Ok, so the problem is probably the commit I mentioned. It makes the
> no_tracer tracer to set tracer_enabled to 0, and I can't find where
> it would be set to 1 for mmiotrace. And this interferes with
> tracing_read_pipe(), making it quit when iter->pos is non-zero.
> See no_trace_init() in trace.c. According to this, the cat-quit
> occurs when the buffer gets empty after first data, but this isn't
> totally in agreement with what I recall from my experiments. And it
> does happen also on other times than injecting markers.
>
> So either it is wrong to check tracer_enabled in tracing_read_pipe(),
> or no_trace_init() should not touch it.

Indeed that could be the problem.
None_tracer is chosen as the default tracer when the tracer engine
loads. But actually no_trace_init is not called at this time.

But if you set another tracer and reset current_tracer to none, you
will call no_trace_init. Since tracer_enabled is not reset to 1 with
other tracer's init functions, the problem occurs when you choose one
more time another tracer.

I think that mmiotrace receives a smaller flow of entries (depends on
the debugged module) whereas sched_switch or function's tracer, as an
example, are continuously fed and never enter the "while
(trace_empty(iter))" block. That's why I only see this bug in
mmiotrace.

Perhaps it would be a good idea to reenable tracer_enabled on
tracing_set_trace_write() just before calling the init callback of the
tracer chosen.
