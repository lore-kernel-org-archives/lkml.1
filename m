Return-Path: <linux-kernel-owner+w=401wt.eu-S1757966AbYFEQcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966AbYFEQcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 12:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755129AbYFEQcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 12:32:20 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:45240 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbYFEQcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 12:32:20 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.26-rc5
Date: Thu, 5 Jun 2008 10:32:23 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Alejandro Riveira =?iso-8859-1?q?Fern=E1ndez?= 
	<ariveira@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <alpine.LFD.1.10.0806042018060.3473@woody.linux-foundation.org> <200806051012.07457.bjorn.helgaas@hp.com> <alpine.LFD.1.10.0806050917020.3473@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806050917020.3473@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806051032.24531.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 June 2008 10:19:01 am Linus Torvalds wrote:
> 
> On Thu, 5 Jun 2008, Bjorn Helgaas wrote:
> >  
> >  	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_MEM, i)); i++) {
> > -		if (res->flags & IORESOURCE_DISABLED)
> > +		if (res->flags & IORESOURCE_UNSET ||
> > +		    res->flags & IORESOURCE_DISABLED)
> >  			continue;
> 
> Umm. If I was a compiler, I'd be warning about this. You don't get a 
> warning about suggesting parentheses around the '&'?

Geez, I dreamed about this very question last night, but forgot to
take care this morning.

Actually, I didn't get a warning (gcc 4.1.3), but your way is better.
Here's the updated patch if you haven't fixed it already:



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
+++ work11/drivers/pnp/system.c	2008-06-05 10:29:10.000000000 -0600
@@ -81,7 +81,7 @@ static void reserve_resources_of_dev(str
 	}
 
 	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_MEM, i)); i++) {
-		if (res->flags & IORESOURCE_DISABLED)
+		if (res->flags & (IORESOURCE_UNSET | IORESOURCE_DISABLED))
 			continue;
 
 		reserve_range(dev, res->start, res->end, 0);
