Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbZD2PNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbZD2PNU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 11:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbZD2PNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 11:13:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752151AbZD2PNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 11:13:05 -0400
Date: Wed, 29 Apr 2009 08:09:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 5/5] ring-buffer: fix printk output
Message-Id: <20090429080907.efb8ba2f.akpm@linux-foundation.org>
In-Reply-To: <20090429095625.GE31185@elte.hu>
References: <20090429044814.138790038@goodmis.org>
	<20090429045908.394874083@goodmis.org>
	<20090428222024.8db50539.akpm@linux-foundation.org>
	<20090429054359.GA6148@elte.hu>
	<20090428225541.9ca61a12.akpm@linux-foundation.org>
	<20090429060955.GD6148@elte.hu>
	<20090428232000.6c3d4ce1.akpm@linux-foundation.org>
	<20090429072208.GA22129@elte.hu>
	<20090429004141.5f0565c9.akpm@linux-foundation.org>
	<20090429095625.GE31185@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009 11:56:25 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> > > My larger point remains, about possibly embedding linux-next 
> > > into lkml. I couldnt think of a single linux-next mail that isnt 
> > > relevant to lkml. It's all about commits that are destined for 
> > > upstream in 0-2.5 months.
> > 
> > Sure, I'd be OK with zapping the linux-next list.
> 
> Another, less drastic solution would be to keep it as an _alias_ 
> list. All mails posted to it also go to lkml, but it would still be 
> subscribe-able separately.

That would work, although I wonder about the potential for duplicates
turning up somewhere.

> ( This has come up before and this would be useful for a number of 
>   other things - such as tracing/instrumentation. Someone who is 
>   only interested in instrumentation related discussions could 
>   subscribe to that list. )
> 
> > > > printk_once() is racy on smp and preempt btw ;)
> > > 
> > > Like WARN_ONCE() and WARN_ON_ONCE(). It's really an "oh crap" 
> > > facility, not for normal kernel messages.
> > > 
> > > Do we want to complicate them with locking and preemption - or 
> > > should we just concentrate on getting the "oh crap" message out 
> > > to the syslog (before it's possibly too late to get anything 
> > > out)?
> > > 
> > > I have no strong opinion about it - but i tend to like the 
> > > simpler method most. printk + stack dumps themselves arent 
> > > atomic to begin with.
> > 
> > Well, it's hardly likely to be a problem.  otoh, if two CPUs _do_ 
> > hit the thing at the same time, the resulting output will be all 
> > messed up and we'd really like to see it.
> > 
> > Easily fixed with test_and_set_bit()?
> 
> but if two CPUs hit it at once then the printk+stack-dump itself is 
> already mixed up. So if we do any atomicity it should be done for 
> all the print-once APIs. (note, lockdep does such message-atomicity 
> already, in its own facility)

Confused.

<gets distracted by FW_BUG and friends.  ytf are they in kernel.h?>

#define printk_once(x...) ({				\
	static unsigned long __print_once;		\
							\
	if (!test_and_set_bit(0, &__print_once))	\
		printk(x);				\
})

How can	two CPUs do the printk(x)?
