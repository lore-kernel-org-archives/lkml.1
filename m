Return-Path: <linux-kernel-owner+w=401wt.eu-S965736AbXBOPxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965736AbXBOPxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 10:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965739AbXBOPxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 10:53:20 -0500
Received: from mta16.mail.adelphia.net ([68.168.78.211]:50952 "EHLO
	mta16.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965736AbXBOPxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 10:53:20 -0500
Date: Thu, 15 Feb 2007 09:53:18 -0600
From: Corey Minyard <minyard@acm.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 3/4] ipmi: add pci remove handling
Message-ID: <20070215155318.GA24870@localdomain>
Reply-To: minyard@acm.org
References: <20070214200624.GC5364@localdomain> <20070215022745.648ab8cb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070215022745.648ab8cb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 02:27:45AM -0800, Andrew Morton wrote:
> 
> Judging from the patch headers you were working against 2.6.19, which is
> most optimistic.  Please always prepare and test patches against the
> latest kernel.

Well, I had it applied against a 2.6.20 kernel, but I messed up the
testing of it.  Sorry, my bad.

New patch...


Add pci_remove handling to the driver, so it will clean up if
the device is hot-removed.

Signed-off-by: Corey Minyard <minyard@acm.org>

Index: linux-2.6.20/drivers/char/ipmi/ipmi_si_intf.c
===================================================================
--- linux-2.6.20.orig/drivers/char/ipmi/ipmi_si_intf.c
+++ linux-2.6.20/drivers/char/ipmi/ipmi_si_intf.c
@@ -2191,12 +2191,15 @@ static int __devinit ipmi_pci_probe(stru
 		info->irq_setup = std_irq_setup;
 
 	info->dev = &pdev->dev;
+	pdev->dev.driver_data = info;
 
 	return try_smi_init(info);
 }
 
 static void __devexit ipmi_pci_remove(struct pci_dev *pdev)
 {
+	struct smi_info *info = pdev->dev.driver_data;
+	cleanup_one_si(info);
 }
 
 #ifdef CONFIG_PM
