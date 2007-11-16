Return-Path: <linux-kernel-owner+w=401wt.eu-S1762041AbXKPMvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762041AbXKPMvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 07:51:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756657AbXKPMvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 07:51:35 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:5388 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754439AbXKPMve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 07:51:34 -0500
Message-ID: <473D9261.6080209@ru.mvista.com>
Date: Fri, 16 Nov 2007 15:51:45 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Jonas Stare <jonas.stare@purplescout.se>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH][RESUBMIT] drivers/ide/ide-probe.c, kernel 2.6.23.1
References: <473434F1.50509@purplescout.se> <200711132303.28424.bzolnier@gmail.com> <473C08B2.1030004@purplescout.se> <200711152159.23607.bzolnier@gmail.com> <473D88A5.306@purplescout.se>
In-Reply-To: <473D88A5.306@purplescout.se>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jonas Stare wrote:

> diff -u linux-2.6.23.1-orig/drivers/ide/ide-probe.c linux-2.6.23.1/drivers/ide/ide-probe.c 
> --- linux-2.6.23.1-orig/drivers/ide/ide-probe.c 2007-10-12 18:43:44.000000000 +0200
> +++ linux-2.6.23.1/drivers/ide/ide-probe.c      2007-11-16 10:26:23.000000000 +0100
> @@ -643,6 +643,7 @@
>  static int wait_hwif_ready(ide_hwif_t *hwif)
>  {
>         int rc;
> +       int unit;
>  
>         printk(KERN_DEBUG "Probing IDE interface %s...\n", hwif->name);
>  
> @@ -659,16 +660,25 @@
>                 return rc;
>  
>         /* Now make sure both master & slave are ready */
> -       SELECT_DRIVE(&hwif->drives[0]);
> -       hwif->OUTB(8, hwif->io_ports[IDE_CONTROL_OFFSET]);
> -       mdelay(2);
> -       rc = ide_wait_not_busy(hwif, 35000);
> -       if (rc)
> -               return rc;
> -       SELECT_DRIVE(&hwif->drives[1]);
> -       hwif->OUTB(8, hwif->io_ports[IDE_CONTROL_OFFSET]);
> -       mdelay(2);
> -       rc = ide_wait_not_busy(hwif, 35000);
> +       for (unit = 0; unit < MAX_DRIVES; ++unit) {
> +               /* Ignore disks that we will not probe for later. */
> +               if (!hwif->drives[unit].noprobe ||
> +                   hwif->drives[unit].present) {

    Why not:

		if (hwif->drives[unit].noprobe || !hwif->drives[unit].present) {
                 	printk(KERN_DEBUG "Skip ide_wait_not_busy for %s:%d\n",
                                hwif->name, unit);
			continue;
		}
                 SELECT_DRIVE(&hwif->drives[unit]);
                 hwif->OUTB(8, hwif->io_ports[IDE_CONTROL_OFFSET]);
                 mdelay(2);
                 rc = ide_wait_not_busy(hwif, 35000);
                 if (rc) {
			/* Exit function with master reselected */
                         if (unit != 0)
                         	SELECT_DRIVE(&hwif->drives[0]);
                         return rc;
         	}
	}
>  
>         /* Exit function with master reselected (let's be sane) */
>         SELECT_DRIVE(&hwif->drives[0]);

MBR, Sergei
