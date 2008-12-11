Return-Path: <linux-kernel-owner+w=401wt.eu-S1756988AbYLKTX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbYLKTX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:23:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757425AbYLKTSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:21 -0500
Received: from kroah.org ([198.145.64.141]:55893 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756851AbYLKTSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:07 -0500
Date: Thu, 11 Dec 2008 11:14:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <len.brown@intel.com>
Subject: [patch 15/83] ACPI suspend: Blacklist boxes that require us to set
	SCI_EN directly on resume
Message-ID: <20081211191402.GO5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-suspend-blacklist-boxes-that-require-us-to-set-sci_en-directly-on-resume.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rafael J. Wysocki <rjw@sisk.pl>

commit 65df78473ffbf3bff5e2034df1638acc4f3ddd50 upstream.

Some Apple boxes evidently require us to set SCI_EN on resume
directly, because if we don't do that, they hung somewhere in the
resume code path.  Moreover, on these boxes it is not sufficient to
use acpi_enable() to turn ACPI on during resume.  All of this is
against the ACPI specification which states that (1) the BIOS is
supposed to return from the S3 sleep state with ACPI enabled
(SCI_EN set) and (2) the SCI_EN bit is owned by the hardware and we
are not supposed to change it.

For this reason, blacklist the affected systems so that the SCI_EN
bit is set during resume on them.

[NOTE: Unconditional setting SCI_EN for all system on resume doesn't
 work, because it makes some other systems crash (that's to be
 expected).  Also, it is not entirely clear right now if all of the
 Apple boxes require this workaround.]

This patch fixes the recent regression tracked as
http://bugzilla.kernel.org/show_bug.cgi?id=12038

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Tested-by: Tino Keitel <tino.keitel@gmx.de>
Tested-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/sleep/main.c |   40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

--- a/drivers/acpi/sleep/main.c
+++ b/drivers/acpi/sleep/main.c
@@ -60,6 +60,18 @@ void __init acpi_old_suspend_ordering(vo
 	old_suspend_ordering = true;
 }
 
+/*
+ * According to the ACPI specification the BIOS should make sure that ACPI is
+ * enabled and SCI_EN bit is set on wake-up from S1 - S3 sleep states.  Still,
+ * some BIOSes don't do that and therefore we use acpi_enable() to enable ACPI
+ * on such systems during resume.  Unfortunately that doesn't help in
+ * particularly pathological cases in which SCI_EN has to be set directly on
+ * resume, although the specification states very clearly that this flag is
+ * owned by the hardware.  The set_sci_en_on_resume variable will be set in such
+ * cases.
+ */
+static bool set_sci_en_on_resume;
+
 /**
  *	acpi_pm_disable_gpes - Disable the GPEs.
  */
@@ -201,7 +213,11 @@ static int acpi_suspend_enter(suspend_st
 	}
 
 	/* If ACPI is not enabled by the BIOS, we need to enable it here. */
-	acpi_enable();
+	if (set_sci_en_on_resume)
+		acpi_set_register(ACPI_BITREG_SCI_ENABLE, 1);
+	else
+		acpi_enable();
+
 	/* Reprogram control registers and execute _BFS */
 	acpi_leave_sleep_state_prep(acpi_state);
 
@@ -289,6 +305,12 @@ static int __init init_old_suspend_order
 	return 0;
 }
 
+static int __init init_set_sci_en_on_resume(const struct dmi_system_id *d)
+{
+	set_sci_en_on_resume = true;
+	return 0;
+}
+
 static struct dmi_system_id __initdata acpisleep_dmi_table[] = {
 	{
 	.callback = init_old_suspend_ordering,
@@ -306,6 +328,22 @@ static struct dmi_system_id __initdata a
 		DMI_MATCH(DMI_PRODUCT_NAME, "HP xw4600 Workstation"),
 		},
 	},
+	{
+	.callback = init_set_sci_en_on_resume,
+	.ident = "Apple MacBook 1,1",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Apple Computer, Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "MacBook1,1"),
+		},
+	},
+	{
+	.callback = init_set_sci_en_on_resume,
+	.ident = "Apple MacMini 1,1",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Apple Computer, Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Macmini1,1"),
+		},
+	},
 	{},
 };
 #endif /* CONFIG_SUSPEND */

