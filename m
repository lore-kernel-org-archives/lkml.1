Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbZJVUDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbZJVUDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 16:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbZJVUDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 16:03:37 -0400
Received: from netrider.rowland.org ([192.131.102.5]:33868 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753266AbZJVUDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 16:03:36 -0400
Date: Thu, 22 Oct 2009 16:03:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       <linux-media@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: uvcvideo causes ehci_hcd to halt
In-Reply-To: <4AE080AC.4050108@pardus.org.tr>
Message-ID: <Pine.LNX.4.44L0.0910221558510.9192-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Oct 2009, [UTF-8] Ozan Çağlayan wrote:

> Alan Stern wrote:
> > On Thu, 22 Oct 2009, [UTF-8] Ozan Ã‡aÄŸlayan wrote:
> >
> >   
> >> Here's the outputs from /sys/kernel/debug/usb/ehci:
> >>
> >> periodic:
> >> ----------------
> >> size = 1024
> >>    1:  qh1024-0001/f6ffe280 (h2 ep2 [1/0] q0 p8)
> >>     
> >
> > There's something odd about this.  I'd like to see this file again, 
> > after the patch below has been applied.
> >
> >   
> 
> Do you want me to apply this patch altogether with the first one that
> you sent a while ago in this thread or directly onto the vanilla kernel?

It doesn't matter.  The "size = 1024" line in your debugging output 
means that the first patch won't have any effect; my hunch was wrong.

However it turns out that the most recent patch wasn't quite what I
wanted.  Here's an updated version to be used instead.

Alan Stern



Index: usb-2.6/drivers/usb/host/ehci-dbg.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ehci-dbg.c
+++ usb-2.6/drivers/usb/host/ehci-dbg.c
@@ -596,18 +596,22 @@ static ssize_t fill_periodic_buffer(stru
 							qtd->hw_token) >> 8)) {
 						case 0: type = "out"; continue;
 						case 1: type = "in"; continue;
+						case 2: type = "?2"; continue;
+						case 3: type = "?3"; continue;
 						}
 					}
 
 					temp = scnprintf (next, size,
 						" (%c%d ep%d%s "
-						"[%d/%d] q%d p%d)",
+						"[%d/%d] q%d p%d) t%08x",
 						speed_char (scratch),
 						scratch & 0x007f,
 						(scratch >> 8) & 0x000f, type,
 						p.qh->usecs, p.qh->c_usecs,
 						temp,
-						0x7ff & (scratch >> 16));
+						0x7ff & (scratch >> 16),
+						hc32_to_cpu(ehci,
+							p.qh->hw->hw_token));
 
 					if (seen_count < DBG_SCHED_LIMIT)
 						seen [seen_count++].qh = p.qh;

