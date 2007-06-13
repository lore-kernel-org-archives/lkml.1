Return-Path: <linux-kernel-owner+w=401wt.eu-S1759564AbXFMRzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564AbXFMRzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 13:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758467AbXFMRyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 13:54:55 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:58209 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757918AbXFMRyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 13:54:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:x-mailer:x-operating-system;
        b=oDQbEDUA07aSLlW0SA+OGvfWyiSFpZh20jAKDvRoo0EHL+kXfid1Eyj7piORRg6qA/L4Vqc8MbqtDTxEtDILm4kJjyaFaSRxnrYiv92vEUUCTvDVtkA2twUYdFIxKad9i2AVr4raWjYzpVQB/26J53OGq98+ENr37ru2JmrpxJo=
Date: Thu, 14 Jun 2007 02:00:39 +0800
From: Wang Zhenyu <zhen78@gmail.com>
To: Dave Jones <davej@redhat.com>, Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Wang Zhenyu <zhenyu.z.wang@intel.com>, Eric Anholt <eric@anholt.net>
Subject: Re: I815 suddenly unkown to agpgart?
Message-ID: <20070613180039.GA4508@localhost.localdomain>
References: <Pine.SOC.4.64.0706131804180.2614@math> <20070613160152.GC3875@redhat.com> <20070613161513.GE3875@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070613161513.GE3875@redhat.com>
User-Agent: Mutt/1.4.2.2i
X-Mailer: mutt
X-Operating-System: Linux 2.6.21-rc6 i686
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.06.13 12:15:13 +0000, Dave Jones wrote:
>  >     [AGPGART] intel_agp: use table for device probe
>  >     
> Oh, we have this check in find_gmch ..
> 
>         if (gmch_device && PCI_FUNC(gmch_device->devfn) != 0) {
>                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Which isn't going to work, as Meelis has a gmch on device0, slot0, devfn1.
> Meelis, does it start working again if you change that to just
> 
> 	if (gmch_Device) {

No, the problem for i815 is that it has a config with no integrated gfx.
Sorry I missed it. Meelis, pls test with this patch, which adds a table 
item for this, and fixes wrong driver order within origin i815 driver with IGD.

Thanks.

---
diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index d383168..6d50a37 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -1824,7 +1824,8 @@ static const struct intel_driver_description {
 	{ PCI_DEVICE_ID_INTEL_82810E_MC, PCI_DEVICE_ID_INTEL_82810E_IG, "i810",
 		NULL, &intel_810_driver },
 	{ PCI_DEVICE_ID_INTEL_82815_MC, PCI_DEVICE_ID_INTEL_82815_CGC, "i815",
-		&intel_810_driver, &intel_815_driver },
+		&intel_815_driver, &intel_810_driver },
+	{ PCI_DEVICE_ID_INTEL_82815_MC, 0, "i815", &intel_815_driver, NULL },
 	{ PCI_DEVICE_ID_INTEL_82820_HB, 0, "i820", &intel_820_driver, NULL },
 	{ PCI_DEVICE_ID_INTEL_82820_UP_HB, 0, "i820", &intel_820_driver, NULL },
 	{ PCI_DEVICE_ID_INTEL_82830_HB, PCI_DEVICE_ID_INTEL_82830_CGC, "830M",
---	 
