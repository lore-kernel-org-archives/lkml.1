Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbYKTQTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbYKTQTv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 11:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbYKTQTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 11:19:37 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:42419 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbYKTQTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 11:19:36 -0500
Date: Thu, 20 Nov 2008 21:46:45 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       gregkh@suse.de, k.gantzke@meilhaus.de
Subject: Re: linux-next-20081120 - staging - meilhaus driver build fails
Message-ID: <20081120161645.GA4821@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20081120212907.efc2276b.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081120212907.efc2276b.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

 next-20081120 kernel randconfig on x86_64 box fails, while !CONFIG_MODULES

drivers/staging/meilhaus/memain.c: In function 'me_probe_pci':
drivers/staging/meilhaus/memain.c:425: error: implicit declaration of function '__symbol_get'
drivers/staging/meilhaus/memain.c:425: warning: cast to pointer from integer of different size
drivers/staging/meilhaus/memain.c:433: warning: cast to pointer from integer of different size
drivers/staging/meilhaus/memain.c:453: error: implicit declaration of function '__symbol_put'
make[3]: *** [drivers/staging/meilhaus/memain.o] Error 1

the driver uses __symbol_get and __symbol_put instead of marco's symbol_get and symbol_put, 
I have only build tested the patch.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---
--- linux/drivers/staging/meilhaus/memain.c	2008-11-20 06:08:43.000000000 -0500
+++ linux/drivers/staging/meilhaus/~memain.c	2008-11-20 09:04:15.000000000 -0500
@@ -422,7 +422,7 @@ static int me_probe_pci(struct pci_dev *
 	PDEBUG("module_name: %s\n", module_name);
 
 	if ((constructor =
-	     (me_pci_constructor_t) __symbol_get(constructor_name)) == NULL) {
+	     (me_pci_constructor_t) symbol_get(constructor_name)) == NULL) {
 		if (request_module(module_name)) {
 			PERROR("Error while request for module %s.\n",
 			       module_name);
@@ -430,7 +430,7 @@ static int me_probe_pci(struct pci_dev *
 		}
 
 		if ((constructor =
-		     (me_pci_constructor_t) __symbol_get(constructor_name)) ==
+		     (me_pci_constructor_t) symbol_get(constructor_name)) ==
 		    NULL) {
 			PERROR("Can't get %s driver module constructor.\n",
 			       module_name);
@@ -441,7 +441,7 @@ static int me_probe_pci(struct pci_dev *
 	if ((device & 0xF000) == 0x4000) {	// Bosch build has differnt constructor for me4600.
 		if ((n_device =
 		     (*constructor_bosch) (dev, me_bosch_fw)) == NULL) {
-			__symbol_put(constructor_name);
+			symbol_put(constructor_name);
 			PERROR
 			    ("Can't get device instance of %s driver module.\n",
 			     module_name);
@@ -450,7 +450,7 @@ static int me_probe_pci(struct pci_dev *
 	} else {
 #endif
 		if ((n_device = (*constructor) (dev)) == NULL) {
-			__symbol_put(constructor_name);
+			symbol_put(constructor_name);
 			PERROR
 			    ("Can't get device instance of %s driver module.\n",
 			     module_name);
@@ -503,7 +503,7 @@ static void release_instance(me_device_t
 	if (plugged != ME_PLUGGED_IN) {
 		PDEBUG("release: medummy_constructor\n");
 
-		__symbol_put("medummy_constructor");
+		symbol_put("medummy_constructor");
 	} else {
 		if ((dev_id & 0xF000) == 0x6000) {	// Exceptions: me61xx, me62xx, me63xx are handled by one driver.
 			dev_id &= 0xF0FF;
@@ -513,7 +513,7 @@ static void release_instance(me_device_t
 		constructor_name[3] += (char)((dev_id >> 8) & 0x000F);
 		PDEBUG("release: %s\n", constructor_name);
 
-		__symbol_put(constructor_name);
+		symbol_put(constructor_name);
 	}
 }
 
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
