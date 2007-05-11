Return-Path: <linux-kernel-owner+w=401wt.eu-S1759955AbXEKBsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759955AbXEKBsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 21:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756862AbXEKBsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 21:48:07 -0400
Received: from gate.crashing.org ([63.228.1.57]:33864 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756840AbXEKBsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 21:48:06 -0400
Date: Thu, 10 May 2007 20:47:05 -0500 (CDT)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@gate.crashing.org
To: Simon Horman <horms@verge.net.au>
cc: Timur Tabi <timur@freescale.com>,
       Kim Phillips <kim.phillips@freescale.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org,
       Ismail =?iso-8859-1?Q?D=F6nmez?= <ismail@pardus.org.tr>,
       Michael Schmitz <schmitz@debian.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: Kconfig warnings on latest GIT
In-Reply-To: <20070511012529.GC10715@verge.net.au>
Message-ID: <Pine.LNX.4.64.0705102046400.10555@gate.crashing.org>
References: <200705080004.14570.ismail@pardus.org.tr>
 <20070508143127.38fafa3c.kim.phillips@freescale.com> <4640D988.1040504@freescale.com>
 <20070510051042.GA16812@verge.net.au> <46434ED0.6030808@freescale.com>
 <20070511012529.GC10715@verge.net.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007, Simon Horman wrote:

> On Thu, May 10, 2007 at 11:56:48AM -0500, Timur Tabi wrote:
> > Simon Horman wrote:
> >
> > >>So my question is: in which Kconfig do I define "UCC_FAST_TEMP" and
> > >>"UCC_SLOW_TEMP"?  At first I thought, just put it in drivers/Kconfig, but
> > >>that Kconfig does nothing but including other Kconfigs.  I believe that if I
> > >>submit a patch that adds "UCC_FAST_TEMP" and "UCC_SLOW_TEMP" to
> > >>drivers/Kconfig, it will be rejected.  Either that, or I'll spend six weeks
> > >>trying to persuade everyone that it's a good idea.
> > >>
> > >>Does anyone have any suggestions on how I can fix this?
> > >That does seem like a reasonable suggestion, and one that
> > >would probably work well with the other similar problems
> > >that have been introduced sice 2.6.21.
> >
> > Looks like the fix is simpler than I thought.  Instead of having
> >
> > UCC_GETH
> > 	select UCC_FAST
> >
> > I need to do
> >
> > UCC_FAST
> > 	default y if UCC_GETH
>
> I pondered something like that, but I couldn't get it quite right :(
>
> > I'll have a patch that fixes this out later today.
> >
> > I chose the first method because I wanted each individual UCC device
> > driver to select UCC_FAST or UCC_SLOW as appropriate, so that I
> > wouldn't have to update arch/powerpc/sysdev/qe_lib/Kconfig every time
> > we add a new UCC driver.  Oh well.
>
> --
> Horms
>   H: http://www.vergenet.net/~horms/
>   W: http://www.valinux.co.jp/en/
>

Try this patch:

diff --git a/arch/powerpc/sysdev/qe_lib/Kconfig b/arch/powerpc/sysdev/qe_lib/Kconfig
index 887739f..5de7aba 100644
--- a/arch/powerpc/sysdev/qe_lib/Kconfig
+++ b/arch/powerpc/sysdev/qe_lib/Kconfig
@@ -12,6 +12,7 @@ config UCC_SLOW

 config UCC_FAST
 	bool
+	default y if UCC_GETH
 	default n
 	select UCC
 	help
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index fa489b1..b159c6c 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -2276,7 +2276,6 @@ config GFAR_NAPI
 config UCC_GETH
 	tristate "Freescale QE Gigabit Ethernet"
 	depends on QUICC_ENGINE
-	select UCC_FAST
 	help
 	  This driver supports the Gigabit Ethernet mode of the QUICC Engine,
 	  which is available on some Freescale SOCs.
