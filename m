Return-Path: <linux-kernel-owner+w=401wt.eu-S1751464AbZLZGAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464AbZLZGAi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 01:00:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750766AbZLZGAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 01:00:37 -0500
Received: from outbound-mail-144.bluehost.com ([67.222.38.34]:43289 "HELO
	outbound-mail-144.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750717AbZLZGAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 01:00:36 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=k1SO773KXC1x+CqdSsciaiFm9rgcPQ8iifexImPZE1i972iIAFHPNxja+YIHi7XGupBOVrzrMctkYaeicns5bUphBVLuRzQnRTgVtEyR+y2ao9T6qFF6I18eyhIZ4+1c;
Date: Fri, 25 Dec 2009 22:00:31 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: Re: Linux 2.6.33-rc2 - Merry Christmas ...
Message-ID: <20091225220031.5b06fc49@jbarnes-x200>
In-Reply-To: <20091225215032.GA32581@liondog.tnic>
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>
	<20091225200017.GA4095@liondog.tnic>
	<20091225215032.GA32581@liondog.tnic>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; i586-moblin-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.217.190.127 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Dec 2009 22:50:32 +0100
Borislav Petkov <petkovbb@googlemail.com> wrote:

> On Fri, Dec 25, 2009 at 09:00:17PM +0100, Borislav Petkov wrote:
> > Hi,
> > 
> > the r8169 driver fails loading here with the following message:
> > 
> > [    0.353955] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
> > [    0.354258] r8169 0000:02:00.0: PCI INT A -> GSI 17 (level, low)
> > -> IRQ 17 [    0.354391] r8169 0000:02:00.0: PCI INT A disabled
> > [    0.354527] r8169: probe of 0000:02:00.0 failed with error -22
> > 
> > Machine is Acer Aspire One, Atom N270 CPU.
> > 
> > Actually, the breakage seems to have appeared a bit earlier,
> > sometime between .32 and .33-rc1 as the bisection result shows:
> > 
> > ac1aa47b131416a6ff37eb1005a0a1d2541aad6c is the first bad commit
> > commit ac1aa47b131416a6ff37eb1005a0a1d2541aad6c
> > Author: Jesse Barnes <jbarnes@virtuousgeek.org>
> > Date:   Mon Oct 26 13:20:44 2009 -0700
> > 
> >     PCI: determine CLS more intelligently
> >     
> >     Till now, CLS has been determined either by arch code or as
> >     L1_CACHE_BYTES.  Only x86 and ia64 set CLS explicitly and x86
> > doesn't always get it right.  On most configurations, the chance is
> > that firmware configures the correct value during boot.
> >     
> >     This patch makes pci_init() determine CLS by looking at what
> > firmware has configured.  It scans all devices and if all non-zero
> > values agree, the value is used.  If none is configured or there is
> > a disagreement, pci_dfl_cache_line_size is used.  arch can set the
> > dfl value (via PCI_CACHE_LINE_BYTES or pci_dfl_cache_line_size) or
> >     override the actual one.
> >     
> >     ia64, x86 and sparc64 updated to set the default cls instead of
> > the actual one.
> >     
> >     While at it, declare pci_cache_line_size and
> > pci_dfl_cache_line_size in pci.h and drop private declarations from
> > arch code.
> 
> Ok here's what happens: 
> 
> pci_apply_final_quirks() dumps on the console
> 
> [    0.369252] PCI: CLS 0 bytes, default 64
> 
> which means that it hasn't fallen back to setting the default cache
> line size. Also, the call
> 
> pci_read_config_byte(dev, PCI_CACHE_LINE_SIZE, &tmp);
> 
> sets tmp = 0 and the following condition hits everytime
> 
> if (!cls)
>          cls = tmp;
> if (!tmp || cls == tmp)
>          continue;
> 
> Which means that we never get around the set the default CLS.
> 
> The following dirty fix solves the issue on my machine:
> 
> --
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 7cfa7c3..9854c26 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -2629,7 +2629,10 @@ static int __init pci_apply_final_quirks(void)
>  	if (!pci_cache_line_size) {
>  		printk(KERN_DEBUG "PCI: CLS %u bytes, default %u\n",
>  		       cls << 2, pci_dfl_cache_line_size << 2);
> -		pci_cache_line_size = cls;
> +		if (!cls)
> +			pci_cache_line_size =
> pci_dfl_cache_line_size;
> +		else
> +			pci_cache_line_size = cls;
>  	}

There should be a fix queued in my for-linus branch (I've been out this
week so haven't sent the pull req yet), can you give it a try and make
sure?

Jesse
