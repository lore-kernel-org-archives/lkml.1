Return-Path: <linux-kernel-owner+w=401wt.eu-S1754297AbYEWQkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbYEWQkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 12:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750931AbYEWQkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 12:40:31 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:47852 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189AbYEWQka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 12:40:30 -0400
Date: Fri, 23 May 2008 18:41:09 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, aoliva@redhat.com, alan@lxorguk.ukuu.org.uk,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Haroldo Gamal <gamal@alternex.com.br>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
Message-ID: <20080523164108.GA31545@uranus.ravnborg.org>
References: <1211550282.28967.8.camel@pmac.infradead.org> <1211550374.28967.10.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211550374.28967.10.camel@pmac.infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David.

On Fri, May 23, 2008 at 02:46:14PM +0100, David Woodhouse wrote:
> This allows arbitrary firmware files to be included in the static kernel
> where the firmware loader can find them without requiring userspace to
> be alive.
> 
> Signed-off-by: David Woodhouse <dwmw2@infradead.org>
> ---
>  Makefile             |    2 +-
>  drivers/base/Kconfig |   12 ++++++++++++
>  firmware/Makefile    |   23 +++++++++++++++++++++++
>  3 files changed, 36 insertions(+), 1 deletions(-)
>  create mode 100644 firmware/Makefile
> 
> diff --git a/Makefile b/Makefile
> index 20b3235..ac2ab7e 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -450,7 +450,7 @@ scripts: scripts_basic include/config/auto.conf
>  
>  # Objects we will link into vmlinux / subdirs we need to visit
>  init-y		:= init/
> -drivers-y	:= drivers/ sound/
> +drivers-y	:= drivers/ sound/ firmware/
>  net-y		:= net/
>  libs-y		:= lib/
>  core-y		:= usr/
> diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> index d7da109..687f097 100644
> --- a/drivers/base/Kconfig
> +++ b/drivers/base/Kconfig
> @@ -34,6 +34,18 @@ config FW_LOADER
>  	  require userspace firmware loading support, but a module built outside
>  	  the kernel tree does.
>  
> +config BUILTIN_FIRMWARE
> +       string "Firmware blobs to build into the kernel binary"
> +       depends on FW_LOADER
> +       help
> +         This option allows firmware to be built into the kernel, for the cases
> +	 where the user either cannot or doesn't want to provide it from
> +	 userspace at runtime (for example, when the firmware in question is
> +	 required for accessing the boot device, and the user doesn't want to
> +	 use an initrd). Multiple files should be separated with spaces, and
> +	 the required files should exist under the firmware/ directory in
> +	 the source tree.
> +
>  config DEBUG_DRIVER
>  	bool "Driver Core verbose debug messages"
>  	depends on DEBUG_KERNEL
> diff --git a/firmware/Makefile b/firmware/Makefile
> new file mode 100644
> index 0000000..184b8ef
> --- /dev/null
> +++ b/firmware/Makefile
> @@ -0,0 +1,23 @@
> +#
> +# kbuild file for firmware/
> +#
> +
> +FIRMWARE_BINS := $(subst ",,$(CONFIG_BUILTIN_FIRMWARE))
> +FIRMWARE_OBJS := $(patsubst %,%.o, $(FIRMWARE_BINS))
> +FIRMWARE_SRCS := $(patsubst %,$(obj)/%.c, $(FIRMWARE_BINS))

My personal rule-of-thumb is to use lower case for
all local variables and UPPER case for global variables.

I know that outside the kernel everyone use UPPER case
for Makefile variables but that just not readable.
So in this code snippet I would have used lower case.

> +
> +
> +quiet_cmd_fwbin = MK_FW   $@
> +      cmd_fwbin = echo '/* File automatically generated */' > $@ ;	 \
> +		  echo '\#include <linux/firmware.h>' >> $@ ;		 \
> +		  echo 'static const unsigned char fw[] = {' >> $@ ;	 \
> +		  od -t x1 -A none -v $(srctree)/$(patsubst %.c,%,$@) | \
> +		   sed -e 's/ /, 0x/g' -e 's/^,//' -e 's/$$/,/' >> $@ ; \
> +		  echo '};' >> $@ ;					 \
> +		  echo 'DECLARE_BUILTIN_FIRMWARE("$(patsubst firmware/%.c,%,$@)",fw);' >> $@
A small comment is justified here.
Do not consider everyone to know od.
If you choose a deciaml output you do not need to add 0x

> +
> +$(FIRMWARE_SRCS): $(obj)/%.c: $(srctree)/$(obj)/%
> +	$(call cmd,fwbin)
> +
> +obj-y := $(FIRMWARE_OBJS)

Assignment to targets i smiisng so generated files are not cleaned
by "make clean".

targets := $(FIRMWARE_OBJS)

	Sam

