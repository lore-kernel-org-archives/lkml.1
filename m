Return-Path: <linux-kernel-owner+w=401wt.eu-S1758990AbYFEQMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758990AbYFEQMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 12:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYFEQMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 12:12:12 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:10402 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbYFEQMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 12:12:10 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.26-rc5
Date: Thu, 5 Jun 2008 10:12:06 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Alejandro Riveira =?iso-8859-15?q?Fern=E1ndez?= 
	<ariveira@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
References: <alpine.LFD.1.10.0806042018060.3473@woody.linux-foundation.org> <20080605150306.18c00bd9@Varda> <alpine.LFD.1.10.0806050749570.3473@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806050749570.3473@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200806051012.07457.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 June 2008 08:54:24 am Linus Torvalds wrote:
> 
> On Thu, 5 Jun 2008, Alejandro Riveira Fernández wrote:
> >
> >  I got this on my dmesg; is this expected/harmaless?
> >  (btw The wireless driver oops that i reported is gone as it is the 
> >  bluetooth one ;)
> > 
> ..
> > [    0.233795] system 00:08: iomem range 0x0-0x0 could not be reserved
> > [    0.233795] system 00:08: iomem range 0x0-0x0 could not be reserved
> .. repeated a lot ..
> 
> It's harmless but obviously irritating. The PnP resource manager changes 
> need a few cleanups still - it's getting confused about IORESOURCE_UNSET 
> vs IORESOURCE_DISABLED.

Here's the patch.  I reproduced the problem and verified that this
fixes it.

This should not add conflicts with any of the PNP patches that are
currently in -mm (let me know if it does, of course).  After all
those patches, IORESOURCE_UNSET is never set by PNP, but it should
still be harmless to check for it.



PNP: skip UNSET MEM resources as well as DISABLED ones

We don't need to reserve "unset" resources.  Trying to reserve
them results in messages like this, which are ugly but harmless:

    system 00:08: iomem range 0x0-0x0 could not be reserved

Future PNP patches will remove use of IORESOURCE_UNSET, but
we still need it for now.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work11/drivers/pnp/system.c
===================================================================
--- work11.orig/drivers/pnp/system.c	2008-06-05 09:46:33.000000000 -0600
+++ work11/drivers/pnp/system.c	2008-06-05 09:48:09.000000000 -0600
@@ -81,7 +81,8 @@ static void reserve_resources_of_dev(str
 	}
 
 	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_MEM, i)); i++) {
-		if (res->flags & IORESOURCE_DISABLED)
+		if (res->flags & IORESOURCE_UNSET ||
+		    res->flags & IORESOURCE_DISABLED)
 			continue;
 
 		reserve_range(dev, res->start, res->end, 0);
