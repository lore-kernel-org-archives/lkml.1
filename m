Return-Path: <linux-kernel-owner+w=401wt.eu-S1757380AbYGVXXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380AbYGVXXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756238AbYGVXTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:19:05 -0400
Received: from mail.suse.de ([195.135.220.2]:53035 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756796AbYGVXTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:19:03 -0400
Date: Tue, 22 Jul 2008 16:15:25 -0700
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
Subject: [patch 17/47] SCSI: esp: Fix OOPS in esp_reset_cleanup().
Message-ID: <20080722231525.GR8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="scsi-esp-fix-oops-in-esp_reset_cleanup.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: David S. Miller <davem@davemloft.net>

commit eadc49b1a8d09480f14caea292142f103a89c77a upstream

OOPS reported by Friedrich Oslage <bluebird@porno-bullen.de>

The problem here is that tp->starget is set every time a lun
is allocated for a particular target so we can catch the
sdev_target parent value.

The reset handler uses the NULL'ness of this value to determine
which targets are active.

But esp_slave_destroy() does not NULL out this value when appropriate.

So for every target that doesn't respond, the SCSI bus scan causes
a stale pointer to be left here, with ensuing crashes like you're
seeing.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/esp_scsi.c |    8 ++++++++
 drivers/scsi/esp_scsi.h |    1 +
 2 files changed, 9 insertions(+)

--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2364,6 +2364,7 @@ static int esp_slave_alloc(struct scsi_d
 	dev->hostdata = lp;
 
 	tp->starget = dev->sdev_target;
+	tp->starget_ref++;
 
 	spi_min_period(tp->starget) = esp->min_period;
 	spi_max_offset(tp->starget) = 15;
@@ -2412,10 +2413,17 @@ static int esp_slave_configure(struct sc
 
 static void esp_slave_destroy(struct scsi_device *dev)
 {
+	struct esp *esp = shost_priv(dev->host);
+	struct esp_target_data *tp = &esp->target[dev->id];
 	struct esp_lun_data *lp = dev->hostdata;
 
 	kfree(lp);
 	dev->hostdata = NULL;
+
+	BUG_ON(tp->starget_ref <= 0);
+
+	if (!--tp->starget_ref)
+		tp->starget = NULL;
 }
 
 static int esp_eh_abort_handler(struct scsi_cmnd *cmd)
--- a/drivers/scsi/esp_scsi.h
+++ b/drivers/scsi/esp_scsi.h
@@ -322,6 +322,7 @@ struct esp_target_data {
 	u8			nego_goal_tags;
 
 	struct scsi_target	*starget;
+	int			starget_ref;
 };
 
 struct esp_event_ent {

-- 
