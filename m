Return-Path: <linux-kernel-owner+w=401wt.eu-S933271AbXBWXS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271AbXBWXS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 18:18:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933262AbXBWXRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 18:17:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:35263 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933274AbXBWXRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 18:17:42 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Manuel Lauss <mano@roarinelk.homelinux.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 4/9] Driver core: more fallout from class_device changes for pcmcia
Date: Fri, 23 Feb 2007 15:15:51 -0800
Message-Id: <1172272565581-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.0.1
In-Reply-To: <11722725623183-git-send-email-gregkh@suse.de>
References: <20070223231426.GA20498@kroah.com> <11722725561867-git-send-email-gregkh@suse.de> <11722725592291-git-send-email-gregkh@suse.de> <11722725623183-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manuel Lauss <mano@roarinelk.homelinux.net>

More fallout from the PCMCIA class_device changes.

The first hunk is run-tested on SH-4, the others are converted
in the spirit of the original conversion.


Signed-off-by: Manuel Lauss  <mano@roarinelk.homelinux.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pcmcia/hd64465_ss.c   |    2 +-
 drivers/pcmcia/m32r_cfc.c     |    2 +-
 drivers/pcmcia/m8xx_pcmcia.c  |    2 +-
 drivers/pcmcia/omap_cf.c      |    2 +-
 drivers/pcmcia/rsrc_mgr.c     |    2 +-
 drivers/pcmcia/vrc4171_card.c |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/pcmcia/hd64465_ss.c b/drivers/pcmcia/hd64465_ss.c
index caca0dc..f2e810f 100644
--- a/drivers/pcmcia/hd64465_ss.c
+++ b/drivers/pcmcia/hd64465_ss.c
@@ -907,7 +907,7 @@ static int __init init_hs(void)
 
 	for (i=0; i<HS_MAX_SOCKETS; i++) {
 		unsigned int ret;
-		hs_sockets[i].socket.dev.dev = &hd64465_device.dev;		
+		hs_sockets[i].socket.dev.parent = &hd64465_device.dev;
 		hs_sockets[i].number = i;
 		ret = pcmcia_register_socket(&hs_sockets[i].socket);
 		if (ret && i)
diff --git a/drivers/pcmcia/m32r_cfc.c b/drivers/pcmcia/m32r_cfc.c
index e4a9410..91da15b 100644
--- a/drivers/pcmcia/m32r_cfc.c
+++ b/drivers/pcmcia/m32r_cfc.c
@@ -760,7 +760,7 @@ static int __init init_m32r_pcc(void)
 	/* Set up interrupt handler(s) */
 
 	for (i = 0 ; i < pcc_sockets ; i++) {
-		socket[i].socket.dev.dev = &pcc_device.dev;
+		socket[i].socket.dev.parent = &pcc_device.dev;
 		socket[i].socket.ops = &pcc_operations;
 		socket[i].socket.resource_ops = &pccard_nonstatic_ops;
 		socket[i].socket.owner = THIS_MODULE;
diff --git a/drivers/pcmcia/m8xx_pcmcia.c b/drivers/pcmcia/m8xx_pcmcia.c
index d059c91..9721ed7 100644
--- a/drivers/pcmcia/m8xx_pcmcia.c
+++ b/drivers/pcmcia/m8xx_pcmcia.c
@@ -1321,7 +1321,7 @@ static int __init m8xx_init(void)
 		socket[i].socket.ops = &m8xx_services;
 		socket[i].socket.resource_ops = &pccard_iodyn_ops;
 		socket[i].socket.cb_dev = NULL;
-		socket[i].socket.dev.dev = &m8xx_device.dev;
+		socket[i].socket.dev.parent = &m8xx_device.dev;
 	}
 
 	for (i = 0; i < PCMCIA_SOCKETS_NO; i++)
diff --git a/drivers/pcmcia/omap_cf.c b/drivers/pcmcia/omap_cf.c
index 76f7cbc..d77f751 100644
--- a/drivers/pcmcia/omap_cf.c
+++ b/drivers/pcmcia/omap_cf.c
@@ -291,7 +291,7 @@ static int __devinit omap_cf_probe(struct device *dev)
 		omap_cf_present() ? "present" : "(not present)");
 
 	cf->socket.owner = THIS_MODULE;
-	cf->socket.dev.dev = dev;
+	cf->socket.dev.parent = dev;
 	cf->socket.ops = &omap_cf_ops;
 	cf->socket.resource_ops = &pccard_static_ops;
 	cf->socket.features = SS_CAP_PCCARD | SS_CAP_STATIC_MAP
diff --git a/drivers/pcmcia/rsrc_mgr.c b/drivers/pcmcia/rsrc_mgr.c
index 81dfc2c..ce22262 100644
--- a/drivers/pcmcia/rsrc_mgr.c
+++ b/drivers/pcmcia/rsrc_mgr.c
@@ -232,7 +232,7 @@ static struct resource *iodyn_find_io_region(unsigned long base, int num,
 		unsigned long align, struct pcmcia_socket *s)
 {
 	struct resource *res = make_resource(0, num, IORESOURCE_IO,
-					     s->dev.class_id);
+					     s->dev.bus_id);
 	struct pcmcia_align_data data;
 	unsigned long min = base;
 	int ret;
diff --git a/drivers/pcmcia/vrc4171_card.c b/drivers/pcmcia/vrc4171_card.c
index 206e26c..eee2f1c 100644
--- a/drivers/pcmcia/vrc4171_card.c
+++ b/drivers/pcmcia/vrc4171_card.c
@@ -596,7 +596,7 @@ static int __devinit vrc4171_add_sockets(void)
 		}
 
 		sprintf(socket->name, "NEC VRC4171 Card Slot %1c", 'A' + slot);
-		socket->pcmcia_socket.dev.dev = &vrc4171_card_device.dev;
+		socket->pcmcia_socket.dev.parent = &vrc4171_card_device.dev;
 		socket->pcmcia_socket.ops = &vrc4171_pccard_operations;
 		socket->pcmcia_socket.owner = THIS_MODULE;
 
-- 
1.5.0.1

