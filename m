Return-Path: <linux-kernel-owner+w=401wt.eu-S1761241AbXKBWM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761241AbXKBWM5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 18:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755472AbXKBWMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 18:12:49 -0400
Received: from smtp-105-friday.nerim.net ([62.4.16.105]:51684 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755400AbXKBWMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 18:12:47 -0400
Date: Fri, 2 Nov 2007 23:12:43 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, i2c@lm-sensors.org, linuxppc-dev@ozlabs.org,
       rtc-linux@googlegroups.com
Subject: Re: [2.6 patch] the scheduled I2C RTC driver removal
Message-ID: <20071102231243.61c39d23@hyperion.delvare>
In-Reply-To: <20071031230357.GW7227@stusta.de>
References: <20071031230357.GW7227@stusta.de>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

On Thu, 1 Nov 2007 00:03:58 +0100, Adrian Bunk wrote:
> This patch contains the scheduled removal of legacy I2C RTC drivers with 
> replacement drivers.

I'm adding the rtc list in Cc.

> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
>  Documentation/feature-removal-schedule.txt |    7 
>  arch/powerpc/platforms/83xx/mpc832x_mds.c  |   24 -
>  arch/powerpc/platforms/83xx/mpc834x_mds.c  |   24 -
>  arch/powerpc/platforms/83xx/mpc836x_mds.c  |   24 -
>  arch/ppc/platforms/83xx/mpc834x_sys.c      |   20 -
>  arch/ppc/platforms/85xx/tqm85xx.c          |   21 -
>  arch/ppc/platforms/katana.c                |   21 -
>  drivers/i2c/chips/Kconfig                  |   38 -
>  drivers/i2c/chips/Makefile                 |    3 
>  drivers/i2c/chips/ds1337.c                 |  410 --------------------
>  drivers/i2c/chips/ds1374.c                 |  267 -------------
>  drivers/i2c/chips/m41t00.c                 |  413 ---------------------
>  include/linux/m41t00.h                     |   50 --
>  13 files changed, 1322 deletions(-)

Obviously we're not yet ready to remove the drivers, as some platforms
still use them! The remaining platforms need to be updated to use the
new RTC drivers first. The mapping is as follows:

chip       | old driver | new driver   |
-----------+------------+--------------+
DS1337     | ds1337     | rtc-ds1307   |
DS1339     | ds1337     | rtc-ds1307   |
DS1374     | ds1374     | rtc-ds1374   |
M41T00     | m41t00     | rtc-ds1307   |
M41T81     | m41t00     | rtc-m41t80   |
M41ST85    | m41t00     | rtc-m41t80   |

So, PPC people, please update your platform code to make use of the new
drivers now, and let me know when you're done. As soon as all platforms
are converted, I'll apply Adrian's patch.

Thanks.

> 
> bf858b44b3071082be3aaf71e2d46ddb26415247 
> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> index 6bb9be5..391f2d1 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -275,13 +275,6 @@ Who:  Tejun Heo <htejun@gmail.com>
>  
>  ---------------------------
>  
> -What:	Legacy RTC drivers (under drivers/i2c/chips)
> -When:	November 2007
> -Why:	Obsolete. We have a RTC subsystem with better drivers.
> -Who:	Jean Delvare <khali@linux-fr.org>
> -
> ----------------------------
> -
>  What:	iptables SAME target
>  When:	1.1. 2008
>  Files:	net/ipv4/netfilter/ipt_SAME.c, include/linux/netfilter_ipv4/ipt_SAME.h
> diff --git a/arch/powerpc/platforms/83xx/mpc832x_mds.c b/arch/powerpc/platforms/83xx/mpc832x_mds.c
> index 972fa85..66382df 100644
> --- a/arch/powerpc/platforms/83xx/mpc832x_mds.c
> +++ b/arch/powerpc/platforms/83xx/mpc832x_mds.c
> @@ -145,30 +145,6 @@ static void __init mpc832x_sys_init_IRQ(void)
>  #endif				/* CONFIG_QUICC_ENGINE */
>  }
>  
> -#if defined(CONFIG_I2C_MPC) && defined(CONFIG_SENSORS_DS1374)
> -extern ulong ds1374_get_rtc_time(void);
> -extern int ds1374_set_rtc_time(ulong);
> -
> -static int __init mpc832x_rtc_hookup(void)
> -{
> -	struct timespec tv;
> -
> -	if (!machine_is(mpc832x_mds))
> -		return 0;
> -
> -	ppc_md.get_rtc_time = ds1374_get_rtc_time;
> -	ppc_md.set_rtc_time = ds1374_set_rtc_time;
> -
> -	tv.tv_nsec = 0;
> -	tv.tv_sec = (ppc_md.get_rtc_time) ();
> -	do_settimeofday(&tv);
> -
> -	return 0;
> -}
> -
> -late_initcall(mpc832x_rtc_hookup);
> -#endif
> -
>  /*
>   * Called very early, MMU is off, device-tree isn't unflattened
>   */
> diff --git a/arch/powerpc/platforms/83xx/mpc834x_mds.c b/arch/powerpc/platforms/83xx/mpc834x_mds.c
> index 00aed7c..a81bb3c 100644
> --- a/arch/powerpc/platforms/83xx/mpc834x_mds.c
> +++ b/arch/powerpc/platforms/83xx/mpc834x_mds.c
> @@ -106,30 +106,6 @@ static void __init mpc834x_mds_init_IRQ(void)
>  	ipic_set_default_priority();
>  }
>  
> -#if defined(CONFIG_I2C_MPC) && defined(CONFIG_SENSORS_DS1374)
> -extern ulong ds1374_get_rtc_time(void);
> -extern int ds1374_set_rtc_time(ulong);
> -
> -static int __init mpc834x_rtc_hookup(void)
> -{
> -	struct timespec tv;
> -
> -	if (!machine_is(mpc834x_mds))
> -		return 0;
> -
> -	ppc_md.get_rtc_time = ds1374_get_rtc_time;
> -	ppc_md.set_rtc_time = ds1374_set_rtc_time;
> -
> -	tv.tv_nsec = 0;
> -	tv.tv_sec = (ppc_md.get_rtc_time) ();
> -	do_settimeofday(&tv);
> -
> -	return 0;
> -}
> -
> -late_initcall(mpc834x_rtc_hookup);
> -#endif
> -
>  /*
>   * Called very early, MMU is off, device-tree isn't unflattened
>   */
> diff --git a/arch/powerpc/platforms/83xx/mpc836x_mds.c b/arch/powerpc/platforms/83xx/mpc836x_mds.c
> index 0f3855c..8d87b9c 100644
> --- a/arch/powerpc/platforms/83xx/mpc836x_mds.c
> +++ b/arch/powerpc/platforms/83xx/mpc836x_mds.c
> @@ -152,30 +152,6 @@ static void __init mpc836x_mds_init_IRQ(void)
>  #endif				/* CONFIG_QUICC_ENGINE */
>  }
>  
> -#if defined(CONFIG_I2C_MPC) && defined(CONFIG_SENSORS_DS1374)
> -extern ulong ds1374_get_rtc_time(void);
> -extern int ds1374_set_rtc_time(ulong);
> -
> -static int __init mpc8360_rtc_hookup(void)
> -{
> -	struct timespec tv;
> -
> -	if (!machine_is(mpc836x_mds))
> -		return 0;
> -
> -	ppc_md.get_rtc_time = ds1374_get_rtc_time;
> -	ppc_md.set_rtc_time = ds1374_set_rtc_time;
> -
> -	tv.tv_nsec = 0;
> -	tv.tv_sec = (ppc_md.get_rtc_time) ();
> -	do_settimeofday(&tv);
> -
> -	return 0;
> -}
> -
> -late_initcall(mpc8360_rtc_hookup);
> -#endif
> -
>  /*
>   * Called very early, MMU is off, device-tree isn't unflattened
>   */
> diff --git a/arch/ppc/platforms/83xx/mpc834x_sys.c b/arch/ppc/platforms/83xx/mpc834x_sys.c
> index b84f8df..cb0a749 100644
> --- a/arch/ppc/platforms/83xx/mpc834x_sys.c
> +++ b/arch/ppc/platforms/83xx/mpc834x_sys.c
> @@ -224,26 +224,6 @@ mpc834x_sys_init_IRQ(void)
>  	ipic_set_default_priority();
>  }
>  
> -#if defined(CONFIG_I2C_MPC) && defined(CONFIG_SENSORS_DS1374)
> -extern ulong	ds1374_get_rtc_time(void);
> -extern int	ds1374_set_rtc_time(ulong);
> -
> -static int __init
> -mpc834x_rtc_hookup(void)
> -{
> -	struct timespec	tv;
> -
> -	ppc_md.get_rtc_time = ds1374_get_rtc_time;
> -	ppc_md.set_rtc_time = ds1374_set_rtc_time;
> -
> -	tv.tv_nsec = 0;
> -	tv.tv_sec = (ppc_md.get_rtc_time)();
> -	do_settimeofday(&tv);
> -
> -	return 0;
> -}
> -late_initcall(mpc834x_rtc_hookup);
> -#endif
>  static __inline__ void
>  mpc834x_sys_set_bat(void)
>  {
> diff --git a/arch/ppc/platforms/85xx/tqm85xx.c b/arch/ppc/platforms/85xx/tqm85xx.c
> index 4ee2bd1..27ce389 100644
> --- a/arch/ppc/platforms/85xx/tqm85xx.c
> +++ b/arch/ppc/platforms/85xx/tqm85xx.c
> @@ -258,27 +258,6 @@ int tqm85xx_show_cpuinfo(struct seq_file *m)
>  	return 0;
>  }
>  
> -#if defined(CONFIG_I2C) && defined(CONFIG_SENSORS_DS1337)
> -extern ulong ds1337_get_rtc_time(void);
> -extern int ds1337_set_rtc_time(unsigned long nowtime);
> -
> -static int __init
> -tqm85xx_rtc_hookup(void)
> -{
> -	struct timespec	tv;
> -
> -        ppc_md.set_rtc_time = ds1337_set_rtc_time;
> -        ppc_md.get_rtc_time = ds1337_get_rtc_time;
> -
> -	tv.tv_nsec = 0;
> -	tv.tv_sec = (ppc_md.get_rtc_time)();
> -	do_settimeofday(&tv);
> -
> -	return 0;
> -}
> -late_initcall(tqm85xx_rtc_hookup);
> -#endif
> -
>  #ifdef CONFIG_PCI
>  /*
>   * interrupt routing
> diff --git a/arch/ppc/platforms/katana.c b/arch/ppc/platforms/katana.c
> index 52f63e6..fe6e88c 100644
> --- a/arch/ppc/platforms/katana.c
> +++ b/arch/ppc/platforms/katana.c
> @@ -838,27 +838,6 @@ katana_find_end_of_memory(void)
>  	return bdp->bi_memsize;
>  }
>  
> -#if defined(CONFIG_I2C_MV64XXX) && defined(CONFIG_SENSORS_M41T00)
> -extern ulong	m41t00_get_rtc_time(void);
> -extern int	m41t00_set_rtc_time(ulong);
> -
> -static int __init
> -katana_rtc_hookup(void)
> -{
> -	struct timespec	tv;
> -
> -	ppc_md.get_rtc_time = m41t00_get_rtc_time;
> -	ppc_md.set_rtc_time = m41t00_set_rtc_time;
> -
> -	tv.tv_nsec = 0;
> -	tv.tv_sec = (ppc_md.get_rtc_time)();
> -	do_settimeofday(&tv);
> -
> -	return 0;
> -}
> -late_initcall(katana_rtc_hookup);
> -#endif
> -
>  #if defined(CONFIG_SERIAL_TEXT_DEBUG) && defined(CONFIG_SERIAL_MPSC_CONSOLE)
>  static void __init
>  katana_map_io(void)
> diff --git a/drivers/i2c/chips/Kconfig b/drivers/i2c/chips/Kconfig
> index 2e1c24f..5b8eb02 100644
> --- a/drivers/i2c/chips/Kconfig
> +++ b/drivers/i2c/chips/Kconfig
> @@ -4,32 +4,6 @@
>  
>  menu "Miscellaneous I2C Chip support"
>  
> -config SENSORS_DS1337
> -	tristate "Dallas DS1337 and DS1339 Real Time Clock (DEPRECATED)"
> -	depends on EXPERIMENTAL
> -	help
> -	  If you say yes here you get support for Dallas Semiconductor
> -	  DS1337 and DS1339 real-time clock chips.
> -
> -	  This driver can also be built as a module.  If so, the module
> -	  will be called ds1337.
> -
> -	  This driver is deprecated and will be dropped soon. Use
> -	  rtc-ds1307 instead.
> -
> -config SENSORS_DS1374
> -	tristate "Dallas DS1374 Real Time Clock (DEPRECATED)"
> -	depends on EXPERIMENTAL
> -	help
> -	  If you say yes here you get support for Dallas Semiconductor
> -	  DS1374 real-time clock chips.
> -
> -	  This driver can also be built as a module.  If so, the module
> -	  will be called ds1374.
> -
> -	  This driver is deprecated and will be dropped soon. Use
> -	  rtc-ds1374 instead.
> -
>  config DS1682
>  	tristate "Dallas DS1682 Total Elapsed Time Recorder with Alarm"
>  	depends on EXPERIMENTAL
> @@ -116,18 +90,6 @@ config TPS65010
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called tps65010.
>  
> -config SENSORS_M41T00
> -	tristate "ST M41T00 RTC chip (DEPRECATED)"
> -	depends on PPC32
> -	help
> -	  If you say yes here you get support for the ST M41T00 RTC chip.
> -
> -	  This driver can also be built as a module.  If so, the module
> -	  will be called m41t00.
> -
> -	  This driver is deprecated and will be dropped soon. Use
> -	  rtc-ds1307 or rtc-m41t80 instead.
> -
>  config SENSORS_MAX6875
>  	tristate "Maxim MAX6875 Power supply supervisor"
>  	depends on EXPERIMENTAL
> diff --git a/drivers/i2c/chips/Makefile b/drivers/i2c/chips/Makefile
> index ca924e1..1d5d1a5 100644
> --- a/drivers/i2c/chips/Makefile
> +++ b/drivers/i2c/chips/Makefile
> @@ -2,12 +2,9 @@
>  # Makefile for miscellaneous I2C chip drivers.
>  #
>  
> -obj-$(CONFIG_SENSORS_DS1337)	+= ds1337.o
> -obj-$(CONFIG_SENSORS_DS1374)	+= ds1374.o
>  obj-$(CONFIG_DS1682)		+= ds1682.o
>  obj-$(CONFIG_SENSORS_EEPROM)	+= eeprom.o
>  obj-$(CONFIG_SENSORS_MAX6875)	+= max6875.o
> -obj-$(CONFIG_SENSORS_M41T00)	+= m41t00.o
>  obj-$(CONFIG_SENSORS_PCA9539)	+= pca9539.o
>  obj-$(CONFIG_SENSORS_PCF8574)	+= pcf8574.o
>  obj-$(CONFIG_SENSORS_PCF8591)	+= pcf8591.o
> (...)

-- 
Jean Delvare
