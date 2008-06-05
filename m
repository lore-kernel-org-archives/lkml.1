Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbYFEQTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbYFEQTG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 12:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759813AbYFEQSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 12:18:51 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:9381 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759527AbYFEQSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 12:18:49 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Tony Luck" <tony.luck@intel.com>
Subject: Re: 53052feb6 (PNP: remove pnp_mem_flags() as an lvalue) breaks my ALSA intel8x0 sound card regression
Date: Thu, 5 Jun 2008 10:18:52 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Avuton Olrich" <avuton@gmail.com>,
       "Rene Herman" <rene.herman@keyaccess.nl>,
       "Rene Herman" <rene.herman@gmail.com>,
       "Len Brown" <len.brown@intel.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <3aa654a40806010742r1d61caa2j681882145533b56a@mail.gmail.com> <200806021642.50491.bjorn.helgaas@hp.com> <12c511ca0806041638t1dace5c1i3831297305670ae4@mail.gmail.com>
In-Reply-To: <12c511ca0806041638t1dace5c1i3831297305670ae4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806051018.54025.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 June 2008 05:38:53 pm Tony Luck wrote:
> This is now in Linus tree (commit 4b34fe156455d26ee6ed67b61539f136bf4e439c)
> 
> > --- work11.orig/drivers/pnp/system.c    2008-06-02 14:58:56.000000000 -0600
> > +++ work11/drivers/pnp/system.c 2008-06-02 15:44:36.000000000 -0600
> > @@ -81,7 +81,7 @@ static void reserve_resources_of_dev(str
> >        }
> >
> >        for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_MEM, i)); i++) {
> > -               if (res->flags & IORESOURCE_UNSET)
> > +               if (res->flags & IORESOURCE_DISABLED)
> 
> but this change is responsible for a slew of console messages during
> boot like this
> on my Tiger4:
> 
> system 00:01: iomem range 0x0-0x0 has been reserved
> system 00:01: iomem range 0x0-0x0 has been reserved
> system 00:01: iomem range 0x0-0x0 has been reserved
> system 00:01: iomem range 0x0-0x0 has been reserved
> system 00:01: iomem range 0x0-0x0 has been reserved
> system 00:01: iomem range 0x0-0x0 has been reserved
> system 00:01: iomem range 0x0-0x0 has been reserved
> system 00:01: iomem range 0x0-0x0 has been reserved
> system 00:01: iomem range 0x0-0x0 has been reserved
>  ... continues for total of 46 lines

I just sent Linus the patch to fix this (below).

In Linus' current tree, PNP_MAX_MEM is 24, so I would expect that
you would see 24 iomem messages (either successful or unsuccessful
reservations) for each system device (PNP0C01 or PNP0C02).

Hmm... the other report (on LKML) was for "iomem range 0x0-0x0
could not be reserved", while your messages were for successful
reservations.  I don't know why they're different.  But I think
this patch should fix both.



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
