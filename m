Return-Path: <linux-kernel-owner+w=401wt.eu-S1757907AbYH2X0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907AbYH2X0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 19:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbYH2X0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 19:26:35 -0400
Received: from abydos.nerdbox.net ([216.151.149.55]:43976 "EHLO
	abydos.NerdBox.Net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbYH2X0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 19:26:34 -0400
Date: Fri, 29 Aug 2008 16:26:33 -0700 (PDT)
From: Steve VanDeBogart <vandebo-lkml@NerdBox.Net>
To: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH] uml: ubd can access uninitialized memory
Message-ID: <alpine.DEB.1.00.0808291624290.15543@abydos.NerdBox.Net>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ubd_kern.c:do_io() may access uninitialized memory and divide requests
into smaller chunks than necessary.  Found with Valgrind.

Signed-off-by: Steve VanDeBogart <vandebo-lkml@nerdbox.net>
---

Index: linux-2.6.27-rc5/arch/um/drivers/ubd_kern.c
===================================================================
--- linux-2.6.27-rc5.orig/arch/um/drivers/ubd_kern.c	2008-08-29 15:50:19.000000000 -0700
+++ linux-2.6.27-rc5/arch/um/drivers/ubd_kern.c	2008-08-29 15:51:48.000000000 -0700
@@ -1218,8 +1218,7 @@
  	struct ubd *ubd_dev = disk->private_data;

  	io_req->req = req;
-	io_req->fds[0] = (ubd_dev->cow.file != NULL) ? ubd_dev->cow.fd :
-		ubd_dev->fd;
+	io_req->fds[0] = (ubd_dev->cow.file == NULL) ? -1 : ubd_dev->cow.fd;
  	io_req->fds[1] = ubd_dev->fd;
  	io_req->cow_offset = -1;
  	io_req->offset = offset;
@@ -1374,12 +1373,18 @@
  	nsectors = req->length / req->sectorsize;
  	start = 0;
  	do {
-		bit = ubd_test_bit(start, (unsigned char *) &req->sector_mask);
-		end = start;
-		while((end < nsectors) &&
-		      (ubd_test_bit(end, (unsigned char *)
-				    &req->sector_mask) == bit))
-			end++;
+		if (req->fds[0] == -1) {
+			bit = 1;
+			end = nsectors;
+		} else {
+			bit = ubd_test_bit(start,
+					(unsigned char *) &req->sector_mask);
+			end = start;
+			while ((end < nsectors) &&
+					(ubd_test_bit(end, (unsigned char *)
+						  &req->sector_mask) == bit))
+				end++;
+		}

  		off = req->offset + req->offsets[bit] +
  			start * req->sectorsize;
