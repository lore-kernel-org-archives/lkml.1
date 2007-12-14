Return-Path: <linux-kernel-owner+w=401wt.eu-S1754944AbXLNOim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbXLNOim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 09:38:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbXLNOif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 09:38:35 -0500
Received: from rtr.ca ([76.10.145.34]:4356 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbXLNOie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 09:38:34 -0500
Message-ID: <47629568.6050901@rtr.ca>
Date: Fri, 14 Dec 2007 09:38:32 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Arun Thomas <arun.thomas@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       jirislaby@gmail.com
Subject: Re: PROBLEM: E6850 has an 8+ minute delay during boot
References: <9a8cbed90712140110l156a34e3x38533b7710544cf8@mail.gmail.com>
In-Reply-To: <9a8cbed90712140110l156a34e3x38533b7710544cf8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arun Thomas wrote:
...
> [   31.670148] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
> [   31.670351] TCP: Hash tables configured (established 131072 bind 65536)
> [   31.670391] TCP reno registered
> [   31.681591] checking if image is initramfs...<7>Switched to high
> resolution mode on CPU 0
> [  540.133678] Clocksource tsc unstable (delta = 299978139535 ns)
> [  540.137708] Time: hpet clocksource has been installed.
> [  540.432798]  it is
> [  541.570364] Freeing initrd memory: 44428k freed
> [  541.570748] audit: initializing netlink socket (disabled)
...

Ahh... BINGO!

This is very likely the same problem that I first reported back in 2.6.21(20?),
when NOHZ and HPET first came in!

It never occurred to me to wait a full 8-minutes though,
so I just rebooted again after a 1-2 minute wait each time.

Seen on Core2Duo T7400 and Core2Quad E6600 systems, with kernels 2.6.21/22
at various points.  Not consistent -- sometimes it would boot after a few
attempts, sometimes not.

It always hung around the "Switched to high resolution mode" messages.

Thomas Gleixner wrote:
> The problem is caused by an SMI during the calibration routine. We
> really need to come up with a solid solution which does not rely on
> the periodic timer coming in, when there is something else (HPET,
> pm_timer) available.
...

Oh good, an explanation!

Now we just need a creative fix.

One thing that *might* be sufficient, would be to do the
delay loop calibration twice, and compare the results to
see if they're within 10% (pick a number) of each other.

Is there a flag or something that SMI sets that we could poll
before/after the calibration?  That could be used to tell us
that it needs redoing ?
