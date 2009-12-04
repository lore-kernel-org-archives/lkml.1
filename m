Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbZLDK7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbZLDK7F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 05:59:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755164AbZLDK7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 05:59:04 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36900 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965AbZLDK7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 05:59:03 -0500
Date: Fri, 4 Dec 2009 11:59:08 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Amit Kucheria <amit.kucheria@canonical.com>
Cc: Herring Robert-RA7055 <ra7055@freescale.com>,
       List Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.infradead.org, valentin.longchamp@epfl.ch,
       daniel@caiaq.de, grant.likely@secretlab.ca,
       Nguyen Dinh-R00091 <R00091@freescale.com>
Subject: Re: [RFC][PATCH 03/10] arm: mxc: changes to common plat-mxc code
	to add support for i.MX5
Message-ID: <20091204105908.GJ15126@pengutronix.de>
References: <cover.1259893118.git.amit.kucheria@canonical.com> <58eb7d14c6cf56cbc874657dff5789c47116b49e.1259893118.git.amit.kucheria@canonical.com> <DE2504B3A515524BBE6934369EFDC0DA08C2A56C@az33exm20.fsl.freescale.net> <20091204083451.GG15126@pengutronix.de> <20091204103102.GC3747@matterhorn.verdurent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091204103102.GC3747@matterhorn.verdurent.com>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 11:48:12 up 52 days, 23:37, 59 users,  load average: 1.87, 1.64,
	1.62
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 12:31:02PM +0200, Amit Kucheria wrote:
> Some comments below:
> 
> On 09 Dec 04, Sascha Hauer wrote:
> > On Thu, Dec 03, 2009 at 08:12:58PM -0700, Herring Robert-RA7055 wrote:
> > > Amit,
> > > 
> > > I would suggest you refactor the timer code into version 1 and version 2
> > > either as 2 separate files or with a timer_is_v2() function rather than
> > > the mess of cpu_is_X macros it currently has. Essentially there are 2
> > > versions of the timer hardware. Version 1 is found on MX1/MXL and MX21.
> > > Version 2 is found on MX25, MX27, MX31, MX35, MX37, MX51, and future
> > > parts. I will send you what we have done in our tree.
> > Like this:
> > 
> > 
> > commit ed6bbc59e3f6b33b48a0d5ac053220cd318ceee7
> > Author: Sascha Hauer <s.hauer@pengutronix.de>
> > Date:   Tue Nov 17 16:31:13 2009 +0100
> > 
> >     mxc timer: Add mx51 support
> >     
> >     Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > 
> > diff --git a/arch/arm/plat-mxc/time.c b/arch/arm/plat-mxc/time.c
> > index 844567e..0c45509 100644
> > --- a/arch/arm/plat-mxc/time.c
> > +++ b/arch/arm/plat-mxc/time.c
> > @@ -57,6 +57,9 @@
> >  #define MX3_TCN			0x24
> >  #define MX3_TCMP		0x10
> >  
> > +#define timer_is_v1()	(cpu_is_mx1() || cpu_is_mx27())
>                                                         ^^^^
>                                       Shouldn't this be mx21 according to
> 				      Rob's comment?

i.MX1, i.MX21 and i.MX27 are identical, at least that's what the code
shows, so it should be:

#define timer_is_v1()      (cpu_is_mx1() || cpu_is_mx21() || cpu_is_mx27())
#define timer_is_v2()      (cpu_is_mx3() || cpu_is_mx25() || cpu_is_mx51() || cpu_is_mxc91231())

One difference between i.MX1 and i.MX21/27 is:

static void gpt_irq_acknowledge(void)
{
	if (timer_is_v1()) {
		if (cpu_is_mx1())
			__raw_writel(0, timer_base + MX1_2_TSTAT);
		else
			__raw_writel(MX2_TSTAT_CAPT | MX2_TSTAT_COMP,
				timer_base + MX1_2_TSTAT);
	}

	if (timer_is_v2())
		__raw_writel(MX3_TSTAT_OF1, timer_base + MX3_TSTAT);
}

I'll test the code before applying it to be sure, I can test on all
CPUs except i.MX21 and the 91231.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
