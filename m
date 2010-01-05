Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589Ab0AEAga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab0AEAga (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563Ab0AEAg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:36:28 -0500
Received: from kroah.org ([198.145.64.141]:42510 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558Ab0AEAgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:36:18 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Borislav Petkov <borislav.petkov@amd.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 91/97] amd64_edac: make driver loading more robust
Date: Mon,  4 Jan 2010 16:33:44 -0800
Message-Id: <1262651630-7354-91-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

commit 56b34b91e22313294154cee0c16e294cf8a45b61 upstream.

Currently, the module does not initialize fully when the DIMMs aren't
ECC but remains still loaded. Propagate the error when no instance of
the driver is properly initialized and prevent further loading.

Reorganize and polish error handling in amd64_edac_init() while at it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/edac/amd64_edac.c |   23 ++++++++++++++++-------
 1 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 72d84d0..22910c6 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -3167,25 +3167,29 @@ static void amd64_setup_pci_device(void)
 static int __init amd64_edac_init(void)
 {
 	int nb, err = -ENODEV;
+	bool load_ok = false;
 
 	edac_printk(KERN_INFO, EDAC_MOD_STR, EDAC_AMD64_VERSION "\n");
 
 	opstate_init();
 
 	if (cache_k8_northbridges() < 0)
-		return err;
+		goto err_ret;
 
 	msrs = msrs_alloc();
+	if (!msrs)
+		goto err_ret;
 
 	err = pci_register_driver(&amd64_pci_driver);
 	if (err)
-		return err;
+		goto err_pci;
 
 	/*
 	 * At this point, the array 'pvt_lookup[]' contains pointers to alloc'd
 	 * amd64_pvt structs. These will be used in the 2nd stage init function
 	 * to finish initialization of the MC instances.
 	 */
+	err = -ENODEV;
 	for (nb = 0; nb < num_k8_northbridges; nb++) {
 		if (!pvt_lookup[nb])
 			continue;
@@ -3193,16 +3197,21 @@ static int __init amd64_edac_init(void)
 		err = amd64_init_2nd_stage(pvt_lookup[nb]);
 		if (err)
 			goto err_2nd_stage;
-	}
 
-	amd64_setup_pci_device();
+		load_ok = true;
+	}
 
-	return 0;
+	if (load_ok) {
+		amd64_setup_pci_device();
+		return 0;
+	}
 
 err_2nd_stage:
-	debugf0("2nd stage failed\n");
 	pci_unregister_driver(&amd64_pci_driver);
-
+err_pci:
+	msrs_free(msrs);
+	msrs = NULL;
+err_ret:
 	return err;
 }
 
-- 
1.6.6

