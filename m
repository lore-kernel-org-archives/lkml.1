Return-Path: <linux-kernel-owner+w=401wt.eu-S1754445AbYIJRwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbYIJRwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 13:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbYIJRwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 13:52:32 -0400
Received: from smtp-out.google.com ([216.239.33.17]:59232 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbYIJRwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 13:52:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:from:to:cc:in-reply-to:references:content-type:
	organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=QJeV6fSD0vsgrovI5LkZ3y5CUEy1izHH5WtTN+Ax4uJx9PVizXPz20A5NXXKpPzF4
	4zO20UWSEvZ9t9o/FujQQ==
Subject: Re: [PATCH 2.6.27-rc5] Fix itimer/many thread hang.
From: Frank Mayhar <fmayhar@google.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080910121251.GB220@tv-sign.ru>
References: <1220906643.31846.21.camel@bobble.smo.corp.google.com>
	 <20080909070329.GD2086@elte.hu> <20080909160152.GA714@tv-sign.ru>
	 <1220992172.23059.20.camel@bobble.smo.corp.google.com>
	 <20080910121251.GB220@tv-sign.ru>
Content-Type: text/plain
Organization: Google, Inc.
Date: Wed, 10 Sep 2008 10:50:58 -0700
Message-Id: <1221069058.25218.10.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-10 at 16:12 +0400, Oleg Nesterov wrote:
> On 09/09, Frank Mayhar wrote:
> >
> > On Tue, 2008-09-09 at 20:01 +0400, Oleg Nesterov wrote:
> >
> > > As for this particular function, it seems to me that ->signal == NULL
> > > is not possible, no?
> >
> > That's not completely clear to me.  I'm allowing for the possibility
> > that it might be called during, say, process teardown.  It's used in so
> > many places that I'm uncomfortable leaving the == NULL check out.
> 
> Please see my reply to Roland.

I saw it.  I dunno, I'm more of the "belt-and-suspenders" mindset.  I'll
add a comment, thought, that this is probably a "can't happen" but we
check it anyway.

> > > Btw, this function has a lot of callers, perhaps it is better to
> > > uninline it.
> >
> > If that's the consensus I'll do so.  I assumed that speed was more
> > important than space in this case.  Am I mistaken?
> 
> Are you sure inline will be faster? It has a lot of calllers, think
> about i-cache. And the function call is not that expensive.

Hmm.  It just seems to me that making it inline enables the optimizer to
do smarter things with the flow of control.  The routine isn't all that
long, disassembling the posix_cpu_timers_exit_group() routine gives a
good view of it and it appears to be around 120 bytes.  Certainly less
than 200 bytes (all of posix_cpu_timers_exit_group() is only 201 bytes).
That doesn't seem like a cache buster but I defer to those who are more
familiar with this stuff.

> > > So, the first CLONE_THREAD creates ->cputime.totals. After that
> > > thread_group_cputime_account_xxx() start to use it even if the task
> > > doesn't have the attached cpu timers.
> > >
> > > Stupid question: can't we allocate .totals in posix_cpu_timer_create() /
> > > set_process_cpu_timer() ?
> >
> > That was the original plan but we (that is, Roland and I) decided to
> > eliminate the separate storage for the dead-threads totals.  It's now
> > all kept in the totals field, for the whole thread group.
> 
> I see, thanks.

You're welcome.  I actually like the new method of keeping track of this
stuff; it seems cleaner and certainly removes the requirement of walking
the thread group to add it up.  Should help some microbenchmarks, at
least. :-)
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

