Return-Path: <linux-kernel-owner+w=401wt.eu-S1758517AbYKQHhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517AbYKQHhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:37:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755396AbYKQHVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:21:55 -0500
Received: from kroah.org ([198.145.64.141]:38812 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756088AbYKQHVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:21:47 -0500
Date: Sun, 16 Nov 2008 23:17:24 -0800
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
       alan@lxorguk.ukuu.org.uk, Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 46/46] ACPI: EC: Dont do transaction from GPE handler in
	poll mode.
Message-ID: <20081117071724.GU29522@kroah.com>
References: <20081117070621.430169021@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-ec-don-t-do-transaction-from-gpe-handler-in-poll-mode.patch"
In-Reply-To: <20081117071333.GA29522@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alexey Starikovskiy <astarikovskiy@suse.de>

commit 8517934ef6aaa28d6e055b98df65b31cedbd1372 upstream.

Referencies: http://bugzilla.kernel.org/show_bug.cgi?id=12004

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/ec.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -581,9 +581,12 @@ static u32 acpi_ec_gpe_handler(void *dat
 	pr_debug(PREFIX "~~~> interrupt\n");
 	status = acpi_ec_read_status(ec);
 
-	gpe_transaction(ec, status);
-	if (ec_transaction_done(ec) && (status & ACPI_EC_FLAG_IBF) == 0)
-		wake_up(&ec->wait);
+	if (test_bit(EC_FLAGS_GPE_MODE, &ec->flags)) {
+		gpe_transaction(ec, status);
+		if (ec_transaction_done(ec) &&
+		    (status & ACPI_EC_FLAG_IBF) == 0)
+			wake_up(&ec->wait);
+	}
 
 	ec_check_sci(ec, status);
 	if (!test_bit(EC_FLAGS_GPE_MODE, &ec->flags) &&

-- 
