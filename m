Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab0BXQXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 11:23:22 -0500
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:6224 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757270Ab0BXQXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 11:23:21 -0500
Message-ID: <4B855140.7030408@draigBrady.com>
Date: Wed, 24 Feb 2010 16:18:08 +0000
From: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
CC: linux-kernel@vger.kernel.org, wim@iguana.be, seth.heasley@intel.com
Subject: Re: [PATCH] iTCO_wdt: Don't double the requested timeout
References: <20100223164019.60a6de1a@marrow.netinsight.se>	<4B840154.1010501@draigBrady.com>	<4B840BC6.9090809@draigBrady.com> <20100224101618.39c3468b@marrow.netinsight.se>
In-Reply-To: <20100224101618.39c3468b@marrow.netinsight.se>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/02/10 09:16, Simon Kagstrom wrote:
> On Tue, 23 Feb 2010 17:09:26 +0000
> Pádraig Brady<P@draigBrady.com>  wrote:
>
>> Actually looking at that code I noticed that it wasn't
>> accounting for the timer counting down twice before reboot,
>> which I thought was the case for ICH4 at least.
>> The following is not even compiled, nor am I sure it
>> applies to TCO v2. Testing/info appreciated.
>
> I tested your change on our TCO v1-based board, and it doubles the time
> until the watchdog triggers. So:

Well it should be halving the timeout :)
I amended the patch and Simon retested to verify
that it now honors the requested timeout.

I also checked an ICH7 box here and it doesn't
seem to need the adjustment, so I've amended the patch accordingly.

Wim, please apply, thanks...


iTCO_wdt: fix TCO V1 timeout values and limits

For TCO V1 devices the programmed timeout was twice too long
because the fact that the TCO V1 timer needs to count down
twice before triggering the watchdog, wasn't accounted for.
Also the timeout values in the module description and error
message were clarified.

Signed-off-by: Pádraig Brady <P@draigBrady.com>
Tested-by: Simon Kagstrom <simon.kagstrom@netinsight.se>

--- a/iTCO_wdt.c        2010-02-24 13:43:54.815676860 +0000
+++ b/iTCO_wdt.c        2010-02-24 15:18:33.341640363 +0000
@@ -304,8 +304,8 @@
  #define WATCHDOG_HEARTBEAT 30  /* 30 sec default heartbeat */
  static int heartbeat = WATCHDOG_HEARTBEAT;  /* in seconds */
  module_param(heartbeat, int, 0);
-MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. "
-       "(2<heartbeat<39 (TCO v1) or 613 (TCO v2), default="
+MODULE_PARM_DESC(heartbeat, "Watchdog timeout in seconds. "
+       "(5..76 (TCO v1) or 3..614 (TCO v2), default="
                                 __MODULE_STRING(WATCHDOG_HEARTBEAT) ")");

  static int nowayout = WATCHDOG_NOWAYOUT;
@@ -321,8 +321,12 @@
  static inline unsigned int seconds_to_ticks(int seconds)
  {
         /* the internal timer is stored as ticks which decrement
-        * every 0.6 seconds */
-       return (seconds * 10) / 6;
+        * every 0.6 seconds. For TCO v1 the timer counts down
+        * twice before triggering the watchdog */
+       if (iTCO_wdt_private.iTCO_version == 1)
+               return (seconds * 5) / 6;
+       else
+               return (seconds * 10) / 6;
  }

  static void iTCO_wdt_set_NO_REBOOT_bit(void)
@@ -756,9 +760,14 @@
            if not reset to the default */
         if (iTCO_wdt_set_heartbeat(heartbeat)) {
                 iTCO_wdt_set_heartbeat(WATCHDOG_HEARTBEAT);
+               int tco_min=5; int tco_max=76; /* TCO V1 */
+               if (iTCO_wdt_private.iTCO_version == 2) {
+                       tco_min=3; tco_max=614;
+               }
                 printk(KERN_INFO PFX
-                       "heartbeat value must be 2 < heartbeat < 39 (TCO v1) "
-                               "or 613 (TCO v2), using %d\n", heartbeat);
+                       "timeout value %d is not between %d and %d"
+                       " inclusive, using %d\n",
+                       heartbeat, tco_min, tco_max, WATCHDOG_HEARTBEAT);
         }

         ret = misc_register(&iTCO_wdt_miscdev);
