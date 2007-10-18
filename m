Return-Path: <linux-kernel-owner+w=401wt.eu-S933412AbXJRI5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933412AbXJRI5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 04:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932691AbXJRI5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 04:57:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59829 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932787AbXJRI5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 04:57:30 -0400
Date: Thu, 18 Oct 2007 10:57:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Greg KH <gregkh@suse.de>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] i386: fix TSC clock source calibration error
Message-ID: <20071018085713.GA11022@elte.hu>
References: <18196.53154.100115.92459@zeus.sw.starentnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18196.53154.100115.92459@zeus.sw.starentnetworks.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.1.7-deb
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2634]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com> wrote:

> I ran into this problem on a system that was unable to obtain NTP sync 
> because the clock was running very slow (over 10000ppm slow). ntpd had 
> declared all of its peers 'reject' with 'peer_dist' reason.
> 
> On investigation, the tsc_khz variable was significantly incorrect 
> causing xtime to run slow.  After a reboot tsc_khz was correct so I 
> did a reboot test to see how often the problem occurred:
> 
> Test was done on a 2000 Mhz Xeon system.  Of 689 reboots, 8 of them 
> had unacceptable tsc_khz values (>500ppm):
> 
>  range of tsc_khz  # of boots  % of boots
> -----------------  ----------  ----------
>         < 1999750           0      0.000%
> 1999750 - 1999800          21      3.048%
> 1999800 - 1999850         166     24.128%
> 1999850 - 1999900         241     35.029%
> 1999900 - 1999950         211     30.669%
> 1999950 - 2000000          42      6.105%
> 2000000 - 2000000           0      0.000%
> 2000050 - 2000100           0      0.000%
>                    [...]
> 2000100 - 2015000           1      0.145%  << BAD
> 2015000 - 2030000           6      0.872%  << BAD
> 2030000 - 2045000           1      0.145%  << BAD
> 2045000 <                   0      0.000%
> 
> The worst boot was 2032.577 Mhz, over 1.5% off!

you are plain crazy, 689 reboots! :-)

> It appears that on rare occasions, mach_countup() is taking longer to 
> complete than necessary.
> 
> I suspect that this is caused by the CPU taking a periodic SMI 
> interrupt right at the end of the 30ms calibration loop.  This would 
> cause the loop to delay while the SMI BIOS hander runs. The resulting 
> TSC value is beyond what it actually should be resulting in a higher 
> tsc_khz.
> 
> The below patch makes native_calculate_cpu_khz() take the best 
> (shortest duration, lowest khz) run of it's 3 calibration loops.  If a 
> SMI goes off causing a bad result (long duration, higher khz) it will 
> be discarded.
> 
> With the patch applied, 300 boots of the same system produce good
> results:
> 
>  range of tsc_khz  # of boots  % of boots
> -----------------  ----------  ----------
>         < 1999750           0      0.000%
> 1999750 - 1999800          30     10.000%
> 1999800 - 1999850         166     55.333%
> 1999850 - 1999900          89     29.667%
> 1999900 - 1999950          15      5.000%
> 1999950 <                   0      0.000%
> 
> Problem was found and tested against 2.6.18.  Patch is against 2.6.22.

very cool problem description and debugging, and a very nice patch! 
We've added your fix to the x86 tree, will go to Linus in the next batch 
of fixes. This patch is a stable kernel candidate as well.

	Ingo
