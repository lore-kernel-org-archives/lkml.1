Return-Path: <linux-kernel-owner+w=401wt.eu-S1757121AbZFITKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121AbZFITKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 15:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266AbZFITKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 15:10:12 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:46091 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911AbZFITKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 15:10:10 -0400
Date: Tue, 9 Jun 2009 21:12:26 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: liqin.chen@sunplusct.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 01/27] score: create Kconfig Kconfig.debug Makefile
Message-ID: <20090609191226.GB7181@uranus.ravnborg.org>
References: <OF2086513E.4B4F803C-ON482575D0.0022E294-482575D0.0023688F@sunplusct.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF2086513E.4B4F803C-ON482575D0.0022E294-482575D0.0023688F@sunplusct.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some comments below.
Mostly nitpicking.

	Sam

> +
> +config GENERIC_IOMAP
> +       bool
> +       default y

The preference these days is the shorter:
config GENERIC_IOMAP
	def_bool y

Note that default for bool is n,
so a standalone "bool" is the same as "def_bool n".


This comment applies to all symbols
listed below this one.

> +config EARLY_PRINTK
> +       bool "Early printk" if EMBEDDED
> +       depends on SYS_HAS_EARLY_PRINTK

Arnd already commented on your "select EMBEDDED".
We usually hide "expert only" options behind EMBEDDED.

Do you really consider EARLY_PRINTK an expert only option?

> +config PAGE_SIZE_4KB
> +       bool
> +       default y

I see no need for this symbol unless you plan to support other
page sizes. "PAGE_SIZE_4KB" is not used outside arch/*


> diff --git a/arch/score/Makefile b/arch/score/Makefile
> new file mode 100644
> index 0000000..b86ec22
> --- /dev/null
> +++ b/arch/score/Makefile
> @@ -0,0 +1,50 @@
> +#
> +# arch/score/Makefile
> +#
> +# This file is subject to the terms and conditions of the GNU General 
> Public
> +# License.  See the file "COPYING" in the main directory of this archive
> +# for more details.
> +#
> +
> +KBUILD_DEFCONFIG := spct6600_defconfig
> +CROSS_COMPILE := score-linux-

This is a bit brutal to always assume a specific CROSS_COMPILE setting.
Consider using cc-cross-prefix - see arch/m68k/Makefile +
Documentation/kbuild/makefiles.txt


> +
> +#
> +# CPU-dependent compiler/assembler options for optimization.
> +#
> +cflags-y += -g -O2 -G0 -pipe -mel -mnhwloop -D__SCOREEL__ \
> +       -D__linux__ -ffunction-sections -ffreestanding

-g is picked up using a kernel option (CONFIG_DEBUG_ something).
Do not hard code it.

-O2 setting likewise - CONFIG_CC_OPTIMIZE_FOR_SIZE
-G0 ??
-ffunction-sections - Does this really work for you?
                      We have potential conflicts with
                      hardcoded section names.


> +#
> +# Board-dependent options and extra files
> +#
> +KBUILD_AFLAGS += $(cflags-y)
> +KBUILD_CFLAGS += $(cflags-y)
> +MODFLAGS += -mlong-calls

Grepping it is a mess how we do this today.
So MODFLAGS usage is as good as the other ways we do this.
I may clean this up one day.

> +LDFLAGS += --oformat elf32-littlescore
> +LDFLAGS_vmlinux        += -G0 -static -nostdlib

> +CLEAN_FILES += arch/score/kernel/vmlinux.lds
This is not needed.

> +
> +#
> +# Choosing incompatible machines durings configuration will result in
> +# error messages during linking.  Select a default linkscript if
> +# none has been choosen above.
> +#
Bogus comment?

> +
> +head-y := arch/score/kernel/head.o
> +libs-y += arch/score/lib/
> +core-y += arch/score/kernel/ arch/score/mm/
> +
> +boot := arch/score/boot
> +
> +vmlinux.bin: vmlinux
> +       $(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
> +
> +archclean:
> +       @$(MAKE) $(clean)=$(boot)
> +
> +define archhelp
> +       echo '  vmlinux.bin          - Raw binary boot image'
> +       echo
> +       echo '  These will be default as apropriate for a configured 
> platform.'
> +endef

	Sam
