Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbYFBWF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbYFBWF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 18:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbYFBWFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 18:05:15 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:26890 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbYFBWFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 18:05:14 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: 53052feb6 (PNP: remove pnp_mem_flags() as an lvalue) breaks my ALSA intel8x0 sound card regression
Date: Mon, 2 Jun 2008 16:05:13 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Avuton Olrich <avuton@gmail.com>, Rene Herman <rene.herman@gmail.com>,
       Len Brown <len.brown@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <3aa654a40806010742r1d61caa2j681882145533b56a@mail.gmail.com> <3aa654a40806012025ic6b9d0dlec05211bad782581@mail.gmail.com> <484444A4.80206@keyaccess.nl>
In-Reply-To: <484444A4.80206@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806021605.14519.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 June 2008 01:06:12 pm Rene Herman wrote:
> On 02-06-08 05:25, Avuton Olrich wrote:
> 
> > On Sun, Jun 1, 2008 at 9:20 AM, Rene Herman <rene.herman@keyaccess.nl> wrote:
> >> On 01-06-08 16:42, Avuton Olrich wrote:
> >>
> >>> My intel8x0 card stops working due to a regression; bisection and
> >>> information below.

Thank you very much for doing all the work to bisect this and write
up such a complete report.

Can you try the patch below, please?

PNP: mark resources that conflict with PCI devices "disabled"

Both the PNP/PCI conflict detection quirk and the PNP system
driver must use the same mechanism to mark resources as disabled.

I think it's best to keep the resource and to keep the type bit
(IORESOURCE_MEM, etc), so that we match the list from firmware
as closely as possible.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work11/drivers/pnp/quirks.c
===================================================================
--- work11.orig/drivers/pnp/quirks.c	2008-06-02 14:59:03.000000000 -0600
+++ work11/drivers/pnp/quirks.c	2008-06-02 15:42:35.000000000 -0600
@@ -286,7 +286,7 @@ static void quirk_system_pci_resources(s
 					pci_name(pdev), i,
 					(unsigned long long) pci_start,
 					(unsigned long long) pci_end);
-				res->flags = 0;
+				res->flags |= IORESOURCE_DISABLED;
 			}
 		}
 	}
Index: work11/drivers/pnp/system.c
===================================================================
--- work11.orig/drivers/pnp/system.c	2008-06-02 14:58:56.000000000 -0600
+++ work11/drivers/pnp/system.c	2008-06-02 15:44:36.000000000 -0600
@@ -81,7 +81,7 @@ static void reserve_resources_of_dev(str
 	}
 
 	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_MEM, i)); i++) {
-		if (res->flags & IORESOURCE_UNSET)
+		if (res->flags & IORESOURCE_DISABLED)
 			continue;
 
 		reserve_range(dev, res->start, res->end, 0);
