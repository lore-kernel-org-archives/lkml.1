Return-Path: <linux-kernel-owner+w=401wt.eu-S1755347AbYBIRw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347AbYBIRw0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 12:52:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbYBIRwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 12:52:18 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:9832 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbYBIRwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 12:52:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=OSItUrTMpAfbYLceKZkoTENRKkLWsZskgHmHPGMwk9pJ9LXnNPnFHgZrOh+8uuHCZlIL4W+vh48TmxMTT6vle0ogUCUATo42j8sEmX+zu4Fe1OMPnm5eYWiQ2lCSx6cLyHIGJfn/ookLw0FlHJwVX013I6t0+dqdr6ac7ZTusrw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: ide/arm/bast-ide.c compile error
Date: Sat, 9 Feb 2008 19:05:24 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: rmk@arm.linux.org.uk, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20080209001515.GF6505@cs181133002.pp.htv.fi>
In-Reply-To: <20080209001515.GF6505@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802091905.24827.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 February 2008, Adrian Bunk wrote:
> Commit 9e016a719209d95338e314b46c3012cc7feaaeec causes the following 
> compile error:
> 
> <--  snip  -->
> 
> ...
>   CC      drivers/ide/arm/bast-ide.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/arm/bast-ide.c: In function 'bastide_register':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/arm/bast-ide.c:31: error: 'hwif' redeclared as different kind of symbol
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/arm/bast-ide.c:29: error: previous definition of 'hwif' was here
> make[4]: *** [drivers/ide/arm/bast-ide.o] Error 1
> 
> <--  snip  -->

OK, I suck big time...

I didn't try to compile bast-ide ARM host driver and I overlooked this:

static int __init
bastide_register(unsigned int base, unsigned int aux, int irq,
		 ide_hwif_t **hwif)
{
	ide_hwif_t *hwif;

patch below...


From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] bast-ide: build fix

On Saturday 09 February 2008, Adrian Bunk wrote:
> Commit 9e016a719209d95338e314b46c3012cc7feaaeec causes the following 
> compile error:
> 
> <--  snip  -->
> 
> ...
>   CC      drivers/ide/arm/bast-ide.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/arm/bast-ide.c: In function 'bastide_register':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/arm/bast-ide.c:31: error: 'hwif' redeclared as different kind of symbol
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/arm/bast-ide.c:29: error: previous definition of 'hwif' was here
> make[4]: *** [drivers/ide/arm/bast-ide.o] Error 1
> 
> <--  snip  -->

Remove 'ide_hwif_t **hwif' argument from bastide_register()
(together with write-only ifs[]).

Cc: Adrian Bunk <bunk@kernel.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/bast-ide.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

Index: b/drivers/ide/arm/bast-ide.c
===================================================================
--- a/drivers/ide/arm/bast-ide.c
+++ b/drivers/ide/arm/bast-ide.c
@@ -21,12 +21,7 @@
 #include <asm/arch/bast-map.h>
 #include <asm/arch/bast-irq.h>
 
-/* list of registered interfaces */
-static ide_hwif_t *ifs[2];
-
-static int __init
-bastide_register(unsigned int base, unsigned int aux, int irq,
-		 ide_hwif_t **hwif)
+static int __init bastide_register(unsigned int base, unsigned int aux, int irq)
 {
 	ide_hwif_t *hwif;
 	hw_regs_t hw;
@@ -76,8 +71,9 @@ static int __init bastide_init(void)
 
 	printk("BAST: IDE driver, (c) 2003-2004 Simtec Electronics\n");
 
-	bastide_register(BAST_VA_IDEPRI, BAST_VA_IDEPRIAUX, IRQ_IDE0, &ifs[0]);
-	bastide_register(BAST_VA_IDESEC, BAST_VA_IDESECAUX, IRQ_IDE1, &ifs[1]);
+	bastide_register(BAST_VA_IDEPRI, BAST_VA_IDEPRIAUX, IRQ_IDE0);
+	bastide_register(BAST_VA_IDESEC, BAST_VA_IDESECAUX, IRQ_IDE1);
+
 	return 0;
 }
 

