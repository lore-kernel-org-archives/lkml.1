Return-Path: <linux-kernel-owner+w=401wt.eu-S1752651AbYFVI67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbYFVI67 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 04:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbYFVI6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 04:58:51 -0400
Received: from wilson.telenet-ops.be ([195.130.132.42]:36777 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbYFVI6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 04:58:49 -0400
Date: Sun, 22 Jun 2008 10:58:46 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: linux-ide@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 2/2] ide: pass hw_regs_t-s to ide_device_add[_all]()
In-Reply-To: <200806202029.11304.bzolnier@gmail.com>
Message-ID: <Pine.LNX.4.64.0806221055210.4607@anakin>
References: <200806202029.11304.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2008, Bartlomiej Zolnierkiewicz wrote:
> * Add 'hw_regs_t **hws' argument to ide_device_add[_all]() and convert
>   host drivers + drivers/ide/setup-pci.c to use it instead of calling
>   ide_init_port_hw() directly (however if host has more than 1 port we
>   must still set hwif->chipset to hint consecutive ide_find_port() call
>   that the ide_hwifs[] slot is occupied).
> 
> * Unexport ide_init_port_hw().
> 
> There should be no functional changes caused by this patch.

Brr... seems to complicate the bookkeeping a lot...

I looked at the m68k drivers only:

> --- a/drivers/ide/legacy/buddha.c
> +++ b/drivers/ide/legacy/buddha.c
> @@ -148,7 +148,6 @@ static void __init buddha_setup_ports(hw
>  
>  static int __init buddha_init(void)
>  {
> -	hw_regs_t hw;
>  	ide_hwif_t *hwif;
>  	int i;
>  
> @@ -159,6 +158,7 @@ static int __init buddha_init(void)
>  
>  	while ((z = zorro_find_device(ZORRO_WILDCARD, z))) {
>  		unsigned long board;
> +		hw_regs_t hw[3], *hws[] = { NULL, NULL, NULL, NULL };
			     ^
max(BUDDHA_NUM_HWIFS, CATWEASEL_NUM_HWIFS, XSURF_NUM_HWIFS)

				  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Another magic constant, hws[] always has 4 elements?

> --- a/drivers/ide/legacy/gayle.c
> +++ b/drivers/ide/legacy/gayle.c
> @@ -125,6 +125,7 @@ static void __init gayle_setup_ports(hw_
>  static int __init gayle_init(void)
>  {
>      int a4000, i;
> +    hw_regs_t hw[2], *hws[] = { NULL, NULL, NULL, NULL };
		    ^
		    GAYLE_NUM_HWIFS

> Index: b/drivers/ide/legacy/q40ide.c
> ===================================================================
> --- a/drivers/ide/legacy/q40ide.c
> +++ b/drivers/ide/legacy/q40ide.c
> @@ -112,7 +112,7 @@ static int __init q40ide_init(void)
>  {
>      int i;
>      ide_hwif_t *hwif;
> -    const char *name;
> +    hw_regs_t hw[2], *hws[] = { NULL, NULL, NULL, NULL };
		    ^
		    Q40IDE_NUM_HWIFS

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
