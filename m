Return-Path: <linux-kernel-owner+w=401wt.eu-S1763955AbZEHAYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763955AbZEHAYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756715AbZEHAKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:10:33 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:52705
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755324AbZEHAKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:10:04 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Gerd Hoffmann <kraxel@xeni.home.kraxel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 15/18] xen: fix legacy irq setup, make ioapic-less machines work.
Date: Thu,  7 May 2009 14:14:40 -0700
Message-Id: <1241730883-4917-16-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241730883-4917-1-git-send-email-jeremy@goop.org>
References: <1241730883-4917-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gerd Hoffmann <kraxel@xeni.home.kraxel.org>

Impact: compatibility with old machines

If the machine has no IO APICs, then just allocate a set of legacy
interrupts.

Signed-off-by: Gerd Hoffmann <kraxel@xeni.home.kraxel.org>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/pci.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/pci.c b/arch/x86/xen/pci.c
index fb3ada9..69b475b 100644
--- a/arch/x86/xen/pci.c
+++ b/arch/x86/xen/pci.c
@@ -65,6 +65,12 @@ void __init xen_setup_pirqs(void)
 {
 	int irq;
 
+	if (0 == nr_ioapics) {
+		for (irq=0; irq < NR_IRQS_LEGACY; irq++)
+			xen_allocate_pirq(irq, "xt-pic");
+		return;
+	}
+
 	/* Pre-allocate legacy irqs */
 	for (irq=0; irq < NR_IRQS_LEGACY; irq++) {
 		int trigger, polarity;
-- 
1.6.0.6

