Return-Path: <linux-kernel-owner+w=401wt.eu-S1760831AbYKDXz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760831AbYKDXz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757534AbYKDXky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:40:54 -0500
Received: from mx1.suse.de ([195.135.220.2]:47879 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757642AbYKDXkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:40:53 -0500
Date: Tue, 4 Nov 2008 15:33:20 -0800
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
       Len Brown <len.brown@intel.com>
Subject: [patch 49/57] ACPI: EC: Check for IBF=0 periodically if not in GPE
	mode
Message-ID: <20081104233320.GX659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-ec-check-for-ibf-0-periodically-if-not-in-gpe-mode.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alexey Starikovskiy <astarikovskiy@suse.de>

commit c0ff17720ec5f42205b3d2ca03a18da0a8272976 upstream.

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Tested-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/ec.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -298,6 +298,18 @@ static int ec_check_ibf0(struct acpi_ec 
 	return (status & ACPI_EC_FLAG_IBF) == 0;
 }
 
+static int ec_wait_ibf0(struct acpi_ec *ec)
+{
+	unsigned long delay = jiffies + msecs_to_jiffies(ACPI_EC_DELAY);
+	/* interrupt wait manually if GPE mode is not active */
+	unsigned long timeout = test_bit(EC_FLAGS_GPE_MODE, &ec->flags) ?
+		msecs_to_jiffies(ACPI_EC_DELAY) : msecs_to_jiffies(1);
+	while (time_before(jiffies, delay))
+		if (wait_event_timeout(ec->wait, ec_check_ibf0(ec), timeout))
+			return 0;
+	return -ETIME;
+}
+
 static int acpi_ec_transaction(struct acpi_ec *ec, struct transaction *t,
 			       int force_poll)
 {
@@ -315,8 +327,7 @@ static int acpi_ec_transaction(struct ac
 			goto unlock;
 		}
 	}
-	if (!wait_event_timeout(ec->wait, ec_check_ibf0(ec),
-				msecs_to_jiffies(ACPI_EC_DELAY))) {
+	if (ec_wait_ibf0(ec)) {
 		pr_err(PREFIX "input buffer is not empty, "
 				"aborting transaction\n");
 		status = -ETIME;

-- 
