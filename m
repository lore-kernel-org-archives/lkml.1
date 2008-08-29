Return-Path: <linux-kernel-owner+w=401wt.eu-S1758830AbYH2Rmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830AbYH2Rmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 13:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419AbYH2RmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 13:42:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:53281 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920AbYH2RmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 13:42:22 -0400
Date: Fri, 29 Aug 2008 10:42:20 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@tglx.de
Subject: Re: [PATCH 4/5] select: make select() use schedule_hrtimeout()
Message-ID: <20080829104220.600096a5@infradead.org>
In-Reply-To: <alpine.LFD.1.10.0808291009450.3300@nehalem.linux-foundation.org>
References: <20080829080549.6906b744@infradead.org>
	<20080829080809.0e42a323@infradead.org>
	<alpine.LFD.1.10.0808290915560.3300@nehalem.linux-foundation.org>
	<20080829171108.63e6dcd4@lxorguk.ukuu.org.uk>
	<alpine.LFD.1.10.0808291009450.3300@nehalem.linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008 10:26:02 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Fri, 29 Aug 2008, Alan Cox wrote:
> >
> > > "schedule_timeout()", there's a big difference between asking for
> > > two ticks and asking for two seconds. The latter should probably
> > > try to round to a nice timer tick basis for power reasons).
> > 
> > I disagree - that is fixing the problem in the wrong place. The
> > timer structure needs an accuracy field of some form that the
> > existing timer functions initialise to 0.
> 
> I do agree that we could do that too, but you miss one big issue:
> even if we were to add an accuracy field inside the kernel, there is
> no such field in the user interfaces.
> 
> We just pass timevals (and sometimes timespecs) around, and no, they
> don't have any way to specify accuracy.
> 
> Yeah, we could use the high bits in the usec/nsec words, but then
> older kernels would basically do random things, so that would be a
> horrible interface.
> 
> The other thing to do would be to just add totally new system calls
> with totally new interfaces, but (a) nobody would use them anyway and
> (b) it's simply not worth it.
> 
> So given that reality, and _if_ we want to support nice
> high-resolution sleeping by select/poll, the only reasonable thing to
> do is to estimate some kind of expected accuracy from the existing
> timeval/timespec.
> 
> And the only reasonable way to do that is to just look at the range.
> You can probably do something fairly trivial with


that works

one of the things we were thinking about was to also have a field in
the task struct (so inherited over fork/exec) that is the default
"slack", which can be set via a prctl, so that an admin can do a "nice"
like thing and run certain known silly apps at different granularity
(and a bunch of smart tricks in some key apps that we'll then do)



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
