Return-Path: <linux-kernel-owner+w=401wt.eu-S1762707AbZAGWYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762707AbZAGWYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:24:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762167AbZAGWXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:23:16 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:20814 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759164AbZAGWXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:23:13 -0500
X-BigFish: VPS4(zba6izzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KD4GU6-01-K3M-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 04/18] x86/oprofile: fix pci_dev use count for AMD northbridge devices
Date: Wed, 7 Jan 2009 23:17:21 +0100
Message-ID: <1231366655-17837-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1231366655-17837-1-git-send-email-robert.richter@amd.com>
References: <1231366655-17837-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 07 Jan 2009 22:22:59.0334 (UTC) FILETIME=[7F285A60:01C97116]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the PCI device use count for AMD northbridge
devices. In case of an IBS LVT initialization failure, the PCI device
is released now by calling pci_dev_put().

If there are no initialization errors, the devices are released in
pci_get_device() while iterating.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 98658f2..c5b5c7f 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -409,6 +409,7 @@ static int init_ibs_nmi(void)
 				       | IBSCTL_LVTOFFSETVAL);
 		pci_read_config_dword(cpu_cfg, IBSCTL, &value);
 		if (value != (ibs_eilvt_off | IBSCTL_LVTOFFSETVAL)) {
+			pci_dev_put(cpu_cfg);
 			printk(KERN_DEBUG "Failed to setup IBS LVT offset, "
 				"IBSCTL = 0x%08x", value);
 			return 1;
-- 
1.6.0.1


