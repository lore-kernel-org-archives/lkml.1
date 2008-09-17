Return-Path: <linux-kernel-owner+w=401wt.eu-S1755101AbYIQRg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101AbYIQRg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 13:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992AbYIQRgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 13:36:19 -0400
Received: from qb-out-0506.google.com ([72.14.204.232]:26471 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbYIQRgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 13:36:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=XaXgD8DQvNrbfew6PngIPdj81tHSNMqwiCxyh7fv+vvVdG9z0c5qtVxJGs/0UoXhVB
         Q7viwiVo2+RLS0EPKJkzJUlz24riGle6/M2+GXc7FTAVV4IWzG/G2zn5Y7yieE6t4yF3
         EqfcX/x4nJ0eGOC9m0dxDOcaiZpFbdYx4fxkk=
Date: Wed, 17 Sep 2008 20:36:09 +0300
From: Pekka Paalanen <pq@iki.fi>
To: "Steven Rostedt" <rostedt@goodmis.org>
Cc: "=?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker" <fweisbec@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: Tracing/ftrace: trouble with trace_entries and trace_pipe
Message-ID: <20080917203609.71470e4b@daedalus.pq.iki.fi>
In-Reply-To: <c62985530809170541p5bdcbfb4xf21232842e7b8b9@mail.gmail.com>
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
	<c62985530809170541p5bdcbfb4xf21232842e7b8b9@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2008 14:41:29 +0200
"Frédéric Weisbecker" <fweisbec@gmail.com> wrote:

> 2008/9/16 Pekka Paalanen <pq@iki.fi>:
> > Ok, so the problem is probably the commit I mentioned. It makes the
> > no_tracer tracer to set tracer_enabled to 0, and I can't find where
> > it would be set to 1 for mmiotrace. And this interferes with
> > tracing_read_pipe(), making it quit when iter->pos is non-zero.
> > See no_trace_init() in trace.c. According to this, the cat-quit
> > occurs when the buffer gets empty after first data, but this isn't
> > totally in agreement with what I recall from my experiments. And it
> > does happen also on other times than injecting markers.
> >
> > So either it is wrong to check tracer_enabled in tracing_read_pipe(),
> > or no_trace_init() should not touch it.
> 
> Indeed that could be the problem.
> None_tracer is chosen as the default tracer when the tracer engine
> loads. But actually no_trace_init is not called at this time.
> 
> But if you set another tracer and reset current_tracer to none, you
> will call no_trace_init. Since tracer_enabled is not reset to 1 with
> other tracer's init functions, the problem occurs when you choose one
> more time another tracer.

Ah, this would explain the "non-deterministic" behaviour I saw.

> I think that mmiotrace receives a smaller flow of entries (depends on
> the debugged module) whereas sched_switch or function's tracer, as an
> example, are continuously fed and never enter the "while
> (trace_empty(iter))" block. That's why I only see this bug in
> mmiotrace.

Mmiotrace does see times, when there are a small number of events
coming, even when tracing a graphics driver. Sounds plausible.

> Perhaps it would be a good idea to reenable tracer_enabled on
> tracing_set_trace_write() just before calling the init callback of the
> tracer chosen.

That's a third option, yes.

Steven, what is the correct fix?

Frederic, thank you very much for testing this!

-- 
Pekka Paalanen
http://www.iki.fi/pq/
