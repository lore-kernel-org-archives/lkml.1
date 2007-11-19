Return-Path: <linux-kernel-owner+w=401wt.eu-S1752089AbXKSSXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbXKSSXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:23:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751093AbXKSSVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:21:40 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41894 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbXKSSVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:21:37 -0500
Date: Mon, 19 Nov 2007 10:18:19 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dave Johnson <djohnson@sw.starentnetworks.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 03/26] x86: fix TSC clock source calibration error
Message-ID: <20071119181819.GD15425@kroah.com>
References: <20071119181438.617190424@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-fix-tsc-clock-source-calibration-error.patch"
In-Reply-To: <20071119181746.GA15425@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Dave Johnson <djohnson@sw.starentnetworks.com>

patch edaf420fdc122e7a42326fe39274c8b8c9b19d41 in mainline.

I ran into this problem on a system that was unable to obtain NTP sync
because the clock was running very slow (over 10000ppm slow). ntpd had
declared all of its peers 'reject' with 'peer_dist' reason.

On investigation, the tsc_khz variable was significantly incorrect
causing xtime to run slow.  After a reboot tsc_khz was correct so I
did a reboot test to see how often the problem occurred:

Test was done on a 2000 Mhz Xeon system.  Of 689 reboots, 8 of them
had unacceptable tsc_khz values (>500ppm):

 range of tsc_khz  # of boots  % of boots
 ----------------  ----------  ----------
        < 1999750           0      0.000%
1999750 - 1999800          21      3.048%
1999800 - 1999850         166     24.128%
1999850 - 1999900         241     35.029%
1999900 - 1999950         211     30.669%
1999950 - 2000000          42      6.105%
2000000 - 2000000           0      0.000%
2000050 - 2000100           0      0.000%
                   [...]
2000100 - 2015000           1      0.145%  << BAD
2015000 - 2030000           6      0.872%  << BAD
2030000 - 2045000           1      0.145%  << BAD
2045000 <                   0      0.000%

The worst boot was 2032.577 Mhz, over 1.5% off!

It appears that on rare occasions, mach_countup() is taking longer to
complete than necessary.

I suspect that this is caused by the CPU taking a periodic SMI
interrupt right at the end of the 30ms calibration loop.  This would
cause the loop to delay while the SMI BIOS hander runs. The resulting
TSC value is beyond what it actually should be resulting in a higher
tsc_khz.

The below patch makes native_calculate_cpu_khz() take the best
(shortest duration, lowest khz) run of it's 3 calibration loops.  If a
SMI goes off causing a bad result (long duration, higher khz) it will
be discarded.

With the patch applied, 300 boots of the same system produce good
results:

 range of tsc_khz  # of boots  % of boots
 ----------------  ----------  ----------
        < 1999750           0      0.000%
1999750 - 1999800          30     10.000%
1999800 - 1999850         166     55.333%
1999850 - 1999900          89     29.667%
1999900 - 1999950          15      5.000%
1999950 <                   0      0.000%

Problem was found and tested against 2.6.18.  Patch is against 2.6.22.

Signed-off-by: Dave Johnson <djohnson@sw.starentnetworks.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/i386/kernel/tsc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/i386/kernel/tsc.c
+++ b/arch/i386/kernel/tsc.c
@@ -122,7 +122,7 @@ unsigned long native_calculate_cpu_khz(v
 {
 	unsigned long long start, end;
 	unsigned long count;
-	u64 delta64;
+	u64 delta64 = (u64)ULLONG_MAX;
 	int i;
 	unsigned long flags;
 
@@ -134,6 +134,7 @@ unsigned long native_calculate_cpu_khz(v
 		rdtscll(start);
 		mach_countup(&count);
 		rdtscll(end);
+		delta64 = min(delta64, (end - start));
 	}
 	/*
 	 * Error: ECTCNEVERSET
@@ -144,8 +145,6 @@ unsigned long native_calculate_cpu_khz(v
 	if (count <= 1)
 		goto err;
 
-	delta64 = end - start;
-
 	/* cpu freq too fast: */
 	if (delta64 > (1ULL<<32))
 		goto err;

-- 
