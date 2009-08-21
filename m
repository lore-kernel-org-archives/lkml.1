Return-Path: <linux-kernel-owner+w=401wt.eu-S932673AbZHUUfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673AbZHUUfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 16:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932514AbZHUUfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 16:35:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40833 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932529AbZHUUfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 16:35:30 -0400
Date: Fri, 21 Aug 2009 22:35:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: ioctls vs syscalls once again
Message-ID: <20090821203510.GB15439@elte.hu>
References: <20090816004705.GA7347@infradead.org> <20090819203916.GA25296@elte.hu> <20090820010552.GA22107@infradead.org> <20090821124638.GC10263@elte.hu> <20090821181823.GA29918@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090821181823.GA29918@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> [ chaged the subject and droped the cc list down as this is not 
>   about discard support anymore]

( it was a good example though, showing where a new ioctl gets
  introduced/proposed. )

> On Fri, Aug 21, 2009 at 02:46:38PM +0200, Ingo Molnar wrote:
> > > ioctl is per defintion a multiplexer.
> > 
> > Yes, and? There's two variants of multiplexing:
> > 
> >   - multiplex something rather straightforward and related
> >   - multiplex unrelated fields, data, structures
> > 
> > I consider the second one 'ugly', the first one 'ok-ish'. YMMV.
> 
> Exactly.  And ioctl is per defintion the latter. [...]

Just to nitpick: not necessarily. A single-purpose ioctl with no 
parameter is obviously not going to multiplex anything - and we have 
some (although not typical - ioctls are addictive and quickly 
attract messy extensions).

( it might still be considered slightly bad style simply due to the
  generic suckiness of type-opaque ioctls as an interface - but 
  that's another matter. )

> [...]  sys_ioctl is a way to give drivers (and in Linux 
> filesystem, too) a way to implement their own syscall table 
> extension for file descritors they control.  While there might be 
> a few "ok-ish" or "nice" ioctl handlers most of them are ugly.  
> That's why people don't like them too much, btw :)

Can you name a single ok-ish ioctl from the kernel source?

> > I'd like to understand the technical basis of your critisism and 
> > i'd like to address any deficiencies of the perfcounters code. 
> > You said you dont like the ioctl solution we have, but that 
> > you'd like a separate syscall even less.
> 
> I really don't like any ioctl solution very much.  But sometimes 
> it's the lesser of the evils, often by a bug margin.

Well if something is the best possible technical solution, how can 
it be evil? (even if lesser than another evil)

That's what i dont understand about your position: i've yet to see 
you react _positively_ to any perfcounters interface, be that 
syscall, ioctl or any proposed imaginery API. Is there _anything_ 
you would react positively to? :-)

> > Perfcounters are a kernel-wide concept, encompassing 100% of all 
> > Linux installations, not just some special hardware.
> 
> That doesn't really matter.  The tty code is also used by 100% of 
> the Linux installation, and still it implements the tty controls 
> as ioctls.

I consider the tty ioctls rather ugly: they have multiple demux 
layers often hiding important details deep in the bowels of the Nth 
level of obfuscation. The variants go into the several dozens.

But ... the ioctl interface for TTYs was really inherited as an 
external compatibility constraint early on, used by a ton of 
applications, so there was not much to be done about that.

Hindsight is always easy but it might have lead to a cleaner TTY 
subsystem in general, had it gotten its own system calls (i mean, 
controlling/setting details of terminal output and input is 
certainly important enough to be raised to the level of system 
calls), nicely abstracted out.

Not possible for TTY - but for new code there's no such excuse 
though.

> Generally having system calls that don't operate on file 
> descriptor genericly (that doesn't mean implemented everywhere, 
> but beeing a generic concept dispatched through file operations) 
> is pretty ugly. We have a lot of them anyway, e.g. the socket 
> system calls, eventfd, inotify.  They don't really buy us anything 
> over ioctls, but they are accepted.  So if you design a clean 
> system call working on perfcounters file descriptor no one could 
> have hard objection (as in actually saying no).  But if you really 
> just do another stupid muliplexer just go for ioctl instead of 
> reinventing the dispatching and multiplexing.

Well, but that's what we have for perfcounters really: there's a 
clean system call plus an ioctl that multiplexes very simple 
IO-alike ops. (which borderline passes as an 'IO control' as well)

I'm trying to figure out where the boundary is - how long should we 
extend the ioctls and when should we start shuffling that 
functionality into new system calls (cleanly designed and done of 
course).

	Ingo
