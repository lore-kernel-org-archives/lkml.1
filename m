Return-Path: <linux-kernel-owner+w=401wt.eu-S1754927AbYGSLi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbYGSLi5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 07:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYGSLit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 07:38:49 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:5170 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbYGSLis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 07:38:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=LYvKevfGjUR+405tnajUa5yOcK1S+OdPe5a9lWvoBewaY62p8pSt5Sjq4cAwUPOvgm
         IUoi06/VgXwfQmfrdAkJbPmN+eo7O9YyATnOEoA1JT9LkdeD3FfIQ/rUxNxtql3reSRA
         8O8WC31si0OHcP1yc8CBbyvDAKEzqmZYEOlNI=
Message-ID: <4881D259.3040202@tuffmail.co.uk>
Date: Sat, 19 Jul 2008 12:39:05 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Alexey Starikovskiy <astarikovskiy@suse.de>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] acpi: Avoid dropping rapid GPEs on Asus EeePC and others
References: <487D23C3.5070301@student.cs.york.ac.uk> <487F31D7.30803@suse.de> <20080717121309.GF31732@khazad-dum.debian.net> <487F3B6D.3090507@suse.de> <20080717162628.GB18457@khazad-dum.debian.net> <487F7724.5080905@tuffmail.co.uk> <20080717185032.GD18457@khazad-dum.debian.net> <487F986A.3070504@tuffmail.co.uk> <4881CE72.1090401@tuffmail.co.uk>
In-Reply-To: <4881CE72.1090401@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>

Fix regression "Asus Eee PC hotkeys stop working if pressed quickly",
<http://bugzilla.kernel.org/show_bug.cgi?id=11089>.  More important 
notifications e.g. battery level may also be affected.

It looks like this EC clears the SCI_EVT bit after every query, but there may
be more events buffered.  Therefore we should repeatedly query the EC until it
reports that no events remain.

The regression was caused by a recently added check for GPE interrupt storms.
The Eee PC triggers this check and switches to polling GPEs.  When multiple 
events arrive between polling intervals, only one was fetched from the EC.
This caused erroneous behaviour; ultimately events stop being delivered 
altogether when the EC buffer overflows.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Tested-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 9ca71df..e764011 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -457,14 +457,10 @@ void acpi_ec_remove_query_handler(struct acpi_ec *ec, u8 query_bit)
 
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
@@ -482,6 +478,18 @@ static void acpi_ec_gpe_query(void *ec_cxt)
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
+	while (acpi_ec_query(ec, &value) == 0)
+		acpi_ec_gpe_run_handler(ec, value);
+}
+
 static u32 acpi_ec_gpe_handler(void *data)
 {
 	acpi_status status = AE_OK;


