Return-Path: <linux-kernel-owner+w=401wt.eu-S1758039AbYH2Qan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039AbYH2Qan (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 12:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757146AbYH2QaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 12:30:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:52369 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756923AbYH2QaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 12:30:20 -0400
Date: Fri, 29 Aug 2008 09:30:17 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de
Subject: Re: [PATCH 4/5] select: make select() use schedule_hrtimeout()
Message-ID: <20080829093017.7ff4389d@infradead.org>
In-Reply-To: <alpine.LFD.1.10.0808290915560.3300@nehalem.linux-foundation.org>
References: <20080829080549.6906b744@infradead.org>
	<20080829080809.0e42a323@infradead.org>
	<alpine.LFD.1.10.0808290915560.3300@nehalem.linux-foundation.org>
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

On Fri, 29 Aug 2008 09:20:18 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Fri, 29 Aug 2008, Arjan van de Ven wrote:
> > 
> > now that we have schedule_hrtimeout(), make select() use it.
> > But only for short delays; really long delays are assumed to not
> > need the highres level of accuracy but rather want the regular
> > timer behavior for now.
> 
> This is _really_ ugly.
> 
> Can't you just do this relaxation in "schedule_hrtimeout()" instead,
> and just document the fact that the "high resolution" of hrtimeout is
> relative to the length of the timeout.

yes we can
(sorry, bad pun)
 
> It's not that select() doesn't care, it's that *NOBODY* cares. If
> somebody asks for a timeout of one second and 2 microseconds, the two
> microseconds simply don't matter. Ever. But if somebody asks for a
> timeout of 12 microseconds, individual microseconds probably _do_
> matter.

ok I'll do it this way; I wanted to avoid changing behavior for long
delays (some people think there's too much overhead in hrtimers or
something) but i'm totally fine with not doing this bifurbicated
braintwist at all.

> 
> So if you want high-resolution select/poll, then get rid of the
> "use_hr" logic entirely, and just do it unconditionally. Then, relax
> the scheduler timeouts in the scheduler.

ok, no big deal, see below

> 
> (But, that's probably _generally_ true. Even now, when people do 
> "schedule_timeout()", there's a big difference between asking for two 
> ticks and asking for two seconds. The latter should probably try to
> round to a nice timer tick basis for power reasons).

yes that's a separate story; this is what "range timers" are about and
David Woodhouse and I are working on that as well
(but this select stuff is basically a prerequisite to use that)

