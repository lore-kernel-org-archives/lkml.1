Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677AbYGUTJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbYGUTJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 15:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbYGUTJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 15:09:32 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:32910 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292AbYGUTJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 15:09:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=Op2SNrWjGAW/ZddvslXjak4tT7Dq28wUXch3l4Ix0n5nDo9Sv2yqzaprMYo4B2p+xe
         6hX9t4tmnItwxCUZFsrEdLgyis39jP1+nLkQCo9HTc9oCJV20GFIjs8ffvzXkaIf7BvO
         p/H8Sai8/3t4tPLxwHVgY2TLEExbucSDH5i50=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] gayle: reserve memory resources at once
Date: Mon, 21 Jul 2008 20:38:23 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
References: <200806221916.59751.bzolnier@gmail.com> <Pine.LNX.4.64.0807191436330.2017@anakin>
In-Reply-To: <Pine.LNX.4.64.0807191436330.2017@anakin>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807212038.24068.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 July 2008, Geert Uytterhoeven wrote:
> On Sun, 22 Jun 2008, Bartlomiej Zolnierkiewicz wrote:
> > * Reserve memory resources for all IDE ports at once by moving
> >   request_mem_region() out of 'for ()' loop and always defining
> >   GAYLE_IDEREG_SIZE to 0x2000.
> > 
> > * Keep memory resources even if no free IDE slots can be found
> >   (this driver is unloadable currently).
> 
> I don't like this part. You're changing the driver to no longer
> correctly handle initialization failures.

Yeah, I don't like it either.  Unfortunately I don't have a better
idea of how to convert this driver to ide_host_add() without this step.

Anyway, this was meant to be temporary and I planned to fix it later
after ide_host_add() is in place but actually I forgot about it...

Fix below.

BTW core code was fixed to allow module removal so it would be great
if you (or somebody else fluent in zorro drivers) could take a look
into converting gayle.c and buddha.c to use new-style zorro probing
(struct zorro_driver & friends) so we can fix these drivers to use
->remove method + zorro_unregister_driver() for module_exit().

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] gayle: release resources on ide_host_add() failure

"gayle: reserve memory resources at once" patch temporary removed
freeing of resources on failure (to ease convertion to ide_host_add()
interface).  This patch fixes it.

Thanks to Geert for noticing the issue.

Noticed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
goes on top of pata tree

 drivers/ide/legacy/gayle.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: b/drivers/ide/legacy/gayle.c
===================================================================
--- a/drivers/ide/legacy/gayle.c
+++ b/drivers/ide/legacy/gayle.c
@@ -127,7 +127,7 @@ static int __init gayle_init(void)
     unsigned long phys_base, res_start, res_n;
     unsigned long base, ctrlport, irqport;
     ide_ack_intr_t *ack_intr;
-    int a4000, i;
+    int a4000, i, rc;
     hw_regs_t hw[GAYLE_NUM_HWIFS], *hws[] = { NULL, NULL, NULL, NULL };
 
     if (!MACH_IS_AMIGA)
@@ -179,7 +179,11 @@ found:
 	hws[i] = &hw[i];
     }
 
-    return ide_host_add(NULL, hws, NULL);
+    rc = ide_host_add(NULL, hws, NULL);
+    if (rc)
+	release_mem_region(res_start, res_n);
+
+    return rc;
 }
 
 module_init(gayle_init);
