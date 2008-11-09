Return-Path: <linux-kernel-owner+w=401wt.eu-S1755951AbYKIQXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbYKIQXs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 11:23:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755420AbYKIQXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 11:23:19 -0500
Received: from ik-out-1112.google.com ([66.249.90.180]:63336 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771AbYKIQXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 11:23:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=M97rMJWuih5QvvlKHPUCe2xWJfaioq3lByZGLYU2HNBlhNCT57ZfJKMxBtzz7EfqJ6
         WPBEF8gKKOE6Aqm1kkMcy45EutoQt19xMJ28R+HPSsGosjLop60h68727WUTQnVRsteH
         iO4XQOgJ1ct1rTxCHzDIgCWhiAOFA5CdufeQY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 6/6] ide: rework handling of serialized ports
Date: Sun, 9 Nov 2008 15:04:14 +0100
User-Agent: KMail/1.9.10
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20081103200244.5098.29817.sendpatchset@localhost.localdomain> <491094B2.4090107@ru.mvista.com> <491095C4.3000503@ru.mvista.com>
In-Reply-To: <491095C4.3000503@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811091504.14279.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 November 2008, Sergei Shtylyov wrote:
> Hello, I wrote:
> 
> >> Index: b/drivers/ide/ide-probe.c
> >> ===================================================================
> >> --- a/drivers/ide/ide-probe.c
> >> +++ b/drivers/ide/ide-probe.c
> 
> > [...]
> 
> >> @@ -1436,10 +1398,8 @@ static void ide_init_port(ide_hwif_t *hw
> >>      }
> >>  
> >>      if ((d->host_flags & IDE_HFLAG_SERIALIZE) ||
> >> -        ((d->host_flags & IDE_HFLAG_SERIALIZE_DMA) && hwif->dma_base)) {
> >> -        if (hwif->mate)
> >> -            hwif->mate->serialized = hwif->serialized = 1;
> >> -    }
> >> +        ((d->host_flags & IDE_HFLAG_SERIALIZE_DMA) && hwif->dma_base))
> >> +        hwif->host_flags |= IDE_HFLAG_SERIALIZE;
> 
> >    I don't see what use is forcing this flag at all here -- it doesn't 
> > seem to be checked only in init_irq() now, so this *if* could just be 
> > moved there...
> 
>     Oops, rephrasing hurts sometimes: I meant "it seems", of course. :-)

I prefer to leave it in ide_init_port() because the future ide_hwgroup_t
removal depends on this flag in deciding whether serialization is needed.

Actually it is better to force the flag on host instead of port so:

...
v2:
* Set host's ->host_flags field instead of port's copy.
...
diff -u b/drivers/ide/hpt366.c b/drivers/ide/hpt366.c
--- b/drivers/ide/hpt366.c
+++ b/drivers/ide/hpt366.c
@@ -1303,7 +1303,7 @@
 		 * Clock is shared between the channels,
 		 * so we'll have to serialize them... :-(
 		 */
-		hwif->host_flags |= IDE_HFLAG_SERIALIZE;
+		hwif->host->host_flags |= IDE_HFLAG_SERIALIZE;
 		hwif->rw_disk = &hpt3xxn_rw_disk;
 	}
 }
diff -u b/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
--- b/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1030,7 +1030,7 @@
 		ide_hwif_t *h = ide_ports[index];
 
 		if (h && h->hwgroup) {  /* scan only initialized ports */
-			if (hwif->host_flags & IDE_HFLAG_SERIALIZE) {
+			if (hwif->host->host_flags & IDE_HFLAG_SERIALIZE) {
 				if (hwif->host == h->host)
 					match = h;
 			}
@@ -1399,7 +1399,7 @@
 
 	if ((d->host_flags & IDE_HFLAG_SERIALIZE) ||
 	    ((d->host_flags & IDE_HFLAG_SERIALIZE_DMA) && hwif->dma_base))
-		hwif->host_flags |= IDE_HFLAG_SERIALIZE;
+		hwif->host->host_flags |= IDE_HFLAG_SERIALIZE;
 
 	if (d->host_flags & IDE_HFLAG_RQSIZE_256)
 		hwif->rqsize = 256;

