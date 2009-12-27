Return-Path: <linux-kernel-owner+w=401wt.eu-S1752355AbZL0PVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbZL0PVV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 10:21:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbZL0PVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 10:21:20 -0500
Received: from mail.issp.bas.bg ([195.96.236.10]:36220 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbZL0PVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 10:21:20 -0500
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: linux-kernel@vger.kernel.org
Subject: [BUG] agpgart-amd64 not initialized in 2.6.33-rc2
Date: Sun, 27 Dec 2009 17:19:39 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.33-rc2; KDE/4.2.4; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912271719.39306.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Recently (2.6.33-rc2 kernel, x86_64, 4GB RAM) I found (in dmesg):

[drm:mga_do_agp_dma_bootstrap] *ERROR* Unable to acquire AGP: -19

and there is no /dev/agpgart device on the machine while all is OK 
if booting 2.6.32.2. 

In both kernels I have:

CONFIG_AGP=y
CONFIG_AGP_AMD64=y

CONFIG_GART_IOMMU=y

but nevertheless dmesg shows:

PCI-DMA: Using software bounce buffering for IO (SWIOTLB)

due to quirks in via K8T800Pro host bridge.

Looking for the reason I found that agp_amd64_init() appears in:

#ifndef CONFIG_GART_IOMMU
module_init(agp_amd64_init);
module_exit(agp_amd64_cleanup);
#endif

 /*  so it is not invoked here due to CONFIG_GART_IOMMU=y   */

and also appears in:
 
arch/x86/kernel/pci-gart_64.c, function: gart_iommu_init()

The last one is part of the struct x86_init_ops(struct x86_init_iommu, as a function pointer) 
only if gart-iommu is successfully detected, which is not the case here due to the quirk, 
so agp_amd64_init() is not invoked here neither. 

Sure, configuring the kernel without CONFIG_GART_IOMMU=y (which is not user selectable)

should solve the problem, but usually users do not know about quirks, so it should
work even as set here (and it works up to 2.6.32.2). I believe the bug is introduced
with the changes in the order iommu detect/init works for 2.6.33.

I am here for additional info/tests.

Best regards

Marin Mitov



 
