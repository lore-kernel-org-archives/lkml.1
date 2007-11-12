Return-Path: <linux-kernel-owner+w=401wt.eu-S1756864AbXKLVZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864AbXKLVZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 16:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbXKLVZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 16:25:12 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51705 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752322AbXKLVZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 16:25:10 -0500
Date: Mon, 12 Nov 2007 13:24:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jonas Stare <jonas.stare@purplescout.se>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] drivers/ide/ide-probe.c, kernel 2.6.23.1
Message-Id: <20071112132448.0facce12.akpm@linux-foundation.org>
In-Reply-To: <473434F1.50509@purplescout.se>
References: <473434F1.50509@purplescout.se>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Nov 2007 11:22:41 +0100 Jonas Stare <jonas.stare@purplescout.se> wrote:

> Hi.
> 
> This week I ran into a strange hardware problem. During boot I got a 35 
> second delay while waiting for IDE-disks that weren't there to report 
> that they were not in a BSY state. The problem was most likely in the 
> hardware but this patch enables you to ignore waiting for disks by 
> setting hdX=noprobe (and not setting the geometry by hand) as a kernel 
> option.
> 
> If no noprobe-option is set the code will work (more or less) as the 
> original but if set the code will skip the ide_wait_not_busy() for that 
> drive. Even if there would be a drive there and it is still BSY 
> afterwards it should not matter since it isn't probed for later.
> 
> There are other ways to get around the "35-seconds-of-waiting-in-vain", 
> like actually fix the hardware, insert a second drive that works or 
> recompile the kernel with edd-support builtin (atleast I've seen that 
> solution on a forum) and possibly others. But this patch would allow 
> people to get Linux to boot quickly on wonky hardware without having to 
> recompile anything.
> 
> (The code also honors the MAX_DRIVES variable instead of assuming that 
> ther will be 2 drives on the bus.)

I keep on hearing about problems with boot-time IDE probing.  It's public
enemy #1 with the embedded guys.

It does seem that operator intervention is needed in some fashion.

> I will be happy for all the comments I can get. :) But be gentle, this 
> is my first patch...
> 
>    Best regards
>    Jonas Stare
> 
> Signed-off-by: Jonas Stare <jonas.stare@purplescout.se>
> --
> diff -u linux-2.6.23.1-orig/drivers/ide/ide-probe.c 
> linux-2.6.23.1/drivers/ide/ide-probe.c
> --- linux-2.6.23.1-orig/drivers/ide/ide-probe.c 2007-10-12 
> 18:43:44.000000000 +0200
> +++ linux-2.6.23.1/drivers/ide/ide-probe.c      2007-11-09 
> 10:43:16.000000000 +0100
> @@ -643,6 +643,7 @@
>   static int wait_hwif_ready(ide_hwif_t *hwif)
>   {
>          int rc;
> +       int unit;
> 
>          printk(KERN_DEBUG "Probing IDE interface %s...\n", hwif->name);
> 
> @@ -659,20 +660,24 @@
>                  return rc;
> 
>          /* Now make sure both master & slave are ready */
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
> +                   hwif->drives[unit].forced_geom) {
> +                       SELECT_DRIVE(&hwif->drives[unit]);
> +                       hwif->OUTB(8, hwif->io_ports[IDE_CONTROL_OFFSET]);
> +                       mdelay(2);
> +                       rc = ide_wait_not_busy(hwif, 35000);
> +                       /* Exit function with master selected (let's be 
> sane) */
> +                       SELECT_DRIVE(&hwif->drives[0]);
> +                       if (rc)
> +                               return rc;
> +               } else {
> +                       printk(KERN_DEBUG "Skip ide_wait_not_busy for 
> %s:%d\n",
> +                         hwif->name, unit);
> +               }
> +       }
> 
> -       /* Exit function with master reselected (let's be sane) */
> -       SELECT_DRIVE(&hwif->drives[0]);
> -
>          return rc;
>   }

Maybe that's the fix, maybe not - I'll defer to others on that (please).

Your email client is wordwrapping the text, and replaces tabs with spaces. 
Most of them seem to do this nowadays.  For thunderbird, please see
http://mbligh.org/linuxdocs/Email/Clients/Thunderbird


