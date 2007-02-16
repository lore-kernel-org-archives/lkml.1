Return-Path: <linux-kernel-owner+w=401wt.eu-S966102AbXBOQmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966102AbXBOQmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 11:42:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966108AbXBOQmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 11:42:47 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:50307 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966102AbXBOQmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 11:42:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=GMVdcbwVGrrvoF5NPrN33Qsdo7d8ECmjIXvV02SBDNHHf729fJ9tHQ6s/plnceHzQZuJmv18qJMrI89BpumuXeoMbSqOCdmuSVnyAF/UPRwtvY+ksqCM85zsMt0bqv5sQrmo+82p7RYybKIrOHpyVJudKqih57jzvSTPUaanXVQ=
Date: Fri, 16 Feb 2007 16:41:59 +0000
From: Frederik Deweerdt <deweerdt@free.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: [-mm patch] pci_iomap_regions error handling fix (was Re: 2.6.20-mm1)
Message-ID: <20070216164159.GA32060@slug>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 05:14:08AM -0800, Andrew Morton wrote:
> 
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.20-mm1/
> 
Hi,

It appears that the pcim_iomap_regions() function doesn't get the error
handling right. It BUGs early at boot with a backtrace along the lines of:

ahci_init
pci_register_driver
driver_register
[...]
ahci_init_one
pcim_iomap_region
pcim_iounmap

The following patch allows me to boot. Only the if(mask..) continue;
part fixes the problem actually, the gotos where changed so that we
don't try to unmap something we couldn't map anyway.

Regards,
Frederik

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>


diff --git a/lib/devres.c b/lib/devres.c
index 2a668dd..eb38849 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -274,21 +274,21 @@ int pcim_iomap_regions(struct pci_dev *pdev, u16 mask, const char *name)
 
 		rc = pci_request_region(pdev, i, name);
 		if (rc)
-			goto err_region;
+			goto err_inval;
 
 		rc = -ENOMEM;
 		if (!pcim_iomap(pdev, i, 0))
-			goto err_iomap;
+			goto err_region;
 	}
 
 	return 0;
 
- err_iomap:
-	pcim_iounmap(pdev, iomap[i]);
  err_region:
 	pci_release_region(pdev, i);
  err_inval:
 	while (--i >= 0) {
+		if (!(mask & (1 << i)))
+			continue;
 		pcim_iounmap(pdev, iomap[i]);
 		pci_release_region(pdev, i);
 	}
