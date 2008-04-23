Return-Path: <linux-kernel-owner+w=401wt.eu-S1752643AbYDWWcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbYDWWcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 18:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbYDWWcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 18:32:33 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:39230 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbYDWWcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 18:32:32 -0400
Message-ID: <480FB8FA.3060805@tiscali.nl>
Date: Thu, 24 Apr 2008 00:32:26 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: paulus@samba.org, linuxppc-dev@ozlabs.org
CC: lkml <linux-kernel@vger.kernel.org>,
       Segher Boessenkool <segher@kernel.crashing.org>
Subject: [PATCH 1/2 v2] powerpc: mpic_pasemi_msi: failed allocation unnoticed
References: <480F6905.3070808@tiscali.nl>
In-Reply-To: <480F6905.3070808@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

also please add my signoff to 
[PATCH 2/2 v2] mpic_u3msi: mpic_u3msi: failed allocation unnoticed
---
bitmap_find_free_region(), called by mpic_msi_alloc_hwirqs() may return
signed, but hwirq is unsigned. A failed allocation remains unnoticed.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/arch/powerpc/sysdev/mpic_pasemi_msi.c b/arch/powerpc/sysdev/mpic_pasemi_msi.c
index 33cbfb2..68aff60 100644
--- a/arch/powerpc/sysdev/mpic_pasemi_msi.c
+++ b/arch/powerpc/sysdev/mpic_pasemi_msi.c
@@ -95,6 +95,7 @@ static int pasemi_msi_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 	unsigned int virq;
 	struct msi_desc *entry;
 	struct msi_msg msg;
+	int ret;
 
 	pr_debug("pasemi_msi_setup_msi_irqs, pdev %p nvec %d type %d\n",
 		 pdev, nvec, type);
@@ -108,8 +109,9 @@ static int pasemi_msi_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 		 * few MSIs for someone, but restrictions will apply to how the
 		 * sources can be changed independently.
 		 */
-		hwirq = mpic_msi_alloc_hwirqs(msi_mpic, ALLOC_CHUNK);
-		if (hwirq < 0) {
+		ret = mpic_msi_alloc_hwirqs(msi_mpic, ALLOC_CHUNK);
+		hwirq = ret;
+		if (ret < 0) {
 			pr_debug("pasemi_msi: failed allocating hwirq\n");
 			return hwirq;
 		}

