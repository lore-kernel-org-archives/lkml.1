Return-Path: <linux-kernel-owner+w=401wt.eu-S933802AbYBUB2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933802AbYBUB2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 20:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755686AbYBUB2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 20:28:11 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:44244 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbYBUB2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 20:28:09 -0500
Date: Wed, 20 Feb 2008 17:36:19 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86: skip it if Fam 10h only handle bus 0
In-reply-to: <200802190313.02551.yinghai.lu@sun.com>
To: Ingo Molnar <mingo@elte.hu>, Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802201736.19685.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802190311.44404.yinghai.lu@sun.com>
 <200802190313.02551.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


need to apply after
	x86_64: check MSR to get MMCONFIG for AMD Family 10h Opteron v3

some BIOS only let AMD fam 10h handle bus0, and nvidia mcp55/ck804
to handle other buses. at that case MCFG will cover all over them.

this patch will skip it so to use MCFG later.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86/pci/mmconfig-shared.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/mmconfig-shared.c
+++ linux-2.6/arch/x86/pci/mmconfig-shared.c
@@ -123,6 +123,14 @@ static const char __init *pci_mmcfg_amd_
 
 	busnbits = (msr >> FAM10H_MMIO_CONF_BUSRANGE_SHIFT) &
 			 FAM10H_MMIO_CONF_BUSRANGE_MASK;
+
+	/*
+	 * only handle bus 0 ?
+	 * need to skip it
+	 */
+	if (!busnbits)
+		return NULL;
+
 	if (busnbits > 8) {
 		segnbits = busnbits - 8;
 		busnbits = 8;
