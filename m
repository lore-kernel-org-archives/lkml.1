Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbYKZQOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbYKZQOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 11:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbYKZQNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 11:13:37 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49936 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156AbYKZQNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 11:13:36 -0500
Date: Wed, 26 Nov 2008 17:15:24 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, mtk.manpages@gmail.com,
       dl9pf@gmx.de, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Document sysfs interface to RTC system wakeup
Message-ID: <20081126161524.GD1983@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Documentation/rtc.txt b/Documentation/rtc.txt
index 8deffcd..ac843ab 100644
--- a/Documentation/rtc.txt
+++ b/Documentation/rtc.txt
@@ -187,6 +187,88 @@ driver returns ENOIOCTLCMD.  Some common
 
 If all else fails, check out the rtc-test.c driver!
 
+	    Even newer /sys interface
+	    ~~~~~~~~~~~~~~~~~~~~~~~~~
+
+tino.keitel@gmx.de
+
+How to use /sys/class/rtc/rtcX/wakealarm
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+This file takes the seconds since epoch to enable a wake event at the
+specified time.
+
+If a '0' is written, the alarm is disabled.
+
+If the alarm was already enabled, a new alarm can only be set after the
+old alarm is disabled.
+
+
+Migration from /proc/acpi/alarm
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+Users of /proc/acpi/alarm have to change their code to supply the
+seconds since epoch instead of a date string.
+
+For shell scripts, this can be done using the date command, e.g. like
+this:
+
+date -d tomorrow "+%s"
+
+This returns the seconds since epoch of the current time on the
+following day.
+
+Please note that you have to disable the old alarm first, if you want
+to set a new alarm. Otherwise, you get an error. Example:
+
+echo 12345 > /sys/class/rtc/rtc0/wakealarm
+echo 0 > /sys/class/rtc/rtc0/wakealarm
+echo 23456 > /sys/class/rtc/rtc0/wakealarm
+
+
+cd /proc/acpi
+echo EXP0 > wakeup
+echo PCI1 > wakeup
+echo USB0 > wakeup
+echo USB1 > wakeup
+echo USB2 > wakeup
+echo USB7 > wakeup
+echo HDEF > wakeup
+cd /sys/class/rtc/rtc0
+echo $(( $(cat since_epoch) + 20 )) > wakealarm
+
+    [PATCH] RTC gets sysfs wakealarm attribute
+
+    This adds a new "wakealarm" sysfs attribute to RTC class devices which support
+    alarm operations and are wakeup-capable:
+
+     - It reads as either empty, or the scheduled alarm time as seconds
+       since the POSIX epoch.  (That time may already have passed, since
+       nothing currently enforces one-shot alarm semantics.)
+
+     - It can be written with an alarm time in the future, again seconds
+       since the POSIX epoch, which enables the alarm.
+
+     - It can be written with an alarm time not in the future (such as 0,
+       the start of the POSIX epoch) to disable the alarm.
+
+    Usage examples (some need GNU date) after "cd /sys/class/rtc/rtcN":
+
+        alarm after 10 minutes:
+        # echo $(( $(cat since_epoch) + 10 * 60 )) > wakealarm
+        alarm tuesday evening 10pm:
+        # date -d '10pm tuesday' "+%s" > wakealarm
+        disable alarm:
+                # echo 0 > wakealarm
+
+    This resembles the /proc/acpi/alarm file in that nothing happens when the
+    alarm triggers ...  except possibly waking the system from sleep.  It's also
+    like that in a nasty way: not much can be done to prevent one task from
+    clobbering another task's alarm settings.
+
+    It differs from that file in that there's no in-kernel date parser.
+
+    Note that a few RTCs ignore rtc_wkalrm.enabled when setting alarms, or aren't
+    set up correctly, so they won't yet behave with this attribute.
+
 
 -------------------- 8< ---------------- 8< -----------------------------
 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
