Return-Path: <linux-kernel-owner+w=401wt.eu-S1757993AbYIATL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993AbYIATL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 15:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbYIATLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 15:11:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751526AbYIATLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 15:11:17 -0400
Date: Mon, 1 Sep 2008 12:10:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
In-Reply-To: <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.10.0809011142520.12958@nehalem.linux-foundation.org>
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de> <48BC2A03.9000104@lwfinger.net> <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 1 Sep 2008, Thomas Gleixner wrote:
> 
> Hmm. Haven't seen that before, but if confirms what I guessed from
> your previous dmesg information. I wonder why you did not observe
> strange behaviour with older kernel versions.

x86-32 never used the PM_TIMER for frequency estimation, it only ever used 
the PIT. See the old "native_calculate_cpu_khz()" in tsc_32.c that you 
deleted in favor of the (imho inferior) x86-64 version.

How about:

 - taking the old 32-bit code, and using it to initially _just_ estimate 
   the TSC speed. That code was stable and pretty much guaranteed to work 
   reasonably well on all machines. It retries the timings three times, 
   and picks the best one.

 - Then, _after_ you already have a pretty good estimation for TSC, you 
   can use _that_ to then get the HPET and/or PM_TIMER version (and not 
   use the PIT at all for those calibrations)

 - and if the PM_TIMER one is too far off, just throw it away. We know the 
   PIT is a lot more trustworthy than the PM_TIMER.

Hmm?

			Linus
