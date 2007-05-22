Return-Path: <linux-kernel-owner+w=401wt.eu-S1763420AbXEVM2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763420AbXEVM2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 08:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757023AbXEVM21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 08:28:27 -0400
Received: from mail.bn-online.net ([217.76.96.46]:33125 "EHLO
	blatz006.blatzheim.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606AbXEVM20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 08:28:26 -0400
Message-ID: <4652E1E4.4080708@colognechip.com>
Date: Tue, 22 May 2007 14:28:20 +0200
From: Martin Bachem <info@colognechip.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: [PATCH 2.6.21.1] hisax: adds error-checking for hisax_register()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as875) adds error-checking to the callers of
hisax_register().  It also changes an error pathway in that routine,
making it return an error code rather than 0.

This fixes Bugzilla #7960.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Martin Bachem <info@colognechip.com>
Acked-by: Karsten Keil <kkeil@suse.de>

---

Index: usb-2.6/drivers/isdn/hisax/config.c
===================================================================
--- usb-2.6.orig/drivers/isdn/hisax/config.c
+++ usb-2.6/drivers/isdn/hisax/config.c
@@ -1551,7 +1551,7 @@ int hisax_register(struct hisax_d_if *hi
 	if (retval == 0) { // yuck
 		cards[i].typ = 0;
 		nrcards--;
-		return retval;
+		return -EINVAL;
 	}
 	cs = cards[i].cs;
 	hisax_d_if->cs = cs;
Index: usb-2.6/drivers/isdn/hisax/hfc_usb.c
===================================================================
--- usb-2.6.orig/drivers/isdn/hisax/hfc_usb.c
+++ usb-2.6/drivers/isdn/hisax/hfc_usb.c
@@ -1306,7 +1306,11 @@ usb_init(hfcusb_data * hfc)
 	}
 	/* default Prot: EURO ISDN, should be a module_param */
 	hfc->protocol = 2;
-	hisax_register(&hfc->d_if, p_b_if, "hfc_usb", hfc->protocol);
+	i = hisax_register(&hfc->d_if, p_b_if, "hfc_usb", hfc->protocol);
+	if (i) {
+		printk(KERN_INFO "HFC-S USB: hisax_register -> %d\n", i);
+		return i;
+	}

 #ifdef CONFIG_HISAX_DEBUG
 	hfc_debug = debug;
Index: usb-2.6/drivers/isdn/hisax/hisax_fcpcipnp.c
===================================================================
--- usb-2.6.orig/drivers/isdn/hisax/hisax_fcpcipnp.c
+++ usb-2.6/drivers/isdn/hisax/hisax_fcpcipnp.c
@@ -859,7 +859,11 @@ new_adapter(void)
 	for (i = 0; i < 2; i++)
 		b_if[i] = &adapter->bcs[i].b_if;

-	hisax_register(&adapter->isac.hisax_d_if, b_if, "fcpcipnp", protocol);
+	if (hisax_register(&adapter->isac.hisax_d_if, b_if, "fcpcipnp",
+			protocol) != 0) {
+		kfree(adapter);
+		adapter = NULL;
+	}

 	return adapter;
 }
Index: usb-2.6/drivers/isdn/hisax/st5481_init.c
===================================================================
--- usb-2.6.orig/drivers/isdn/hisax/st5481_init.c
+++ usb-2.6/drivers/isdn/hisax/st5481_init.c
@@ -107,12 +107,17 @@ static int probe_st5481(struct usb_inter
 	for (i = 0; i < 2; i++)
 		b_if[i] = &adapter->bcs[i].b_if;

-	hisax_register(&adapter->hisax_d_if, b_if, "st5481_usb", protocol);
+	if (hisax_register(&adapter->hisax_d_if, b_if, "st5481_usb",
+			protocol) != 0)
+		goto err_b1;
+
 	st5481_start(adapter);

 	usb_set_intfdata(intf, adapter);
 	return 0;

+ err_b1:
+	st5481_release_b(&adapter->bcs[1]);
  err_b:
 	st5481_release_b(&adapter->bcs[0]);
  err_d:

