Return-Path: <linux-kernel-owner+w=401wt.eu-S1758773AbYKQHgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773AbYKQHgd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:36:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756062AbYKQHVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:21:46 -0500
Received: from kroah.org ([198.145.64.141]:38764 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756008AbYKQHVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:21:43 -0500
Date: Sun, 16 Nov 2008 23:17:10 -0800
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
Subject: [patch 43/46] ACPI: EC: wait for last write gpe
Message-ID: <20081117071709.GR29522@kroah.com>
References: <20081117070621.430169021@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-ec-wait-for-last-write-gpe.patch"
In-Reply-To: <20081117071333.GA29522@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alexey Starikovskiy <astarikovskiy@suse.de>

commit dd15f8c42af09031e27da5b4d697ce925511f2e1 upstream.

There is a possibility that EC might break if next command is
issued within 1 us after write or burst-disable command.

Suggestd-by: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/ec.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -102,6 +102,7 @@ struct transaction {
 	u8 command;
 	u8 wlen;
 	u8 rlen;
+	bool done;
 };
 
 static struct acpi_ec {
@@ -178,7 +179,7 @@ static int ec_transaction_done(struct ac
 	unsigned long flags;
 	int ret = 0;
 	spin_lock_irqsave(&ec->curr_lock, flags);
-	if (!ec->curr || (!ec->curr->wlen && !ec->curr->rlen))
+	if (!ec->curr || ec->curr->done)
 		ret = 1;
 	spin_unlock_irqrestore(&ec->curr_lock, flags);
 	return ret;
@@ -195,17 +196,20 @@ static void gpe_transaction(struct acpi_
 			acpi_ec_write_data(ec, *(ec->curr->wdata++));
 			--ec->curr->wlen;
 		} else
-			/* false interrupt, state didn't change */
-			++ec->curr->irq_count;
-
+			goto err;
 	} else if (ec->curr->rlen > 0) {
 		if ((status & ACPI_EC_FLAG_OBF) == 1) {
 			*(ec->curr->rdata++) = acpi_ec_read_data(ec);
-			--ec->curr->rlen;
+			if (--ec->curr->rlen == 0)
+				ec->curr->done = true;
 		} else
-			/* false interrupt, state didn't change */
-			++ec->curr->irq_count;
-	}
+			goto err;
+	} else if (ec->curr->wlen == 0 && (status & ACPI_EC_FLAG_IBF) == 0)
+		ec->curr->done = true;
+	goto unlock;
+err:
+	/* false interrupt, state didn't change */
+	++ec->curr->irq_count;
 unlock:
 	spin_unlock_irqrestore(&ec->curr_lock, flags);
 }
@@ -265,6 +269,7 @@ static int acpi_ec_transaction_unlocked(
 	spin_lock_irqsave(&ec->curr_lock, tmp);
 	/* following two actions should be kept atomic */
 	t->irq_count = 0;
+	t->done = false;
 	ec->curr = t;
 	acpi_ec_write_cmd(ec, ec->curr->command);
 	if (ec->curr->command == ACPI_EC_COMMAND_QUERY)

-- 
