Return-Path: <linux-kernel-owner+w=401wt.eu-S1755823AbZDGFrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823AbZDGFrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 01:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755136AbZDGFqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 01:46:55 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:2062 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819AbZDGFqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 01:46:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rS7oDjufNgqLyANX2E/Ayh1woGQzpyNGsPii6/BRRSOOs6uuQH/oeG0DQG+UM1DaBA
         jokPsIyThuyLfm/CfaHJfcLcy8bBhbrtaAex7pg4bo0GVl8Wgeluy1JFg6scrYrI3Lsl
         A+Ozga+RmC0sXVA/7pigVEKowkC0yE/74HMHY=
Subject: Re: [PATCH 4/4] tracing/filters: use ring_buffer_discard_commit
 for discarded events
From: Tom Zanussi <tzanussi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <alpine.DEB.2.00.0904021033080.965@gandalf.stny.rr.com>
References: <20090402052721.013878388@goodmis.org>
	 <20090402053522.834546042@goodmis.org> <1238663187.6621.13.camel@bookworm>
	 <alpine.DEB.2.00.0904021033080.965@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Tue, 07 Apr 2009 00:46:49 -0500
Message-Id: <1239083209.7220.42.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 11:01 -0400, Steven Rostedt wrote:
> On Thu, 2 Apr 2009, Tom Zanussi wrote:
> 
> > Hi Steve,
> > 
> > Great to see this!  I updated my filter removal rcu patch, made some
> > changes to the filter_check_discard() to work with the new
> > ring_buffer_discard_commit() and made the necessary changes to the
> > ftrace tracers as well - see the patch below, which has only been
> > touch-tested at this point.  It seemed to work at first, but then
> > produced an oops, which may well be a problem related to the changes I
> > made.  I'll look into it more tomorrow night, and will also fix up this
> > patch and repost it if it basically looks ok.  I'll post the oops and
> > the lines of code that it refers to just in case it it rings a bell...
> 
> Yeah, it looks like it is related to changes that you made ;-)
> 
> > 
> > [  240.461982] ------------[ cut here ]------------
> > [  240.461993] WARNING: at kernel/trace/ring_buffer.c:1610
> > ring_buffer_discard_commit+0xfa/0x100()
> 
> > [  240.462259] Pid: 6143, comm: bash Not tainted 2.6.29-tip #35
> > [  240.462267] Call Trace:
> > [  240.462280]  [<ffffffff8025c5c8>] warn_slowpath+0xd8/0x130
> > [  240.462291]  [<ffffffff802c2be5>] ? rb_reserve_next_event+0x45/0x360
> > [  240.462304]  [<ffffffff802c6fc1>] ? trace_buffer_lock_reserve
> > +0x51/0x70
> > [  240.462316]  [<ffffffff802c12ea>] ? ring_buffer_unlock_commit
> > +0x5a/0x60
> > [  240.462329]  [<ffffffff802c2be5>] ? rb_reserve_next_event+0x45/0x360
> > [  240.462340]  [<ffffffff802c30cb>] ? ring_buffer_lock_reserve
> > +0x9b/0xe0
> > [  240.462354]  [<ffffffff8035f42b>] ? dnotify_parent+0xb/0xc0
> > [  240.462365]  [<ffffffff8032af65>] ? vfs_write+0x155/0x1d0
> > [  240.462375]  [<ffffffff802c1e2a>] ring_buffer_discard_commit
> > +0xfa/0x100
> > [  240.462386]  [<ffffffff8035f42b>] ? dnotify_parent+0xb/0xc0
> > [  240.462396]  [<ffffffff802c843b>] trace_function+0xab/0xc0

[...]

> The bug does not stick out in this patch set. Perhaps it is part of the 
> original too?  But something somewhere is calling the discard outside the 
> reserve and commit.
> 

It doesn't stick out to me either - the funny thing is that it only
happens with CONFIG_PREEMPT_VOLUNTARY - with CONFIG_PREEMPT it's fine.

In fact, with CONFIG_PREEMPT_VOLUNTARY, an RB_WARN_ON(!preempt_count())
right after frace_preempt_disable() triggers immediately, which unless
I'm missing something, should never happen.  Is there a bug in
PREEMPT_VOLUNTARY?

Tom

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 7a6209f..bac9ab7 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1494,6 +1494,8 @@ ring_buffer_lock_reserve(struct ring_buffer *buffer, unsigned long length)
 	/* If we are tracing schedule, we don't want to recurse */
 	resched = ftrace_preempt_disable();
 
+	RB_WARN_ON(buffer, !preempt_count());
+
 	cpu = raw_smp_processor_id();
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))


> -- Steve
> 

