Return-Path: <linux-kernel-owner+w=401wt.eu-S1752375AbXCJGU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbXCJGU0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 01:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbXCJGTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 01:19:39 -0500
Received: from tapsys.com ([72.36.178.242]:40064 "EHLO tapsys.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326AbXCJGTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 01:19:08 -0500
Message-ID: <45F24DCE.8060902@madrabbit.org>
Date: Sat, 10 Mar 2007 01:18:54 -0500
From: Ray Lee <ray-lk@madrabbit.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>,
       Vladimir Lebedev <vladimir.p.lebedev@intel.com>,
       Len Brown <len.brown@intel.com>
Subject: Re: Odd suspend regression in 2.6.21-rc[123]
References: <45F0C018.2020409@madrabbit.org>
In-Reply-To: <45F0C018.2020409@madrabbit.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote:
> In 2.6.21-rc1,2,3, my laptop will fully suspend to ram, but then
> *immediately* resumes back from suspension. (It resumes just fine, as well.)
[...]
> HP/Compaq NX6125 system, AMD64, dmesg attached.

hg bisect found the below patch as the culprit, and reverting it does
fix the regression. It's supposed to address "sometime ac/battery update
stops after resume from disk." This thread:
http://lkml.org/lkml/2007/2/24/111 appears to talk about the same issue,
and therefore it may be solved without the below patch, so perhaps we
can all be happy.

Regardless, I think my laptop no longer being able to go into S3 sleep
is a bit more important than someone else's laptop merely not showing
the correct AC status :-).

Please revert. (git patch id ed41dab90eb40ac4911e60406bc653661f0e4ce1)

Ray


ACPI: Disable GPEs in preparation for sleep.

http://bugzilla.kernel.org/show_bug.cgi?id=7887

Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
Signed-off-by: Vladimir Lebedev <vladimir.p.lebedev@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>

committer: Len Brown <len.brown@intel.com>


diff -r 31db4f8c1b77 -r 2a00d393c882 drivers/acpi/hardware/hwsleep.c
--- a/drivers/acpi/hardware/hwsleep.c   Fri Feb 09 10:45:33 2007 -0800
+++ b/drivers/acpi/hardware/hwsleep.c   Sat Feb 10 01:30:35 2007 -0500
@@ -235,6 +235,14 @@ acpi_status acpi_enter_sleep_state_prep(
                                "While executing method _SST"));
        }

+       /*
+        * 1) Disable/Clear all GPEs
+        */
+       status = acpi_hw_disable_all_gpes();
+       if (ACPI_FAILURE(status)) {
+               return_ACPI_STATUS(status);
+       }
+
        return_ACPI_STATUS(AE_OK);
 }

@@ -290,13 +298,8 @@ acpi_status asmlinkage acpi_enter_sleep_
        }

        /*
-        * 1) Disable/Clear all GPEs
         * 2) Enable all wakeup GPEs
         */
-       status = acpi_hw_disable_all_gpes();
-       if (ACPI_FAILURE(status)) {
-               return_ACPI_STATUS(status);
-       }
        acpi_gbl_system_awake_and_running = FALSE;

        status = acpi_hw_enable_all_wakeup_gpes();

