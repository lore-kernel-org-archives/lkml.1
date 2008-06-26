Return-Path: <linux-kernel-owner+w=401wt.eu-S1755926AbYFZIAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbYFZIAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 04:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbYFZIAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 04:00:06 -0400
Received: from sirf.com ([125.16.220.82]:23024 "HELO bnglmail.sirf.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1751926AbYFZIAE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 04:00:04 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: Time drifting after multiple sleep/wakeup in timekeeping
Date: Thu, 26 Jun 2008 13:30:01 +0530
Message-ID: <013B1C915F9462459242424413ABB264011AC7AC@bnglmail.sirf.com>
In-reply-to: <e2e108260806252347m7a6b114by5b5100a86ce35a55@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Time drifting after multiple sleep/wakeup in timekeeping
Thread-Index: AcjXWIZjLldiOdxUS06ml0znYBs4agACVaPQ
From: "Mayank Sharma" <mayanks@sirf.com>
To: "Bart Van Assche" <bart.vanassche@gmail.com>
Cc: "lkml" <linux-kernel@vger.kernel.org>, <linux-arm@lists.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

I have observed this behaviour on 2.6.23-17. The diff in my earlier mail was with the latest kernel.

I am cc'ing linux-arm on this mail. In my opinion the problem was not restrictive to ARM and hence I posted this message in the linux-kernel list.

-Mayank 

-----Original Message-----
From: Bart Van Assche [mailto:bart.vanassche@gmail.com] 
Sent: Thursday, June 26, 2008 12:18 PM
To: Mayank Sharma
Cc: lkml
Subject: Re: Time drifting after multiple sleep/wakeup in timekeeping

On Wed, Jun 25, 2008 at 1:48 PM, Mayank Sharma <mayanks@sirf.com> wrote:
> I noticed a bug with respect to time drifting after multiple sleep/wakeup sequence.

I suggest that you CC at least one ARM-specific mailing list, and also that you specify which kernel version the original behavior was observed on. Were you working with a vanilla Linux kernel or a patched one ?

Bart.

Forwarded Message for linux-arm mailing list
Hi,

I noticed a bug with respect to time drifting after multiple sleep/wakeup sequence. We have an embedded ARM11 based platform on which we have successfuly ported Linux. We also have a RTC on board. Hence we have implemented the read_persistent_clock() function overriding the one defined in kernel/time/timekeeping.c. What we observed was that after doing multiple sleep/wakeup sequences, the time reported by RTC and gettimeofday was drifting. After about 10 iterations the gettimeofday was lagging by about one second. Subsequently the lag only increased. 

What looks to me is that in the timekeeping_resume function we are adding the number of seconds we have been sleeping to adjust the new time. But since we are adding only the seconds slept the update is only second level accurate. read_persistent_clock gives a second level granulaity, and hence we cannot help that. Hence after one sleep/wake sequence the gettimeoday would have lagged by delta (where delta is less than a second). On multiple such iterations the delta keeps adding up, becoming a second and thereafter we see a drift of more than a second.

If however we set the gettimeofday (xtime) to the RTC time on wakeup (Just like we do in timekeeping_init()) instead of just adding the sleep time, the drift will not accumulate. I am using the patch mentioned in the end of the mail to fix this issue. Let me know if this is a valid patch.

Regards,
Mayank

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c index e91c29f..6edf37f 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -288,12 +288,19 @@ static int timekeeping_resume(struct sys_device *dev)
        if (now && (now > timekeeping_suspend_time)) {
                unsigned long sleep_length = now - timekeeping_suspend_time;
 
-               xtime.tv_sec += sleep_length;
+               /* Syncronize the xtime with the rtc as is done during init. This
+                * ensures that drift is not accumulated while sleeping and waking
+                * multiple times
+                */
+               xtime.tv_sec = now;
+               xtime.tv_nsec = 0;
                wall_to_monotonic.tv_sec -= sleep_length;
                total_sleep_time += sleep_length;
        }
        /* Make sure that we have the correct xtime reference */
-       timespec_add_ns(&xtime, timekeeping_suspend_nsecs);
+       else {
+               timespec_add_ns(&xtime, timekeeping_suspend_nsecs);
+    }
        update_xtime_cache(0);
        /* re-base the last cycle value */
        clock->cycle_last = 0;

