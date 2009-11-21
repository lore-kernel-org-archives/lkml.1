Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbZKULwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbZKULwP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 06:52:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbZKULwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 06:52:14 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:38453 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793AbZKULwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 06:52:12 -0500
Date: Sat, 21 Nov 2009 12:52:17 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dbrownell@users.sourceforge.net, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 6/8] drivers/usb/host/ehci-omap.c: introduce missing kfree
Message-ID: <Pine.LNX.4.64.0911211251480.23681@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Error handling code following a kzalloc should free the allocated data.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,f1,l;
position p1,p2;
expression *ptr != NULL;
@@

x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...x...+> }
(
x->f1 = E
|
 (x->f1 == NULL || ...)
|
 f(...,x->f1,...)
)
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---
 drivers/usb/host/ehci-omap.c        |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index 7ba8df3..12f1ad2 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -558,7 +558,7 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 	omap = kzalloc(sizeof(*omap), GFP_KERNEL);
 	if (!omap) {
 		ret = -ENOMEM;
-		goto err_create_hcd;
+		goto err_disabled;
 	}
 
 	hcd = usb_create_hcd(&ehci_omap_hc_driver, &pdev->dev,
@@ -653,6 +653,7 @@ err_ioremap:
 	usb_put_hcd(hcd);
 
 err_create_hcd:
+	kfree(omap);
 err_disabled:
 err_pdata:
 	return ret;
