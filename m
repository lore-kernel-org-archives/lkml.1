Return-Path: <linux-kernel-owner+w=401wt.eu-S1759679AbYJIQse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759679AbYJIQse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 12:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755079AbYJIQs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 12:48:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42711 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755153AbYJIQs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 12:48:26 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH] early_ioremap: fix fencepost error
To: linux-kernel@vger.kernel.org, mingo@redhat.com
Date: Thu, 09 Oct 2008 17:48:14 +0100
Message-ID: <20081009164750.31850.91790.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The x86 implementation of early_ioremap has an off by one error. If we get
an object which ends on the first byte of a page we undermap by one page and
this causes a crash on boot with the ASUS P5QL whose DMI table happens to fit
this alignment.

The size computation is currently

	last_addr = phys_addr + size - 1;
	npages = (PAGE_ALIGN(last_addr) - phys_addr)

(Consider a request for 1 byte at alignment 0...)

Closes #11693

Debugging work by Ian Campbell/Felix Geyer

Signed-off-by: Alan Cox <alan@rehat.com>
---

 arch/x86/mm/ioremap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index d4b6e6a..d0975fc 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -595,7 +595,7 @@ void __init *early_ioremap(unsigned long phys_addr, unsigned long size)
 	 */
 	offset = phys_addr & ~PAGE_MASK;
 	phys_addr &= PAGE_MASK;
-	size = PAGE_ALIGN(last_addr) - phys_addr;
+	size = PAGE_ALIGN(last_addr + 1) - phys_addr;
 
 	/*
 	 * Mappings have to fit in the FIX_BTMAP area.

