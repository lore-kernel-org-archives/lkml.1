Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbZBVMyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbZBVMyx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 07:54:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbZBVMym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 07:54:42 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:52491 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbZBVMyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 07:54:41 -0500
To: Prakash Punnoor <prakash@punnoor.de>
Cc: Robert Hancock <hancockrwd@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, david@lang.hm,
       Matthew Wilcox <matthew@wil.cx>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com,
       linux-pci@vger.kernel.org
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm>
	<499FD623.1010105@kernel.org> <49A04F1E.7020006@gmail.com>
	<200902221308.55053.prakash@punnoor.de>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 22 Feb 2009 04:54:54 -0800
In-Reply-To: <200902221308.55053.prakash@punnoor.de> (Prakash Punnoor's message of "Sun\, 22 Feb 2009 13\:08\:54 +0100")
Message-ID: <m1iqn2ein5.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: prakash@punnoor.de, linux-pci@vger.kernel.org, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, matthew@wil.cx, david@lang.hm, akpm@linux-foundation.org, jbarnes@virtuousgeek.org, yinghai@kernel.org, hancockrwd@gmail.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Prakash Punnoor <prakash@punnoor.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0013]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] pci: enable MSI on 8132
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Prakesh could you try this patch instead?

I think the problem is simply that the MCP55 ht mapping capability
requires an address to be programed into it and it wasn't in your
case.

It should not hurt to enable one msi ht mapping capability too many.

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index baad093..f7a0370 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2017,10 +2017,19 @@ static void __devinit ht_enable_msi_mapping(struct pci_dev *dev)
 	while (pos && ttl--) {
 		u8 flags;
 
-		if (pci_read_config_byte(dev, pos + HT_MSI_FLAGS,
-					 &flags) == 0) {
+		if (pci_read_config_byte(dev, pos + HT_MSI_FLAGS, &flags))
+			return;
+
+		if (!(flags & HT_MSI_FLAGS_ENABLE)) {
 			dev_info(&dev->dev, "Enabling HT MSI Mapping\n");
 
+			if (!(flags & HT_MSI_FLAGS_FIXED)) {
+				pci_write_config_dword(dev, pos + HT_MSI_ADDR_LO,
+					(HT_MSI_FIXED_ADDR & HT_MSI_FIXED_ADDR));
+				pci_write_config_dword(dev, pos + HT_MSI_ADDR_HI,
+					(HT_MSI_FIXED_ADDR >> 32));
+			}
+
 			pci_write_config_byte(dev, pos + HT_MSI_FLAGS,
 					      flags | HT_MSI_FLAGS_ENABLE);
 		}
