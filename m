Return-Path: <linux-kernel-owner+w=401wt.eu-S1753238AbYJ1HjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbYJ1HjY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 03:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbYJ1HjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 03:39:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:60325 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568AbYJ1HjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 03:39:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,497,1220252400"; 
   d="scan'208";a="456213588"
Date: Tue, 28 Oct 2008 14:44:11 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: Eric Dumazet <dada1@cosmosbay.com>, benli@broadcom.com
Cc: "willy@linux.intel.com" <willy@linux.intel.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Michael Chan <mchan@broadcom.com>
Subject: Re: [PATCH] PCI: Limit VPD length for Broadcom 5708S
Message-ID: <20081028064411.GA7043@yzhao12-linux.sh.intel.com>
References: <48920413.6080508@cosmosbay.com> <4906405F.6080708@cosmosbay.com> <1225164385.3977.11.camel@localhost> <4906AF5F.9040704@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4906AF5F.9040704@cosmosbay.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 02:21:19PM +0800, Eric Dumazet wrote:
> Benjamin Li a écrit :
> > Hi Eric,
> > 
> > It looks like the same problem again: we are reading past a valid VPD
> > address.
> > 
> > After some initial debugging, it looks like dev->vpd is NULL when the
> > Broadcom 5706C/5706S/5708C/570S/5709 quirk is called.  Because of this
> > dev->vpd->len is never set to the proper length to limit the VPD reads.
> > I will debug further to determine what has changed.
> > 
> > Thanks again for pointing out the problem.
> > 
> 
> I did a git bisect this morning :
> 
> $ git bisect good
> 201de56eb22f1ff3f36804bc70cbff220b50f067 is first bad commit
> commit 201de56eb22f1ff3f36804bc70cbff220b50f067
> Author: Zhao, Yu <yu.zhao@intel.com>
> Date:   Mon Oct 13 19:49:55 2008 +0800
> 
>     PCI: centralize the capabilities code in probe.c
> 
>     This patch centralizes the initialization and release functions of
>     various PCI capabilities in probe.c, which makes the introduction
>     of new capability support functions cleaner in the future.
> 
>     Signed-off-by: Yu Zhao <yu.zhao@intel.com>
>     Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> 

Yes, the VPD initialization code has been moved to a later stage that is
after the pci_fixup_header. Can you please try following fix?

Thanks,
Yu

VPD quirks needs to be called after the capability is initialized. Since
VPD initialization is move to after pci_fixup_header, VPD quirks should
be done at pci_fixup_final stage correspondingly.

Signed-off-by: Yu Zhao <yu.zhao@intel.com>

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index bbf66ea..5049a47 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1692,24 +1692,24 @@ static void __devinit quirk_brcm_570x_limit_vpd(struct pci_dev *dev)
 	}
 }
 
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_BROADCOM,
-			 PCI_DEVICE_ID_NX2_5706,
-			 quirk_brcm_570x_limit_vpd);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_BROADCOM,
-			 PCI_DEVICE_ID_NX2_5706S,
-			 quirk_brcm_570x_limit_vpd);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_BROADCOM,
-			 PCI_DEVICE_ID_NX2_5708,
-			 quirk_brcm_570x_limit_vpd);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_BROADCOM,
-			 PCI_DEVICE_ID_NX2_5708S,
-			 quirk_brcm_570x_limit_vpd);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_BROADCOM,
-			 PCI_DEVICE_ID_NX2_5709,
-			 quirk_brcm_570x_limit_vpd);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_BROADCOM,
-			 PCI_DEVICE_ID_NX2_5709S,
-			 quirk_brcm_570x_limit_vpd);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
+			PCI_DEVICE_ID_NX2_5706,
+			quirk_brcm_570x_limit_vpd);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
+			PCI_DEVICE_ID_NX2_5706S,
+			quirk_brcm_570x_limit_vpd);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
+			PCI_DEVICE_ID_NX2_5708,
+			quirk_brcm_570x_limit_vpd);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
+			PCI_DEVICE_ID_NX2_5708S,
+			quirk_brcm_570x_limit_vpd);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
+			PCI_DEVICE_ID_NX2_5709,
+			quirk_brcm_570x_limit_vpd);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
+			PCI_DEVICE_ID_NX2_5709S,
+			quirk_brcm_570x_limit_vpd);
 
 #ifdef CONFIG_PCI_MSI
 /* Some chipsets do not support MSI. We cannot easily rely on setting
