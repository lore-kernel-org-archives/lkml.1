Return-Path: <linux-kernel-owner+w=401wt.eu-S1758017AbYCMWFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbYCMWFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 18:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757602AbYCMWFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 18:05:10 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40285 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756856AbYCMWFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 18:05:09 -0400
Date: Thu, 13 Mar 2008 23:05:41 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, stern@rowland.harvard.edu,
       linux-usb@vger.kernel.org, oliver@neukum.name
Subject: Re: 2.6.25 -- long standing bug with usb after resume with 4GB ram
Message-ID: <20080313220541.GA8115@elf.ucw.cz>
References: <20080313110141.GA4329@elf.ucw.cz> <20080313215842.GB15029@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313215842.GB15029@kroah.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > There are problems with usb after suspend/resume... it works as long
> > as memory is limited to 3G -- probably because iommu/agpgart/something
> > is not used in such case.
> > 
> > rmmod/insmod of ehci_hcd & ohci_hcd fixes that.
> > 
> > For testing with 2.6.25, you'll need aperture_64.c patch that makes
> > iommu as nosave (or it oopses).
> 
> Any pointer to where this patch is?
> 
> Can it go into 2.6.25?

Here it is: Yes, I guess it could go into 2.6.25...
								Pavel


diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 608152a..88747f3 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -18,6 +18,7 @@ #include <linux/pci_ids.h>
 #include <linux/pci.h>
 #include <linux/bitops.h>
 #include <linux/ioport.h>
+#include <linux/suspend.h>
 #include <asm/e820.h>
 #include <asm/io.h>
 #include <asm/gart.h>
@@ -76,6 +77,7 @@ static u32 __init allocate_aperture(void
 	printk(KERN_INFO "Mapping aperture over %d KB of RAM @ %lx\n",
 			aper_size >> 10, __pa(p));
 	insert_aperture_resource((u32)__pa(p), aper_size);
+	register_nosave_region((u32)__pa(p) >> PAGE_SHIFT, (u32)__pa(p+aper_size) >> PAGE_SHIFT);
 
 	return (u32)__pa(p);
 }


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
