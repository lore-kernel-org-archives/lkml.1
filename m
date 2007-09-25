Return-Path: <linux-kernel-owner+w=401wt.eu-S1753489AbXIYMyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbXIYMyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 08:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbXIYMyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 08:54:06 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:46171 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750980AbXIYMyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 08:54:04 -0400
Message-ID: <46F904C9.7080009@suse.de>
Date: Tue, 25 Sep 2007 16:53:29 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Alexey Starikovskiy <aystarik@gmail.com>,
       Damien Wyart <damien.wyart@free.fr>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       Frans Pop <elendil@planet.nl>, linux-acpi@vger.kernel.org
Subject: Re: ACPI power off regression in 2.6.23-rc8 (NOT in rc7)
References: <20070925065109.GA3080@localhost.localdomain> <200709251405.26861.rjw@sisk.pl> <46F8F98F.60206@gmail.com> <200709251439.21519.rjw@sisk.pl>
In-Reply-To: <200709251439.21519.rjw@sisk.pl>
Content-Type: multipart/mixed;
 boundary="------------090509040107080707050001"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090509040107080707050001
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Rafael J. Wysocki wrote:
> On Tuesday, 25 September 2007 14:05, Alexey Starikovskiy wrote:
>> Rafael J. Wysocki wrote:
>>> On Tuesday, 25 September 2007 13:45, Rafael J. Wysocki wrote:
>>>> On Tuesday, 25 September 2007 11:58, Damien Wyart wrote:
>>>>>>> No, I do not have CONFIG_ACPI_SLEEP set,
>>>>>>> because I do not have CONFIG_PM_SLEEP set,
>>>>>>> because I do not want SUSPEND and/or HIBERNATION.
>>>>>> Same answer from my side: I do not have CONFIG_ACPI_SLEEP for the same
>>>>>> reason (and this worked fine without them in rc7). I do not think
>>>>>> these settings should have changed between rc7 and rc8.
>>>> Well, we haven't changed much.
>>>>
>>>>> Also, another test I just did: on another computer, rc8 is fine
>>>>> regarding ACPI power off, even if CONFIG_ACPI_SLEEP is not set. I can
>>>>> provide config if needed.
>>>> On the box that fails to power off, can you please test -rc8 with these two
>>>> commits reverted:
>>>>
>>>> commit 5a50fe709d527f31169263e36601dd83446d5744
>>>> ACPI: suspend: consolidate handling of Sx states addendum
>>>>
>>>> commit f216cc3748a3a22c2b99390fddcdafa0583791a2
>>>> ACPI: suspend: consolidate handling of Sx states.
>>>>
>>>> and see if it works?
>>> If it does, please test the patch from this message
>>>
>>> http://marc.info/?l=linux-kernel&m=119052978117735&w=4
>>>
>>> on top of vanilla 2.6.23-rc8.
>> You will need one more patch on top of just mentioned one.
> 
> Hm, why did you put acpi_target_sleep_state under CONFIG_SUSPEND?
> 
> CONFIG_HIBERNATION needs acpi_target_sleep_state  too.
Agree, attaching updated patch.

Thanks,
Alex.

--------------090509040107080707050001
Content-Type: text/x-patch;
 name="fix-ACPI_SLEEP_states.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix-ACPI_SLEEP_states.patch"

ACPI: suspend: fix ACPI_SLEEP states

From: Alexey Starikovskiy <astarikovskiy@suse.de>

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
---

 drivers/acpi/sleep/Makefile |    2 +-
 drivers/acpi/sleep/main.c   |    5 +++++
 include/acpi/acpi_drivers.h |    4 ----
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/sleep/Makefile b/drivers/acpi/sleep/Makefile
index ba9bd40..f1fb888 100644
--- a/drivers/acpi/sleep/Makefile
+++ b/drivers/acpi/sleep/Makefile
@@ -1,5 +1,5 @@
 obj-y					:= wakeup.o
-obj-$(CONFIG_ACPI_SLEEP)		+= main.o
+obj-y					+= main.o
 obj-$(CONFIG_ACPI_SLEEP)		+= proc.o
 
 EXTRA_CFLAGS += $(ACPI_CFLAGS)
diff --git a/drivers/acpi/sleep/main.c b/drivers/acpi/sleep/main.c
index c79edcb..6ea0628 100644
--- a/drivers/acpi/sleep/main.c
+++ b/drivers/acpi/sleep/main.c
@@ -24,7 +24,9 @@
 
 u8 sleep_states[ACPI_S_STATE_COUNT];
 
+#if defined(CONFIG_SUSPEND)||defined(CONFIG_HIBERNATION)
 static u32 acpi_target_sleep_state = ACPI_STATE_S0;
+#endif
 
 int acpi_sleep_prepare(u32 acpi_state)
 {
@@ -48,6 +50,7 @@ int acpi_sleep_prepare(u32 acpi_state)
 }
 
 #ifdef CONFIG_SUSPEND
+
 static struct pm_ops acpi_pm_ops;
 
 extern void do_suspend_lowlevel(void);
@@ -299,6 +302,7 @@ int acpi_suspend(u32 acpi_state)
 	return -EINVAL;
 }
 
+#ifdef CONFIG_PM_SLEEP
 /**
  *	acpi_pm_device_sleep_state - return preferred power state of ACPI device
  *		in the system sleep state given by %acpi_target_sleep_state
@@ -373,6 +377,7 @@ int acpi_pm_device_sleep_state(struct device *dev, int wake, int *d_min_p)
 		*d_min_p = d_min;
 	return d_max;
 }
+#endif
 
 static void acpi_power_off_prepare(void)
 {
diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
index 202acb9..f85f77a 100644
--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -147,10 +147,6 @@ static inline void unregister_hotplug_dock_device(acpi_handle handle)
 /*--------------------------------------------------------------------------
                                   Suspend/Resume
   -------------------------------------------------------------------------- */
-#ifdef CONFIG_ACPI_SLEEP
 extern int acpi_sleep_init(void);
-#else
-static inline int acpi_sleep_init(void) { return 0; }
-#endif
 
 #endif /*__ACPI_DRIVERS_H__*/

--------------090509040107080707050001--
