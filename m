Return-Path: <linux-kernel-owner+w=401wt.eu-S1757024AbYLaXlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024AbYLaXlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 18:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbYLaXlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 18:41:04 -0500
Received: from waste.org ([66.93.16.53]:60590 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164AbYLaXlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 18:41:03 -0500
Subject: Re: random.c changes for sparse irq_desc are crap
From: Matt Mackall <mpm@selenic.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <495BFB48.8080506@kernel.org>
References: <1230748169.19620.132.camel@calx>  <495BFB48.8080506@kernel.org>
Content-Type: text/plain
Date: Wed, 31 Dec 2008 17:40:26 -0600
Message-Id: <1230766826.19620.150.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-31 at 15:07 -0800, Yinghai Lu wrote:
> Matt Mackall wrote:
> > I just noticed you merged a change that pointlessly converts two
> > random.c functions into ugly random.h inlines without going through the
> > maintainer.
> > 
> > I also don't like the look of the newly-introduced sparse variants of
> > these functions. Failure to find an irq descriptor in
> > get_timer_rand_state is a BUG_ON should-never-happen sort of condition,
> > not something to silently ignore. Letting the code try to dereference
> > NULL is preferred here: we'll actually be able to find and fix the
> > broken driver that's throwing around meaningless irq vectors.
> > 
> > Throwing away the timer_state pointer in the set_timer_rand_state
> > function is similarly bogus in addition to being a memory leak.
> > 
> > Please fix this up.
> > 
> 
> want something like this?

Not quite.

First, please turn these back into normal functions in random.c.
Inlining functions is generally discouraged these days unless you have a
good reason and numbers to back it up.

Second, as I tried to explain above, BUG_ON(!desc) is doing very little
that the subsequent desc->timer_rand_state wouldn't already do
(generating a traceback). In cases where dereferencing NULL should never
happen, it's preferable to not add the extra check and just let the oops
happen. We'll still get a backtrace if anything ever goes wrong, but we
won't have wasted any code space or CPU cycles when it doesn't.

-- 
Mathematics is the supreme nostalgia of our time.

