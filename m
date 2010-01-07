Return-Path: <linux-kernel-owner+w=401wt.eu-S1754208Ab0AGV4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab0AGV4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 16:56:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153Ab0AGV4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 16:56:04 -0500
Received: from xenotime.net ([72.52.64.118]:46018 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753756Ab0AGV4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 16:56:00 -0500
Date: Thu, 7 Jan 2010 13:55:57 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Michal Marek <mmarek@suse.cz>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kbuild@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Valdis.Kletnieks@vt.edu
Subject: Re: linux-next: Tree for January 7 (pcmcia)
Message-Id: <20100107135557.989c9585.rdunlap@xenotime.net>
In-Reply-To: <20100107210744.GA10320@sepie.suse.cz>
References: <20100107172134.af71c742.sfr@canb.auug.org.au>
	<20100107101006.e59989a8.rdunlap@xenotime.net>
	<20100107205728.GA19115@isilmar.linta.de>
	<20100107210744.GA10320@sepie.suse.cz>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010 22:07:44 +0100 Michal Marek wrote:

> On Thu, Jan 07, 2010 at 09:57:28PM +0100, Dominik Brodowski wrote:
> > Hey,
> > 
> > On Thu, Jan 07, 2010 at 10:10:06AM -0800, Randy Dunlap wrote:
> > > > Hi all,
> > > > 
> > > > Changes since 20100106:
> > > 
> > > 
> > > drivers/built-in.o: In function `yenta_probe':
> > > yenta_socket.c:(.devinit.text+0x1e582): undefined reference to `pccard_nonstatic_ops'
> > > 
> > > CONFIG_PCCARD=y
> > > CONFIG_PCMCIA=m
> > > CONFIG_PCCARD_NONSTATIC=m
> > > CONFIG_YENTA=y
> > > 
> > > so yenta code (built-in) tries to reference data that lives in a
> > > loadable module.
> > 
> > Uh, that was I. If kconfig can't be fixed easily, I'll revert the change
> 
> Hi Randy, Dominik,
> 
> Please try this one-liner. The problem is that 'if X' and 'if X!=n' are not
> the same in ternary logic.
> 
> Michal
> 
> From e7b12e70272484da2161c0b6c459f2eff2a989a8 Mon Sep 17 00:00:00 2001
> From: Michal Marek <mmarek@suse.cz>
> Date: Thu, 7 Jan 2010 21:03:11 +0100
> Subject: [PATCH] pcmcia: fix yenta dependency on PCCARD_NONSTATIC
> 
> With CONFIG_PCMCIA=m and CONFIG_YENTA=y, we get
> 
> drivers/built-in.o: In function `yenta_probe':
> yenta_socket.c:(.devinit.text+0x1e582): undefined reference to
> `pccard_nonstatic_ops'
> 
> This is because
> 
> select PCCARD_NONSTATIC if PCMCIA
> 
> sets PCCARD_NONSTATIC = min(YENTA, PCMCIA). Change it to 'if PCMCIA!=n'
> to remove the upper limit.
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Michal Marek <mmarek@suse.cz>

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  drivers/pcmcia/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
> index 5cea8ba..e196a19 100644
> --- a/drivers/pcmcia/Kconfig
> +++ b/drivers/pcmcia/Kconfig
> @@ -84,7 +84,7 @@ config YENTA
>  	tristate "CardBus yenta-compatible bridge support"
>  	depends on PCI
>  	select CARDBUS if !EMBEDDED
> -	select PCCARD_NONSTATIC if PCMCIA
> +	select PCCARD_NONSTATIC if PCMCIA != n
>  	---help---
>  	  This option enables support for CardBus host bridges.  Virtually
>  	  all modern PCMCIA bridges are CardBus compatible.  A "bridge" is
> -- 
> 1.6.5.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


---
~Randy
