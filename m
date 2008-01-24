Return-Path: <linux-kernel-owner+w=401wt.eu-S1758290AbYAXRI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbYAXRI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:08:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759873AbYAXRHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 12:07:16 -0500
Received: from re01.intra2net.com ([82.165.28.202]:4149 "EHLO
	re01.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760548AbYAXRHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 12:07:13 -0500
X-Greylist: delayed 1014 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jan 2008 12:07:13 EST
From: "Gerd v. Egidy" <gerd.von.egidy@intra2net.com>
Organization: Intra2net AG
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fix oops on rmmod capidrv
Date: Thu, 24 Jan 2008 17:50:14 +0100
User-Agent: KMail/1.9.6
Cc: kkeil@suse.de, kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801241750.14669.gerd.von.egidy@intra2net.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I think the patch below fixes a long-standing bug on rmmod capidrv. Please 
apply.

Kind regards,

Gerd

Fix overwriting the stack with the version string
(it is currently 10 bytes + zero) when unloading the
capidrv module. Safeguard against overwriting it
should the version string grow in the future.

Should fix Kernel Bug Tracker Bug 9696.

Signed-off-by: Gerd v. Egidy <gerd.von.egidy@intra2net.com>

diff -r -u linux-2.6.23.orig/drivers/isdn/capi/capidrv.c 
linux-2.6.23/drivers/isdn/capi/capidrv.c
--- linux-2.6.23.orig/drivers/isdn/capi/capidrv.c	Tue Oct  9 22:31:38 2007
+++ linux-2.6.23/drivers/isdn/capi/capidrv.c	Thu Jan 24 16:47:55 2008
@@ -2306,13 +2306,14 @@
 
 static void __exit capidrv_exit(void)
 {
-	char rev[10];
+	char rev[32];
 	char *p;
 
 	if ((p = strchr(revision, ':')) != 0) {
-		strcpy(rev, p + 1);
-		p = strchr(rev, '$');
-		*p = 0;
+		strncpy(rev, p + 1, sizeof(rev));
+		rev[sizeof(rev)-1] = 0;
+		if ((p = strchr(rev, '$')) != 0)
+			*p = 0;
 	} else {
 		strcpy(rev, " ??? ");
 	}
