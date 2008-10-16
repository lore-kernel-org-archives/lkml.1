Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbYJPCvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbYJPCvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 22:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbYJPCvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 22:51:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046AbYJPCvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 22:51:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: prasad@linux.vnet.ibm.com
X-Fcc: ~/Mail/linus
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, akpm@linux-foundation.org,
       mingo@elte.hu, jason.wessel@windriver.com, avi@qumranet.com,
       richardj_moore@uk.ibm.com
Subject: Re: [RFC Patch 1/9] Introducing generic hardware breakpoint handler
	interfaces
In-Reply-To: K.Prasad's message of  Thursday, 9 October 2008 00:53:00 +0530 <20081008192300.GA4989@in.ibm.com>
References: <20081008192044.GA4510@in.ibm.com>
	<20081008192300.GA4989@in.ibm.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20081016024956.602C61544CB@magilla.localdomain>
Date: Wed, 15 Oct 2008 19:49:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "sstep_reason" hair in the x86 patch is the perfect example of exactly
what I wanted to avoid by keeping the hw_breakpoint layer simpler.  (Also I
strongly doubt that the x86 patch's single-step magic is correct in all the
corner cases.  But that discussion is the very rat hole that I want to
defer, is my point in this here discussion.)

I think the role of the hw_breakpoint layer ought to be an arch-neutral API
for accessing and multiplexing the breakpoint functionality of the hardware.
I don't think its role ought to include enhancing the facilities beyond
what the actual hardware has (just the multiplexing).

AFAIK no hardware's facility delivers two separate exceptions for a single
hit of a single breakpoint slot.  There is just one hit, and it's either
before the instruction or after it.  So you only need one handler function,
and one pointer slot for it.

Each given type of breakpoint on a given arch is either a fire-before or a
fire-after type.  The *_supported() functions are enough to make it clear.
Those really should be inlines in an arch header, since they will be
constants or type==CONST tests that are probably entirely optimized away
(and let a big dead fork of the caller's code get optimized away).

For fire-before types, there are two flavors.  On powerpc, data breakpoints
are fire-before, and to actually complete the triggering load/store you
have to clear the dabr (disable the breakpoint) before resuming (and then
potentially deal with step-then-reenable, etc).  On x86, instruction
breakpoints are fire-before, but there is the option of using the magic RF
bit to suppress the hit without disabling the breakpoint.  So you need
another inline a la *_supported() to indicate what's possible.  (Possibly
the handler should be able to control this with its return value,
i.e. allow returning with RF clear for some reason.)

The sequence of suppress-and-single-step (x86 insn) or
disable-and-single-step-and-reenable (powerpc data) will of course be
desireable for high-level uses.  But that doesn't mean they need to be
built into hw_breakpoint.  Make the hw_breakpoint layer clearly expose what
the options are on the hardware, and the rest can be built up from
hw_breakpoint along with other components managing the stepping part.
(For user-mode stepping, the building blocks are already there.  For the
kernel side, we can attack that windmill another day.)


Thanks,
Roland
