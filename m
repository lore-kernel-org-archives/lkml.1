Return-Path: <linux-kernel-owner+w=401wt.eu-S1756636AbXLNGDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636AbXLNGDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 01:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbXLNGDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 01:03:08 -0500
Received: from an-out-0708.google.com ([209.85.132.250]:4256 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbXLNGDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 01:03:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=T2en1sT+9PGlj7aFuf8bxMSTX/HSHmYmXLpw5eC5EW2Cnn6ABwB/FX2W4eTenI13Hm6kOOp69aTjwZi9OJFZwutmj7kJK6dOMFpI1rjYFkHy+FkI0AgmTz9QTRQ4efo0ov0kWtyHPFRDSvrbAnSJIvPmJYqHjsc2Qyg36y2PPkI=
Message-ID: <ae65fe130712132203u6d77cf3h9d0265bb37da9574@mail.gmail.com>
Date: Fri, 14 Dec 2007 14:03:05 +0800
From: "guanxun mu" <lyxmoo@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] AS apple talk protocol register_snap_client failed
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PACTH APPLETALK]

This patch update proto_init process when register_snap_client failed

Signed-off-by: Michale Moore <lyxmoo@gmail.com>

diff --git a/net/appletalk/aarp.c b/net/appletalk/aarp.c
index 6c5c6dc..d6573f6 100644
--- a/net/appletalk/aarp.c
+++ b/net/appletalk/aarp.c
@@ -873,7 +873,10 @@ void __init aarp_proto_init(void)
 {
        aarp_dl = register_snap_client(aarp_snap_id, aarp_rcv);
        if (!aarp_dl)
-               printk(KERN_CRIT "Unable to register AARP with SNAP.\n");
+       {
+               printk(KERN_CRIT "Unable to register AARP with SNAP.\n");
+               return;
+       }
        init_timer(&aarp_timer);
        aarp_timer.function = aarp_expire_timeout;
        aarp_timer.data     = 0;
diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index e0d37d6..ce9929c 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -1894,9 +1894,9 @@ static int __init atalk_init(void)

        (void)sock_register(&atalk_family_ops);
        ddp_dl = register_snap_client(ddp_snap_id, atalk_rcv);
-       if (!ddp_dl)
-               printk(atalk_err_snap);
-
+       if (!ddp_dl)
+               goto failed;
+
        dev_add_pack(&ltalk_packet_type);
        dev_add_pack(&ppptalk_packet_type);

@@ -1906,7 +1906,13 @@ static int __init atalk_init(void)
        atalk_register_sysctl();
 out:
        return rc;
+failed:
+       printk(atalk_err_snap);
+       sock_unregister(PF_APPLETALK);
+       proto_unregister(&ddp_proto);
+       return -1;
 }
+
 module_init(atalk_init);

 /*
