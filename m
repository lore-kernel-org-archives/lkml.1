Return-Path: <linux-kernel-owner+w=401wt.eu-S1760163AbZLOMZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760163AbZLOMZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 07:25:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760146AbZLOMZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 07:25:21 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:34506 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760117AbZLOMZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 07:25:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=L0GzwqKRsYqFPfvnsiBZVIDp10KRn2Oyz3+bSznccOYPrOwnKepwfJKrdrVpfORGi4
         ipEP0JNmMQsoyQQtPNgvrT5jrYr2YXoi2qH+erp2UYeJygESBE8gzxNtphMZTktxg2Kw
         VT1T0E/FqceSeRVWuqZ+nVLt/WnWnidjim5Sg=
Date: Tue, 15 Dec 2009 17:55:25 +0530
From: Csaba Henk <csaba@gluster.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] PCI: Handle case when no pci device can provide cache
 line size hint
Message-ID: <20091215122525.GA21846@foogalware.zresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prior to this patch, if pci_read_config_byte(dev, PCI_CACHE_LINE_SIZE, ...)
returns 0 for all dev, pci_cache_line_size ends up set to zero
(instead of pci_dfl_cache_line_size).

This patch ensures the pci_cache_line_size = pci_dfl_cache_line_size
setting in the above scenario.

This happens in case of a kvm-88 guest (where, consequently, the rtl8139
NIC failed to initialize).

Signed-off-by: Csaba Henk <csaba@gluster.com>
---
 drivers/pci/quirks.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 7cfa7c3..f70f4e2 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2629,7 +2629,7 @@ static int __init pci_apply_final_quirks(void)
 	if (!pci_cache_line_size) {
 		printk(KERN_DEBUG "PCI: CLS %u bytes, default %u\n",
 		       cls << 2, pci_dfl_cache_line_size << 2);
-		pci_cache_line_size = cls;
+		pci_cache_line_size = cls ? cls : pci_dfl_cache_line_size;
 	}
 
 	return 0;
-- 
1.6.5.6

