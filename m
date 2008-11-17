Return-Path: <linux-kernel-owner+w=401wt.eu-S1757537AbYKQHhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537AbYKQHhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:37:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756126AbYKQHVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:21:48 -0500
Received: from kroah.org ([198.145.64.141]:38773 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753166AbYKQHVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:21:45 -0500
Date: Sun, 16 Nov 2008 23:17:17 -0800
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
Subject: [patch 44/46] ACPI: EC: restart failed command
Message-ID: <20081117071717.GS29522@kroah.com>
References: <20081117070621.430169021@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-ec-restart-failed-command.patch"
In-Reply-To: <20081117071333.GA29522@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alexey Starikovskiy <astarikovskiy@suse.de>

commit a2f93aeadf97e870ff385030633a73e21146815d upstream.

Restart current transaction if we recieved unexpected GPEs instead
of needed ones.

http://bugzilla.kernel.org/show_bug.cgi?id=11896

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/ec.c |   41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -100,6 +100,8 @@ struct transaction {
 	u8 *rdata;
 	unsigned short irq_count;
 	u8 command;
+	u8 wi;
+	u8 ri;
 	u8 wlen;
 	u8 rlen;
 	bool done;
@@ -185,26 +187,34 @@ static int ec_transaction_done(struct ac
 	return ret;
 }
 
+static void start_transaction(struct acpi_ec *ec)
+{
+	ec->curr->irq_count = ec->curr->wi = ec->curr->ri = 0;
+	ec->curr->done = false;
+	acpi_ec_write_cmd(ec, ec->curr->command);
+}
+
 static void gpe_transaction(struct acpi_ec *ec, u8 status)
 {
 	unsigned long flags;
 	spin_lock_irqsave(&ec->curr_lock, flags);
 	if (!ec->curr)
 		goto unlock;
-	if (ec->curr->wlen > 0) {
-		if ((status & ACPI_EC_FLAG_IBF) == 0) {
-			acpi_ec_write_data(ec, *(ec->curr->wdata++));
-			--ec->curr->wlen;
-		} else
+	if (ec->curr->wlen > ec->curr->wi) {
+		if ((status & ACPI_EC_FLAG_IBF) == 0)
+			acpi_ec_write_data(ec,
+				ec->curr->wdata[ec->curr->wi++]);
+		else
 			goto err;
-	} else if (ec->curr->rlen > 0) {
+	} else if (ec->curr->rlen > ec->curr->ri) {
 		if ((status & ACPI_EC_FLAG_OBF) == 1) {
-			*(ec->curr->rdata++) = acpi_ec_read_data(ec);
-			if (--ec->curr->rlen == 0)
+			ec->curr->rdata[ec->curr->ri++] = acpi_ec_read_data(ec);
+			if (ec->curr->rlen == ec->curr->ri)
 				ec->curr->done = true;
 		} else
 			goto err;
-	} else if (ec->curr->wlen == 0 && (status & ACPI_EC_FLAG_IBF) == 0)
+	} else if (ec->curr->wlen == ec->curr->wi &&
+		   (status & ACPI_EC_FLAG_IBF) == 0)
 		ec->curr->done = true;
 	goto unlock;
 err:
@@ -219,6 +229,15 @@ static int acpi_ec_wait(struct acpi_ec *
 	if (wait_event_timeout(ec->wait, ec_transaction_done(ec),
 			       msecs_to_jiffies(ACPI_EC_DELAY)))
 		return 0;
+	/* try restart command if we get any false interrupts */
+	if (ec->curr->irq_count &&
+	    (acpi_ec_read_status(ec) & ACPI_EC_FLAG_IBF) == 0) {
+		pr_debug(PREFIX "controller reset, restart transaction\n");
+		start_transaction(ec);
+		if (wait_event_timeout(ec->wait, ec_transaction_done(ec),
+					msecs_to_jiffies(ACPI_EC_DELAY)))
+			return 0;
+	}
 	/* missing GPEs, switch back to poll mode */
 	if (printk_ratelimit())
 		pr_info(PREFIX "missing confirmations, "
@@ -268,10 +287,8 @@ static int acpi_ec_transaction_unlocked(
 	/* start transaction */
 	spin_lock_irqsave(&ec->curr_lock, tmp);
 	/* following two actions should be kept atomic */
-	t->irq_count = 0;
-	t->done = false;
 	ec->curr = t;
-	acpi_ec_write_cmd(ec, ec->curr->command);
+	start_transaction(ec);
 	if (ec->curr->command == ACPI_EC_COMMAND_QUERY)
 		clear_bit(EC_FLAGS_QUERY_PENDING, &ec->flags);
 	spin_unlock_irqrestore(&ec->curr_lock, tmp);

-- 
