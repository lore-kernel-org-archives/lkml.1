Return-Path: <linux-kernel-owner+w=401wt.eu-S1762638AbXHIWbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762638AbXHIWbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 18:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbXHIWbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 18:31:08 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1321 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374AbXHIWbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 18:31:05 -0400
Date: Fri, 10 Aug 2007 00:31:23 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] msleep() with hrtimers
In-Reply-To: <20070807211401.7078c12d.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0708100020050.1817@scrub.home>
References: <15327.1186166232@lwn.net> <20070807124009.9f6c2247.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0708080115020.1817@scrub.home> <20070807162940.74f536f8.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0708080535140.1817@scrub.home> <20070807211401.7078c12d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 7 Aug 2007, Andrew Morton wrote:

> > The current msleep is fine and doesn't need any "fixing".
> > Not all the world is i386, _please_ keep hrtimer usage where it's 
> > required. Simple timer should be given preference unless the higher 
> > resolution is really needed, which is not the case here.
> 
> Hang on.  Having msleep(1) sleep for 20 milliseconds is really awful
> behaviour.  Possibly worse is the fact that with other configs, it will
> delay for eight milliseconds.  Or two.  That's an order of magnitude of
> unpredictability which can actually cause driver breakage.
> 
> Fixing that *bug* is a good thing.  I see no reason why we should "keep
> hrtimer usage where it is required"?  The implementation details are hidden
> from the caller.

This is not a bug. You have to keep in mind that for hrtimer to make a 
real difference HIGH_RES_TIMERS has to be enabled, OTOH if HZ is already 
set to 1000, it doesn't make much difference.
The sleep was and will be only a minimum time, expecting something 
different is actually a bug.

> > so below is a nanosleep implementation based 
> > on Jonathan's patch. This will user give a choice, so there is no need to 
> > force all users to use hrtimer for a simple sleep.
> 
> But apart from needlessly fattening the kernel API, that leaves us in the
> current situation where an unknown number of the msleep() callers actually
> care that they are calling a function which by a huge margin fails to do
> what they are asking it to do.  It will take a long time to hunt down all
> the problematic callsites and migrate them to nanosleep().

As I tried to say before this is foremost an API issue. Introducing 
nanosleep() makes it clear that this user will benefit from enabling 
HIGH_RES_TIMERS, whereas msleep() says that resolution is not that 
important and thus it will work fine without HIGH_RES_TIMERS and/or 
HZ_1000.

bye, Roman
