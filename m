Return-Path: <linux-kernel-owner+w=401wt.eu-S1031131AbXDYUu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031131AbXDYUu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 16:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031133AbXDYUu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 16:50:26 -0400
Received: from rrcs-71-42-183-126.sw.biz.rr.com ([71.42.183.126]:34305 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031131AbXDYUuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 16:50:25 -0400
Subject: Re: [ofa-general] [PATCH 6/6] [RFC]mlx4 build system stuff
From: Steve Wise <swise@opengridcomputing.com>
To: Roland Dreier <rolandd@cisco.com>
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
In-Reply-To: <20074201532.jhCN1hLvxaAengJm@cisco.com>
References: <20074201532.jhCN1hLvxaAengJm@cisco.com>
Content-Type: text/plain
Date: Wed, 25 Apr 2007 15:50:19 -0500
Message-Id: <1177534219.29222.0.camel@stevo-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-20 at 15:32 -0700, Roland Dreier wrote:
> Hook up mlx4_core and mlx4_ib drivers to Kconfig and Makefiles.
> 
> Signed-off-by: Roland Dreier <rolandd@cisco.com>
> 
> ---
> 
>  infiniband/Kconfig          |    2 ++
>  infiniband/Makefile         |    1 +
>  infiniband/hw/mlx4/Kconfig  |    9 +++++++++
>  infiniband/hw/mlx4/Makefile |    3 +++
>  net/Kconfig                 |   14 ++++++++++++++
>  net/Makefile                |    1 +
>  net/mlx4/Makefile           |    4 ++++
>  7 files changed, 34 insertions(+)
> 
> diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
> index 82afba5..37deaae 100644
> --- a/drivers/infiniband/Kconfig
> +++ b/drivers/infiniband/Kconfig
> @@ -45,6 +45,8 @@ source "drivers/infiniband/hw/ehca/Kconfig"
>  source "drivers/infiniband/hw/amso1100/Kconfig"
>  source "drivers/infiniband/hw/cxgb3/Kconfig"
>  
> +source "drivers/infiniband/hw/mlx4/Kconfig"
> +
>  source "drivers/infiniband/ulp/ipoib/Kconfig"
>  
>  source "drivers/infiniband/ulp/srp/Kconfig"
> diff --git a/drivers/infiniband/Makefile b/drivers/infiniband/Makefile
> index da2066c..75f325e 100644
> --- a/drivers/infiniband/Makefile
> +++ b/drivers/infiniband/Makefile
> @@ -4,6 +4,7 @@ obj-$(CONFIG_INFINIBAND_IPATH)		+= hw/ipath/
>  obj-$(CONFIG_INFINIBAND_EHCA)		+= hw/ehca/
>  obj-$(CONFIG_INFINIBAND_AMSO1100)	+= hw/amso1100/
>  obj-$(CONFIG_INFINIBAND_CXGB3)		+= hw/cxgb3/
> +obj-$(CONFIG_MLX4_INFINIBAND)		+= hw/mlx4/
>  obj-$(CONFIG_INFINIBAND_IPOIB)		+= ulp/ipoib/
>  obj-$(CONFIG_INFINIBAND_SRP)		+= ulp/srp/
>  obj-$(CONFIG_INFINIBAND_ISER)		+= ulp/iser/
> diff --git a/drivers/infiniband/hw/mlx4/Kconfig b/drivers/infiniband/hw/mlx4/Kconfig
> new file mode 100644
> index 0000000..b8912cd
> --- /dev/null
> +++ b/drivers/infiniband/hw/mlx4/Kconfig
> @@ -0,0 +1,9 @@
> +config MLX4_INFINIBAND
> +	tristate "Mellanox ConnectX HCA support"
> +	depends on INFINIBAND
> +	select MLX4_CORE
> +	---help---
> +	  This driver provides low-level InfiniBand support for
> +	  Mellanox ConnectX PCI Express host channel adapters (HCAs).
> +	  This is required to use InfiniBand protocols such as
> +	  IP-over-IB or SRP with these devices.
> diff --git a/drivers/infiniband/hw/mlx4/Makefile b/drivers/infiniband/hw/mlx4/Makefile
> new file mode 100644
> index 0000000..70f09c7
> --- /dev/null
> +++ b/drivers/infiniband/hw/mlx4/Makefile
> @@ -0,0 +1,3 @@
> +obj-$(CONFIG_MLX4_INFINIBAND)	+= mlx4_ib.o
> +
> +mlx4_ib-y :=	ah.o cq.o doorbell.o mad.o main.o mr.o qp.o srq.o
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index c3f9f59..842f020 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -2493,6 +2493,20 @@ config PASEMI_MAC
>  	  This driver supports the on-chip 1/10Gbit Ethernet controller on
>  	  PA Semi's PWRficient line of chips.
>  
> +config MLX4_CORE
> +	tristate
> +	depends on PCI
> +	default n
> +

No help menu for the core module?


> +config MLX4_DEBUG
> +	bool "Verbose debugging output" if (MLX4_CORE && EMBEDDED)
> +	default y
> +	---help---
> +	  This option causes debugging code to be compiled into the
> +	  mlx4_core driver.  The output can be turned on via the
> +	  debug_level module parameter (which can also be set after
> +	  the driver is loaded through sysfs).
> +
>  endmenu
>  
>  source "drivers/net/tokenring/Kconfig"
> diff --git a/drivers/net/Makefile b/drivers/net/Makefile
> index 33af833..1604e1a 100644
> --- a/drivers/net/Makefile
> +++ b/drivers/net/Makefile
> @@ -197,6 +197,7 @@ obj-$(CONFIG_SMC911X) += smc911x.o
>  obj-$(CONFIG_DM9000) += dm9000.o
>  obj-$(CONFIG_FEC_8XX) += fec_8xx/
>  obj-$(CONFIG_PASEMI_MAC) += pasemi_mac.o
> +obj-$(CONFIG_MLX4_CORE) += mlx4/
>  
>  obj-$(CONFIG_MACB) += macb.o
>  
> diff --git a/drivers/net/mlx4/Makefile b/drivers/net/mlx4/Makefile
> new file mode 100644
> index 0000000..4f18889
> --- /dev/null
> +++ b/drivers/net/mlx4/Makefile
> @@ -0,0 +1,4 @@
> +obj-$(CONFIG_MLX4_CORE)		+= mlx4_core.o
> +
> +mlx4_core-y :=	alloc.o cmd.o cq.o eq.o fw.o icm.o intf.o main.o mcg.o mr.o \
> +		pd.o profile.o qp.o reset.o srq.o
> _______________________________________________
> general mailing list
> general@lists.openfabrics.org
> http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general
> 
> To unsubscribe, please visit http://openib.org/mailman/listinfo/openib-general

