Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520Ab0AHSWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab0AHSWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 13:22:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354Ab0AHSWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 13:22:33 -0500
Received: from isilmar.linta.de ([213.133.102.198]:36092 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753123Ab0AHSWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 13:22:32 -0500
Date: Fri, 8 Jan 2010 18:54:23 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Michal Marek <mmarek@suse.cz>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-kbuild@vger.kernel.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Valdis.Kletnieks@vt.edu
Subject: Re: linux-next: Tree for January 7 (pcmcia)
Message-ID: <20100108175423.GA29713@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Randy Dunlap <rdunlap@xenotime.net>, Michal Marek <mmarek@suse.cz>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-kbuild@vger.kernel.org, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, Valdis.Kletnieks@vt.edu
References: <20100107172134.af71c742.sfr@canb.auug.org.au>
 <20100107101006.e59989a8.rdunlap@xenotime.net>
 <20100107205728.GA19115@isilmar.linta.de>
 <20100107210744.GA10320@sepie.suse.cz>
 <20100107135557.989c9585.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100107135557.989c9585.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Thu, Jan 07, 2010 at 01:55:57PM -0800, Randy Dunlap wrote:
> > On Thu, Jan 07, 2010 at 09:57:28PM +0100, Dominik Brodowski wrote:
> > > Hey,
> > > 
> > > On Thu, Jan 07, 2010 at 10:10:06AM -0800, Randy Dunlap wrote:
> > > > > Hi all,
> > > > > 
> > > > > Changes since 20100106:
> > > > 
> > > > 
> > > > drivers/built-in.o: In function `yenta_probe':
> > > > yenta_socket.c:(.devinit.text+0x1e582): undefined reference to `pccard_nonstatic_ops'
> > > > 
> > > > CONFIG_PCCARD=y
> > > > CONFIG_PCMCIA=m
> > > > CONFIG_PCCARD_NONSTATIC=m
> > > > CONFIG_YENTA=y
> > > > 
> > > > so yenta code (built-in) tries to reference data that lives in a
> > > > loadable module.
> > > 
> > > Uh, that was I. If kconfig can't be fixed easily, I'll revert the change
> > 
> > Hi Randy, Dominik,
> > 
> > Please try this one-liner. The problem is that 'if X' and 'if X!=n' are not
> > the same in ternary logic.
> > 
> > Michal
> > 
> > From e7b12e70272484da2161c0b6c459f2eff2a989a8 Mon Sep 17 00:00:00 2001
> > From: Michal Marek <mmarek@suse.cz>
> > Date: Thu, 7 Jan 2010 21:03:11 +0100
> > Subject: [PATCH] pcmcia: fix yenta dependency on PCCARD_NONSTATIC
> > 
> > With CONFIG_PCMCIA=m and CONFIG_YENTA=y, we get
> > 
> > drivers/built-in.o: In function `yenta_probe':
> > yenta_socket.c:(.devinit.text+0x1e582): undefined reference to
> > `pccard_nonstatic_ops'
> > 
> > This is because
> > 
> > select PCCARD_NONSTATIC if PCMCIA
> > 
> > sets PCCARD_NONSTATIC = min(YENTA, PCMCIA). Change it to 'if PCMCIA!=n'
> > to remove the upper limit.
> > 
> > Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> > Signed-off-by: Michal Marek <mmarek@suse.cz>
> 
> Acked-by: Randy Dunlap <rdunlap@xenotime.net>
> 
> Thanks.

Thanks for the patch. I extended it a bit further:

>From 77f9eb4599f1d0f5a43cadece9809018b534e308 Mon Sep 17 00:00:00 2001
From: Michal Marek <mmarek@suse.cz>
Date: Thu, 7 Jan 2010 21:03:11 +0100
Subject: [PATCH] pcmcia: fix yenta dependency on PCCARD_NONSTATIC

With CONFIG_PCMCIA=m and CONFIG_YENTA=y, we get

drivers/built-in.o: In function `yenta_probe':
yenta_socket.c:(.devinit.text+0x1e582): undefined reference to
`pccard_nonstatic_ops'

This is because

select PCCARD_NONSTATIC if PCMCIA

sets PCCARD_NONSTATIC = min(YENTA, PCMCIA). Change it to 'if PCMCIA!=n'
to remove the upper limit.

[linux@dominikbrodowski.net: propagate change to PCMICA_M8XX]
Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Michal Marek <mmarek@suse.cz>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>

diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
index efc51b9..e8f35da 100644
--- a/drivers/pcmcia/Kconfig
+++ b/drivers/pcmcia/Kconfig
@@ -84,7 +84,7 @@ config YENTA
 	tristate "CardBus yenta-compatible bridge support"
 	depends on PCI
 	select CARDBUS if !EMBEDDED
-	select PCCARD_NONSTATIC if PCMCIA
+	select PCCARD_NONSTATIC if PCMCIA != n
 	---help---
 	  This option enables support for CardBus host bridges.  Virtually
 	  all modern PCMCIA bridges are CardBus compatible.  A "bridge" is
@@ -161,8 +161,8 @@ config TCIC
 
 config PCMCIA_M8XX
 	tristate "MPC8xx PCMCIA support"
-	depends on PCMCIA && PPC && 8xx
-	select PCCARD_IODYN if PCMCIA
+	depends on PCCARD && PPC && 8xx
+	select PCCARD_IODYN if PCMCIA != n
 	help
 	  Say Y here to include support for PowerPC 8xx series PCMCIA
 	  controller.
