Return-Path: <linux-kernel-owner+w=401wt.eu-S1752659AbYLTOPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbYLTOPg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 09:15:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbYLTOP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 09:15:29 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:49190 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbYLTOP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 09:15:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=D/a6ZLik3e/4bYscGE7H2QUUxfVledcRwOV6WZoSJRzWmCQsd0A9zo9Q1o4zODkpOI
         ZZqQ7v9DSLA0CoE6l8+5d3oeKjH5IAW/lXIKNHzR3gX9wFzJCFLOGnyVWmFVCS06ZWfL
         6x4Uvu+jpqmF/Ab2K8bsGh5fhdSpWsfOgkzik=
Message-ID: <c62985530812200615g6030c4c4gef71489aa5e35a5d@mail.gmail.com>
Date: Sat, 20 Dec 2008 15:15:26 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: ftrace behaviour (was: [PATCH] ftrace: introduce tracing_reset_online_cpus() helper)
Cc: "Pekka Paalanen" <pq@iki.fi>, "Pekka J Enberg" <penberg@cs.helsinki.fi>,
       mingo@elte.hu, linux-kernel@vger.kernel.org,
       "Markus Metzger" <markus.t.metzger@gmail.com>
In-Reply-To: <alpine.DEB.1.10.0812191827390.26234@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0812191207130.6888@melkki.cs.Helsinki.FI>
	 <c62985530812190247i705d9c3er7662a1b133c6eb29@mail.gmail.com>
	 <alpine.DEB.1.10.0812191216190.26432@gandalf.stny.rr.com>
	 <20081220004453.50aec846@daedalus.pq.iki.fi>
	 <alpine.DEB.1.10.0812191827390.26234@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/20 Steven Rostedt <rostedt@goodmis.org>:
> On Sat, 20 Dec 2008, Pekka Paalanen wrote:
>
>> Steven,
>>
>> I have some critique on where the tracing infrastructure has been going
>> to lately. Please, let me know if I am just out-of-date on the current
>> state or misunderstood something.
>
> I could always use a critique ;-)
>
>>
>> On Fri, 19 Dec 2008 12:20:18 -0500 (EST)
>> Steven Rostedt <rostedt@goodmis.org> wrote:
>>
>> >
>> > On Fri, 19 Dec 2008, Fr?d?ric Weisbecker wrote:
>> > >
>> > >
>> > > That's looks good.
>>
>> The mmiotrace part looks good, too.
>>
>> > > By the past, I also suggested Steven to automatically reset the traces
>> > > buffer each time a tracer is started, that
>> > > would factor out the code a bit more. I don't think one tracer would
>> > > avoid to reset the buffer once it is started, and
>> > > I don't think it is needed to reset twice on tracer switching: on stop
>> > > of the old tracer and on start on the new. Only
>> > > on start should be enough.
>> >
>> > I'm actually against the idea of reseting a trace everytime we enable it.
>> > That is:
>> >
>> > echo 1 > /debug/tracing/tracing_enabled
>> >
>> > This should not reset the tracer. I actually do tracing where I disable
>> > and enable it around areas I am interested in. I want all tracing, not
>> > just the last one.
>>
>> But doesn't this go against the fact, that you need to write 0 there to
>> be able to change the ring buffer size?
>>
>> I mean, is tracing_enabled a "pause button" as I recall you explaining
>> a long time ago, and again now, or "kill it all" as required for changing
>> the ring buffer size?
>
> It is more now a pause than kill it all. Although it never really did
> kill it all. Before the ring buffer, we needed to echo in 'none' to
> the current tracer before resizing. Now we can just get by with echoing 0
> to the tracing_enabled.
>
> I'm starting to like the idea that tracing_enabled is a lighter weight
> version of echoing the the tracer into the current_tracer file. Perhaps it
> should reset the buffer on a echo 1 > tracing_enabled. We now have a
> tracing_on that we can "pause" tracing with. The only thing that the
> tracing_on does is to stop writes to the ring buffer. It does not stop any
> of the infrastructure that does the tracing.
>
> Note, this is the main reason why you need to check for NULL on return of
> a ring_buffer_lock_reserve. That will return NULL when the tracing_on is 0.


I agree with the fact that tracing_enabled and tracing_on are both
confusing for a new user.
Perhaps it needs a little disambiguation.
With not rename tracing_on to ringbuffer_on ? That would give the idea
that tracing_enabled
acts on the tracing layer whereas ringbuffer_on is more a low level solution.

Or another solution if you consider to reset buffer when echo 0 >
tracing_enabled, so this
file can stay tracing_enabled and tracing_on could become tracing_pause.


>> Unless you have an answer to this, I'd like to suggest we resurrect the
>> "none" tracer. When "none" is the current tracer, there would be no
>> buffers allocated at all, and you could request a new buffer size.
>> "none" would be the default. Do you see any problems here?
>>
>> AFAIK the "nop" tracer will not do, because it still allows text
>> messages (markers) to be written, and hence the ring buffer must
>> exist. Or am I wrong?
>
> No, you are quite right. We could recreate the 'none' tracer again that
> has no buffer. At boot up it would be the default tracer, unless something
> else changes that.


If none tracer is recreated, I would suggest to rename nop tracer to
"print tracer" with
the single purpose of allowing to print the ftrace_printk entries....
Since there already have been
a patch to add an ftrace_printk tracer, that would make sense.

Again, that would be a future disambiguation between the nop and none
tracer inside available_tracer file.
