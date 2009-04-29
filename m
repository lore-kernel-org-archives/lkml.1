Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbZD2Hp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbZD2Hp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 03:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbZD2HpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 03:45:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39782 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752042AbZD2HpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 03:45:09 -0400
Date: Wed, 29 Apr 2009 00:41:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 5/5] ring-buffer: fix printk output
Message-Id: <20090429004141.5f0565c9.akpm@linux-foundation.org>
In-Reply-To: <20090429072208.GA22129@elte.hu>
References: <20090429044814.138790038@goodmis.org>
	<20090429045908.394874083@goodmis.org>
	<20090428222024.8db50539.akpm@linux-foundation.org>
	<20090429054359.GA6148@elte.hu>
	<20090428225541.9ca61a12.akpm@linux-foundation.org>
	<20090429060955.GD6148@elte.hu>
	<20090428232000.6c3d4ce1.akpm@linux-foundation.org>
	<20090429072208.GA22129@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009 09:22:08 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Wed, 29 Apr 2009 08:09:55 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > 
> > > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > > 
> > > > On Wed, 29 Apr 2009 07:43:59 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> > > > 
> > > > > 
> > > > > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > > 
> > > > > > On Wed, 29 Apr 2009 00:48:19 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:
> > > > > > 
> > > > > > > -	printk_once(KERN_WARNING "Tracing recursion: depth[%d]:"
> > > > > > > +	printk_once(KERN_WARNING "Tracing recursion: depth[%ld]:"
> > > > > > 
> > > > > > hrmph.  I didn't know that printk_once() existed, and I should 
> > > > > > have known.  I wonder how many other people don't know.
> > > > > 
> > > > > Was posted to linux-next@vger.kernel.org.
> > > > 
> > > > Well no wonder I didn't know about it.
> > > 
> > > I (too?) think it's counter-productive that the linux-next list is 
> > > split out of lkml. I constantly fall into that trap: i get a 
> > > bugreport against one of our trees, i see that there's vger in the 
> > > Cc: list and mistake it for being Cc:-ed to lkml (all our trees are 
> > > developed on lkml and most of the bugreports come Cc:-ed to lkml) 
> > > but in reality it's Cc:-ed to linux-next which has a much smaller 
> > > audience. (which audience apparently does not even include you)
> > > 
> > > If this email list fragmentation and the resoluting loss of 
> > > information bothers you too then please ask Stephen to move 
> > > linux-next mails to lkml (i've Cc:-ed Stephen) - it's not like it's 
> > > actually something separate ... today's linux-next messages are 
> > > tomorrow's lkml messages. Moving linux-next mails to lkml would 
> > > nicely improve the S/N ratio on lkml.
> > > 
> > 
> > eh.  Just auto-add lkml to tipbot-commit emails?
> 
> Yeah - the tip-commits-bot already has such a feature and we are 
> making use of it - but this commit predates it. So it was posted to 
> linux-next and the tip-commits list.

there's a tip-commits list?

> My larger point remains, about possibly embedding linux-next into 
> lkml. I couldnt think of a single linux-next mail that isnt relevant 
> to lkml. It's all about commits that are destined for upstream in 
> 0-2.5 months.

Sure, I'd be OK with zapping the linux-next list.

> > printk_once() is racy on smp and preempt btw ;)
> 
> Like WARN_ONCE() and WARN_ON_ONCE(). It's really an "oh crap" 
> facility, not for normal kernel messages.
> 
> Do we want to complicate them with locking and preemption - or 
> should we just concentrate on getting the "oh crap" message out to 
> the syslog (before it's possibly too late to get anything out)?
> 
> I have no strong opinion about it - but i tend to like the simpler 
> method most. printk + stack dumps themselves arent atomic to begin 
> with.

Well, it's hardly likely to be a problem.  otoh, if two CPUs _do_ hit
the thing at the same time, the resulting output will be all messed up
and we'd really like to see it.

Easily fixed with test_and_set_bit()?
