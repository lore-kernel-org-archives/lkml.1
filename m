Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993Ab0AGVHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab0AGVHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 16:07:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229Ab0AGVHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 16:07:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56289 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab0AGVHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 16:07:47 -0500
Date: Thu, 7 Jan 2010 22:07:44 +0100
From: Michal Marek <mmarek@suse.cz>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kbuild@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Valdis.Kletnieks@vt.edu
Subject: Re: linux-next: Tree for January 7 (pcmcia)
Message-ID: <20100107210744.GA10320@sepie.suse.cz>
References: <20100107172134.af71c742.sfr@canb.auug.org.au>
 <20100107101006.e59989a8.rdunlap@xenotime.net>
 <20100107205728.GA19115@isilmar.linta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100107205728.GA19115@isilmar.linta.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 09:57:28PM +0100, Dominik Brodowski wrote:
> Hey,
> 
> On Thu, Jan 07, 2010 at 10:10:06AM -0800, Randy Dunlap wrote:
> > > Hi all,
> > > 
> > > Changes since 20100106:
> > 
> > 
> > drivers/built-in.o: In function `yenta_probe':
> > yenta_socket.c:(.devinit.text+0x1e582): undefined reference to `pccard_nonstatic_ops'
> > 
> > CONFIG_PCCARD=y
> > CONFIG_PCMCIA=m
> > CONFIG_PCCARD_NONSTATIC=m
> > CONFIG_YENTA=y
> > 
> > so yenta code (built-in) tries to reference data that lives in a
> > loadable module.
> 
> Uh, that was I. If kconfig can't be fixed easily, I'll revert the change

Hi Randy, Dominik,

Please try this one-liner. The problem is that 'if X' and 'if X!=n' are not
the same in ternary logic.

Michal

>From e7b12e70272484da2161c0b6c459f2eff2a989a8 Mon Sep 17 00:00:00 2001
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

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 drivers/pcmcia/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
index 5cea8ba..e196a19 100644
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
-- 
1.6.5.3

