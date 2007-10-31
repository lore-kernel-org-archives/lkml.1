Return-Path: <linux-kernel-owner+w=401wt.eu-S1759482AbXJaPUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759482AbXJaPUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 11:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756634AbXJaPUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 11:20:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35727 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756526AbXJaPUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 11:20:24 -0400
Date: Wed, 31 Oct 2007 08:10:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [patch 01/26] ACPI: disable lower idle C-states across
	suspend/resume
Message-ID: <20071031151044.GB2437@kroah.com>
References: <20071031150535.967437651@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-disable-lower-idle-c-states-across-suspend-resume.patch"
In-Reply-To: <20071031151015.GA2437@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Thomas Gleixner <tglx@linutronix.de>

changeset b04e7bdb984e3b7f62fb7f44146a529f88cc7639 from mainline.

device_suspend() calls ACPI suspend functions, which seems to have undesired
side effects on lower idle C-states. It took me some time to realize that
especially the VAIO BIOSes (both Andrews jinxed UP and my elfstruck SMP one)
show this effect. I'm quite sure that other bug reports against suspend/resume
about turning the system into a brick have the same root cause.

After fishing in the dark for quite some time, I realized that removing the ACPI
processor module before suspend (this removes the lower C-state functionality)
made the problem disappear. Interestingly enough the propability of having a
bricked box is influenced by various factors (interrupts, size of the ram image,
...). Even adding a bunch of printks in the wrong places made the problem go
away. The previous periodic tick implementation simply pampered over the
problem, which explains why the dyntick / clockevents changes made this more
prominent.

We avoid complex functionality during the boot process and we have to do the
same during suspend/resume. It is a similar scenario and equaly fragile.

Add suspend / resume functions to the ACPI processor code and disable the lower
idle C-states across suspend/resume. Fall back to the default idle
implementation (halt) instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/processor_core.c |    2 ++
 drivers/acpi/processor_idle.c |   19 ++++++++++++++++++-
 include/acpi/processor.h      |    2 ++
 3 files changed, 22 insertions(+), 1 deletion(-)

--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -93,6 +93,8 @@ static struct acpi_driver acpi_processor
 		.add = acpi_processor_add,
 		.remove = acpi_processor_remove,
 		.start = acpi_processor_start,
+		.suspend = acpi_processor_suspend,
+		.resume = acpi_processor_resume,
 		},
 };
 
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -324,6 +324,23 @@ static void acpi_state_timer_broadcast(s
 
 #endif
 
+/*
+ * Suspend / resume control
+ */
+static int acpi_idle_suspend;
+
+int acpi_processor_suspend(struct acpi_device * device, pm_message_t state)
+{
+	acpi_idle_suspend = 1;
+	return 0;
+}
+
+int acpi_processor_resume(struct acpi_device * device)
+{
+	acpi_idle_suspend = 0;
+	return 0;
+}
+
 static void acpi_processor_idle(void)
 {
 	struct acpi_processor *pr = NULL;
@@ -354,7 +371,7 @@ static void acpi_processor_idle(void)
 	}
 
 	cx = pr->power.state;
-	if (!cx) {
+	if (!cx || acpi_idle_suspend) {
 		if (pm_idle_save)
 			pm_idle_save();
 		else
--- a/include/acpi/processor.h
+++ b/include/acpi/processor.h
@@ -279,6 +279,8 @@ int acpi_processor_power_init(struct acp
 int acpi_processor_cst_has_changed(struct acpi_processor *pr);
 int acpi_processor_power_exit(struct acpi_processor *pr,
 			      struct acpi_device *device);
+int acpi_processor_suspend(struct acpi_device * device, pm_message_t state);
+int acpi_processor_resume(struct acpi_device * device);
 
 /* in processor_thermal.c */
 int acpi_processor_get_limit_info(struct acpi_processor *pr);

-- 
