Return-Path: <linux-kernel-owner+w=401wt.eu-S1751855AbXFCVU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbXFCVU1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 17:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbXFCVUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 17:20:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:52714 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbXFCVUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 17:20:14 -0400
From: Olaf Dietsche <olaf+list.linux-acpi@olafdietsche.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [2.6.22-rc3][ACPI?] Resume from s2r doesn't work.
References: <878xb35sje.fsf@goat.bogus.local> <200706012340.54394.rjw@sisk.pl>
	<87hcpr2ubl.fsf@goat.bogus.local> <200706020037.16615.rjw@sisk.pl>
Date: Sun, 03 Jun 2007 23:20:41 +0200
Message-ID: <87wsykpweu.fsf@goat.bogus.local>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Provags-ID: V01U2FsdGVkX18nGP3z6t/cOR0CuGIPGebIixXizqsJMS3WETY
 JPX9NQZz3ERNul+pYEL4oLpbXQDgeV+2rxGDCXbyBDSUxqxn0+
 /ieeC1MqAv5tL/yPFT3Zg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> Second, you can use PM_TRACE (Documentation/power/s2ram.txt) to find the
> place where it really fails.

First I augmented my minimal config kernel with some TRACE_RESUME()s:

--- a/kernel/power/main.c	2007-05-27 23:48:05.000000000 +0200
+++ b/kernel/power/main.c	2007-06-03 22:28:46.000000000 +0200
@@ -223,6 +223,7 @@
 	pr_debug("PM: Finishing wakeup.\n");
 	suspend_finish(state);
  Unlock:
+	TRACE_RESUME(error);
 	mutex_unlock(&pm_mutex);
 	return error;
 }
@@ -303,6 +304,7 @@
 		error = enter_state(state);
 	else
 		error = -EINVAL;
+	TRACE_RESUME(error);
 	return error ? error : n;
 }
 
With this test script:

#! /bin/sh

sync
echo 1 >/sys/power/pm_trace
echo mem >/sys/power/state
shutdown -rn now

I got alternating
  hash matches drivers/base/power/resume.c:58
and
  hash matches kernel/power/main.c:307

> First, you can check if the patch
>
> http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc3/patches/20-ACPI-preserve-the-ebx-value-in-acpi_copy_wakeup_routine.patch

Then I applied this patch, but it doesn't change anything.

But either way the script never reaches "shutdown -rn now". So, it
seems, that my laptop does a full resume every other reboot, but it
never returns to userspace.

> Also, please read Documentation/power/basic-pm-debugging.txt .

Regards, Olaf.
