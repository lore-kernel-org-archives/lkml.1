Return-Path: <linux-kernel-owner+w=401wt.eu-S1753842AbZHIMqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbZHIMqP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 08:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbZHIMqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 08:46:14 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:35199 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889AbZHIMqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 08:46:14 -0400
Date: Sun, 9 Aug 2009 14:44:41 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Karsten Keil <isdn@linux-pingi.de>
Cc: isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/3] drivers/isdn/hisax: Correct use of
 request_region/request_mem_region
In-Reply-To: <200908091420.33935.isdn@linux-pingi.de>
Message-ID: <Pine.LNX.4.64.0908091444020.16252@ask.diku.dk>
References: <Pine.LNX.4.64.0908090942560.13271@ask.diku.dk>
 <Pine.LNX.4.64.0908091150310.13271@ask.diku.dk> <200908091420.33935.isdn@linux-pingi.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

request_mem_region should be used when ioremap is used subsequently.
In this case, release_mem_region was already used where needed.

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression start,E;
@@

- request_region
+ request_mem_region
    (start,...)
  ... when != request_mem_region(start,...)
      when != start = E
  ioremap(start,...)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/isdn/hisax/isurf.c          |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/hisax/isurf.c b/drivers/isdn/hisax/isurf.c
index ca41617..e1c3434 100644
--- a/drivers/isdn/hisax/isurf.c
+++ b/drivers/isdn/hisax/isurf.c
@@ -259,7 +259,8 @@ setup_isurf(struct IsdnCard *card)
 			cs->hw.isurf.reset);
 			return (0);
 	}
-	if (!request_region(cs->hw.isurf.phymem, ISURF_IOMEM_SIZE, "isurf iomem")) {
+	if (!request_mem_region(cs->hw.isurf.phymem, ISURF_IOMEM_SIZE,
+				"isurf iomem")) {
 		printk(KERN_WARNING "HiSax: Siemens I-Surf memory region "
 			"%lx-%lx already in use\n",
 			cs->hw.isurf.phymem,
