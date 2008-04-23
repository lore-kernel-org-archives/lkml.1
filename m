Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbYDWQyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbYDWQyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 12:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYDWQyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 12:54:36 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:51091 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbYDWQyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 12:54:36 -0400
Message-ID: <480F69C9.4040208@tiscali.nl>
Date: Wed, 23 Apr 2008 18:54:33 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: paulus@samba.org, linuxppc-dev@ozlabs.org
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] powerpc: mpic_pasemi_msi: failed allocation unnoticed
References: <480F6905.3070808@tiscali.nl>
In-Reply-To: <480F6905.3070808@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A similar problem in arch/powerpc/sysdev/mpic_u3msi.c:
---
bitmap_find_free_region(), called by mpic_msi_alloc_hwirqs() may
return -ENOMEM, but hwirq of type irq_hw_number_t which is unsigned.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
The functions can be found respectively in:
//---[ vi lib/bitmap.c +807 ]---
//---[ vi arch/powerpc/sysdev/mpic_msi.c +39 ]---

diff --git a/arch/powerpc/sysdev/mpic_u3msi.c b/arch/powerpc/sysdev/mpic_u3msi.c
index 1d5a408..30a4e27 100644
--- a/arch/powerpc/sysdev/mpic_u3msi.c
+++ b/arch/powerpc/sysdev/mpic_u3msi.c
@@ -122,7 +122,7 @@ static int u3msi_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 
 	list_for_each_entry(entry, &pdev->msi_list, list) {
 		hwirq = mpic_msi_alloc_hwirqs(msi_mpic, 1);
-		if (hwirq < 0) {
+		if (hwirq == -ENOMEM) {
 			pr_debug("u3msi: failed allocating hwirq\n");
 			return hwirq;
 		}
