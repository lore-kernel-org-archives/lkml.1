Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbYHWSrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbYHWSrS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 14:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbYHWSrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 14:47:04 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61345 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751562AbYHWSrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 14:47:02 -0400
Date: Sat, 23 Aug 2008 19:45:33 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] rtc: fix deadlock
In-Reply-To: <20080823171139.GA13144@elte.hu>
Message-ID: <Pine.LNX.4.55.0808231919450.6466@cliff.in.clinika.pl>
References: <200808230948.m7N9mUc1016360@harpo.it.uu.se> <20080823160151.GB27974@elte.hu>
 <18608.16826.607428.203994@harpo.it.uu.se> <20080823171139.GA13144@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Aug 2008, Ingo Molnar wrote:

> > The sporadic nature of the bug means that it will probably take a 
> > couple of days of testing and dozens of reboots w/o problems before 
> > I'm confident to say that the problem's been fixed.
> 
> btw., i've seen that lockup too on a testbox - but havent been able to 
> track it down yet. You went further and presented the bug on a plate by 
> tracking it down to the loop in get_rtc_time() - so now we can both test 
> the fix and see whether the lockups are gone.

 Hmm, waiting for 20ms with interrupts disabled sounds like a bad idea --
a lot of system timer ticks may be lost and some devices may not be happy
about such a delay either (serial?).  I think your proposal only papers
over the actual bug and it should simply be forbidden to call this
function with interrupts disabled.

 I can see this is a part of the legacy RTC interface, so except from the
long delay the function itself may have a chance to work with interrupts
disabled.  But with the modern RTC library this is no longer true as some
RTC chips it supports can only be accessed with interrupts enabled,
because their accessor functions may sleep.  This is for example common
with RTC chips wired through I2C.

 Therefore I think to avoid propagating the design problem with places
calling get_rtc_time() when they eventually switch to the RTC library it
would be better to put:

BUG_ON(irqs_disabled());

into get_rtc_time() now and fix the callers which happen to trigger it.

  Maciej
