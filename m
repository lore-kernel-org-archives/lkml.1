Return-Path: <linux-kernel-owner+w=401wt.eu-S1753926AbZLDJgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbZLDJgB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 04:36:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbZLDJgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 04:36:00 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38307 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbZLDJf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 04:35:59 -0500
Date: Fri, 4 Dec 2009 10:36:04 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Amit Kucheria <amit.kucheria@canonical.com>
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>,
       Dinh.Nguyen@freescale.com, s.hauer@pengutronix.de,
       grant.likely@secretlab.ca, r.herring@freescale.com,
       linux-arm-kernel@lists.infradead.org, daniel@caiaq.de,
       valentin.longchamp@epfl.ch
Subject: Re: [RFC][PATCH 01/10] arm: mxc: New interrupt controller (TZIC)
	for i.MX5 family
Message-ID: <20091204093604.GA10910@pengutronix.de>
References: <cover.1259893118.git.amit.kucheria@canonical.com> <e99e70e2a619693064130a747b6ee3a93273337b.1259893118.git.amit.kucheria@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e99e70e2a619693064130a747b6ee3a93273337b.1259893118.git.amit.kucheria@canonical.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Dec 04, 2009 at 04:47:01AM +0200, Amit Kucheria wrote:
> Freescale i.MX51 processor uses a different interrupt controller. Add the
> driver and fix the Makefile to account for it.
> 
> Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
> ---
>  arch/arm/plat-mxc/Kconfig  |    4 +
>  arch/arm/plat-mxc/Makefile |    9 ++-
>  arch/arm/plat-mxc/tzic.c   |  180 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 192 insertions(+), 1 deletions(-)
>  create mode 100644 arch/arm/plat-mxc/tzic.c
> 
> diff --git a/arch/arm/plat-mxc/Kconfig b/arch/arm/plat-mxc/Kconfig
> index ca5c7c2..11bf691 100644
> --- a/arch/arm/plat-mxc/Kconfig
> +++ b/arch/arm/plat-mxc/Kconfig
> @@ -75,4 +75,8 @@ config ARCH_HAS_RNGA
>  
>  config ARCH_MXC_IOMUX_V3
>  	bool
> +
> +config MXC_TZIC
> +	bool
> +	depends on ARCH_MXC
>  endif
The whole file arch/arm/plat-mxc/Kconfig is a big 

	if ARCH_MXC
	...
	endif

so there is no need for "depends on ARCH_MXC"

> diff --git a/arch/arm/plat-mxc/Makefile b/arch/arm/plat-mxc/Makefile
> index e3212c8..5be53ca 100644
> --- a/arch/arm/plat-mxc/Makefile
> +++ b/arch/arm/plat-mxc/Makefile
> @@ -3,7 +3,14 @@
>  #
>  
>  # Common support
> -obj-y := irq.o clock.o gpio.o time.o devices.o cpu.o system.o
> +obj-y := clock.o gpio.o time.o devices.o cpu.o system.o
> +
> +# MX51 uses the TZIC interrupt controller, older platforms use AVIC
> +ifeq ($(CONFIG_MXC_TZIC),y)
> +obj-y += tzic.o
> +else
> +obj-y += irq.o
> +endif
We're not there yet, but in the future we want to build kernel images
that run on (say) imx51 and imx27.  In such a kernel we'd need irq.o
*and* tzic.o.  So don't kick out irq.o when CONFIG_MXC_TZIC but make
that dependant on the other SOCs.

> diff --git a/arch/arm/plat-mxc/tzic.c b/arch/arm/plat-mxc/tzic.c
> new file mode 100644
> index 0000000..3af8fc6
> --- /dev/null
> +++ b/arch/arm/plat-mxc/tzic.c
> [...]
> +static void mxc_mask_irq(unsigned int irq)
please add a namespace for these functions.  There is already a function
mxc_mask_irq.  Giving the same name twice is possible but makes the code
harder to understand.

> [...]
> + * @param is_idle		1 if called in idle loop (enset registers);
s/enset/unset/ ?

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
