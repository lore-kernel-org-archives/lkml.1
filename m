Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbYIDE1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbYIDE1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 00:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbYIDE07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 00:26:59 -0400
Received: from 1wt.eu ([62.212.114.60]:3170 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbYIDE06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 00:26:58 -0400
Date: Thu, 4 Sep 2008 06:25:42 +0200
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Alok Kataria <akataria@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Michael Buesch <mb@bu3sch.de>, Dan Hecht <dhecht@vmware.com>
Subject: Re: [PATCH] Fix TSC calibration issues
Message-ID: <20080904042542.GH19337@1wt.eu>
References: <alpine.LFD.1.10.0809020759480.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809021918450.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809021120120.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809022358370.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809021906250.3259@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809031103090.3243@apollo.tec.linutronix.de> <1220490884.22734.83.camel@alok-dev1> <alpine.LFD.1.10.0809031817430.3515@nehalem.linux-foundation.org> <20080903201602.2ab6c449@infradead.org> <alpine.LFD.1.10.0809032041130.3515@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809032041130.3515@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 08:59:05PM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 3 Sep 2008, Arjan van de Ven wrote:
> > 
> > but at some point, even doing things in parallel/asynchronous isn't
> > helping, "parallel shit is still shit" :)
> 
> Well, the thing is, you can't call ti "shit" when the fact is that we 
> don't have any other options than to wait.
> 
> The only frequency we can trust on 99% of all machines is the PIT, and 
> it's a very uncomfortable programming model due to all the history (it is 
> one of the few truly 8-bit things left in a modern PC). The other options 
> are just not reliably there, or are known to not have a stable frequency.
> 
> So how would you suggest we do it? Lowering the wait to 5ms (times 5, so 
> it's really 25ms, although we can probably stop early if the first 
> iterations are very consistent) will work, but it _will_ reduce precision. 
> And it's still real time.
> 
> But we simply don't have alternatives. That 'shit' is originally from the 
> company you work for, btw, and while it was good for its time, the 
> replacement (HPET) was horribly misdesigned by the same company, and is 
> deficient in many ways (not the least of which is the idiotic enumeration: 
> another ACPI braindamage), and it often isn't even exposed.
> 
> As a result, the PIT remains to this day the most reliable source of a 
> reference timer. That includes even on really modern machines (ie the one 
> I have from Intel that contains hardware not even released yet!).

15 years ago when I only knew DOS, I used the PIT a lot for precise
delay calculations. I can attest that it can be a very precise timer
for delays when you run busy loops. You even need very few ticks because
you detect the falling edge with a high accuracy. Basically, I would
do this :

    pit1 = readpit();
    while (readpit() == pit1);
    t1 = rdtsc(); // precise beginning of tick 0
    while (readpit() != pit1 - 5000);
    t2 = rdtsc(); // precise beginning of tick 5000

(t2 - t1) will be exactly 5000 PIT ticks long, or 4.1904767 ms.

Additional sanity checks are needed of course, such as rollover
detection, and a max loop counter in case we boot on a machine
with a broken PIT.

If someone wants to test this, I'd be interested in the number of
ticks required to get a good accuracy, I bet that even with a few
hundred ones it's already precise by a few ppm (about the precision
of the input clock in fact).

Willy

