Return-Path: <linux-kernel-owner+w=401wt.eu-S1759051AbZBMDCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759051AbZBMDCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 22:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbZBMDCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 22:02:08 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:33605 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbZBMDCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 22:02:05 -0500
Subject: [PATCH][RFC] Apply NTP frequency/tick changes immediately.
From: john stultz <johnstul@us.ibm.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Clark Williams <williams@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 12 Feb 2009 19:02:01 -0800
Message-Id: <1234494121.7042.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Roman,
	It was brought to my attention that since the GENERIC_TIME changes
landed, the adjtimex behavior changed for struct timex.tick and .freq
changes. When the tick or freq value is set, we adjust the
tick_length_base in ntp_update_frequency(). However, this new value
doesn't get applied to tick_length until the next second (via
second_overflow). 

This means some applications that do quick time tweaking do not see the
requested change made as quickly as expected.

Looking at the code, it doesn't seem like it would be too hard to
immediately apply the change to the tick_length value, so its changed in
the following NTP_INTERVAL, which this patch does.

I've run a few tests with this change, and ntpd still functions fine. I
do however note that the drift value for my test system changed from
~170ppm to ~18ppm, which I didn't quite expect, and needs some
additional research.

Anyway, I just wanted to see if you had any thoughts on this sort of
change.

thanks
-john


Apply NTP tick/frequency adjustments immediately instead of waiting for
the next second to pass.

Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index f5f793d..9fd0d15 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -51,6 +51,7 @@ static long ntp_tick_adj;
 
 static void ntp_update_frequency(void)
 {
+	u64 old_tick_length_base = tick_length_base;
 	u64 second_length = (u64)(tick_usec * NSEC_PER_USEC * USER_HZ)
 				<< NTP_SCALE_SHIFT;
 	second_length += (s64)ntp_tick_adj << NTP_SCALE_SHIFT;
@@ -60,6 +61,11 @@ static void ntp_update_frequency(void)
 
 	tick_nsec = div_u64(second_length, HZ) >> NTP_SCALE_SHIFT;
 	tick_length_base = div_u64(tick_length_base, NTP_INTERVAL_FREQ);
+	
+	/* Don't wait for the next second_overflow, apply
+	 * the change to the tick length immediately
+	 */
+	tick_length += tick_length_base - old_tick_length_base;
 }
 
 static void ntp_update_offset(long offset)


