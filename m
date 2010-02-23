Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab0BWROb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 12:14:31 -0500
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:10572 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752363Ab0BWROa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 12:14:30 -0500
Message-ID: <4B840BC6.9090809@draigBrady.com>
Date: Tue, 23 Feb 2010 17:09:26 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
CC: linux-kernel@vger.kernel.org, wim@iguana.be, seth.heasley@intel.com
Subject: [PATCH] iTCO_wdt: Don't double the requested timeout
References: <20100223164019.60a6de1a@marrow.netinsight.se> <4B840154.1010501@draigBrady.com>
In-Reply-To: <4B840154.1010501@draigBrady.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually looking at that code I noticed that it wasn't
accounting for the timer counting down twice before reboot,
which I thought was the case for ICH4 at least.
The following is not even compiled, nor am I sure it
applies to TCO v2. Testing/info appreciated.
I might be able to dig out an ICH4 system at some stage.

cheers,
Pádraig.

--- a/iTCO_wdt.c    2009-06-10 03:05:27.000000000 +0000
+++ b/iTCO_wdt.c  2010-02-23 17:02:07.829640740 +0000
@@ -274,7 +274,7 @@
  static int heartbeat = WATCHDOG_HEARTBEAT;  /* in seconds */
  module_param(heartbeat, int, 0);
  MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. "
-       "(2<heartbeat<39 (TCO v1) or 613 (TCO v2), default="
+       "(4<heartbeat<78 (TCO v1) or 1226 (TCO v2), default="
                                 __MODULE_STRING(WATCHDOG_HEARTBEAT) ")");

  static int nowayout = WATCHDOG_NOWAYOUT;
@@ -290,8 +290,8 @@
  static inline unsigned int seconds_to_ticks(int seconds)
  {
         /* the internal timer is stored as ticks which decrement
-        * every 0.6 seconds */
-       return (seconds * 10) / 6;
+        * every 0.6 seconds. The timer counts down twice before reboot */
+       return (seconds * 10) / 3;
  }

  static void iTCO_wdt_set_NO_REBOOT_bit(void)
@@ -721,8 +721,8 @@
         if (iTCO_wdt_set_heartbeat(heartbeat)) {
                 iTCO_wdt_set_heartbeat(WATCHDOG_HEARTBEAT);
                 printk(KERN_INFO PFX
-                       "heartbeat value must be 2 < heartbeat < 39 (TCO v1) "
-                               "or 613 (TCO v2), using %d\n", heartbeat);
+                       "heartbeat value must be 4 < heartbeat < 78 (TCO v1) "
+                               "or 1226 (TCO v2), using %d\n", heartbeat);
         }

         ret = misc_register(&iTCO_wdt_miscdev);
