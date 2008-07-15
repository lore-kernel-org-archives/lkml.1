Return-Path: <linux-kernel-owner+w=401wt.eu-S1760773AbYGOWZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760773AbYGOWZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754461AbYGOWYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:24:51 -0400
Received: from ik-out-1112.google.com ([66.249.90.178]:26903 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbYGOWYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:24:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding:sender;
        b=Ut+N0hq+7VaB5E2PDYs1pTptnVuOdgFxJWwXwGotSAuPL45m1ZHLFBGc0YIMV4Lupb
         eb66qXawZLFcZc6/YAy06+kCGMMKA3jzZUb0crqurBMLi0l+y0e3BppG7+AC3AnzUBbs
         agwa+rjXwgazUZuoFaDbClo8x2lWnH23UqMmo=
Message-ID: <487D23C3.5070301@student.cs.york.ac.uk>
Date: Tue, 15 Jul 2008 23:25:07 +0100
From: Alan Jenkins <aj504@student.cs.york.ac.uk>
Reply-To: alan-jenkins@tuffmail.co.uk
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: astarikovskiy@suse.de
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] acpi: Avoid dropping rapid hotkey events (or other GPEs)
 on Asus EeePC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like this EC clears the SMI_EVT bit after every query, even if there
are more events pending.  The workaround is to repeatedly query the EC until
it reports that no events remain.

This fixes a regression in 2.6.26 (from 2.6.25.3).  Initially reported as
"Asus Eee PC hotkeys stop working if pressed quickly" in bugzilla
<http://bugzilla.kernel.org/show_bug.cgi?id=11089>.

The regression was caused by a recently added check for interrupt storms.
The Eee PC triggers this check and switches to polling.  When multiple events
arrive between polling intervals, only one is fetched from the EC.  This causes
erroneous behaviour; ultimately events stop being delivered altogether when the
EC buffer overflows.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>

---
diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 5622aee..2b4c5a2 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -459,14 +459,10 @@ void acpi_ec_remove_query_handler(struct acpi_ec *ec, u8 query_bit)
 
 EXPORT_SYMBOL_GPL(acpi_ec_remove_query_handler);
 
-static void acpi_ec_gpe_query(void *ec_cxt)
+static void acpi_ec_gpe_run_handler(struct acpi_ec *ec, u8 value)
 {
-	struct acpi_ec *ec = ec_cxt;
-	u8 value = 0;
 	struct acpi_ec_query_handler *handler, copy;
 
-	if (!ec || acpi_ec_query(ec, &value))
-		return;
 	mutex_lock(&ec->lock);
 	list_for_each_entry(handler, &ec->list, node) {
 		if (value == handler->query_bit) {
@@ -484,6 +480,18 @@ static void acpi_ec_gpe_query(void *ec_cxt)
 	mutex_unlock(&ec->lock);
 }
 
+static void acpi_ec_gpe_query(void *ec_cxt)
+{
+	struct acpi_ec *ec = ec_cxt;
+	u8 value = 0;
+
+	if (!ec)
+		return;
+
+	while (!acpi_ec_query(ec, &value))
+		acpi_ec_gpe_run_handler(ec, value);
+}
+
 static u32 acpi_ec_gpe_handler(void *data)
 {
 	acpi_status status = AE_OK;


