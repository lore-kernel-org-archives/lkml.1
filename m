Return-Path: <linux-kernel-owner+w=401wt.eu-S932477AbXA2WVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477AbXA2WVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 17:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbXA2WVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 17:21:37 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:22650 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbXA2WVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 17:21:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MFKcVqyngauAlwaubsrgglPD1diljWSbUHUbHXb8ezNKzugxUCLvJiYqSfXKM7PjtNM7AXCdDLi2UHhWQ4eHQkGfurZxmMwZ+c07f/yVNcUOvnpDOnSfYUQKR8LPeZ61Fw/4GCY6SwzLcuZ9PKVeP3AXicE89dCQATo3o2w6EvM=
Subject: Re: i965 testers wanted (Re: intel-agp PM experiences)
From: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Riss <frederic.riss@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: andi@lisas.de, davej@codemonkey.org.uk,
       kernel list <linux-kernel@vger.kernel.org>, seife@suse.de,
       Wang Zhenyu <zhenyu.z.wang@intel.com>
In-Reply-To: <20070129221006.GC17199@elf.ucw.cz>
References: <d120d5000701160608t73db4405n5d157db43899776a@mail.gmail.com>
	 <20070116142432.GA6171@elf.ucw.cz>
	 <d120d5000701161325h112a9299w944763b7f1032a61@mail.gmail.com>
	 <20070117004012.GA11140@rhlx01.hs-esslingen.de>
	 <20070117005755.GB6270@elf.ucw.cz>
	 <20070118115105.GA28233@rhlx01.hs-esslingen.de>
	 <20070118231650.GA5352@ucw.cz>
	 <20070122044519.GA24398@zhen-devel.sh.intel.com>
	 <20070123094456.GG6033@ucw.cz> <1170108330.21603.5.camel@funkylaptop>
	 <20070129221006.GC17199@elf.ucw.cz>
Content-Type: text/plain; charset=utf-8
Date: Mon, 29 Jan 2007 23:21:31 +0100
Message-Id: <1170109291.21603.15.camel@funkylaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 29 janvier 2007 à 23:10 +0100, Pavel Machek a écrit :
> > > Ok, I guess we'd like some testing here... so that in can be fixed in
> > > mainline...
> > 
> > I can confirm that this patch is needed for my Intel Mac Mini to resume
> > correctly when used without BIOS emulation (EFI mode). Here're the
> > relevant lspci lines:
> 
> Can you attach the patch you tested (there was link above, but it did
> not work for me), and try pushing it through maintainers?

I inlined the patch I used below. If I'm not mistaken, the maintainer is
Davej which is already in the Cc: list. I think it's exactly the same as
was submitted in http://lkml.org/lkml/2007/1/16/297 (I may have hand
copied it though, can't remember). The above link is more complete as it
contains the Signed-off-by and a description.

diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index ab0a9c0..f64a115 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -1955,6 +1955,15 @@ static int agp_intel_resume(struct pci_d
 
 	pci_restore_state(pdev);
 
+	/* We should restore our graphics device's config space,
+	 * as host bridge (00:00) resumes before graphics device (02:00),
+	 * then our access to its pci space can work right. 
+	 */
+	if (intel_i810_private.i810_dev)
+		pci_restore_state(intel_i810_private.i810_dev);
+	if (intel_i830_private.i830_dev)
+		pci_restore_state(intel_i830_private.i830_dev);
+
 	if (bridge->driver == &intel_generic_driver)
 		intel_configure();
 	else if (bridge->driver == &intel_850_driver)


