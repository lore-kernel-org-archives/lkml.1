Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbZJAXYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbZJAXYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754492AbZJAXYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:24:24 -0400
Received: from kroah.org ([198.145.64.141]:39667 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586AbZJAXXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:23:19 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 16:18:05 2009
Message-Id: <20091001231805.170427311@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 16:16:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stefan Bader <stefan.bader@canonical.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       Steve Conklin <steve.conklin@canonical.com>
Subject: [patch 5/9] Fix incorrect stable backport to bas_gigaset
References: <20091001231633.719696398@mini.kroah.org>
Content-Disposition: inline; filename=fix-incorrect-stable-backport-to-bas_gigaset.patch
In-Reply-To: <20091001231938.GA29593@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tilman Schmidt <tilman@imap.cc>

bas_gigaset: correctly allocate USB interrupt transfer buffer

[ Upstream commit 170ebf85160dd128e1c4206cc197cce7d1424705 ]

This incorrect backport to 2.6.28.10 placed some code into the probe function
which used a pointer before it was initialized. Moving this to the correct
place (as it is in upstream).

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Acked-by: Tim Gardner <tim.gardner@canonical.com>
Acked-by: Steve Conklin <steve.conklin@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/isdn/gigaset/bas-gigaset.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/isdn/gigaset/bas-gigaset.c
+++ b/drivers/isdn/gigaset/bas-gigaset.c
@@ -2140,8 +2140,16 @@ static int gigaset_initcshw(struct cards
 	struct bas_cardstate *ucs;
 
 	cs->hw.bas = ucs = kmalloc(sizeof *ucs, GFP_KERNEL);
-	if (!ucs)
+	if (!ucs) {
+		pr_err("out of memory\n");
+		return 0;
+	}
+	ucs->int_in_buf = kmalloc(IP_MSGSIZE, GFP_KERNEL);
+	if (!ucs->int_in_buf) {
+		kfree(ucs);
+		pr_err("out of memory\n");
 		return 0;
+	}
 
 	ucs->urb_cmd_in = NULL;
 	ucs->urb_cmd_out = NULL;
@@ -2236,12 +2244,6 @@ static int gigaset_probe(struct usb_inte
 		}
 		hostif = interface->cur_altsetting;
 	}
-	ucs->int_in_buf = kmalloc(IP_MSGSIZE, GFP_KERNEL);
-	if (!ucs->int_in_buf) {
-		kfree(ucs);
-		pr_err("out of memory\n");
-		return 0;
-	}
 
 	/* Reject application specific interfaces
 	 */


