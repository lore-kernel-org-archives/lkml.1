Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbYGVUul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbYGVUul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 16:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754288AbYGVUuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 16:50:19 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:61933 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbYGVUuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 16:50:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=cvPXBA0qz1dEwZ/DSDFhJM4zFoTvs9MW+xlbmdj/u/MQ2HH73dGOaKQDcZxg52yZEU
         Ues+SZpuqMKh/jKkTVSWold7KQ5zOjefR6BqhUYNLF1XnTptD2g8/zBKS3TrHIBIqy4Q
         QR8V73u8tfAxSJrM/Smqe97ml7jp1U44oEGl8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH] ide-floppy fix
Date: Tue, 22 Jul 2008 21:49:19 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, stable@kernel.org
References: <20080715053356.GA18628@gollum.tnic> <200807212103.36804.bzolnier@gmail.com> <20080722052735.GA16054@gollum.tnic>
In-Reply-To: <20080722052735.GA16054@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807222149.19939.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday 22 July 2008, Borislav Petkov wrote:

[...]

> [    5.879917] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
> [    5.879997] probe_mask=0x3, i=0x0, io_addr=0x1f0
> [    5.880057] ide_generic: I/O resource 0x1F0-0x1F7 not free.
> [    5.880115] probe_mask=0x3, i=0x1, io_addr=0x170
> [    5.880173] ide_generic: I/O resource 0x170-0x177 not free.
> [    5.880246] ide_host_register: loop0: i=0, hwif=00000000
> [    5.880299] ide_host_register: loop0: i=1, hwif=00000000
> [    5.880357] ide_host_register: loop0: i=2, hwif=00000000
> 
> and then it goes KABOOM!
> 
> 
> 
> I tested both with BLK_DEV_GENERIC on and off and the
> error happens only when it is on:
> 
> --- config.ok   2008-07-22 06:58:48.000000000 +0200
> +++ config.b0rked       2008-07-22 06:59:31.000000000 +0200
> @@ -1,7 +1,7 @@
>  #
>  # Automatically generated make config: don't edit
>  # Linux kernel version: 2.6.26
> -# Tue Jul 22 06:58:28 2008
> +# Tue Jul 22 06:59:24 2008
>  #
>  # CONFIG_64BIT is not set
>  CONFIG_X86_32=y
> @@ -600,7 +600,7 @@ CONFIG_IDE_PROC_FS=y
>  #
>  # IDE chipset support/bugfixes
>  #
> -# CONFIG_IDE_GENERIC is not set
> +CONFIG_IDE_GENERIC=y
>  # CONFIG_BLK_DEV_PLATFORM is not set
>  # CONFIG_BLK_DEV_CMD640 is not set
>  # CONFIG_BLK_DEV_IDEPNP is not set
> 
> I've also attached the .config that breaks the machine. Please take a look in
> case i'm missing something.

Thanks, with this config I can reproduce the problem.

> > [ Besides it shouldn't result in phantom hde & hdf devices
> >   and ide_generic blowing up on failure. ]
> > 
> > Have you tried the memset() fix that I proposed
> > (pata tree contains the revised patch now)?
> 
> yep, test runs ontop of your tree from Sunday which already has the fix.

*sigh*

The previous fix was garbage and contained brown-paper-bag bug:

diff -u b/drivers/ide/ide-generic.c b/drivers/ide/ide-generic.c
--- b/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -114,7 +114,7 @@
 	printk(KERN_INFO DRV_NAME ": please use \"probe_mask=0x3f\" module "
 			 "parameter for probing all legacy ISA IDE ports\n");
 
-	memset(hws, 0, MAX_HWIFS);
+	memset(hws, 0, sizeof(hw_regs_t *) * MAX_HWIFS);
 
 	for (i = 0; i < ARRAY_SIZE(legacy_bases); i++) {
 		io_addr = legacy_bases[i];


Now it should be finally fixed.

> > > One of the possible fixes is adding
> > > 
> > > depends on !BLK_DEV_GENERIC
> > > 
> > > after each IDE chipset driver using the generic detection in drivers/ide/Kconfig
> > > but it's a not-that-elegant one. Another thing would be using a dummy one like
> > > BLK_DEV_IDEDMA_PCI, but I'm not that sure. Will look into it. I'm pretty sure
> > > you have a better idea...
> > 
> > pata_legacy.c has a proper fix which needs porting into ide-generic.c
> > (it should be pretty easy thing to do).
> 
> (is this a hint^^? :))

It has *HINT* written all over it. ;)

Thanks,
Bart
