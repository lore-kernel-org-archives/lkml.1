Return-Path: <linux-kernel-owner+w=401wt.eu-S1755629AbYHRT2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629AbYHRT2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761621AbYHRT14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:27:56 -0400
Received: from mail.suse.de ([195.135.220.2]:47610 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761625AbYHRT1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:27:54 -0400
Date: Mon, 18 Aug 2008 12:19:30 -0700
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
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 08/49] SCSI: scsi_transport_spi: fix oops in revalidate
Message-ID: <20080818191930.GI10350@suse.de>
References: <20080818191012.663450219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="scsi-scsi_transport_spi-fix-oops-in-revalidate.patch"
In-Reply-To: <20080818191834.GA10350@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------

From: James Bottomley <James.Bottomley@HansenPartnership.com>

commit e8bac9e0647dd04c83fd0bfe7cdfe2f6dfb100d0 upstream

The class_device->device conversion is causing an oops in revalidate
because it's assuming that the device_for_each_child iterator will only
return struct scsi_device children.  The conversion made all former
class_devices children of the device as well, so this assumption is
broken.  Fix it.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/scsi_transport_spi.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -360,12 +360,14 @@ spi_transport_rd_attr(rti, "%d\n");
 spi_transport_rd_attr(pcomp_en, "%d\n");
 spi_transport_rd_attr(hold_mcs, "%d\n");
 
-/* we only care about the first child device so we return 1 */
+/* we only care about the first child device that's a real SCSI device
+ * so we return 1 to terminate the iteration when we find it */
 static int child_iter(struct device *dev, void *data)
 {
-	struct scsi_device *sdev = to_scsi_device(dev);
+	if (!scsi_is_sdev_device(dev))
+		return 0;
 
-	spi_dv_device(sdev);
+	spi_dv_device(to_scsi_device(dev));
 	return 1;
 }
 

-- 
