Return-Path: <linux-kernel-owner+w=401wt.eu-S1757245AbYGXPdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbYGXPdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 11:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbYGXPdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 11:33:36 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:56224 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbYGXPdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 11:33:35 -0400
Date: Fri, 25 Jul 2008 00:35:26 +0900 (JST)
Message-Id: <20080725.003526.39154055.anemo@mba.ocn.ne.jp>
To: geert@linux-m68k.org, ralf@linux-mips.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 29/29] initrd: Fix virtual/physical mix-up in overwrite
 test
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20080717191758.556975996@mail.of.borg>
References: <20080717191607.955742542@mail.of.borg>
	<20080717191758.556975996@mail.of.borg>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008 21:16:36 +0200, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>  	if (initrd_start && !initrd_below_start_ok &&
> -			initrd_start < min_low_pfn << PAGE_SHIFT) {
> +	    page_to_pfn(virt_to_page(initrd_start)) < min_low_pfn) {
>  		printk(KERN_CRIT "initrd overwritten (0x%08lx < 0x%08lx) - "
> -		    "disabling it.\n",initrd_start,min_low_pfn << PAGE_SHIFT);
> +		    "disabling it.\n",
> +		    page_to_pfn(virt_to_page(initrd_start)), min_low_pfn);
>  		initrd_start = 0;
>  	}

This patch causes warnings on mips:

linux/init/main.c: In function 'start_kernel':
linux/init/main.c:633: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast
linux/init/main.c:636: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast

Because an argument of mips virt_to_phys() is an pointer and
initrd_start is unsigned long.  It seems most (all?) arch's
virt_to_phys() casts its argument to unsigned long internally.  Should
mips follow?

---
Atsushi Nemoto
