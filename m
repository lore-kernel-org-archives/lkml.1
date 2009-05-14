Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487AbZENS7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbZENS7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 14:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbZENS7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 14:59:14 -0400
Received: from h155.mvista.com ([63.81.120.155]:11202 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750944AbZENS7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 14:59:14 -0400
Message-ID: <4A0C6A27.7010703@ru.mvista.com>
Date: Thu, 14 May 2009 22:59:51 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] ide: pass number of ports to ide_host_{alloc,add}()
References: <20090513205139.28638.87226.sendpatchset@localhost.localdomain> <20090513205222.28638.19386.sendpatchset@localhost.localdomain>
In-Reply-To: <20090513205222.28638.19386.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Pass number of ports to ide_host_{alloc,add}() and then update
> all users accordingly.

> There should be no functional changes caused by this patch.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

> Index: b/drivers/ide/buddha.c
> ===================================================================
> --- a/drivers/ide/buddha.c
> +++ b/drivers/ide/buddha.c
> @@ -160,7 +160,7 @@ static int __init buddha_init(void)
>  
>  	while ((z = zorro_find_device(ZORRO_WILDCARD, z))) {
>  		unsigned long board;
> -		hw_regs_t hw[MAX_NUM_HWIFS], *hws[] = { NULL, NULL, NULL, NULL };
> +		hw_regs_t hw[MAX_NUM_HWIFS], *hws[] = { NULL, NULL, NULL };

    I think it makes sense to just drop the NULL initializers here...

>  
>  		if (z->id == ZORRO_PROD_INDIVIDUAL_COMPUTERS_BUDDHA) {
>  			buddha_num_hwifs = BUDDHA_NUM_HWIFS;
> @@ -224,7 +224,7 @@ fail_base2:
>  			hws[i] = &hw[i];
>  		}
>  
> -		ide_host_add(&buddha_port_info, hws, NULL);
> +		ide_host_add(&buddha_port_info, hws, i, NULL);

    ... since ide_host_add() won't look beyond hws[i - 1] anyway.

>  	}
>  
>  	return 0;
> Index: b/drivers/ide/cmd640.c
> ===================================================================
> --- a/drivers/ide/cmd640.c
> +++ b/drivers/ide/cmd640.c
> @@ -708,7 +708,7 @@ static int __init cmd640x_init(void)
>  	int second_port_cmd640 = 0, rc;
>  	const char *bus_type, *port2;
>  	u8 b, cfr;
> -	hw_regs_t hw[2], *hws[] = { NULL, NULL, NULL, NULL };
> +	hw_regs_t hw[2], *hws[] = { NULL, NULL };

    Same here...

> Index: b/drivers/ide/gayle.c
> ===================================================================
> --- a/drivers/ide/gayle.c
> +++ b/drivers/ide/gayle.c
> @@ -125,7 +125,7 @@ static int __init gayle_init(void)
>      unsigned long base, ctrlport, irqport;
>      ide_ack_intr_t *ack_intr;
>      int a4000, i, rc;
> -    hw_regs_t hw[GAYLE_NUM_HWIFS], *hws[] = { NULL, NULL, NULL, NULL };
> +    hw_regs_t hw[GAYLE_NUM_HWIFS], *hws[] = { NULL, NULL };

    ... and here.

> Index: b/drivers/ide/icside.c
> ===================================================================
> --- a/drivers/ide/icside.c
> +++ b/drivers/ide/icside.c
[...]
> @@ -467,7 +467,7 @@ icside_register_v6(struct icside_state *
>  	struct ide_host *host;
>  	unsigned int sel = 0;
>  	int ret;
> -	hw_regs_t hw[2], *hws[] = { &hw[0], NULL, NULL, NULL };
> +	hw_regs_t hw[2], *hws[] = { &hw[0], NULL };

    I wonder if there's an old bug here since I'm not seeing when hws[1] is 
set to non-NULL -- despite there are apparently two ports?

    Indeed, this bug seems to date back to the 'struct ide_host' 
introduction, see this:
 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=48c3c1072651922ed153bcf0a33ea82cf20df390#patch1...

MBR, Sergei
