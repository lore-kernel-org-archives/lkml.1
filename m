Return-Path: <linux-kernel-owner+w=401wt.eu-S1752740AbZKGTwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbZKGTwF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 14:52:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbZKGTwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 14:52:04 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:38081 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbZKGTwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 14:52:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=v3b71IIqZmRns6Xwg33EF6cuw7rAnMaOQPvm1WMKtz72GE5VnXaeGOfjgJT15s8u2/
         ozH5D3yGKj2/mUKGNPlj4ESSSq0YWd0Sp+5NIBAmsFpsru3kKtxW62EkOJDdLVWNRewl
         AhYhWergLpVOEsd1a8hYi0wwF8nbj53YIJVrY=
Date: Sat, 7 Nov 2009 20:52:09 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Avi Kivity <avi@redhat.com>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 4/6] hw-breakpoints: Rewrite the hw-breakpoints layer
	on top of perf events
Message-ID: <20091107195204.GA4930@nowhere>
References: <1257275474-5285-1-git-send-email-fweisbec@gmail.com> <1257275474-5285-5-git-send-email-fweisbec@gmail.com> <19186.5488.320389.567026@cargo.ozlabs.ibm.com> <20091105110951.GB4877@nowhere> <19189.17876.115917.777652@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19189.17876.115917.777652@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 07, 2009 at 09:03:00PM +1100, Paul Mackerras wrote:
> Frederic Weisbecker writes:
> 
> > On Thu, Nov 05, 2009 at 10:59:44AM +1100, Paul Mackerras wrote:
> > > What I haven't managed to understand yet is how you provide reliable
> > > breakpoints for debugging purposes.  If I'm debugging a program and I
> > > have set a breakpoint, I'll be very unhappy if the breakpoint should
> > > trigger but doesn't because the perf_event infrastructure has decided
> > > it can't schedule that breakpoint in.  If the breakpoint isn't going
> > > to work then I want to know that at the time that I set it.
> > 
> > 
> > 
> > That won't happen because of the set of constraints we have.
> > We never overcommit the debug register resources, except in
> > the case of non-pinned counter, but that's in their nature :)
> 
> Suppose you have 4 breakpoint registers per cpu and there are two
> pinned per-cpu breakpoint events, three non-pinned per-cpu breakpoint
> events, and one pinned per-task breakpoint event.  I believe your
> constraints will allow that situation.
> 
> What will happen is that the two pinned per-cpu breakpoint events will
> use two of the hardware registers, and the three non-pinned per-cpu
> breakpoint events will get round-robined onto the other two hardware
> registers.  The per-task breakpoint will never get to use a hardware
> register, because the code in perf_event.c schedules per-cpu events
> before it schedules per-task events (see for example
> perf_event_task_tick()).



Oh! :-(

 
> We will have to make the event scheduling in kernel/perf_event.c a bit
> more sophisticated before we can guarantee that a pinned breakpoint
> event will always get to use a hardware register.
> 
> Paul.


Ok, so the only solution for now (a part from fixing that into perf) is to
consider the non-pinned events as being pinned in the constraints.

