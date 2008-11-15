Return-Path: <linux-kernel-owner+w=401wt.eu-S1756378AbYKOF3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378AbYKOF3I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 00:29:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbYKOFZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 00:25:14 -0500
Received: from kroah.org ([198.145.64.141]:50582 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753511AbYKOFZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 00:25:03 -0500
Date: Fri, 14 Nov 2008 21:23:23 -0800
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
       alan@lxorguk.ukuu.org.uk, Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [patch 12/22] ACPI: EC: make kernel messages more useful when GPE
	storm is detected
Message-ID: <20081115052323.GM3710@kroah.com>
References: <20081115051732.506914008@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-ec-make-kernel-messages-more-useful-when-gpe-storm-is-detected.patch"
In-Reply-To: <20081115052220.GA3710@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>

commit f8248434e6a11d7cd314281be3b39bbcf82fc243 upstream.

Make sure we can tell if the GPE storm workaround gets activated,
and avoid flooding the logs afterwards.

http://bugzilla.kernel.org/show_bug.cgi?id=11841
"plenty of line "ACPI: EC: non-query interrupt received,
 switching to interrupt mode" in dmesg"

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Acked-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/ec.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -286,7 +286,8 @@ static int acpi_ec_transaction_unlocked(
 		acpi_enable_gpe(NULL, ec->gpe, ACPI_NOT_ISR);
 	} else if (test_bit(EC_FLAGS_GPE_MODE, &ec->flags) &&
 		   t->irq_count > ACPI_EC_STORM_THRESHOLD) {
-		pr_debug(PREFIX "GPE storm detected\n");
+		pr_info(PREFIX "GPE storm detected, "
+			"transactions will use polling mode\n");
 		set_bit(EC_FLAGS_GPE_STORM, &ec->flags);
 	}
 	return ret;
@@ -566,9 +567,15 @@ static u32 acpi_ec_gpe_handler(void *dat
 	if (!test_bit(EC_FLAGS_GPE_MODE, &ec->flags) &&
 	    !test_bit(EC_FLAGS_NO_GPE, &ec->flags)) {
 		/* this is non-query, must be confirmation */
-		if (printk_ratelimit())
-			pr_info(PREFIX "non-query interrupt received,"
+		if (!test_bit(EC_FLAGS_GPE_STORM, &ec->flags)) {
+			if (printk_ratelimit())
+				pr_info(PREFIX "non-query interrupt received,"
+					" switching to interrupt mode\n");
+		} else {
+			/* hush, STORM switches the mode every transaction */
+			pr_debug(PREFIX "non-query interrupt received,"
 				" switching to interrupt mode\n");
+		}
 		set_bit(EC_FLAGS_GPE_MODE, &ec->flags);
 	}
 	return ACPI_INTERRUPT_HANDLED;

-- 
