Return-Path: <linux-kernel-owner+w=401wt.eu-S1758351AbYFIDkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351AbYFIDkO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 23:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756722AbYFIDkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 23:40:01 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:24592 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491AbYFIDkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 23:40:00 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Frans Pop <elendil@planet.nl>
Subject: Re: Linux 2.6.26-rc5
Date: Sun, 8 Jun 2008 21:39:45 -0600
User-Agent: KMail/1.9.9
Cc: Jesper Krogh <jesper@krogh.cc>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Avuton Olrich <avuton@gmail.com>
References: <alpine.LFD.1.10.0806042018060.3473@woody.linux-foundation.org> <484AE520.7050001@krogh.cc> <200806072350.59976.elendil@planet.nl>
In-Reply-To: <200806072350.59976.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806082139.45829.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 June 2008 3:50:59 pm Frans Pop wrote:
> Jesper Krogh wrote:
> > Not that they seem critical to the system but I do get alot of these. I
> > cant remember having seen that before.
> >
> > [    2.904467] system 00:06: iomem range 0x0-0x0 could not be reserved
> > [    2.904469] system 00:06: iomem range 0x0-0x0 could not be reserved
> > [    2.904471] system 00:06: iomem range 0x0-0x0 could not be reserved
> > [    2.904473] system 00:06: iomem range 0x0-0x0 could not be reserved
>
> [...]
>
> I'm getting these too. Not present in the last -rc4 kernel I built.
>
> Reverting this commit (the only recent one to the file the message
> originates from), gets rid of the extra zero-range messages:
>
> commit 4b34fe156455d26ee6ed67b61539f136bf4e439c
> Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Date:   Mon Jun 2 16:42:49 2008 -0600
>
>     PNP: mark resources that conflict with PCI devices "disabled"
>
>     Both the PNP/PCI conflict detection quirk and the PNP system
>     driver must use the same mechanism to mark resources as disabled.
>
>     I think it's best to keep the resource and to keep the type bit
>     (IORESOURCE_MEM, etc), so that we match the list from firmware
>     as closely as possible.
>
>     Fixes this regression from 2.6.25: http://lkml.org/lkml/2008/6/1/82
>
>     Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
>     Tested-by: Avuton Olrich <avuton@gmail.com>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>
> Relevant CCs added.

The patch below should fix this and is already in Linus' tree.
Can you give it a whirl to confirm?  Thanks!


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

