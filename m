Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbYD2Nxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbYD2Nxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbYD2Nxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:53:46 -0400
Received: from rs02.intra2net.com ([81.169.173.116]:49282 "EHLO
	rs02.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbYD2Nxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:53:45 -0400
X-Greylist: delayed 1565 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Apr 2008 09:53:45 EDT
From: "Gerd v. Egidy" <gerd.von.egidy@intra2net.com>
Organization: Intra2net AG
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix oops on rmmod capidrv
Date: Tue, 29 Apr 2008 15:27:29 +0200
User-Agent: KMail/1.9.9
Cc: stable@kernel.org
References: <200801241750.14669.gerd.von.egidy@intra2net.com>
In-Reply-To: <200801241750.14669.gerd.von.egidy@intra2net.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804291527.29611.gerd.von.egidy@intra2net.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

my patch below was added to 2.6.23.15 and linus tree that became 2.6.25, but 
was too late for 2.6.24. So if you consider another stable release for 2.6.24 
you might want to add that patch too.

Kind regards,

Gerd

Fix overwriting the stack with the version string
(it is currently 10 bytes + zero) when unloading the
capidrv module. Safeguard against overwriting it
should the version string grow in the future.

Should fix Kernel Bug Tracker Bug 9696.

Signed-off-by: Gerd v. Egidy <gerd.von.egidy@intra2net.com>
Acked-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/drivers/isdn/capi/capidrv.c
+++ b/drivers/isdn/capi/capidrv.c
@@ -2306,13 +2306,14 @@ static int __init capidrv_init(void)
 
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


-- 
Address (better: trap) for people I really don't want to get mail from:
joanne@cactusamerica.com
