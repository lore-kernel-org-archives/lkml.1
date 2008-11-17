Return-Path: <linux-kernel-owner+w=401wt.eu-S1753027AbYKQHZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbYKQHZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbYKQHVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:21:09 -0500
Received: from kroah.org ([198.145.64.141]:38291 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752606AbYKQHU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:20:59 -0500
Date: Sun, 16 Nov 2008 23:14:57 -0800
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
       Len Brown <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 12/46] ACPI: EC: make kernel messages more useful when GPE
	storm is detected
Message-ID: <20081117071457.GM29522@kroah.com>
References: <20081117070621.430169021@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-ec-make-kernel-messages-more-useful-when-gpe-storm-is-detected.patch"
In-Reply-To: <20081117071333.GA29522@kroah.com>
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
