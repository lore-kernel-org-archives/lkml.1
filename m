Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563Ab0A0MKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab0A0MKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 07:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412Ab0A0MKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 07:10:31 -0500
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:52496 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753855Ab0A0MKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 07:10:30 -0500
Subject: Re: [PATCH] kernel/timekeeping:  move xtime_cache to be in the
 same cache line as the lock
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20100126152822.d05b5487.akpm@linux-foundation.org>
References: <1264088361.2082.45.camel@localhost>
	 <20100126152822.d05b5487.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jan 2010 12:10:26 +0000
Message-ID: <1264594226.2059.47.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-26 at 15:28 -0800, Andrew Morton wrote:
> On Thu, 21 Jan 2010 15:39:21 +0000
> Richard Kennedy <richard@rsk.demon.co.uk> wrote:
> 
> > move xtime_cache to be in the same cache line as the lock
> >     
> > allowing current_kernel_time() to access only one cache line
> 
> Sentences start with capital letters, please.

Sorry about that, I will try harder in future ;)


> 
> I don't know how reliable this is.  I _think_ the compiler and linker
> are free to place variables of this nature in any old place.  Whether
> any of the current tools actually do that I don't know.  Note that one
> of these variables has file-static scope and the other does not, which
> perhaps increases the risk that the compiler or linker will go and
> fiddle with them.
> 
> To do this reliably one would need to put them in a struct:
> 
> time.h:
> 
> extern struct xtime_stuff {
> 	seqlock_t _xtime_lock,
> 	struct timespec _xtime_cache,
> } xtime_stuff;
> 
> #define xtime_lock xtime_stuff._xtime_lock
> 
> 
> timekeeping.c:
> 
> struct xtime_stuff {
> 	._xtime_lock = __SEQLOCK_UNLOCKED(xtime_stuff._xtime_lock),
> };
Thank you, yes that looks like a much better approach.
I can do this if it's needed, but John Stultz said he's going to kill
the xtime_cache anyway, so it may not be worth it?

However I do wonder if we should move all, or at least some, of the
variables protected by that xtime_lock into that structure? Then we can
manage their placement and they would be easier to find. After only a
brief look I see variables in ntp, tick &  timekeeping that seem to be
protected by that seqlock.

> > BTW on 64 bit timespec is a 16 byte structure so the aligned 16 doesn't
> > do much, and on 32bit timepec is 8bytes so this just seems to spread
> > these variables across more cache lines than necessary. Any ideas what
> > this is here for?
> 
> Dunno.  I had a bit of a peek in the git history but it got complicated
> and people rarely bother explaining things like this anyway :(
> 
regards
Richard

