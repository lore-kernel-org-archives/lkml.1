Return-Path: <linux-kernel-owner+w=401wt.eu-S1759300AbYCTW40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300AbYCTW40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 18:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754614AbYCTW4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 18:56:18 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:47632 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754371AbYCTW4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 18:56:17 -0400
X-Sasl-enc: RhBCS7i1Ykgfx6tn99PMf9V8LEtzk55IGHb40r7MFmI7 1206053776
Date: Thu, 20 Mar 2008 19:56:12 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <david-b@pacbell.net>, Richard Purdie <rpurdie@rpsys.net>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
Message-ID: <20080320225612.GB20788@khazad-dum.debian.net>
References: <20080316184349.GA28543@khazad-dum.debian.net> <200803161246.23909.david-b@pacbell.net> <20080318001429.896acf51.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080318001429.896acf51.akpm@linux-foundation.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2008, Andrew Morton wrote:
> On Sun, 16 Mar 2008 11:46:23 -0800 David Brownell <david-b@pacbell.net> wrote:
> > On Sunday 16 March 2008, Henrique de Moraes Holschuh wrote:
> > > Is the use of "if (preempt_count())" to know when to defer led gpio work to
> > > a workqueue needed? __Shouldn't "if (in_atomic())" be enough?
> > 
> > At this point, I don't know of any such reason.
> > 
> > I remember hunting for the right heuristic, and settling on
> > that one for reasons that I can't recall now.  They may even
> > be no longer applicable.
> 
> Both are incorrect.  When CONFIG_PREEMPT=n we have no support for
> determining whether schedule() may be called.  The calling code has to sort
> out its stuff on its own.
> 
> <greps for preempt_count>
> 
> The LEDs code seems to be the sole offender.  print_vma_addr() might be
> wrong too, but Ingo did it, and perhaps he knows that all code paths which
> call print_vma_addr() from deadlockable contexts have already called
> inc_preempt_count().  But is that true for all architectures?
> 
> <greps for in_atomic>
> 
> omigawd, what have we done, and how can we fix it? :(

Well, it is obvious an "are we in a sleep-ok state?" query that works in any
case is desired by a lot of code.

I certainly don't want to punt every thinkpad LED write to a workqueue,
because that would mean less time with the CPU in C3 in the bottom line,
even if there are some benefits to always doing it the workqueue way (the
workqueue helper colapses attempts to change the LED state too often).

Can we add "in_scheduleable()", or maybe "can_schedule()", that returns
in_atomic() if CONFIG_PREEMT, or 0 if there is no way to know?   To my
limited knowledge of how that part of the kernel works, it would do the
right thing.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
