Return-Path: <linux-kernel-owner+w=401wt.eu-S1760610AbZFIKVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760610AbZFIKVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760564AbZFIKSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:18:33 -0400
Received: from kroah.org ([198.145.64.141]:54565 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760522AbZFIKSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:18:32 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:40:57 2009
Message-Id: <20090609094057.382414792@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:11 -0700
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
       alan@lxorguk.ukuu.org.uk, Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Jens Axboe <jens.axboe@oracle.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 23/87] xen/blkfront: allow xenbus state transition to Closing->Closed  when not Connected
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=xen-blkfront-allow-xenbus-state-transition-to-closing-closed-when-not-connected.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ian Campbell <ian.campbell@citrix.com>

commit 28afea5b2ffaa48f4f43d22ae8edcc384c05df80 upstream.

This situation can occur when attempting to attach a block device whose
backend is an empty physical CD-ROM driver. The backend in this case
will go directly from the Initialising state to Closing->Closed.
Previously this would result in a NULL pointer deref on info->gd
(xenbus_dev_fatal does not return as a1a15ac5 seems to expect)

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/block/xen-blkfront.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -977,8 +977,10 @@ static void backend_changed(struct xenbu
 		break;
 
 	case XenbusStateClosing:
-		if (info->gd == NULL)
-			xenbus_dev_fatal(dev, -ENODEV, "gd is NULL");
+		if (info->gd == NULL) {
+			xenbus_frontend_closed(dev);
+			break;
+		}
 		bd = bdget_disk(info->gd, 0);
 		if (bd == NULL)
 			xenbus_dev_fatal(dev, -ENODEV, "bdget failed");


