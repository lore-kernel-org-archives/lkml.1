Return-Path: <linux-kernel-owner+w=401wt.eu-S1757794AbZELXa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794AbZELXa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 19:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756344AbZELXZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 19:25:34 -0400
Received: from 75-149-38-2-SFBA.hfc.comcastbusiness.net ([75.149.38.2]:36191
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754829AbZELXZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 19:25:27 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Gerd Hoffmann <kraxel@xeni.home.kraxel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 16/17] xen: fix legacy irq setup, make ioapic-less machines work.
Date: Tue, 12 May 2009 16:25:23 -0700
Message-Id: <1242170724-13349-17-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242170724-13349-1-git-send-email-jeremy@goop.org>
References: <1242170724-13349-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gerd Hoffmann <kraxel@xeni.home.kraxel.org>

If the machine has no IO APICs, then just allocate a set of legacy
interrupts.

[ Impact: fix Xen compatibility with old machines ]

Signed-off-by: Gerd Hoffmann <kraxel@xeni.home.kraxel.org>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/pci.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/pci.c b/arch/x86/xen/pci.c
index 4b286f1..07b59fe 100644
--- a/arch/x86/xen/pci.c
+++ b/arch/x86/xen/pci.c
@@ -66,6 +66,12 @@ void __init xen_setup_pirqs(void)
 {
 	int irq;
 
+	if (0 == nr_ioapics) {
+		for (irq = 0; irq < NR_IRQS_LEGACY; irq++)
+			xen_allocate_pirq(irq, "xt-pic");
+		return;
+	}
+
 	/* Pre-allocate legacy irqs */
 	for (irq = 0; irq < NR_IRQS_LEGACY; irq++) {
 		int trigger, polarity;
-- 
1.6.0.6

