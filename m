Return-Path: <linux-kernel-owner+w=401wt.eu-S1753538AbZKJI4C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbZKJI4C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 03:56:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbZKJI4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 03:56:00 -0500
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:25057 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752693AbZKJIz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 03:55:56 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=LmIc4nQy2ZdGHQjvcynZezKI7wQxSSu8ioZo5YY4sjxp0sAWwDKz50PMnFQgswuTH44cO8yst7KhXRJ1+vXqvg2zHoW227/R4hqDxkW6aEi3AEEJRcv1suru47+0ZUHgJqprxunpfoqMOKDt8eUC3hjCfOykZbJOBX88n2WLVec=  ;
X-Yahoo-SMTP: qGLgp.mswBDSnFfWmYVMF5Rmg6NJ
X-YMail-OSG: YMMckV4VM1lMaLT5brP7g_mhFNs8QiiHE4tCeoQX_R0jfyUgFQQP9dSkuMQ8aFHQnJ86hZCCJRpmX0I0afSUd5yfMdqQeFy3PoNvdL4zsWU_dEPR5pXzyvil2DkqnREjAgPi.se5doUMNAqFdO.QPvsqm5c_W6v5t9htLDfwxSGdtjEVG7gYIQr.V5XP0jFZ.Hdvkc9psclicpP_8Ye6Iz1qf70Hf7GHmoA629hJKWQYywmWsJYESkG0BnSkvxfjnbDq8zHWrEOGNI7XrjZ.MexJmy81mlaBt4OQhwzfQvMZqBy303dSXkQx5E8FzHTc0A2Q5891Fo658Q--
X-Yahoo-Newman-Property: ymail-3
From: Steven King <sfking00@yahoo.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [Repost without wordwrapping] Merge m68k and m68knommu
Date: Tue, 10 Nov 2009 00:55:42 -0800
User-Agent: KMail/1.9.9
Cc: linux-m68k@vger.kernel.org, uclinux-dev@uclinux.org,
       Greg Ungerer <gerg@snapgear.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>
References: <200910181655.40579.sfking00@yahoo.com>
In-Reply-To: <200910181655.40579.sfking00@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911100055.43227.sfking00@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 October 2009 04:55:40 Steven King wrote:
> This is a script and patch to merge the m68knommu arch into m68k.

Ping.

>
> The script was inspired by the script Sam Ravnborg used to merge the
> includes from m68knommu. For those files common to both arches but
> differing in content, the m68k version of the file is renamed to
> <file>_mm.<ext> and the m68knommu version of the file is moved into the
> corresponding m68k directory and renamed <file>_no.<ext> and a small
> wrapper file <file>.<ext> is used to select between the two version.
> Files that are common to both but don't differ are removed from the
> m68knommu tree and files and directories that are unique to the
> m68knommu tree are moved to the m68k tree. Finally, the arch/m68knommu
> tree is removed.
>
> To select between the the versions of the files, the wrapper uses
>
> #ifdef CONFIG_MMU
> #include <file>_mm.<ext>
> #else
> #include <file>_no.<ext>
> #endif
>
> The patch modifies the toplevel Makefile so that ARCH=m68knommu still
> works (by setting SRCARCH=m68k) and adds the m68knommu Kconfig and
> Makefile to the m68k Kconfig and Makefile, using the definition of ARCH
> to select which values to use.
>
> Thus when building for either a m68k or an m68knommu target, one still
> specifies either ARCH=m68k or ARCH=m68knommu and everything should
> build EXACTLY as it did pre-merge.  (I think).
>
>
> Signed-off-by: Steven King <sfking@fdwdc.com>
>
> ------------------------------------------------------------------------
>-------
>
> #!/bin/sh
>
>
> mergefile() {
> 	BASE=${1%.?}
> 	EXT=${1#${BASE}}
> 	git mv ${TARGET}/$1 ${TARGET}/${BASE}_mm${EXT}
> 	git mv ${SOURCE}/$1 ${TARGET}/${BASE}_no${EXT}
> 	cat <<-EOF > ${TARGET}/$1
> 	#ifdef CONFIG_MMU
> 	#include "${BASE}_mm${EXT}"
> 	#else
> 	#include "${BASE}_no${EXT}"
> 	#endif
> 	EOF
> 	git add ${TARGET}/$1
> }
>
> mergedir() {
> 	TARGET=arch/m68k/$1
> 	SOURCE=arch/m68knommu/$1
> 	files=${1}_MERGE_FILES
> 	MERGE_FILES=${!files}
>
> 	echo "merging files in $1"
> 	for F in $MERGE_FILES ; do
> 		mergefile $F
> 	done
>
> 	files=${1}_NOMERGE_FILES
> 	NOMERGE_FILES=${!files}
>
> 	echo "moving files in $1"
> 	for F in $NOMERGE_FILES ; do
> 		git mv ${SOURCE}/$F ${TARGET}/$F
> 	done
>
> 	files=${1}_REMOVE_FILES
> 	REMOVE_FILES=${!files}
>
> 	echo "removing common files in $1"
> 	for F in $REMOVE_FILES ; do
> 		git rm ${SOURCE}/$F
> 	done
>
> 	if [ -e ${SOURCE}/Makefile ]; then
> 	git mv ${TARGET}/Makefile ${TARGET}/Makefile_mm
> 	git mv ${SOURCE}/Makefile ${TARGET}/Makefile_no
> 	cat <<-EOF > ${TARGET}/Makefile
> 	ifdef CONFIG_MMU
> 	include ${TARGET}/Makefile_mm
> 	else
> 	include ${TARGET}/Makefile_no
> 	endif
> 	EOF
> 	git add ${TARGET}/Makefile
> 	fi
> }
>
> configs_MERGE_FILES=""
> configs_NOMERGE_FILES="m5208evb_defconfig \
> 			m5272c3_defconfig \
> 			m5307c3_defconfig \
> 			m5249evb_defconfig \
> 			m5275evb_defconfig \
> 			m5407c3_defconfig"
> configs_REMOVE_FILES=""
> kernel_MERGE_FILES="asm-offsets.c \
> 			dma.c entry.S \
> 			m68k_ksyms.c \
> 			module.c \
> 			process.c \
> 			ptrace.c \
> 			setup.c \
> 			signal.c \
> 			sys_m68k.c \
> 			time.c \
> 			traps.c \
> 			vmlinux.lds.S"
> kernel_NOMERGE_FILES="init_task.c \
> 			irq.c \
> 			syscalltable.S"
> kernel_REMOVE_FILES=""
> lib_MERGE_FILES="checksum.c \
> 			muldi3.c"
> lib_NOMERGE_FILES="delay.c \
> 			divsi3.S \
> 			memcpy.c \
> 			memset.c \
> 			modsi3.S \
> 			mulsi3.S \
> 			udivsi3.S \
> 			umodsi3.S"
> lib_REMOVE_FILES="ashldi3.c \
> 			ashrdi3.c \
> 			lshrdi3.c"
> mm_MERGE_FILES="fault.c \
> 			init.c \
> 			kmap.c \
> 			memory.c"
> mm_NOMERGE_FILES=""
> mm_REMOVE_FILES=""
>
> DIRS="configs kernel lib mm"
>
> for dir in $DIRS ; do
> 	mergedir $dir
> done
> echo "moving platform"
> git mv arch/m68knommu/platform arch/m68k/
> echo "removing remaining m68knommu dirs"
> git rm -r arch/m68knommu
> rm -r arch/m68knommu
> exit 0
>
> ------------------------------------------------------------------------
>-------
>
> diff --git a/Makefile b/Makefile
> index 9425d1d..1de4c0f 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -205,13 +205,14 @@ ifeq ($(ARCH),sh64)
>         SRCARCH := sh
>  endif
>
> -# Where to locate arch specific headers
> -hdr-arch  := $(SRCARCH)
> -
> +# Additional ARCH settings for m68k
>  ifeq ($(ARCH),m68knommu)
> -       hdr-arch  := m68k
> +       SRCARCH  := m68k
>  endif
>
> +# Where to locate arch specific headers
> +hdr-arch  := $(SRCARCH)
> +
>  KCONFIG_CONFIG	?= .config
>
>  # SHELL used by kbuild
> diff --git a/arch/m68k/Kconfig.debug b/arch/m68k/Kconfig.debug
> index f53b6d5..cec668b 100644
> --- a/arch/m68k/Kconfig.debug
> +++ b/arch/m68k/Kconfig.debug
> @@ -2,4 +2,37 @@ menu "Kernel hacking"
>
>  source "lib/Kconfig.debug"
>
> +if ARCH = "m68knommu"
> +
> +config FULLDEBUG
> +	bool "Full Symbolic/Source Debugging support"
> +	help
> +	  Enable debugging symbols on kernel build.
> +
> +config HIGHPROFILE
> +	bool "Use fast second timer for profiling"
> +	depends on COLDFIRE
> +	help
> +	  Use a fast secondary clock to produce profiling information.
> +
> +config BOOTPARAM
> +	bool 'Compiled-in Kernel Boot Parameter'
> +
> +config BOOTPARAM_STRING
> +	string 'Kernel Boot Parameter'
> +	default 'console=ttyS0,19200'
> +	depends on BOOTPARAM
> +
> +config NO_KERNEL_MSG
> +	bool "Suppress Kernel BUG Messages"
> +	help
> +	  Do not output any debug BUG messages within the kernel.
> +
> +config BDM_DISABLE
> +	bool "Disable BDM signals"
> +	depends on (EXPERIMENTAL && COLDFIRE)
> +	help
> +	  Disable the ColdFire CPU's BDM signals.
> +
> +endif
>  endmenu
> diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
> index 29dd848..7a27ca7 100644
> --- a/arch/m68k/Kconfig
> +++ b/arch/m68k/Kconfig
> @@ -2,6 +2,8 @@
>  # For a description of the syntax of this configuration file,
>  # see Documentation/kbuild/kconfig-language.txt.
>  #
> +if ARCH != "m68knommu"
> +
>  config M68K
>  	bool
>  	default y
> @@ -64,6 +66,89 @@ config GENERIC_TIME
>  config ARCH_USES_GETTIMEOFFSET
>  	def_bool y
>
> +endif
> +
> +if ARCH = "m68knommu"
> +
> +config M68K
> +	bool
> +	default y
> +	select HAVE_IDE
> +
> +config MMU
> +	bool
> +	default n
> +
> +config NO_DMA
> +	bool
> +	depends on !COLDFIRE
> +	default y
> +
> +config FPU
> +	bool
> +	default n
> +
> +config ZONE_DMA
> +	bool
> +	default y
> +
> +config RWSEM_GENERIC_SPINLOCK
> +	bool
> +	default y
> +
> +config RWSEM_XCHGADD_ALGORITHM
> +	bool
> +	default n
> +
> +config ARCH_HAS_ILOG2_U32
> +	bool
> +	default n
> +
> +config ARCH_HAS_ILOG2_U64
> +	bool
> +	default n
> +
> +config GENERIC_FIND_NEXT_BIT
> +	bool
> +	default y
> +
> +config GENERIC_GPIO
> +	bool
> +	default n
> +
> +config GENERIC_HWEIGHT
> +	bool
> +	default y
> +
> +config GENERIC_HARDIRQS
> +	bool
> +	default y
> +
> +config GENERIC_CALIBRATE_DELAY
> +	bool
> +	default y
> +
> +config GENERIC_TIME
> +	bool
> +	default y
> +
> +config GENERIC_CMOS_UPDATE
> +	bool
> +	default y
> +
> +config TIME_LOW_RES
> +	bool
> +	default y
> +
> +config GENERIC_CLOCKEVENTS
> +	bool
> +	default n
> +
> +config NO_IOPORT
> +	def_bool y
> +
> +endif
> +
>  mainmenu "Linux/68k Kernel Configuration"
>
>  source "init/Kconfig"
> @@ -72,6 +157,7 @@ source "kernel/Kconfig.freezer"
>
>  menu "Platform dependent setup"
>
> +if ARCH != "m68knommu"
>  config EISA
>  	bool
>  	---help---
> @@ -384,15 +470,638 @@ config NODES_SHIFT
>  	int
>  	default "3"
>  	depends on !SINGLE_MEMORY_CHUNK
> +endif
> +
> +
> +if ARCH = "m68knommu"
> +choice
> +	prompt "CPU"
> +	default M68EZ328
> +
> +config M68328
> +	bool "MC68328"
> +	help
> +	  Motorola 68328 processor support.
> +
> +config M68EZ328
> +	bool "MC68EZ328"
> +	help
> +	  Motorola 68EX328 processor support.
> +
> +config M68VZ328
> +	bool "MC68VZ328"
> +	help
> +	  Motorola 68VZ328 processor support.
> +
> +config M68360
> +	bool "MC68360"
> +	help
> +	  Motorola 68360 processor support.
> +
> +config M5206
> +	bool "MCF5206"
> +	help
> +	  Motorola ColdFire 5206 processor support.
> +
> +config M5206e
> +	bool "MCF5206e"
> +	help
> +	  Motorola ColdFire 5206e processor support.
> +
> +config M520x
> +	bool "MCF520x"
> +	select GENERIC_CLOCKEVENTS
> +	help
> +	   Freescale Coldfire 5207/5208 processor support.
> +
> +config M523x
> +	bool "MCF523x"
> +	select GENERIC_CLOCKEVENTS
> +	help
> +	  Freescale Coldfire 5230/1/2/4/5 processor support
> +
> +config M5249
> +	bool "MCF5249"
> +	help
> +	  Motorola ColdFire 5249 processor support.
> +
> +config M5271
> +	bool "MCF5271"
> +	help
> +	  Freescale (Motorola) ColdFire 5270/5271 processor support.
> +
> +config M5272
> +	bool "MCF5272"
> +	help
> +	  Motorola ColdFire 5272 processor support.
> +
> +config M5275
> +	bool "MCF5275"
> +	help
> +	  Freescale (Motorola) ColdFire 5274/5275 processor support.
> +
> +config M528x
> +	bool "MCF528x"
> +	select GENERIC_CLOCKEVENTS
> +	help
> +	  Motorola ColdFire 5280/5282 processor support.
> +
> +config M5307
> +	bool "MCF5307"
> +	help
> +	  Motorola ColdFire 5307 processor support.
> +
> +config M532x
> +	bool "MCF532x"
> +	help
> +	  Freescale (Motorola) ColdFire 532x processor support.
> +
> +config M5407
> +	bool "MCF5407"
> +	help
> +	  Motorola ColdFire 5407 processor support.
> +
> +endchoice
> +
> +config M527x
> +	bool
> +	depends on (M5271 || M5275)
> +	select GENERIC_CLOCKEVENTS
> +	default y
> +
> +config COLDFIRE
> +	bool
> +	depends on (M5206 || M5206e || M520x || M523x || M5249 || M527x ||
> M5272 || M528x || M5307 || M532x || M5407) +	select GENERIC_GPIO
> +	select ARCH_REQUIRE_GPIOLIB
> +	default y
> +
> +config CLOCK_SET
> +	bool "Enable setting the CPU clock frequency"
> +	default n
> +	help
> +	  On some CPU's you do not need to know what the core CPU clock
> +	  frequency is. On these you can disable clock setting. On some
> +	  traditional 68K parts, and on all ColdFire parts you need to set
> +	  the appropriate CPU clock frequency. On these devices many of the
> +	  onboard peripherals derive their timing from the master CPU clock
> +	  frequency.
> +
> +config CLOCK_FREQ
> +	int "Set the core clock frequency"
> +	default "66666666"
> +	depends on CLOCK_SET
> +	help
> +	  Define the CPU clock frequency in use. This is the core clock
> +	  frequency, it may or may not be the same as the external clock
> +	  crystal fitted to your board. Some processors have an internal
> +	  PLL and can have their frequency programmed at run time, others
> +	  use internal dividers. In general the kernel won't setup a PLL
> +	  if it is fitted (there are some exceptions). This value will be
> +	  specific to the exact CPU that you are using.
> +
> +config CLOCK_DIV
> +	int "Set the core/bus clock divide ratio"
> +	default "1"
> +	depends on CLOCK_SET
> +	help
> +	  On many SoC style CPUs the master CPU clock is also used to drive
> +	  on-chip peripherals. The clock that is distributed to these
> +	  peripherals is sometimes a fixed ratio of the master clock
> +	  frequency. If so then set this to the divider ratio of the
> +	  master clock to the peripheral clock. If not sure then select 1.
> +
> +config OLDMASK
> +	bool "Old mask 5307 (1H55J) silicon"
> +	depends on M5307
> +	help
> +	  Build support for the older revision ColdFire 5307 silicon.
> +	  Specifically this is the 1H55J mask revision.
> +
> +comment "Platform"
> +
> +config PILOT3
> +	bool "Pilot 1000/5000, PalmPilot Personal/Pro, or PalmIII support"
> +	depends on M68328
> +	help
> +	  Support for the Palm Pilot 1000/5000, Personal/Pro and PalmIII.
> +
> +config XCOPILOT_BUGS
> +	bool "(X)Copilot support"
> +	depends on PILOT3
> +	help
> +	  Support the bugs of Xcopilot.
> +
> +config UC5272
> +        bool 'Arcturus Networks uC5272 dimm board support'
> +        depends on M5272
> +        help
> +          Support for the Arcturus Networks uC5272 dimm board.
> +
> +config UC5282
> +       bool "Arcturus Networks uC5282 board support"
> +          depends on M528x
> +       help
> +          Support for the Arcturus Networks uC5282 dimm board.
> +
> +config UCSIMM
> +	bool "uCsimm module support"
> +	depends on M68EZ328
> +	help
> +	  Support for the Arcturus Networks uCsimm module.
> +
> +config UCDIMM
> +	bool "uDsimm module support"
> +	depends on M68VZ328
> +	help
> +	  Support for the Arcturus Networks uDsimm module.
> +
> +config DRAGEN2
> +	bool "DragenEngine II board support"
> +	depends on M68VZ328
> +	help
> +	  Support for the DragenEngine II board.
> +
> +config DIRECT_IO_ACCESS
> +	bool "Allow user to access IO directly"
> +	depends on (UCSIMM || UCDIMM || DRAGEN2)
> +	help
> +	  Disable the CPU internal registers protection in user mode,
> +          to allow a user application to read/write them.
> +
> +config INIT_LCD
> +	bool "Initialize LCD"
> +	depends on (UCSIMM || UCDIMM || DRAGEN2)
> +	help
> +	  Initialize the LCD controller of the 68x328 processor.
> +
> +config MEMORY_RESERVE
> +	int "Memory reservation (MiB)"
> +	depends on (UCSIMM || UCDIMM)
> +	help
> +	  Reserve certain memory regions on 68x328 based boards.
> +
> +config UCQUICC
> +	bool "Lineo uCquicc board support"
> +	depends on M68360
> +	help
> +	  Support for the Lineo uCquicc board.
> +
> +config ARN5206
> +	bool "Arnewsh 5206 board support"
> +	depends on M5206
> +	help
> +	  Support for the Arnewsh 5206 board.
> +
> +config M5206eC3
> +	bool "Motorola M5206eC3 board support"
> +	depends on M5206e
> +	help
> +	  Support for the Motorola M5206eC3 board.
> +
> +config ELITE
> +	bool "Motorola M5206eLITE board support"
> +	depends on M5206e
> +	help
> +	  Support for the Motorola M5206eLITE board.
> +
> +config M5208EVB
> +	bool "Freescale M5208EVB board support"
> +	depends on M520x
> +	help
> +	  Support for the Freescale Coldfire M5208EVB.
> +
> +config M5235EVB
> +	bool "Freescale M5235EVB support"
> +	depends on M523x
> +	help
> +	  Support for the Freescale M5235EVB board.
> +
> +config M5249C3
> +	bool "Motorola M5249C3 board support"
> +	depends on M5249
> +	help
> +	  Support for the Motorola M5249C3 board.
> +
> +config M5271EVB
> +	bool "Freescale (Motorola) M5271EVB board support"
> +	depends on M5271
> +	help
> +	  Support for the Freescale (Motorola) M5271EVB board.
> +
> +config M5275EVB
> +	bool "Freescale (Motorola) M5275EVB board support"
> +	depends on M5275
> +	help
> +	  Support for the Freescale (Motorola) M5275EVB board.
> +
> +config M5272C3
> +	bool "Motorola M5272C3 board support"
> +	depends on M5272
> +	help
> +	  Support for the Motorola M5272C3 board.
> +
> +config COBRA5272
> +	bool "senTec COBRA5272 board support"
> +	depends on M5272
> +	help
> +	  Support for the senTec COBRA5272 board.
> +
> +config AVNET5282
> +	bool "Avnet 5282 board support"
> +	depends on M528x
> +	help
> +	  Support for the Avnet 5282 board.
> +
> +config M5282EVB
> +	bool "Motorola M5282EVB board support"
> +	depends on M528x
> +	help
> +	  Support for the Motorola M5282EVB board.
> +
> +config COBRA5282
> +	bool "senTec COBRA5282 board support"
> +	depends on M528x
> +	help
> +	  Support for the senTec COBRA5282 board.
> +
> +config SOM5282EM
> +	bool "EMAC.Inc SOM5282EM board support"
> +	depends on M528x
> +	help
> +	  Support for the EMAC.Inc SOM5282EM module.
> +
> +config WILDFIRE
> +	bool "Intec Automation Inc. WildFire board support"
> +	depends on M528x
> +	help
> +	  Support for the Intec Automation Inc. WildFire.
> +
> +config WILDFIREMOD
> +	bool "Intec Automation Inc. WildFire module support"
> +	depends on M528x
> +	help
> +	  Support for the Intec Automation Inc. WildFire module.
> +
> +config ARN5307
> +	bool "Arnewsh 5307 board support"
> +	depends on M5307
> +	help
> +	  Support for the Arnewsh 5307 board.
> +
> +config M5307C3
> +	bool "Motorola M5307C3 board support"
> +	depends on M5307
> +	help
> +	  Support for the Motorola M5307C3 board.
> +
> +config SECUREEDGEMP3
> +	bool "SnapGear SecureEdge/MP3 platform support"
> +	depends on M5307
> +	help
> +	  Support for the SnapGear SecureEdge/MP3 platform.
> +
> +config M5329EVB
> +	bool "Freescale (Motorola) M5329EVB board support"
> +	depends on M532x
> +	help
> +	  Support for the Freescale (Motorola) M5329EVB board.
> +
> +config COBRA5329
> +	bool "senTec COBRA5329 board support"
> +	depends on M532x
> +	help
> +	  Support for the senTec COBRA5329 board.
> +
> +config M5407C3
> +	bool "Motorola M5407C3 board support"
> +	depends on M5407
> +	help
> +	  Support for the Motorola M5407C3 board.
> +
> +config CLEOPATRA
> +	bool "Feith CLEOPATRA board support"
> +	depends on (M5307 || M5407)
> +	help
> +	  Support for the Feith Cleopatra boards.
> +
> +config CANCam
> +	bool "Feith CANCam board support"
> +	depends on M5272
> +	help
> +	  Support for the Feith CANCam board.
> +
> +config SCALES
> +	bool "Feith SCALES board support"
> +	depends on M5272
> +	help
> +	  Support for the Feith SCALES board.
> +
> +config NETtel
> +	bool "SecureEdge/NETtel board support"
> +	depends on (M5206e || M5272 || M5307)
> +	help
> +	  Support for the SnapGear NETtel/SecureEdge/SnapGear boards.
> +
> +config SNAPGEAR
> +	bool "SnapGear router board support"
> +	depends on NETtel
> +	help
> +	  Special additional support for SnapGear router boards.
> +
> +config CPU16B
> +	bool "Sneha Technologies S.L. Sarasvati board support"
> +	depends on M5272
> +	help
> +	  Support for the SNEHA CPU16B board.
> +
> +config MOD5272
> +	bool "Netburner MOD-5272 board support"
> +	depends on M5272
> +	help
> +	  Support for the Netburner MOD-5272 board.
> +
> +config SAVANTrosie1
> +	bool "Savant Rosie1 board support"
> +	depends on M523x
> +	help
> +	  Support for the Savant Rosie1 board.
> +
> +config ROMFS_FROM_ROM
> +	bool "ROMFS image not RAM resident"
> +	depends on (NETtel || SNAPGEAR)
> +	help
> +	  The ROMfs filesystem will stay resident in the FLASH/ROM, not be
> +	  moved into RAM.
> +
> +config PILOT
> +	bool
> +	default y
> +	depends on (PILOT3 || PILOT5)
> +
> +config ARNEWSH
> +	bool
> +	default y
> +	depends on (ARN5206 || ARN5307)
> +
> +config FREESCALE
> +	bool
> +	default y
> +	depends on (M5206eC3 || M5208EVB || M5235EVB || M5249C3 || M5271EVB ||
> M5272C3 || M5275EVB || M5282EVB || M5307C3 || M5329EVB || M5407C3) +
> +config HW_FEITH
> +	bool
> +	default y
> +	depends on (CLEOPATRA || CANCam || SCALES)
> +
> +config senTec
> +	bool
> +	default y
> +	depends on (COBRA5272 || COBRA5282)
> +
> +config EMAC_INC
> +	bool
> +	default y
> +	depends on (SOM5282EM)
> +
> +config SNEHA
> +        bool
> +	default y
> +	depends on CPU16B
> +
> +config SAVANT
> +	bool
> +	default y
> +	depends on SAVANTrosie1
> +
> +config AVNET
> +	bool
> +	default y
> +	depends on (AVNET5282)
> +
> +config 4KSTACKS
> +	bool "Use 4Kb for kernel stacks instead of 8Kb"
> +	default y
> +	help
> +	  If you say Y here the kernel will use a 4Kb stacksize for the
> +	  kernel stack attached to each process/thread. This facilitates
> +	  running more threads on a system and also reduces the pressure
> +	  on the VM subsystem for higher order allocations.
> +
> +config HZ
> +	int
> +	default 1000 if CLEOPATRA
> +	default 100
> +
> +comment "RAM configuration"
> +
> +config RAMBASE
> +	hex "Address of the base of RAM"
> +	default "0"
> +	help
> +	  Define the address that RAM starts at. On many platforms this is
> +	  0, the base of the address space. And this is the default. Some
> +	  platforms choose to setup their RAM at other addresses within the
> +	  processor address space.
> +
> +config RAMSIZE
> +	hex "Size of RAM (in bytes)"
> +	default "0x400000"
> +	help
> +	  Define the size of the system RAM. If you select 0 then the
> +	  kernel will try to probe the RAM size at runtime. This is not
> +	  supported on all CPU types.
> +
> +config VECTORBASE
> +	hex "Address of the base of system vectors"
> +	default "0"
> +	help
> +	  Define the address of the system vectors. Commonly this is
> +	  put at the start of RAM, but it doesn't have to be. On ColdFire
> +	  platforms this address is programmed into the VBR register, thus
> +	  actually setting the address to use.
> +
> +config KERNELBASE
> +	hex "Address of the base of kernel code"
> +	default "0x400"
> +	help
> +	  Typically on m68k systems the kernel will not start at the base
> +	  of RAM, but usually some small offset from it. Define the start
> +	  address of the kernel here. The most common setup will have the
> +	  processor vectors at the base of RAM and then the start of the
> +	  kernel. On some platforms some RAM is reserved for boot loaders
> +	  and the kernel starts after that. The 0x400 default was based on
> +	  a system with the RAM based at address 0, and leaving enough room
> +	  for the theoretical maximum number of 256 vectors.
> +
> +choice
> +	prompt "RAM bus width"
> +	default RAMAUTOBIT
> +
> +config RAMAUTOBIT
> +	bool "AUTO"
> +	help
> +	  Select the physical RAM data bus size. Not needed on most platforms,
> +	  so you can generally choose AUTO.
> +
> +config RAM8BIT
> +	bool "8bit"
> +	help
> +	  Configure RAM bus to be 8 bits wide.
> +
> +config RAM16BIT
> +	bool "16bit"
> +	help
> +	  Configure RAM bus to be 16 bits wide.
> +
> +config RAM32BIT
> +	bool "32bit"
> +	help
> +	  Configure RAM bus to be 32 bits wide.
> +
> +endchoice
> +
> +comment "ROM configuration"
> +
> +config ROM
> +	bool "Specify ROM linker regions"
> +	default n
> +	help
> +	  Define a ROM region for the linker script. This creates a kernel
> +	  that can be stored in flash, with possibly the text, and data
> +	  regions being copied out to RAM at startup.
> +
> +config ROMBASE
> +	hex "Address of the base of ROM device"
> +	default "0"
> +	depends on ROM
> +	help
> +	  Define the address that the ROM region starts at. Some platforms
> +	  use this to set their chip select region accordingly for the boot
> +	  device.
> +
> +config ROMVEC
> +	hex "Address of the base of the ROM vectors"
> +	default "0"
> +	depends on ROM
> +	help
> +	  This is almost always the same as the base of the ROM. Since on all
> +	  68000 type variants the vectors are at the base of the boot device
> +	  on system startup.
> +
> +config ROMVECSIZE
> +	hex "Size of ROM vector region (in bytes)"
> +	default "0x400"
> +	depends on ROM
> +	help
> +	  Define the size of the vector region in ROM. For most 68000
> +	  variants this would be 0x400 bytes in size. Set to 0 if you do
> +	  not want a vector region at the start of the ROM.
> +
> +config ROMSTART
> +	hex "Address of the base of system image in ROM"
> +	default "0x400"
> +	depends on ROM
> +	help
> +	  Define the start address of the system image in ROM. Commonly this
> +	  is strait after the ROM vectors.
> +
> +config ROMSIZE
> +	hex "Size of the ROM device"
> +	default "0x100000"
> +	depends on ROM
> +	help
> +	  Size of the ROM device. On some platforms this is used to setup
> +	  the chip select that controls the boot ROM device.
> +
> +choice
> +	prompt "Kernel executes from"
> +	---help---
> +	  Choose the memory type that the kernel will be running in.
> +
> +config RAMKERNEL
> +	bool "RAM"
> +	help
> +	  The kernel will be resident in RAM when running.
> +
> +config ROMKERNEL
> +	bool "ROM"
> +	help
> +	  The kernel will be resident in FLASH/ROM when running. This is
> +	  often referred to as Execute-in-Place (XIP), since the kernel
> +	  code executes from the position it is stored in the FLASH/ROM.
> +
> +endchoice
> +
> +if COLDFIRE
> +source "kernel/Kconfig.preempt"
> +endif
> +
> +source "kernel/time/Kconfig"
> +
> +endif
>
>  source "mm/Kconfig"
>
>  endmenu
>
> +
> +if ARCH = "m68knommu"
> +
> +config ISA_DMA_API
> +	bool
> +	depends on !M5272
> +	default y
> +
> +source "drivers/pcmcia/Kconfig"
> +endif
> +
>  menu "General setup"
>
>  source "fs/Kconfig.binfmt"
>
> +if ARCH != "m68knommu"
> +
>  config ZORRO
>  	bool "Amiga Zorro (AutoConfig) bus support"
>  	depends on AMIGA
> @@ -458,12 +1167,29 @@ source "drivers/pci/Kconfig"
>
>  source "drivers/zorro/Kconfig"
>
> +endif
> +
>  endmenu
>
> +if ARCH = "m68knommu"
> +
> +menu "Power management options"
> +
> +config PM
> +	bool "Power Management support"
> +	help
> +	  Support processor power management modes
> +
> +endmenu
> +
> +endif
> +
>  source "net/Kconfig"
>
>  source "drivers/Kconfig"
>
> +if ARCH != "m68knommu"
> +
>  menu "Character devices"
>
>  config ATARI_MFPSER
> @@ -618,6 +1344,8 @@ config SERIAL_CONSOLE
>
>  endmenu
>
> +endif
> +
>  source "fs/Kconfig"
>
>  source "arch/m68k/Kconfig.debug"
> diff --git a/arch/m68k/Makefile b/arch/m68k/Makefile
> index 570d85c..3910b46 100644
> --- a/arch/m68k/Makefile
> +++ b/arch/m68k/Makefile
> @@ -1,3 +1,5 @@
> +ifeq ($(ARCH),m68k)
> +
>  #
>  # m68k/Makefile
>  #
> @@ -120,3 +122,130 @@ archclean:
>
>  install:
>  	sh $(srctree)/arch/m68k/install.sh $(KERNELRELEASE) vmlinux.gz
> System.map "$(INSTALL_PATH)" +
> +else
> +
> +#
> +# m68knommu Makefile
> +#
> +# This file is subject to the terms and conditions of the GNU General
> Public +# License.  See the file "COPYING" in the main directory of this
> archive +# for more details.
> +#
> +# (C) Copyright 2002, Greg Ungerer <gerg@snapgear.com>
> +#
> +
> +KBUILD_DEFCONFIG := m5208evb_defconfig
> +
> +platform-$(CONFIG_M68328)	:= 68328
> +platform-$(CONFIG_M68EZ328)	:= 68EZ328
> +platform-$(CONFIG_M68VZ328)	:= 68VZ328
> +platform-$(CONFIG_M68360)	:= 68360
> +platform-$(CONFIG_M5206)	:= 5206
> +platform-$(CONFIG_M5206e)	:= 5206e
> +platform-$(CONFIG_M520x)	:= 520x
> +platform-$(CONFIG_M523x)	:= 523x
> +platform-$(CONFIG_M5249)	:= 5249
> +platform-$(CONFIG_M527x)	:= 527x
> +platform-$(CONFIG_M5272)	:= 5272
> +platform-$(CONFIG_M528x)	:= 528x
> +platform-$(CONFIG_M5307)	:= 5307
> +platform-$(CONFIG_M532x)	:= 532x
> +platform-$(CONFIG_M5407)	:= 5407
> +PLATFORM := $(platform-y)
> +
> +board-$(CONFIG_PILOT)		:= pilot
> +board-$(CONFIG_UC5272)          := UC5272
> +board-$(CONFIG_UC5282)          := UC5282
> +board-$(CONFIG_UCSIMM)		:= ucsimm
> +board-$(CONFIG_UCDIMM)		:= ucdimm
> +board-$(CONFIG_UCQUICC)		:= uCquicc
> +board-$(CONFIG_DRAGEN2)		:= de2
> +board-$(CONFIG_ARNEWSH)		:= ARNEWSH
> +board-$(CONFIG_FREESCALE)	:= FREESCALE
> +board-$(CONFIG_M5235EVB)	:= M5235EVB
> +board-$(CONFIG_M5271EVB)	:= M5271EVB
> +board-$(CONFIG_M5275EVB)	:= M5275EVB
> +board-$(CONFIG_M5282EVB)	:= M5282EVB
> +board-$(CONFIG_ELITE)		:= eLITE
> +board-$(CONFIG_NETtel)		:= NETtel
> +board-$(CONFIG_SECUREEDGEMP3)	:= MP3
> +board-$(CONFIG_CLEOPATRA)	:= CLEOPATRA
> +board-$(CONFIG_senTec)		:= senTec
> +board-$(CONFIG_SNEHA) 	        := SNEHA
> +board-$(CONFIG_M5208EVB)	:= M5208EVB
> +board-$(CONFIG_MOD5272)		:= MOD5272
> +board-$(CONFIG_AVNET)           := AVNET
> +board-$(CONFIG_SAVANT)		:= SAVANT
> +BOARD := $(board-y)
> +
> +model-$(CONFIG_RAMKERNEL)	:= ram
> +model-$(CONFIG_ROMKERNEL)	:= rom
> +MODEL := $(model-y)
> +
> +#
> +# Some code support is grouped together for a common cpu-subclass (for
> +# example all ColdFire cpu's are very similar). Determine the sub-class
> +# for the selected cpu. ONLY need to define this for the non-base
> member +# of the family.
> +#
> +cpuclass-$(CONFIG_M5206)	:= coldfire
> +cpuclass-$(CONFIG_M5206e)	:= coldfire
> +cpuclass-$(CONFIG_M520x)	:= coldfire
> +cpuclass-$(CONFIG_M523x)	:= coldfire
> +cpuclass-$(CONFIG_M5249)	:= coldfire
> +cpuclass-$(CONFIG_M527x)	:= coldfire
> +cpuclass-$(CONFIG_M5272)	:= coldfire
> +cpuclass-$(CONFIG_M528x)	:= coldfire
> +cpuclass-$(CONFIG_M5307)	:= coldfire
> +cpuclass-$(CONFIG_M532x)	:= coldfire
> +cpuclass-$(CONFIG_M5407)	:= coldfire
> +cpuclass-$(CONFIG_M68328)	:= 68328
> +cpuclass-$(CONFIG_M68EZ328)	:= 68328
> +cpuclass-$(CONFIG_M68VZ328)	:= 68328
> +cpuclass-$(CONFIG_M68360)	:= 68360
> +CPUCLASS := $(cpuclass-y)
> +
> +ifneq ($(CPUCLASS),$(PLATFORM))
> +CLASSDIR := arch/m68k/platform/$(cpuclass-y)/
> +endif
> +
> +export PLATFORM BOARD MODEL CPUCLASS
> +
> +#
> +# Some CFLAG additions based on specific CPU type.
> +#
> +cflags-$(CONFIG_M5206)		:= $(call cc-option,-mcpu=5206,-m5200)
> +cflags-$(CONFIG_M5206e)		:= $(call cc-option,-m5206e,-m5200)
> +cflags-$(CONFIG_M520x)		:= $(call cc-option,-mcpu=5208,-m5200)
> +cflags-$(CONFIG_M523x)		:= $(call cc-option,-mcpu=523x,-m5307)
> +cflags-$(CONFIG_M5249)		:= $(call cc-option,-mcpu=5249,-m5200)
> +cflags-$(CONFIG_M5271)		:= $(call cc-option,-mcpu=5271,-m5307)
> +cflags-$(CONFIG_M5272)		:= $(call cc-option,-mcpu=5271,-m5200)
> +cflags-$(CONFIG_M5275)		:= $(call cc-option,-mcpu=5275,-m5307)
> +cflags-$(CONFIG_M528x)		:= $(call cc-option,-m528x,-m5307)
> +cflags-$(CONFIG_M5307)		:= $(call cc-option,-m5307,-m5200)
> +cflags-$(CONFIG_M532x)		:= $(call cc-option,-mcpu=532x,-m5307)
> +cflags-$(CONFIG_M5407)		:= $(call cc-option,-m5407,-m5200)
> +cflags-$(CONFIG_M68328)		:= -m68000
> +cflags-$(CONFIG_M68EZ328)	:= -m68000
> +cflags-$(CONFIG_M68VZ328)	:= -m68000
> +cflags-$(CONFIG_M68360)		:= -m68332
> +
> +KBUILD_AFLAGS += $(cflags-y)
> +
> +KBUILD_CFLAGS += $(cflags-y)
> +KBUILD_CFLAGS += -D__linux__
> +KBUILD_CFLAGS += -DUTS_SYSNAME=\"uClinux\"
> +
> +head-y := arch/m68k/platform/$(cpuclass-y)/head.o
> +
> +core-y	+= arch/m68k/kernel/ \
> +	   arch/m68k/mm/ \
> +	   $(CLASSDIR) \
> +	   arch/m68k/platform/$(PLATFORM)/
> +libs-y	+= arch/m68k/lib/
> +
> +archclean:
> +
> +endif


