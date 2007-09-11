Return-Path: <linux-kernel-owner+w=401wt.eu-S1764289AbXIKSyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764289AbXIKSyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 14:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760881AbXIKSyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 14:54:04 -0400
Received: from mail.gmx.net ([213.165.64.20]:42035 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757595AbXIKSyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 14:54:01 -0400
X-Authenticated: #217404
X-Provags-ID: V01U2FsdGVkX1+SQnN8ErKSTh1sb5QQ3tRdij/rQ9x91D+cwb9KiU
	rHD3F8aUG3uZIV
Subject: Re: tsc timer related problems/questions
From: Dennis Lubert <plasmahh@gmx.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <46E5ED2A.6080908@shaw.ca>
References: <fa.sr0PjjOVi2ceb88Wh7ND1s6urC0@ifi.uio.no>
	 <46E5ED2A.6080908@shaw.ca>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 11 Sep 2007 20:54:11 +0200
Message-Id: <1189536851.6255.85.camel@speedy.projectiwear.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Also thanks to all the others for their reply!
Am Montag, den 10.09.2007, 19:19 -0600 schrieb Robert Hancock:
> Dennis Lubert wrote:
> > Hello list,
> > [105771.581838]  [<ffffffff806bc5f7>] start_secondary+0x474/0x483
> > 
> > Question: Is this a known bug already or should further investigation
> > take place?
> 
> It's unclear what that could be. As Arjan mentioned this can be caused 
> by the BIOS going off into SMI mode for a long time. If you don't have 
> ACPI turned on, doing this may prevent this from happening.
ACPI is turned on. As I have no experience with what SMI mode is, or how
it could be entered, is there a way to figure that out? When that BUG
happens the system is running one of our tests which involves lots of
calls to gettimeofday and/or clock_gettime on all cores, all being
constantly under 100% cpu usage. There does not seem to be anything
notable different in that situation.

> What time source is getting used? The best alternative is HPET, most 
> newer systems are providing that now. After that, there's ACPI PM timer 
> (make sure you have ACPI enabled). The worst possible fallback is the 
> PIT, which from this poor resolution sounds like what it is using.
The systems all do not have HPET unfortunately. Using the timesource
"jiffies" is the worst fallback (giving HZ resolution), I assume thats
driven by PIT. Using pmtimer is also a suboptimal choice, as its takes
(depending on the system) between 8 and 12 times more time than the tsc
based calls, which sometimes gets into 2µs per call, much more than the
optimal resolution of <1µs, and that also gets some apps to use
significant more CPU for the timer calls, as an example one of our proxy
apps needs to check timeouts of internal data very very often and on the
bad pmtimer machines it spends up to 40% in the gettimeofday calls.

> AMD CPUs don't seem to have synchronized TSCs across multiple CPUs. It 
> seems this is the case even with different cores in the same CPU 
> package. Therefore the TSC is not considered a suitable time source on 
> multi-CPU AMD systems.
Ok, I hope you won't get angry if I try to get an official statement
from AMD about this, it seems a bit strange to me ;)
Anyways, I got some time-warp-test.c program written by Ingo Molnar
which should check TSC synchronity on the CPUs. Running that program for
a while (30 minutes) did not lead to any negative results. Does anyone
have experiences with this program, and under what conditions it should
be run? and how long?

> This is expected behavior if you force TSC usage on with CPU frequency 
> scaling enabled, there's a reason we turn that off normally. (Also in 
> the case where some CPUs stop the TSC in certain power-saving halt 
> states.) Theoretically one could track the TSC between different CPUs 
> running at different clock speeds, etc. and across halts, but it doesn't 
> really seem worth the trouble, especially in cases like AMD multi-CPU 
> where the TSC can't be trusted across CPUs anyway.
I found some patch attempts in various places, e.g. one by Suleiman
Souhlal posted on this list that try to this and similar things.
Wouldn't those patches (although seemingly suboptimal) not be better
than nothing? As I described earlier, it wouldn't be that much of a
problem to have small differences (one could try syncing the tsc every
now and then) for us, one of the main concerns (beside an "ok" accuracy)
is the performance, a variante thats 8-12 times slower is (hopefully
understandable) very suboptimal

greets

Dennis

