Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbZG0Hdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbZG0Hdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 03:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbZG0Hdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 03:33:38 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:57385 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944AbZG0Hdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 03:33:38 -0400
Date: Mon, 27 Jul 2009 09:33:38 +0200
From: Andreas Mohr <andi@lisas.de>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: Dynamic configure max_cstate
Message-ID: <20090727073338.GA12669@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248672613.2560.604.camel@ymzhang>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> When running a fio workload, I found sometimes cpu C state has
> big impact on the result. Mostly, fio is a disk I/O workload
> which doesn't spend much time with cpu, so cpu switch to C2/C3
> freqently and the latency is big.

Rather than inventing ways to limit ACPI Cx state usefulness, we should
perhaps be thinking of what's wrong here.

And your complaint might just fit into a thought I had recently:
are we actually taking ACPI Cx exit latency into account, for timers???

If we program a timer to fire at some point, then it is quite imaginable
that any ACPI Cx exit latency due to the CPU being idle at that moment
could add to actual timer trigger time significantly.

To combat this, one would need to tweak the timer expiration time
to include the exit latency. But of course once the CPU is running
again, one would need to re-add the latency amount (read: reprogram the
timer hardware, ugh...) to prevent the timer from firing too early.

Given that one would need to reprogram timer hardware quite often,
I don't know whether taking Cx exit latency into account is feasible.
OTOH analysis of the single next timer value and actual hardware reprogramming
would have to be done only once (in ACPI sleep and wake paths each),
thus it might just turn out to be very beneficial after all
(minus prolonging ACPI Cx path activity and thus aggravating CPU power
savings, of course).

Arjan mentioned examples of maybe 10us for C2 and 185us for C3/C4 in an
article.

OTOH even 185us is only 0.185ms, which, when compared to disk seek
latency (around 7ms still, except for SSD), doesn't seem to be all that much.
Or what kind of ballpark figure do you have for percentage of I/O
deterioration?
I'm wondering whether we might have an even bigger problem with disk I/O
related to this than just the raw ACPI exit latency value itself.

Andreas Mohr
