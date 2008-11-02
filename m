Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbYKBRRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbYKBRRx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 12:17:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbYKBRRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 12:17:44 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:11962 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbYKBRRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 12:17:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=MC1l+mxAP6GYaCZI1B4lsDEtARup6unjpWngiruchU9lTl4UlIf6Hlbvu2BQdL+2sO
         9vI5smn+6xjdIq+SFUk1Ez79utPSFaTbEzgR3eVeVoCyzDocIgphLBGVFOPOK13JCh1K
         j7x+0Auvr4Bdkb3U9FGPjXkgiKffmm5GV84MI=
Date: Sun, 2 Nov 2008 19:17:37 +0200
From: Pekka Paalanen <pq@iki.fi>
To: "=?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker" <fweisbec@gmail.com>
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Tracing framework regressions in 2.6.28-rc2
Message-ID: <20081102191737.37c32729@daedalus.pq.iki.fi>
In-Reply-To: <c62985530811020852q1807ddc7ide08bac3630d9ff@mail.gmail.com>
References: <20081102183534.1bdc6779@daedalus.pq.iki.fi>
	<c62985530811020852q1807ddc7ide08bac3630d9ff@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Nov 2008 17:52:02 +0100
"Frédéric Weisbecker" <fweisbec@gmail.com> wrote:

> Hi Pekka!
> 
> 2008/11/2 Pekka Paalanen <pq@iki.fi>:
> > Hi all,
> >
> > I finally had the time to check how mmiotrace works in 2.6.28-rc2.
> > On the first try I didn't find any mmiotrace problems, I traced the
> > Nouveau DRM driver just fine, but the file /debug/tracing/current_tracer
> > has started to misbehave.
> >
...
> > Now, whatever I echo to current_tracer, I get EINVAL.
> > What's more confusing, if I do
> > echo mmiotrace > /debug/tracing/current_tracer
> > then I see the EINVAL error *and* mmiotrace is activated!
> >
> > The problem is with newlines, with 'echo -n' it works as it should.
> >
> > I'm starting to think the patch itself is fine, but it exposes an
> > assumption in the write fop: a single write call contains all the
> > data. I suspect there are actually two write calls in case of 'echo':
> > one with 'mmiotrace' and one with '\n'. I don't see how else I could
> > get the behaviour I get.
> 
> 
> A patch has been applied for this in the mainline, the issue will be
> fixed for rc3:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=60063a66236c15f5613f91390631e06718689782

Oh wow, that was a simple fix. Thanks for pointing it out!
Although it still leaves, AFAIK, the issue of multiple write calls,
but I guess we can still live as we used to.

> > Another issue is the disappeared 'none' pseudo-tracer, which seems
> > to be replaced with the 'nop' real tracer. Is using 'nop' now equivalent
> > to the previous 'none' tracer?
> 
> Yes. A nop tracer has been released to have a kind of pattern to write
> new tracers, and to have a tracer that does
> nothing but is able to show user marks for example.
> Since it does nothing, we replaced the none tracer by this one.
> 
> > I mean, when the 'nop' tracer is current, are all tracing calls no-ops and
> > nothing will ever get into the ring buffer?
> > I have to update the mmiotrace documentation about disabling tracing.
> 
> Hhm not really, you can receive pseudo entries like user marks. But
> you can disable all the tracing by setting 0 to
> tracing_enabled.

I thought the original purpose of /debug/tracing/tracing_enabled flag was
to pause tracing, and not issue a full shutdown. And it still is not a
full tracing framework shutdown. I know mmiotrace did not bother to
implement this behaviour, but just tears everything down. I don't know
about the other tracers.

I'm just thinking, that having a proper 'none' pseudo-tracer would allow
to release the huge ring buffers, and allocate them only when any other
tracer becomes current. In my original mail I asked about the ring buffer
allocation.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
