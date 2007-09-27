Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbXI0KDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbXI0KDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 06:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbXI0KDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 06:03:03 -0400
Received: from smtp20.orange.fr ([80.12.242.26]:18388 "EHLO smtp20.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbXI0KDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 06:03:01 -0400
X-ME-UUID: 20070927100258390.0984D1C000AA@mwinf2001.orange.fr
Date: Thu, 27 Sep 2007 12:02:58 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm] VT ioctl race fix
Message-ID: <20070927100257.GA1498@caravaggio>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When calling the RELDISP VT ioctl, we are reading vt_newvt while the console
workqueue could be messing with it (through change_console()).
We fix this race by taking the console semaphore before reading vt_newvt.

Andrew, would you please consider this patch for -mm inclusion ?

Signed-off-by: Samuel Ortiz <sameo@openedhand.com>

---
 drivers/char/vt_ioctl.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux-2.6.22/drivers/char/vt_ioctl.c
===================================================================
--- linux-2.6.22.orig/drivers/char/vt_ioctl.c	2007-07-09 01:32:17.000000000 +0200
+++ linux-2.6.22/drivers/char/vt_ioctl.c	2007-09-27 11:58:42.000000000 +0200
@@ -770,6 +770,7 @@
 		/*
 		 * Switching-from response
 		 */
+		acquire_console_sem();
 		if (vc->vt_newvt >= 0) {
 			if (arg == 0)
 				/*
@@ -784,7 +785,6 @@
 				 * complete the switch.
 				 */
 				int newvt;
-				acquire_console_sem();
 				newvt = vc->vt_newvt;
 				vc->vt_newvt = -1;
 				i = vc_allocate(newvt);
@@ -798,7 +798,6 @@
 				 * other console switches..
 				 */
 				complete_change_console(vc_cons[newvt].d);
-				release_console_sem();
 			}
 		}
 
@@ -810,9 +809,12 @@
 			/*
 			 * If it's just an ACK, ignore it
 			 */
-			if (arg != VT_ACKACQ)
+			if (arg != VT_ACKACQ) {
+				release_console_sem();
 				return -EINVAL;
+			}
 		}
+		release_console_sem();
 
 		return 0;
 

