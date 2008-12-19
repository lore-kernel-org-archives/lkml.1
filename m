Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbYLSWpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbYLSWpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 17:45:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbYLSWpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 17:45:04 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:53774 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbYLSWpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 17:45:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=SU94ZrSzw1YUGUX3mykLlhPG1VgV2u+OB6vVYx2glcuvQDcEO5mIEPmrrggHS94Nb+
         m4woCWrrciGb8oYZ8ScnW7vik5mazJ5i9NFK+AgkJ1gILm+9A4vmg1icS/d4u4azxOC5
         De2bnRRAK0NzD9fb0dJBADY6E6neaCd2sW5jU=
Date: Sat, 20 Dec 2008 00:44:53 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Pekka J Enberg <penberg@cs.helsinki.fi>, mingo@elte.hu,
       linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@gmail.com>
Subject: ftrace behaviour (was: [PATCH] ftrace: introduce
 tracing_reset_online_cpus() helper)
Message-ID: <20081220004453.50aec846@daedalus.pq.iki.fi>
In-Reply-To: <alpine.DEB.1.10.0812191216190.26432@gandalf.stny.rr.com>
References: <Pine.LNX.4.64.0812191207130.6888@melkki.cs.Helsinki.FI>
	<c62985530812190247i705d9c3er7662a1b133c6eb29@mail.gmail.com>
	<alpine.DEB.1.10.0812191216190.26432@gandalf.stny.rr.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven,

I have some critique on where the tracing infrastructure has been going
to lately. Please, let me know if I am just out-of-date on the current
state or misunderstood something.

On Fri, 19 Dec 2008 12:20:18 -0500 (EST)
Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Fri, 19 Dec 2008, Fr?d?ric Weisbecker wrote:
> > 
> > 
> > That's looks good.

The mmiotrace part looks good, too.

> > By the past, I also suggested Steven to automatically reset the traces
> > buffer each time a tracer is started, that
> > would factor out the code a bit more. I don't think one tracer would
> > avoid to reset the buffer once it is started, and
> > I don't think it is needed to reset twice on tracer switching: on stop
> > of the old tracer and on start on the new. Only
> > on start should be enough.
> 
> I'm actually against the idea of reseting a trace everytime we enable it.
> That is:
> 
> echo 1 > /debug/tracing/tracing_enabled
> 
> This should not reset the tracer. I actually do tracing where I disable 
> and enable it around areas I am interested in. I want all tracing, not 
> just the last one.

But doesn't this go against the fact, that you need to write 0 there to
be able to change the ring buffer size?

I mean, is tracing_enabled a "pause button" as I recall you explaining
a long time ago, and again now, or "kill it all" as required for changing
the ring buffer size?

Or has something changed that I don't know about?

Also another important but not so related question:
are the ring buffers allocated always on boot, whenever any tracer
(say, only mmiotrace) is enabled in the kernel configuration?

The ring buffers are huge and eat a considerable chunk of precious RAM.
How could distributors ever enable mmiotrace in their kernel
configurations by default, if it eats lots of memory for nothing?

If distributors do not enable mmiotrace by default, we are in a worse
situation than with out-of-tree mmiotrace module (if it could work).
Users need to reconfigure and recompile their kernels, which is
something we wanted to avoid. This is the reality right now.

Unless you have an answer to this, I'd like to suggest we resurrect the
"none" tracer. When "none" is the current tracer, there would be no
buffers allocated at all, and you could request a new buffer size.
"none" would be the default. Do you see any problems here?

AFAIK the "nop" tracer will not do, because it still allows text
messages (markers) to be written, and hence the ring buffer must
exist. Or am I wrong?

> Now we have recently added /debug/tracing/tracing_on which can quickly 
> stop tracing. I may be able to use that, and we can let the 
> tracing_enable" reset it too.

Does this mean I have to implement yet another on/off hook?

IMHO it is starting to be confusing having all these
current_tracer, tracing_enabled, tracing_on etc.

> I'll have to take a look at my scripts to see if that would work.
> 
> -- Steve


Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
