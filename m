Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603Ab0AEAgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab0AEAgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:36:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578Ab0AEAg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:36:29 -0500
Received: from kroah.org ([198.145.64.141]:42505 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540Ab0AEAgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:36:17 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Borislav Petkov <borislav.petkov@amd.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 90/97] amd64_edac: fix driver instance freeing
Date: Mon,  4 Jan 2010 16:33:43 -0800
Message-Id: <1262651630-7354-90-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

commit 8f68ed9728193b1f2fb53ba06031b06bd8b3d1b4 upstream.

Fix use-after-free errors by pushing all memory-freeing calls to the end
of amd64_remove_one_instance().

Reported-by: Darren Jenkins <darrenrjenkins@gmail.com>
LKML-Reference: <1261370306.11354.52.camel@ICE-BOX>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/edac/amd64_edac.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index d271509..72d84d0 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -3082,16 +3082,15 @@ static void __devexit amd64_remove_one_instance(struct pci_dev *pdev)
 
 	amd64_free_mc_sibling_devices(pvt);
 
-	kfree(pvt);
-	mci->pvt_info = NULL;
-
-	mci_lookup[pvt->mc_node_id] = NULL;
-
 	/* unregister from EDAC MCE */
 	amd_report_gart_errors(false);
 	amd_unregister_ecc_decoder(amd64_decode_bus_error);
 
 	/* Free the EDAC CORE resources */
+	mci->pvt_info = NULL;
+	mci_lookup[pvt->mc_node_id] = NULL;
+
+	kfree(pvt);
 	edac_mc_free(mci);
 }
 
-- 
1.6.6

