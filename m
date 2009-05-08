Return-Path: <linux-kernel-owner+w=401wt.eu-S1762934AbZEHMQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762934AbZEHMQs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 08:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760843AbZEHMQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 08:16:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37260 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761945AbZEHMQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 08:16:34 -0400
Date: Fri, 8 May 2009 14:15:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: john stultz <johnstul@us.ibm.com>
Cc: George Spelvin <linux@horizon.com>, ulrich.windl@rz.uni-regensburg.de,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Clark Williams <williams@redhat.com>, zippel@linux-m68k.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH] tsc_khz= boot option to avoid TSC calibration
	variance
Message-ID: <20090508121521.GC18758@elte.hu>
References: <1241742647.7518.108.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241742647.7518.108.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* john stultz <johnstul@us.ibm.com> wrote:

> All, 
> 
> Despite recent tweaking, TSC calibration variance is still biting 
> users who care about keeping close sync with NTP servers over 
> reboots.
> 
> Here's a recent example: 
> http://lkml.indiana.edu/hypermail/linux/kernel/0905.0/02061.html
> 
> The problem is, each reboot, we have to calibrate the TSC, and any 
> error, regardless of how small, in the calibrated freq has to be 
> corrected for by NTP. Assuming the error is within 500ppm NTP can 
> correct this, but until it finds the proper correction value for 
> the new TSC freq, users may see time offsets from the NTP server.
> 
> In my experience, its fairly easy to see 100khz variance from 
> reboot to reboot with 2.6.30-rc.
> 
> While I think its worth trying to improve the calibration further, 
> there will likely be a trade-off between very accurate calibration 
> and fast boot times.
> 
> To mitigate this, I wanted to provide a tsc_khz= boot option. This 
> would allow users to set the tsc_khz value at boot-up, assuming 
> they are within 1Mhz of the calibrated value (to protect against 
> bad values). Once the tsc_khz value is set in grub, the box will 
> always boot with the same value, so the NTP drift value prior to 
> reboot will still be correct after rebooting.
> 
> Thanks to George Spelvin for the idea:
> 	http://lkml.indiana.edu/hypermail/linux/kernel/0905.0/02807.html
> 
> Thoughts or feedback?
> 
> Signed-off-by: John Stultz <johnstul@us.ibm.com>

Wouldnt it be a lot more flexible to have a sysctl for this, which 
would be set before ntpd is started? (or which would be set by ntpd)

The mechanism and semantics would be similar: we would _not_ expose 
cpu_khz directly, we'd have a boot_cpu_khz value saved for sure, and 
we'd allow the sysctl to set the cpu_khz to within 1MHz of cpu_khz - 
and we'd re-scale the timer irq and other calibrated values 
accordingly.

Alternatively, a much simpler method: why doesnt ntpd save its own 
notion of cpu_khz once it has reached stability, and reads cpu_khz 
(from /proc/cpuinfo) during bootup and re-scales its initial offset 
and phase shift accordingly, compensating for that noise? (if it's 
within 1MHz)

	Ingo
