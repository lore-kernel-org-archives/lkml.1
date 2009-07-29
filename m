Return-Path: <linux-kernel-owner+w=401wt.eu-S1751675AbZG2IAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675AbZG2IAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 04:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbZG2IAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 04:00:38 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:50835 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbZG2IAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 04:00:37 -0400
Date: Wed, 29 Jul 2009 10:00:37 +0200
From: Andreas Mohr <andi@lisas.de>
To: Len Brown <lenb@kernel.org>
Cc: Andreas Mohr <andi@lisas.de>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: Dynamic configure max_cstate
Message-ID: <20090729080037.GA1113@rhlx01.hs-esslingen.de>
References: <20090727073338.GA12669@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.0907282014030.17102@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0907282014030.17102@localhost.localdomain>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 28, 2009 at 08:17:09PM -0400, Len Brown wrote:
> > And your complaint might just fit into a thought I had recently:
> > are we actually taking ACPI Cx exit latency into account, for timers???
> 
> Yes.
> menu_select() calls tick_nohz_get_sleep_length() specifically
> to compare the expiration of the next timer vs. the expected sleep length.
> 
> The problem here is likely that the expected sleep length
> is shorter than expected, for IO interrupts are not timers...
> Thus we add long deep C-state wakeup time to the IO interrupt latency...

Well, but... the code does not work according to my idea about this.
The code currently checks against the expected sleep length and throws away
any large exit latencies that don't fit.
What I was thinking how to handle this is entirely different (and,
frankly, I'm not sure whether it would have any advantage, but still):
actively _subtract_ the idle exit latency from the timer expiration
time (i.e., reprogram the timer on idle entry and again on idle exit if
not expired yet) to make sure that the timer fires correctly
despite having to handle the idle exit, too.

OTOH while this might allow deeper Cx states, it's most likely a weaker
solution than the current implementation, since it requires up to two
times additional timer reprogramming.
And additionally taking into account I/O-inflicted idle exit can be
implemented pretty easily alongside the existing tick_nohz_get_sleep_length()
mechanism.

The code still causes some additional uneasiness such as:
tick_nohz_get_sleep_length() returns dev->next_event - now,
but pushed through all the ACPI latency hardware-wise)
the actual timer appearance after cpu wakeup might be
entirely random, there should be a feedback mechanism which
measures when a timer was expected and when it then _actually_ turned up,
to cancel out the delay effects of ACPI idle entry/exit.

== i.e. we seem to be calculating these things on what we _think_ the
machine is doing, not on what we _know_ about its previous behaviour ==
- since we don't have a feedback loop...
IMHO this is an important missing element here, if such a feedback loop
was implemented, then timer wakeups would be much more precise,
which incidentally would result in improved machine performance.
(CC Thomas)


And spinning this a bit further - let me guess (I didn't check it)
that hard realtime users are always quick to disable ACPI Cx completely?
With such a mechanism they shouldn't need to, since the timer is
programmed according to _actual_ CPU wakeup time, not when we _think_
it might wakeup.
(CC Ingo)


I just realized that such a feedback loop (resulting in possibly
early-programmed timers) would then need my timer reprogramming
mechanism again (after ACPI idle exit), to avoid early timer trigger.
However ultimately I think it might turn out to be a much better solution
to precisely _determine_ timer fireing than to simply statically, mechanically
(blindly!) pre-set the time around which a timer "might be expected to be fired".


An annoyingly simple sentence to phrase the current situation:
"With ACPI idle configured, high-res timers aren't."


Or am I wrong and the current implementation is already doing all this
already? Didn't see that though...

Andreas Mohr
