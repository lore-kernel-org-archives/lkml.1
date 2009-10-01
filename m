Return-Path: <linux-kernel-owner+w=401wt.eu-S932220AbZJAIfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220AbZJAIfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932224AbZJAIfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:35:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38218 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932234AbZJAIfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:35:33 -0400
Date: Thu, 1 Oct 2009 10:34:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Len Brown <lenb@kernel.org>,
       Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [origin tree boot hang] [PATCH] Revert "early_printk:
	Allowmorethan one early console"
Message-ID: <20091001083447.GC12200@elte.hu>
References: <20090923135539.GA6542@kroah.com> <20090923173709.GA18056@elte.hu> <4ABA6182.1000106@windriver.com> <20090923190239.GC24251@elte.hu> <20090923191756.GA25163@elte.hu> <20090923210555.GA13492@elte.hu> <4ABA90C6.3000600@windriver.com> <20090924122249.GA8425@cmpxchg.org> <4ABB7D5E.6000301@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ABB7D5E.6000301@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jason Wessel <jason.wessel@windriver.com> wrote:

> >From 047b893e33041dbaf17b2a7eb03ea20486344d6f Mon Sep 17 00:00:00 2001
> From: Jason Wessel <jason.wessel@windriver.com>
> Date: Thu, 24 Sep 2009 09:00:01 -0500
> Subject: [PATCH 1/1] x86,earlyprintk: Fix regression to handle serial,ttySn as 1 arg
> 
> Commit c9530948bc626c8b638015c0b32abb9615659ec6 introduced a
> regression in the parsing of the earlyprintk= kernel arguments.
> 
> If you specify "earlyprintk=serial,ttyS0,115200" as a kernel argument,
> the "serial,ttyS" should be parsed as a single argument and not as
> "serial" and then "ttyS".
> 
> Also update the documentation to reflect you can specify the ttyS
> directly without the "serial" argument.
> 
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> ---
>  Documentation/kernel-parameters.txt |    1 +
>  arch/x86/kernel/early_printk.c      |    5 ++++-
>  2 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 6fa7292..9107b38 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -671,6 +671,7 @@ and is between 256 and 4096 characters. It is defined in the file
>  	earlyprintk=	[X86,SH,BLACKFIN]
>  			earlyprintk=vga
>  			earlyprintk=serial[,ttySn[,baudrate]]
> +			earlyprintk=ttySn[,baudrate]
>  			earlyprintk=dbgp[debugController#]
>  
>  			Append ",keep" to not disable it when the real console
> diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
> index 2acfd3f..b7bfdd5 100644
> --- a/arch/x86/kernel/early_printk.c
> +++ b/arch/x86/kernel/early_printk.c
> @@ -201,8 +201,11 @@ static int __init setup_early_printk(char *buf)
>  
>  	while (*buf != '\0') {
>  		if (!strncmp(buf, "serial", 6)) {
> -			early_serial_init(buf + 6);
> +			buf += 6;
> +			early_serial_init(buf);
>  			early_console_register(&early_serial_console, keep);
> +			if (!strncmp(buf, ",ttyS", 5))
> +			    buf += 5;
>  		}

Looks good, beyond the tab-as-four-spaces ugliness which i fixed.

( and the 5/6 literals look a bit ugly too but are obvious and i dont 
  see a cleaner way to write them. )

Thanks,

	Ingo
