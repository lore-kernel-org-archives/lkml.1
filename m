Return-Path: <linux-kernel-owner+w=401wt.eu-S1757566AbYGVXYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbYGVXYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756814AbYGVXTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:19:08 -0400
Received: from ns2.suse.de ([195.135.220.15]:57682 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755922AbYGVXTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:19:07 -0400
Date: Tue, 22 Jul 2008 16:15:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 18/47] SCSI: esp: tidy up target reference counting
Message-ID: <20080722231530.GS8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="scsi-esp-tidy-up-target-reference-counting.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: James Bottomley <James.Bottomley@HansenPartnership.com>

commit ec5e69f6d3f4350681d6f7eaae515cf014be9276 upstream

The esp driver currently does hand rolled reference counting of its
target.  It's much easier to do what it needs to do if it's plugged into
the mid-layer callbacks (target_alloc and target_destroy) which were
designed for this case, so do it this way and get rid of the internal
target reference count.

Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/esp_scsi.c |   30 ++++++++++++++++++++----------
 drivers/scsi/esp_scsi.h |    1 -
 2 files changed, 20 insertions(+), 11 deletions(-)

--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2352,6 +2352,24 @@ void scsi_esp_unregister(struct esp *esp
 }
 EXPORT_SYMBOL(scsi_esp_unregister);
 
+static int esp_target_alloc(struct scsi_target *starget)
+{
+	struct esp *esp = shost_priv(dev_to_shost(&starget->dev));
+	struct esp_target_data *tp = &esp->target[starget->id];
+
+	tp->starget = starget;
+
+	return 0;
+}
+
+static void esp_target_destroy(struct scsi_target *starget)
+{
+	struct esp *esp = shost_priv(dev_to_shost(&starget->dev));
+	struct esp_target_data *tp = &esp->target[starget->id];
+
+	tp->starget = NULL;
+}
+
 static int esp_slave_alloc(struct scsi_device *dev)
 {
 	struct esp *esp = shost_priv(dev->host);
@@ -2363,9 +2381,6 @@ static int esp_slave_alloc(struct scsi_d
 		return -ENOMEM;
 	dev->hostdata = lp;
 
-	tp->starget = dev->sdev_target;
-	tp->starget_ref++;
-
 	spi_min_period(tp->starget) = esp->min_period;
 	spi_max_offset(tp->starget) = 15;
 
@@ -2413,17 +2428,10 @@ static int esp_slave_configure(struct sc
 
 static void esp_slave_destroy(struct scsi_device *dev)
 {
-	struct esp *esp = shost_priv(dev->host);
-	struct esp_target_data *tp = &esp->target[dev->id];
 	struct esp_lun_data *lp = dev->hostdata;
 
 	kfree(lp);
 	dev->hostdata = NULL;
-
-	BUG_ON(tp->starget_ref <= 0);
-
-	if (!--tp->starget_ref)
-		tp->starget = NULL;
 }
 
 static int esp_eh_abort_handler(struct scsi_cmnd *cmd)
@@ -2603,6 +2611,8 @@ struct scsi_host_template scsi_esp_templ
 	.name			= "esp",
 	.info			= esp_info,
 	.queuecommand		= esp_queuecommand,
+	.target_alloc		= esp_target_alloc,
+	.target_destroy		= esp_target_destroy,
 	.slave_alloc		= esp_slave_alloc,
 	.slave_configure	= esp_slave_configure,
 	.slave_destroy		= esp_slave_destroy,
--- a/drivers/scsi/esp_scsi.h
+++ b/drivers/scsi/esp_scsi.h
@@ -322,7 +322,6 @@ struct esp_target_data {
 	u8			nego_goal_tags;
 
 	struct scsi_target	*starget;
-	int			starget_ref;
 };
 
 struct esp_event_ent {

-- 
