Return-Path: <linux-kernel-owner+w=401wt.eu-S1754493AbXHHEPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbXHHEPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 00:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750768AbXHHEPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 00:15:35 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56431 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750734AbXHHEPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 00:15:33 -0400
Date: Tue, 7 Aug 2007 21:14:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] msleep() with hrtimers
Message-Id: <20070807211401.7078c12d.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0708080535140.1817@scrub.home>
References: <15327.1186166232@lwn.net>
	<20070807124009.9f6c2247.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0708080115020.1817@scrub.home>
	<20070807162940.74f536f8.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0708080535140.1817@scrub.home>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007 05:47:02 +0200 (CEST) Roman Zippel <zippel@linux-m68k.org> wrote:

> 
> 
> On Tue, 7 Aug 2007, Andrew Morton wrote:
> 
> > On Wed, 8 Aug 2007 01:16:49 +0200 (CEST)
> > Roman Zippel <zippel@linux-m68k.org> wrote:
> > 
> > > Hi,
> > > 
> > > On Tue, 7 Aug 2007, Andrew Morton wrote:
> > > 
> > > > I'd be surprised if there was significant overhead - the maximum frequency
> > > > at which msleep() can be called is 1000Hz.  We'd need an awful lot of
> > > > overhead for that to cause problems, surely?
> > > > 
> > > > <thinks he's missing something again>
> > > 
> > > _Anybody_ has yet to answer what's wrong with adding a nanosleep() and 
> > > using that instead.
> > > 
> > 
> > You mean that the implementation could be simplified if msleep() were to
> > simply call do_nanosleep()?
> 
> The current msleep is fine and doesn't need any "fixing".
> Not all the world is i386, _please_ keep hrtimer usage where it's 
> required. Simple timer should be given preference unless the higher 
> resolution is really needed, which is not the case here.

Hang on.  Having msleep(1) sleep for 20 milliseconds is really awful
behaviour.  Possibly worse is the fact that with other configs, it will
delay for eight milliseconds.  Or two.  That's an order of magnitude of
unpredictability which can actually cause driver breakage.

Fixing that *bug* is a good thing.  I see no reason why we should "keep
hrtimer usage where it is required"?  The implementation details are hidden
from the caller.

It seems to be a sensible change to me and I fail to understand the
objection.

> so below is a nanosleep implementation based 
> on Jonathan's patch. This will user give a choice, so there is no need to 
> force all users to use hrtimer for a simple sleep.

But apart from needlessly fattening the kernel API, that leaves us in the
current situation where an unknown number of the msleep() callers actually
care that they are calling a function which by a huge margin fails to do
what they are asking it to do.  It will take a long time to hunt down all
the problematic callsites and migrate them to nanosleep().

