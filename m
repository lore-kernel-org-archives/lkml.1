Return-Path: <linux-kernel-owner+w=401wt.eu-S1752663AbZIGVO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbZIGVO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 17:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbZIGVO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 17:14:26 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:55470 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbZIGVOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 17:14:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=TSczj2pmi6HTx748siGPShxzzSj9nyF0poaf+zNCfVPuZtOW9JdisclJZlYuifdWzT
         s2EyhUx5c4xpM/sQXImHd/5F6XwShVaQ+qoAO4dcwdJIJO1PRkilVtQfM6+4DzOZemjK
         263QoI+NMWHlOpuEbZ35UfqoLGa548s5blQVM=
Date: Mon, 7 Sep 2009 23:14:23 +0200
From: Karol Lewandowski <karol.k.lewandowski@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: astarikovskiy@suse.de, lenb@kernel.org, linux-acpi@vger.kernel.org,
       rjwysocki@sisk.pl
Subject: [PATCH] Fix ACPI's EC regression from 2.6.29: use usleep() instead
	of msleep()
Message-ID: <20090907211423.GA2535@bizet.domek.prywatny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Following patch reverts commit that changed usleep() to mleep()
in ACPI's EC driver. That change made hotkeys on my Thinkpad T21
unusable after resume.  

This time, it's regression from 2.6.29 (it was repeadly broken and
fixed in older kernels too).
See http://bugzilla.kernel.org/show_bug.cgi?id=11674 for reference.

I've tested this patch with 2.6.31-rc9 -- hotkeys work again.

Please consider applying this to 2.6.31-tree and maybe 2.6.30-stable
as well.


Thanks.


commit 215c964fcccedc3f8967d57f7051e803e746a38d
Author: Karol Lewandowski <karol.k.lewandowski@gmail.com>
Date:   Mon Sep 7 21:13:02 2009 +0200

    Revert "ACPI: EC: Separate delays for MSI hardware"
    
    This reverts commit 34ff4dbccccce54c83b1234d39b7ad9e548a75dd.

    Revert timeout to old value (larger than spec requires[*]) instead
    of using vendor-dependent delays.

    Without this revert my Thinkpad T21 stops generating hotkey events
    after resume (with 2.6.31-rc9).  See bug #11674 for reference.

    [*] ACPI spec at http://www.acpi.info/DOWNLOADS/ACPIspec30b.pdf
    page 386, "Burst Enable Embedded Controller" defines EC's
    response timeout as =< 50us.

Signed-off-by: Karol Lewandowski <karol.k.lewandowski@gmail.com>

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 391f331..20eed99 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -67,7 +67,7 @@ enum ec_command {
 
 #define ACPI_EC_DELAY		500	/* Wait 500ms max. during EC ops */
 #define ACPI_EC_UDELAY_GLK	1000	/* Wait 1ms max. to get global lock */
-#define ACPI_EC_CDELAY		10	/* Wait 10us before polling EC */
+#define ACPI_EC_UDELAY		100	/* Wait 100us before polling EC again */
 
 #define ACPI_EC_STORM_THRESHOLD 8	/* number of false interrupts
 					   per one transaction */
@@ -236,23 +236,13 @@ static int ec_check_sci(struct acpi_ec *ec, u8 state)
 	return 0;
 }
 
-static void ec_delay(void)
-{
-	/* EC in MSI notebooks don't tolerate delays other than 550 usec */
-	if (EC_FLAGS_MSI)
-		udelay(ACPI_EC_DELAY);
-	else
-		/* Use shortest sleep available */
-		msleep(1);
-}
-
 static int ec_poll(struct acpi_ec *ec)
 {
 	unsigned long delay = jiffies + msecs_to_jiffies(ACPI_EC_DELAY);
-	udelay(ACPI_EC_CDELAY);
+	udelay(ACPI_EC_UDELAY);
 	while (time_before(jiffies, delay)) {
 		gpe_transaction(ec, acpi_ec_read_status(ec));
-		ec_delay();
+		udelay(ACPI_EC_UDELAY);
 		if (ec_transaction_done(ec))
 			return 0;
 	}
