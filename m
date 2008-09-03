Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbYICCvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbYICCvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 22:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbYICCvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 22:51:33 -0400
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:64973 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751239AbYICCvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 22:51:32 -0400
Message-ID: <48BDFBB6.3010106@lwfinger.net>
Date: Tue, 02 Sep 2008 21:51:34 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] Fix TSC calibration issues
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de> <48BC2A03.9000104@lwfinger.net> <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011142520.12958@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011504200.12958@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809020033450.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809012015160.12958@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809012033280.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809020835150.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809020759480.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809021918450.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809021120120.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809022358370.3243@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0809022358370.3243@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> Larry Finger reported at http://lkml.org/lkml/2008/9/1/90:
> An ancient laptop of mine started throwing errors from b43legacy when
> I started using 2.6.27 on it. This has been bisected to commit bfc0f59
> "x86: merge tsc calibration".
> 
> The unification of the TSC code adopted mostly the 64bit code, which
> prefers PMTIMER/HPET over the PIT calibration.
> 
> Larrys system has an AMD K6 CPU. Such systems are known to have
> PMTIMER incarnations which run at double speed. This results in a
> miscalibration of the TSC by factor 0.5. So the resulting calibrated
> CPU/TSC speed is half of the real CPU speed, which means that the TSC
> based delay loop will run half the time it should run. That might
> explain why the b43legacy driver went berserk.
> 
> On the other hand we know about systems, where the PIT based
> calibration results in random crap due to heavy SMI/SMM
> disturbance. On those systems the PMTIMER/HPET based calibration logic
> with SMI detection shows better results.
> 
> According to Alok also virtualized systems suffer from the PIT
> calibration method.
> 
> The solution is to use a more wreckage aware aproach than the current
> either/or decision.
> 
> 1) reimplement the retry loop which was dropped from the 32bit code
> during the merge. It repeats the calibration and selects the lowest
> frequency value as this is probably the closest estimate to the real
> frequency
> 
> 2) Monitor the delta of the TSC values in the delay loop which waits
> for the PIT counter to reach zero. If the maximum value is
> significantly different from the minimum, then we have a pretty safe
> indicator that the loop was disturbed by an SMI.
> 
> 3) keep the pmtimer/hpet reference as a backup solution for systems
> where the SMI disturbance is a permanent point of failure for PIT
> based calibration
> 
> 4) do the loop iteration for both methods, record the lowest value and
> decide after all iterations finished.
> 
> 5) Set a clear preference to PIT based calibration when the result
> makes sense.
> 
> The implementation does the reference calibration based on
> HPET/PMTIMER around the delay, which is necessary for the PIT anyway,
> but keeps separate TSC values to ensure the "independency" of the
> resulting calibration values.
> 
> Tested on various 32bit/64bit machines including Geode 266Mhz, AMD K6
> (affected machine with a double speed pmtimer which I grabbed out of
> the dump), Pentium class machines and AMD/Intel 64 bit boxen.
> 
> Bisected-by:  Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---

I know that Linus has some problems with this patch, but FWIW it 
worked on my K6. The dmesg output is

TSC: PIT calibration deviates from PMTIMER: 428809 214401.
TSC: Using PIT calibration value
Detected 428.809 MHz processor.

Larry
