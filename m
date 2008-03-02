Return-Path: <linux-kernel-owner+w=401wt.eu-S1753935AbYCBGzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbYCBGzf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 01:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbYCBGz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 01:55:28 -0500
Received: from web52011.mail.re2.yahoo.com ([206.190.48.27]:25650 "HELO
	web52011.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751229AbYCBGz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 01:55:27 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Mar 2008 01:55:27 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=kvtKWF+YVbCpD+JXrsFNI43vW7edOBFdI8BUX7Dk4inwNvBBLsTWrwXBHqI/ihxhBlXRyVATIpU6GfubGg/lm26W/noAGOHEuSjgnYyfQqTZOGdwFXtpYbxpIV88hEsMzey3eZItkWIMww6sqafQa+patPhXeIZhcDiLkR501mk=;
X-YMail-OSG: oRYKnQoVM1l_R.Bt83NGKGZx3dPEzCHCqmYGPAZtGae1QNoMV0sBEgwYSDZ8n5i7wN6gteZsTG0TE0Je7IP.QFXit_eLg7IieyNvyY_8IT10KZTBW2Ty6mEuSy1f2OgeVAr6b05cQhB5Bpsyp4S9qh9lLQ--
X-Mailer: YahooMailRC/902.35 YahooMailWebService/0.7.162
Date: Sat, 1 Mar 2008 22:48:45 -0800 (PST)
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Subject: [PATCH v2] Remove obsolete CLOCK_TICK_ADJUST
To: zippel@linux-m68k.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <360162.3798.qm@web52011.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>

The first version of the ntp_interval/tick_length inconsistent usage patch was
recently merged as bbe4d18ac2e058c56adb0cd71f49d9ed3216a405
http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h= \
bbe4d18ac2e058c56adb0cd71f49d9ed3216a405

While the fix did greatly improve the situation, it was correctly pointed out
by Roman that it does have a small bug: If the users change clocksources after
the system has been running and NTP has made corrections, the correctoins made
against the old clocksource will be applied against the new clocksource,
causing error.

The second attempt, which corrects the issue in the NTP_INTERVAL_LENGTH
definition has also made it up-stream as commit
e13a2e61dd5152f5499d2003470acf9c838eab84
http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h= \
e13a2e61dd5152f5499d2003470acf9c838eab84

Roman has correctly pointed out that CLOCK_TICK_ADJUST is calculated
based on the PIT's frequency, and isn't really relevant to non-PIT
driven clocksources (that is, clocksources other then jiffies and pit).

This patch reverts both of those changes, and simply removes
CLOCK_TICK_ADJUST.

This does remove the granularity error correction for users of PIT and Jiffies
clocksource users, but the granularity error but for the majority of users, it
should be within the 500ppm range NTP can accommodate for.

For systems that have granularity errors greater than 500ppm, the
"ntp_tick_adj=" boot option can be used to compensate.

[johnstul@us.ibm.com: provided changelog]

Variable ntp_tick_adj is used only in one file, so it should have keyword
static.

Signed-off-by: Matti Linnanvuori <mattilinnanvuori@yahoo.com>

---

 include/linux/timex.h     |    9 +--------
 kernel/time/ntp.c         |   11 ++++++++++-
 kernel/time/timekeeping.c |    6 ++----
 3 files changed, 13 insertions(+), 13 deletions(-)
diff -puN include/linux/timex.h~time-remove-obsolete-clock_tick_adjust \
                include/linux/timex.h
--- a/include/linux/timex.h~time-remove-obsolete-clock_tick_adjust
+++ a/include/linux/timex.h
@@ -232,14 +232,7 @@ static inline int ntp_synced(void)
 #else
 #define NTP_INTERVAL_FREQ  (HZ)
 #endif
-
-#define CLOCK_TICK_OVERFLOW (LATCH * HZ - CLOCK_TICK_RATE)
-#define CLOCK_TICK_ADJUST (((s64)CLOCK_TICK_OVERFLOW * NSEC_PER_SEC) / \
-     (s64)CLOCK_TICK_RATE)
-
-/* Because using NSEC_PER_SEC would be too easy */
-#define NTP_INTERVAL_LENGTH ((((s64)TICK_USEC * NSEC_PER_USEC * USER_HZ) + \
-         CLOCK_TICK_ADJUST) / NTP_INTERVAL_FREQ)
+#define NTP_INTERVAL_LENGTH (NSEC_PER_SEC/NTP_INTERVAL_FREQ)
 
 /* Returns how long ticks are at present, in ns / 2^(SHIFT_SCALE-10). */
 extern u64 current_tick_length(void);
diff -puN kernel/time/ntp.c~time-remove-obsolete-clock_tick_adjust kernel/time/ntp.c
--- a/kernel/time/ntp.c~time-remove-obsolete-clock_tick_adjust
+++ a/kernel/time/ntp.c
@@ -42,12 +42,13 @@ long time_esterror = NTP_PHASE_LIMIT; /*
 long time_freq;    /* frequency offset (scaled ppm)*/
 static long time_reftime;  /* time at last adjustment (s) */
 long time_adjust;
+static long ntp_tick_adj;
 
 static void ntp_update_frequency(void)
 {
  u64 second_length = (u64)(tick_usec * NSEC_PER_USEC * USER_HZ)
     << TICK_LENGTH_SHIFT;
- second_length += (s64)CLOCK_TICK_ADJUST << TICK_LENGTH_SHIFT;
+ second_length += (s64)ntp_tick_adj << TICK_LENGTH_SHIFT;
  second_length += (s64)time_freq << (TICK_LENGTH_SHIFT - SHIFT_NSEC);
 
  tick_length_base = second_length;
@@ -402,3 +403,11 @@ leave: if ((time_status & (STA_UNSYNC|ST
  notify_cmos_timer();
  return(result);
 }
+
+static int __init ntp_tick_adj_setup(char *str)
+{
+ ntp_tick_adj = simple_strtol(str, NULL, 0);
+ return 1;
+}
+
+__setup("ntp_tick_adj=", ntp_tick_adj_setup);
diff -puN kernel/time/timekeeping.c~time-remove-obsolete-clock_tick_adjust \
                kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~time-remove-obsolete-clock_tick_adjust
+++ a/kernel/time/timekeeping.c
@@ -187,8 +187,7 @@ static void change_clocksource(void)
 
  clock->error = 0;
  clock->xtime_nsec = 0;
- clocksource_calculate_interval(clock,
-  (unsigned long)(current_tick_length()>>TICK_LENGTH_SHIFT));
+ clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
 
  tick_clock_notify();
 
@@ -245,8 +244,7 @@ void __init timekeeping_init(void)
  ntp_clear();
 
  clock = clocksource_get_next();
- clocksource_calculate_interval(clock,
-  (unsigned long)(current_tick_length()>>TICK_LENGTH_SHIFT));
+ clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
  clock->cycle_last = clocksource_read(clock);
 
  xtime.tv_sec = sec;
_


      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ 

