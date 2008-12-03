Return-Path: <linux-kernel-owner+w=401wt.eu-S1758491AbYLCUKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758491AbYLCUKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:10:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbYLCTyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:54:25 -0500
Received: from kroah.org ([198.145.64.141]:60217 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751530AbYLCTyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:54:23 -0500
Date: Wed, 3 Dec 2008 11:52:39 -0800
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
       alan@lxorguk.ukuu.org.uk, Tejun Heo <tj@kernel.org>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 052/104] libata: blacklist Seagate drives which time out
	FLUSH_CACHE when used with NCQ
Message-ID: <20081203195239.GA8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="libata-blacklist-seagate-drives-which-time-out-flush_cache-when-used-with-ncq.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Tejun Heo <tj@kernel.org>

commit ac70a964b0e22a95af3628c344815857a01461b7 upstream.

Some recent Seagate harddrives have firmware bug which causes FLUSH
CACHE to timeout under certain circumstances if NCQ is being used.
This can be worked around by disabling NCQ and fixed by updating the
firmware.  Implement ATA_HORKAGE_FIRMWARE_UPDATE and blacklist these
devices.

The wiki page has been updated to contain information on this issue.

  http://ata.wiki.kernel.org/index.php/Known_issues

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-core.c |   21 +++++++++++++++++++++
 include/linux/libata.h    |    1 +
 2 files changed, 22 insertions(+)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2428,6 +2428,13 @@ int ata_dev_configure(struct ata_device 
 		}
 	}
 
+	if ((dev->horkage & ATA_HORKAGE_FIRMWARE_WARN) && print_info) {
+		ata_dev_printk(dev, KERN_WARNING, "WARNING: device requires "
+			       "firmware update to be fully functional.\n");
+		ata_dev_printk(dev, KERN_WARNING, "         contact the vendor "
+			       "or visit http://ata.wiki.kernel.org.\n");
+	}
+
 	return 0;
 
 err_out_nosup:
@@ -3971,6 +3978,20 @@ static const struct ata_blacklist_entry 
 	{ "ST380817AS",		"3.42",		ATA_HORKAGE_NONCQ },
 	{ "ST3160023AS",	"3.42",		ATA_HORKAGE_NONCQ },
 
+	/* Seagate NCQ + FLUSH CACHE firmware bug */
+	{ "ST31500341AS",	"9JU138",	ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST31000333AS",	"9FZ136",	ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3640623AS",	"9FZ164",	ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3640323AS",	"9FZ134",	ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3320813AS",	"9FZ182",	ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3320613AS",	"9FZ162",	ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+
 	/* Blacklist entries taken from Silicon Image 3124/3132
 	   Windows driver .inf file - also several Linux problem reports */
 	{ "HTS541060G9SA00",    "MB3OC60D",     ATA_HORKAGE_NONCQ, },
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -364,6 +364,7 @@ enum {
 	ATA_HORKAGE_IPM		= (1 << 7),	/* Link PM problems */
 	ATA_HORKAGE_IVB		= (1 << 8),	/* cbl det validity bit bugs */
 	ATA_HORKAGE_STUCK_ERR	= (1 << 9),	/* stuck ERR on next PACKET */
+	ATA_HORKAGE_FIRMWARE_WARN = (1 << 12),	/* firwmare update warning */
 
 	 /* DMA mask for user DMA control: User visible values; DO NOT
 	    renumber */

