Return-Path: <linux-kernel-owner+w=401wt.eu-S965356AbXDGF7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965356AbXDGF7r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 01:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965371AbXDGF7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 01:59:47 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:23645 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965356AbXDGF7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 01:59:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=tf7owNpY76zdAseoXIw4iCIDmJzYq10HUV5Cn3Gx2qmsvAzfFPnLB3+P/Gn6/r03y/TiNVMo7HSw+mitI8gvSA+dxCJC3SMbX5hz+BgfbvdLRIAViYKiEi2NHvxP7XZ5YegWoYnrXLZ+Jj/e4yAarZ8+XUVqZaYnzxJvZ2W++vI=
Date: Sat, 7 Apr 2007 14:59:41 +0900
From: Tejun Heo <htejun@gmail.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org, gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] irq-devres: fix failure path of devm_request_irq()
Message-ID: <20070407055941.GA14120@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

devres should be deallocated with devres_free() not kfree().  This bug
corrupts slab on IRQ request failure.  Fix it.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
Sorry about the bug, please apply before 2.6.21 release.  Thanks.

diff --git a/kernel/irq/devres.c b/kernel/irq/devres.c
index 85a430d..d8ee241 100644
--- a/kernel/irq/devres.c
+++ b/kernel/irq/devres.c
@@ -54,7 +54,7 @@ int devm_request_irq(struct device *dev, unsigned int irq,
 
 	rc = request_irq(irq, handler, irqflags, devname, dev_id);
 	if (rc) {
-		kfree(dr);
+		devres_free(dr);
 		return rc;
 	}
 
