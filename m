Return-Path: <linux-kernel-owner+w=401wt.eu-S1752681AbZGZBaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbZGZBaP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 21:30:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbZGZBaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 21:30:14 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:65143 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbZGZBaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 21:30:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=IIVjHQGc3Ej0OyJOBFQ4G0ayoRoOk1+fnhmXthLjFJ+vljx+vqwkBobQuGlSiHauoZ
         heYgwMx4Av1lI4ZeQXn49U7tPAveOXP9vpxTmVx+mcWptRmwOefHr+AS27c8D92AouAr
         SCiiK3RkTZbPVMLBxToBktH7pqR+DbPqqAeaM=
Message-ID: <4A6BB1A1.50308@gmail.com>
Date: Sat, 25 Jul 2009 22:30:09 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090725)
MIME-Version: 1.0
To: Dave Airlie <airlied@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Subject: [PATCH linux-next] agp: correct missing cleanup on error in agp_add_bridge
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While investigating a kmemleak detected leak, I encountered the
agp_add_bridge function.  It appears to be responsible for freeing
the agp_bridge_data in the case of a failure, but it is only doing
so for some errors.

Fix it to always free the bridge data if a failure condition is
encountered.

Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
---

Note that this seems like a reasonable change to me, but this patch
did not get rid of the kmemleak report, so I don't even have that as
evidence of its correctness.  Please review.

diff --git a/drivers/char/agp/backend.c b/drivers/char/agp/backend.c
index cfa5a64..aebd82c 100644
--- a/drivers/char/agp/backend.c
+++ b/drivers/char/agp/backend.c
@@ -263,18 +263,22 @@ int agp_add_bridge(struct agp_bridge_data *bridge)
 {
        int error;
 
-       if (agp_off)
-               return -ENODEV;
+       if (agp_off) {
+               error = -ENODEV;
+               goto err_put_bridge;
+       }
 
        if (!bridge->dev) {
                printk (KERN_DEBUG PFX "Erk, registering with no pci_dev!\n");
-               return -EINVAL;
+               error = -EINVAL;
+               goto err_put_bridge;
        }
 
        /* Grab reference on the chipset driver. */
        if (!try_module_get(bridge->driver->owner)) {
                dev_info(&bridge->dev->dev, "can't lock chipset driver\n");
-               return -EINVAL;
+               error = -EINVAL;
+               goto err_put_bridge;
        }
 
        error = agp_backend_initialize(bridge);
@@ -304,6 +308,7 @@ frontend_err:
        agp_backend_cleanup(bridge);
 err_out:
        module_put(bridge->driver->owner);
+err_put_bridge:
        agp_put_bridge(bridge);
        return error;
 }

