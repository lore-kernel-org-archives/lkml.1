Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbXC3VWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbXC3VWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbXC3VK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:10:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58244 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbXC3VKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:10:00 -0400
Date: Fri, 30 Mar 2007 14:04:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 09/37] ieee1394: dv1394: fix CardBus card ejection
Message-ID: <20070330210424.GK29450@kroah.com>
References: <20070330205938.984247529@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ieee1394-dv1394-fix-cardbus-card-ejection.patch"
In-Reply-To: <20070330210334.GA29450@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Stefan Richter <stefanr@s5r6.in-berlin.de>

Fix NULL pointer dereference on hot ejection of a FireWire card while
dv1394 was loaded.  http://bugzilla.kernel.org/show_bug.cgi?id=7121
I did not test card ejection with open /dev/dv1394 files yet.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ieee1394/dv1394.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/ieee1394/dv1394.c
+++ b/drivers/ieee1394/dv1394.c
@@ -2267,11 +2267,7 @@ static void dv1394_remove_host (struct h
 {
 	struct video_card *video;
 	unsigned long flags;
-	int id = host->id;
-
-	/* We only work with the OHCI-1394 driver */
-	if (strcmp(host->driver->name, OHCI1394_DRIVER_NAME))
-		return;
+	int id = host->id, found_ohci_card = 0;
 
 	/* find the corresponding video_cards */
 	do {
@@ -2284,6 +2280,7 @@ static void dv1394_remove_host (struct h
 			if ((tmp_vid->id >> 2) == id) {
 				list_del(&tmp_vid->list);
 				video = tmp_vid;
+				found_ohci_card = 1;
 				break;
 			}
 		}
@@ -2293,8 +2290,9 @@ static void dv1394_remove_host (struct h
 			dv1394_un_init(video);
 	} while (video != NULL);
 
-	class_device_destroy(hpsb_protocol_class,
-		MKDEV(IEEE1394_MAJOR, IEEE1394_MINOR_BLOCK_DV1394 * 16 + (id<<2)));
+	if (found_ohci_card)
+		class_device_destroy(hpsb_protocol_class, MKDEV(IEEE1394_MAJOR,
+				IEEE1394_MINOR_BLOCK_DV1394 * 16 + (id << 2)));
 }
 
 static void dv1394_add_host (struct hpsb_host *host)

-- 
