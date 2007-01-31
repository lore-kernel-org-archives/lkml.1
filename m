Return-Path: <linux-kernel-owner+w=401wt.eu-S933254AbXAaNYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254AbXAaNYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 08:24:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933253AbXAaNYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 08:24:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54434 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933251AbXAaNYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 08:24:44 -0500
Date: Wed, 31 Jan 2007 14:22:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Karsten Wiese <fzu@wemgehoertderstaat.de>
Cc: Andrew Morton <akpm@osdl.org>, Maciej Rutecki <maciej.rutecki@gmail.com>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm3
Message-ID: <20070131132245.GA26066@elte.hu>
References: <20070129204528.eb8d695e.akpm@osdl.org> <45BFC442.5000903@gmail.com> <20070130142714.9f8dd5da.akpm@osdl.org> <200701310155.05474.fzu@wemgehoertderstaat.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701310155.05474.fzu@wemgehoertderstaat.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -4.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-4.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Karsten Wiese <fzu@wemgehoertderstaat.de> wrote:

> Similar weirdness here on rc6-mm2 and rc6-rt*: resume from disk waits 
> unduly long.

i'm wondering whether the jiffies update fix from Thomas fixes this bug 
for you.

If not then do you have a serial console enabled?

> Some waiting times from rc6-rt6 from memory:
> 
> Config		| HZ			| NO_HZ + HRESTIMERS
> cmos clock unchanged	| 2s			| 6s
> cmos clock += 10min	| 			| 2 minutes
> cmos clock += 2 month	| 20s			| > 4minutes, test interrupted

i've seen something like this on -rt (and incorrectly attributed it to 
-rt) when running on a system which has a serial port and which has a 
kernel console on that serial port. What happens is that after resume 
(and straight after console suspend) every serial character printed 
takes /alot/ of time - and resume does print a number of kernel messages 
to the console. I didnt get any further in debugging this though, but 
disabling the serial console made the problem go away.

a possibly related thing: the serial code is sensitive to jiffies 
updates and timers, i saw that during early revisions of the dynticks 
code - but the specifics escape me.

the slowdown could also be something like the kernel somehow wrapping 
around jiffies and thus doing /alot/ of jiffy ticks? Or it could be a 
miscalculation in the amount of jiffies that need updating, resulting in 
a similar number of loops in the jiffy update code.

(i'll try to figure out this regression - but wanted to describe to you 
the known things so far, maybe you'll figure it out faster than me.)

	Ingo
