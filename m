Return-Path: <linux-kernel-owner+w=401wt.eu-S1757019AbZDRIoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019AbZDRIoV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 04:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068AbZDRIoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 04:44:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:38527 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814AbZDRIoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 04:44:01 -0400
Message-ID: <49E992C2.4010707@kernel.org>
Date: Sat, 18 Apr 2009 01:43:46 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Matthew Wilcox <matthew@wil.cx>,
       Ingo Molnar <mingo@elte.hu>
CC: linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] x86/pci: fix -1 calling to e820_all_mapped with mmconfig
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


e820_all_mapped need end is (addr + size) instead of (addr + size - 1)

[Impact: fix -1 offset calling]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/mmconfig-shared.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/pci/mmconfig-shared.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/mmconfig-shared.c
+++ linux-2.6/arch/x86/pci/mmconfig-shared.c
@@ -375,7 +375,7 @@ static acpi_status __init check_mcfg_res
 		if (!fixmem32)
 			return AE_OK;
 		if ((mcfg_res->start >= fixmem32->address) &&
-		    (mcfg_res->end < (fixmem32->address +
+		    (mcfg_res->end <= (fixmem32->address +
 				      fixmem32->address_length))) {
 			mcfg_res->flags = 1;
 			return AE_CTRL_TERMINATE;
@@ -392,7 +392,7 @@ static acpi_status __init check_mcfg_res
 		return AE_OK;
 
 	if ((mcfg_res->start >= address.minimum) &&
-	    (mcfg_res->end < (address.minimum + address.address_length))) {
+	    (mcfg_res->end <= (address.minimum + address.address_length))) {
 		mcfg_res->flags = 1;
 		return AE_CTRL_TERMINATE;
 	}
@@ -439,7 +439,7 @@ static int __init is_mmconf_reserved(che
 	u64 old_size = size;
 	int valid = 0;
 
-	while (!is_reserved(addr, addr + size - 1, E820_RESERVED)) {
+	while (!is_reserved(addr, addr + size, E820_RESERVED)) {
 		size >>= 1;
 		if (size < (16UL<<20))
 			break;
