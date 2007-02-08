Return-Path: <linux-kernel-owner+w=401wt.eu-S1752331AbXBHOC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbXBHOC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 09:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423008AbXBHOC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 09:02:59 -0500
Received: from raven.upol.cz ([158.194.120.4]:41251 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbXBHOC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 09:02:58 -0500
Subject: Re: + search-a-little-harder-for-mkimage.patch added to -mm tree
References: <200702080607.l1867c0D006861@shell0.pdx.osdl.net>
Organization: Palacky University in Olomouc, experimental physics department.
To: akpm@linux-foundation.org
Cc: vapier.adi@gmail.com, olecom@flower.upol.cz, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Date: Thu, 8 Feb 2007 15:11:36 +0100
Message-Id: <E1HF9zs-0006Ei-2k@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: akpm@linux-foundation.org
> Newsgroups: gmane.linux.kernel.commits.mm
> Subject: + search-a-little-harder-for-mkimage.patch added to -mm tree
> Date: Wed, 07 Feb 2007 22:07:38 -0800
[]
> ------------------------------------------------------
> Subject: search a little harder for mkimage
> From: "Mike Frysinger" <vapier.adi@gmail.com>
>
> Check to see if `${CROSS_COMPILE}mkimage` exists and if not, fall back to
> the standard `mkimage`

Understanding of what mkuboot.sh is doing leads to:

-- ordinary addition of PATH to (possible) executable, named mkimage;
-- in case of any other problem to execute it: permissions, aliasing due to
   wrong $PATH (and setting it up isn't handle either), script will print
   *wrong* message, in case of CROSS_COMPILE filename;
-- minor overkill due to double wrapping of all of this;

`make' itself executes programs by search $PATH, prints *right*
messages in case of errors.

Unless author of the patch or script itself have really strong position to
not remove it, please.

There are currently four users of this, all like this:

MKIMAGE := $(srctree)/scripts/mkuboot.sh
[...]
quiet_cmd_uimage = UIMAGE  $@
      cmd_uimage = $(CONFIG_SHELL) $(MKIMAGE) -A sh -O linux -T kernel \
                    -C gzip -a $(KERNEL_LOAD) -e $(KERNEL_LOAD) \
                    -n'Linux-$(KERNELRELEASE)' -d $< $@

proposition is to substitute:
     "$(CONFIG_SHELL) $(MKIMAGE)"
with
     "mkimage"

and optional, for particular Makefile, "$(CROSS_COMPILE)" prefix.
Remove mkuboot.sh.

> The Blackfin toolchain includes mkimage, but we dont want to namespace
> collide with any of the user's system setup, so we prefix it with our
> toolchain name.
>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Oleg Verych <olecom@flower.upol.cz>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  scripts/mkuboot.sh |   11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>
> diff -puN scripts/mkuboot.sh~search-a-little-harder-for-mkimage scripts/mkuboot.sh
> --- a/scripts/mkuboot.sh~search-a-little-harder-for-mkimage
> +++ a/scripts/mkuboot.sh
> @@ -4,12 +4,15 @@
>  # Build U-Boot image when `mkimage' tool is available.
>  #
>  
> -MKIMAGE=$(type -path mkimage)
> +MKIMAGE=$(type -path ${CROSS_COMPILE}mkimage)
>  
>  if [ -z "${MKIMAGE}" ]; then
> -	# Doesn't exist
> -	echo '"mkimage" command not found - U-Boot images will not be built' >&2
> -	exit 0;
> +	MKIMAGE=$(type -path mkimage)
> +	if [ -z "${MKIMAGE}" ]; then
> +		# Doesn't exist
> +		echo '"mkimage" command not found - U-Boot images will not be built' >&2
> +		exit 0;
> +	fi
>  fi
>  
>  # Call "mkimage" to create U-Boot image
> _
>
> Patches currently in -mm which might be from vapier.adi@gmail.com are
>
> search-a-little-harder-for-mkimage.patch
> scrub-non-__glibc__-checks-in-linux-socketh-and-linux-stath.patch
>
