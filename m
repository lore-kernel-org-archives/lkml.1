Return-Path: <linux-kernel-owner+w=401wt.eu-S1755285AbZCDHqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbZCDHqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 02:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZCDHqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 02:46:43 -0500
Received: from mail.gmx.net ([213.165.64.20]:46424 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751808AbZCDHqm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 02:46:42 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18yKRMh1XEyBajItKS/Q8vprpWA+nmWiveONvmicM
	5V/4Wd/cHe4Pem
Date: Wed, 4 Mar 2009 08:46:40 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
cc: linux-kernel@vger.kernel.org, Tony Breeds <tony@bakeyournoodle.com>,
       Kumar Gala <galak@kernel.crashing.org>, torvalds@linux-foundation.org
Subject: Re: [PATCH] powerpc: fix the defaults for the linkstation MTD device
 (was: Re: Linux 2.6.29-rc6 bombs while compiling a kernel for a linkstation/kurobox)
In-Reply-To: <20090303083455.GA22397@ime.usp.br>
Message-ID: <Pine.LNX.4.64.0903040828150.4864@axis700.grange>
References: <20090302094303.GA29819@ime.usp.br> <20090303024837.GC24834@bilbo.ozlabs.org>
 <20090303083455.GA22397@ime.usp.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Mar 2009, Rogério Brito wrote:

> Hi, Tony and other people.
> 
> On Mar 03 2009, Tony Breeds wrote:
> > On Mon, Mar 02, 2009 at 06:43:03AM -0300, Rogério Brito wrote:
> > > - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
> > > arch/powerpc/platforms/built-in.o: In function `linkstation_setup_arch':
> > > linkstation.c:(.init.text+0x218): undefined reference to `physmap_set_partitions'
> > > drivers/built-in.o:(__ksymtab+0x9f8): undefined reference to `physmap_set_partitions'
> > > make: *** [.tmp_vmlinux1] Error 1
> > > - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
> > 
> > Looks to me like you need to define CONFIG_MTD_PHYSMAP_COMPAT in your
> > .config.
> 
> Right. This was the fix. The attached diff to update the defconfig is
> included below.
> 
> Please, note that it wasn't sufficient to only to define
> CONFIG_MTD_PHYSMAP_COMPAT. 
> 
> The default values for CONFIG_MTD_PHYSMAP_{START,LEN,BANKWIDTH} weren't
> correct (and, as a result, no MTD was detected on my kurobox and this
> was a regression regarding 2.6.28).
> 
> This patch makes the compilation succeed and the MTD device work again.
> Already tested and in production.

No, I don't think this is a proper fix. Remember, the kernel has to at 
least compile not only with defconfigs, but with all valid configurations. 
So, at the very least you would also have to

 static void __init linkstation_setup_arch(void)
 {
 	struct device_node *np;
-#ifdef CONFIG_MTD_PHYSMAP
+#ifdef CONFIG_MTD_PHYSMAP_COMPAT
 	physmap_set_partitions(linkstation_physmap_partitions,
 			       ARRAY_SIZE(linkstation_physmap_partitions));
 #endif

in linkstation.c. In fact, this is a fix, not changing defconfig, which 
actually strictly speaking is not necessary. If only it fixes a 
regression, that defconfig used to provide mtd devices, now it no longer 
does.

But even this I don't think is a proper fix. A proper fix would be to 
remove flash definitions from linkstation.c completely. Maybe we should 
add them to kuroboxH?.dts, similar to mgcoge.dts and define 
CONFIG_MTD_PHYSMAP_OF, or we can define CONFIG_MTD_CMDLINE_PARTS and rely 
on the user providing a map on the command line. I don't know what is the 
currently preferred way, Kumar? Notice, while fixing linkstation, one 
should also fix storcenter.

Thanks
Guennadi

> Signed-off-by: Rogério Brito <rbrito@ime.usp.br>
> 
> 
> ---
> 
> --- linux/arch/powerpc/configs/linkstation_defconfig.old	2009-03-03 05:11:38.000000000 -0300
> +++ linux/arch/powerpc/configs/linkstation_defconfig	2009-03-03 05:11:54.000000000 -0300
> @@ -1,7 +1,7 @@
>  #
>  # Automatically generated make config: don't edit
> -# Linux kernel version: 2.6.29-rc2
> -# Mon Jan 26 15:35:29 2009
> +# Linux kernel version: 2.6.29-rc6
> +# Tue Mar  3 05:10:59 2009
>  #
>  # CONFIG_PPC64 is not set
>  
> @@ -71,6 +71,15 @@
>  # CONFIG_BSD_PROCESS_ACCT is not set
>  # CONFIG_TASKSTATS is not set
>  # CONFIG_AUDIT is not set
> +
> +#
> +# RCU Subsystem
> +#
> +CONFIG_CLASSIC_RCU=y
> +# CONFIG_TREE_RCU is not set
> +# CONFIG_PREEMPT_RCU is not set
> +# CONFIG_TREE_RCU_TRACE is not set
> +# CONFIG_PREEMPT_RCU_TRACE is not set
>  CONFIG_IKCONFIG=y
>  CONFIG_IKCONFIG_PROC=y
>  CONFIG_LOG_BUF_SHIFT=14
> @@ -88,6 +97,7 @@
>  # CONFIG_IPC_NS is not set
>  # CONFIG_USER_NS is not set
>  # CONFIG_PID_NS is not set
> +# CONFIG_NET_NS is not set
>  CONFIG_BLK_DEV_INITRD=y
>  CONFIG_INITRAMFS_SOURCE=""
>  CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> @@ -153,11 +163,6 @@
>  # CONFIG_DEFAULT_CFQ is not set
>  # CONFIG_DEFAULT_NOOP is not set
>  CONFIG_DEFAULT_IOSCHED="anticipatory"
> -CONFIG_CLASSIC_RCU=y
> -# CONFIG_TREE_RCU is not set
> -# CONFIG_PREEMPT_RCU is not set
> -# CONFIG_TREE_RCU_TRACE is not set
> -# CONFIG_PREEMPT_RCU_TRACE is not set
>  # CONFIG_FREEZER is not set
>  
>  #
> @@ -294,7 +299,6 @@
>  #
>  # Networking options
>  #
> -# CONFIG_NET_NS is not set
>  CONFIG_COMPAT_NET_DEV_OPS=y
>  CONFIG_PACKET=y
>  CONFIG_PACKET_MMAP=y
> @@ -560,7 +564,10 @@
>  #
>  # CONFIG_MTD_COMPLEX_MAPPINGS is not set
>  CONFIG_MTD_PHYSMAP=y
> -# CONFIG_MTD_PHYSMAP_COMPAT is not set
> +CONFIG_MTD_PHYSMAP_COMPAT=y
> +CONFIG_MTD_PHYSMAP_START=0xffc00000
> +CONFIG_MTD_PHYSMAP_LEN=0x400000
> +CONFIG_MTD_PHYSMAP_BANKWIDTH=1
>  # CONFIG_MTD_PHYSMAP_OF is not set
>  # CONFIG_MTD_INTEL_VR_NOR is not set
>  # CONFIG_MTD_PLATRAM is not set
> @@ -617,13 +624,19 @@
>  # CONFIG_BLK_DEV_HD is not set
>  CONFIG_MISC_DEVICES=y
>  # CONFIG_PHANTOM is not set
> -# CONFIG_EEPROM_93CX6 is not set
>  # CONFIG_SGI_IOC4 is not set
>  # CONFIG_TIFM_CORE is not set
>  # CONFIG_ICS932S401 is not set
>  # CONFIG_ENCLOSURE_SERVICES is not set
>  # CONFIG_HP_ILO is not set
>  # CONFIG_C2PORT is not set
> +
> +#
> +# EEPROM support
> +#
> +# CONFIG_EEPROM_AT24 is not set
> +CONFIG_EEPROM_LEGACY=m
> +# CONFIG_EEPROM_93CX6 is not set
>  CONFIG_HAVE_IDE=y
>  # CONFIG_IDE is not set
>  
> @@ -1037,8 +1050,6 @@
>  # Miscellaneous I2C Chip support
>  #
>  # CONFIG_DS1682 is not set
> -# CONFIG_EEPROM_AT24 is not set
> -CONFIG_EEPROM_LEGACY=m
>  # CONFIG_SENSORS_PCF8574 is not set
>  # CONFIG_PCF8575 is not set
>  # CONFIG_SENSORS_PCA9539 is not set
> 
> 
> -- 
> Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
> http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
> Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
