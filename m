Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab0CIJxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 04:53:12 -0500
Received: from mail-pz0-f200.google.com ([209.85.222.200]:34986 "EHLO
	mail-pz0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab0CIJxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 04:53:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:x-operating-system:user-agent;
        b=k1tZU7wo6VXoL+q/VyysKRpnsQ+/ShuZ8bTRShgDDmCEbsrywYgfkms5xUmHoWsZh3
         +hOFjWcxPmKTIeNvt/vpK6m0kvo6DoHIThbXUBcJVMnICepPZsmfNJqhg0GPXP63FOpm
         sbVkEt7vbRFpmtTlBIhHkb0LDmuMiy2m2kUhs=
Date: Tue, 9 Mar 2010 17:52:55 +0800
From: Li Hong <lihong.hi@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] slip: Remove the unused code and add some cleanups in
 slip.c
Message-ID: <20100309095255.GA10793@xhl>
Mail-Followup-To: "David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux xhl 2.6.31-14-generic
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In sl_alloc(), after the for block:

	for (i = 0; i < slip_maxdev; i++) {
		dev = slip_devs[i];
		if (dev == NULL)
			break;
	}

The result is either i >= slip_maxdev or dev != NULL. So the following check
on dev is needless.

Signed-off-by: Li Hong <lihong.hi@gmail.com>
---
 drivers/net/slip.c |   24 +++++++-----------------
 1 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/net/slip.c b/drivers/net/slip.c
index ba5bbc5..adf89c0 100644
--- a/drivers/net/slip.c
+++ b/drivers/net/slip.c
@@ -737,24 +737,15 @@ static struct slip *sl_alloc(dev_t line)
 	if (i >= slip_maxdev)
 		return NULL;
 
-	if (dev) {
-		sl = netdev_priv(dev);
-		if (test_bit(SLF_INUSE, &sl->flags)) {
-			unregister_netdevice(dev);
-			dev = NULL;
-			slip_devs[i] = NULL;
-		}
-	}
+	char name[IFNAMSIZ];
+	sprintf(name, "sl%d", i);
 
-	if (!dev) {
-		char name[IFNAMSIZ];
-		sprintf(name, "sl%d", i);
+	dev = alloc_netdev(sizeof(*sl), name, sl_setup);
+	if (!dev)
+		return NULL;
 
-		dev = alloc_netdev(sizeof(*sl), name, sl_setup);
-		if (!dev)
-			return NULL;
-		dev->base_addr  = i;
-	}
+	dev->base_addr  = i;
+	slip_devs[i] = dev;
 
 	sl = netdev_priv(dev);
 
@@ -772,7 +763,6 @@ static struct slip *sl_alloc(dev_t line)
 	sl->outfill_timer.data = (unsigned long)sl;
 	sl->outfill_timer.function = sl_outfill;
 #endif
-	slip_devs[i] = dev;
 	return sl;
 }
 
-- 
1.6.3.3

