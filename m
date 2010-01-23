Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011Ab0AWAXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab0AWAXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755927Ab0AWAWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:22:40 -0500
Received: from kroah.org ([198.145.64.141]:35075 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755414Ab0AWASz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:18:55 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jan 22 16:11:12 2010
Message-Id: <20100123001112.517695294@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 22 Jan 2010 16:10:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>,
       =?ISO-8859-15?q?Fran=C3=A7ois=20Valenduc?= 
	<francois.valenduc@tvcablenet.be>
Subject: [18/29] ACPI: EC: Add wait for irq storm
In-Reply-To: <20100123001145.GA7391@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alexey Starikovskiy <astarikovskiy@suse.de>

commit 54070101f86ca9a6e9ba243c999d144721ec3db7 upstream.

Merge of poll and irq modes accelerated EC transaction, so
that keyboard starts to suffer again. Add msleep(1) into
transaction path for the storm to allow keyboard controller
to do its job.

Reference: http://bugzilla.kernel.org/show_bug.cgi?id=14747

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: François Valenduc <francois.valenduc@tvcablenet.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/ec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -259,7 +259,6 @@ static int acpi_ec_transaction_unlocked(
 		clear_bit(EC_FLAGS_QUERY_PENDING, &ec->flags);
 	spin_unlock_irqrestore(&ec->curr_lock, tmp);
 	ret = ec_poll(ec);
-	pr_debug(PREFIX "transaction end\n");
 	spin_lock_irqsave(&ec->curr_lock, tmp);
 	ec->curr = NULL;
 	spin_unlock_irqrestore(&ec->curr_lock, tmp);
@@ -316,6 +315,7 @@ static int acpi_ec_transaction(struct ac
 	/* check if we received SCI during transaction */
 	ec_check_sci_sync(ec, acpi_ec_read_status(ec));
 	if (test_bit(EC_FLAGS_GPE_STORM, &ec->flags)) {
+		msleep(1);
 		/* it is safe to enable GPE outside of transaction */
 		acpi_enable_gpe(NULL, ec->gpe);
 	} else if (t->irq_count > ACPI_EC_STORM_THRESHOLD) {
@@ -323,6 +323,7 @@ static int acpi_ec_transaction(struct ac
 			"transactions will use polling mode\n");
 		set_bit(EC_FLAGS_GPE_STORM, &ec->flags);
 	}
+	pr_debug(PREFIX "transaction end\n");
 end:
 	if (ec->global_lock)
 		acpi_release_global_lock(glk);


