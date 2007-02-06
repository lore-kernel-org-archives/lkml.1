Return-Path: <linux-kernel-owner+w=401wt.eu-S965289AbXBFAhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965289AbXBFAhw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 19:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965305AbXBFAhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 19:37:52 -0500
Received: from terminus.zytor.com ([192.83.249.54]:54603 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965289AbXBFAhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 19:37:51 -0500
Message-ID: <45C7CDD7.20806@zytor.com>
Date: Mon, 05 Feb 2007 16:37:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Etienne Lorrain <etienne_lorrain@yahoo.fr>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Compressed ia32 ELF file generation for loading by Gujin
 1/3
References: <522909.27613.qm@web26909.mail.ukl.yahoo.com>
In-Reply-To: <522909.27613.qm@web26909.mail.ukl.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

First of all, if sending attached patches, *MAKE SURE* they're text/plain.

> diff -uprN -X linux-2.6.20/Documentation/dontdiff linux-2.6.20/arch/i386/kernel/setup.c linux-2.6.20-gujin/arch/i386/kernel/setup.c
> --- linux-2.6.20/arch/i386/kernel/setup.c       2007-02-04 18:44:54.000000000 +0000
> +++ linux-2.6.20-gujin/arch/i386/kernel/setup.c 2007-02-05 21:27:01.000000000 +0000
> @@ -579,6 +579,19 @@ void __init setup_arch(char **cmdline_p)
>         strlcpy(command_line, saved_command_line, COMMAND_LINE_SIZE);
>         *cmdline_p = command_line;
> 
> +       /*
> +        * If the command line begin with '/', it is the filename of the
> +        * kernel file - like a shell command line. That can be used to
> +        * deduce where root was located when the kernel was compiled,
> +        * inside a directory of root named /boot, inside a small partition
> +        * mounted on a directory of root named /boot or in the root
> +        * directory itself.
> +        */
> +       if (**cmdline_p == '/')
> +               while (**cmdline_p != ' ' && **cmdline_p != '\t'
> +                       && **cmdline_p != '\n' && **cmdline_p != '\0')
> +                       ++*cmdline_p;
> +
>         max_low_pfn = setup_memory();
> 
>         /*

The standard way to do this is to have a command line argument named 
BOOT_IMAGE (as in BOOT_IMAGE=/foo/bar/baz).  There is no reason to do 
this differently from every other bootloader.

Why build the real-mode code as part of the kernel binary?  If you have 
to reference kernel symbols, you can do that with the -R option to ld. 
Bundling it into the kernel binary just to then extract it later is 
silly at best.

> @@ -1106,6 +1179,9 @@ help:
>         @echo  'Other generic targets:'
>         @echo  '  all             - Build all targets marked with [*]'
>         @echo  '* vmlinux         - Build the bare kernel'
> +       @echo  "  /boot/linux-$(KERNELRELEASE).kgz - create a boot kernel for the Gujin bootloader"
> +       @echo  '  /boot/linux.kgz ROOT=/dev/hda1   - do not autodetect root filesystem at boot time'
> +       @echo  '  /boot/linux.kgz ROOT=auto        - root filesystem from current /proc/cmdline'
>         @echo  '* modules         - Build all modules'
>         @echo  '  modules_install - Install all modules to INSTALL_MOD_PATH (default: /)'
>         @echo  '  dir/            - Build all files in dir and below'

This doesn't exactly fit very well the standard pattern.  Something like 
  make gujin TARGET=... would be more like it.

Given how many of your files are highly Gujin-specific, and have generic 
names, please put them in a subdirectory (e.g. arch/i386/boot/gujin/).

	-hpa
