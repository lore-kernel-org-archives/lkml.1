Return-Path: <linux-kernel-owner+w=401wt.eu-S1753839AbYIGFsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbYIGFsz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 01:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbYIGFsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 01:48:46 -0400
Received: from 1wt.eu ([62.212.114.60]:3373 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbYIGFsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 01:48:45 -0400
Date: Sun, 7 Sep 2008 07:48:31 +0200
From: Willy Tarreau <w@1wt.eu>
To: Alain Knaff <alain@knaff.lu>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] init: bzip2 or lzma -compressed kernels and initrds
Message-ID: <20080907054831.GA2244@1wt.eu>
References: <200809062119.m86LJ5Of026101@hitchhiker.org.lu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809062119.m86LJ5Of026101@hitchhiker.org.lu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alain,

On Sat, Sep 06, 2008 at 11:19:05PM +0200, Alain Knaff wrote:
> From: Alain Knaff <alain@knaff.lu>
> 
> This patch, based on an idea by Christian Ludwig, includes support for
> compressing the kernel with bzip2 or lzma rather than gzip. Both
> compressors give smaller sizes than gzip.  Moreover, lzma's
> decompresses faster than gzip.

So it must have evolved a lot, because last time I considered it
(about 2 years ago), it was the opposite, it needed about 2 minutes
to decompress a kernel on a small machine (650 MHz). It was a shame
because there was a huge space gain, which is important on flash.

> +#ifdef CONFIG_KERNEL_BZIP2
> +	putstr("\nBunzipping Linux... ");
> +	bunzip2(input_data, input_len-4, NULL, compr_flush, NULL);
> +#endif
> +#ifdef CONFIG_KERNEL_LZMA
> +	putstr("\nUnlzmaing Linux... ");
> +	unlzma(input_data, input_len, NULL, output, NULL);
> +#endif

You should not change the messages above, it does not make sense.
What struck me is "unlzmaing" which is almost an unparsable word.
If you really want to indicate the algo, better add it in parenthesis :
"Decompressing Linux (LZMA)..." but even that I don't find very useful.

> +#ifdef CONFIG_KERNEL_GZIP
>  	makecrc();
>  	putstr("\nDecompressing Linux... ");
>  	gunzip();
> +#endif

> --- linux-2.6.26.3/include/asm-x86/boot.h	2008-08-20 20:11:37.000000000 +0200
> +++ linux-2.6.26.3udpcast/include/asm-x86/boot.h	2008-09-06 21:33:56.000000000 +0200
> @@ -17,12 +17,23 @@
>  				+ (CONFIG_PHYSICAL_ALIGN - 1)) \
>  				& ~(CONFIG_PHYSICAL_ALIGN - 1))
>  
> +#if (defined CONFIG_KERNEL_BZIP2 || defined CONFIG_KERNEL_LZMA)
> +#define BOOT_HEAP_SIZE             0x400000
> +#else

Does it mean it will always need at least 4 MB for decompressing ? If
so, you should explicitly state it in the config help so that persons
running embedded systems (the more tempted ones by LZMA/BZIP2) do not
waste their time on it if they have too low resources.

> --- linux-2.6.26.3/include/linux/decompress_bunzip2.h	1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.26.3udpcast/include/linux/decompress_bunzip2.h	2008-09-05 23:51:20.000000000 +0200
> +#ifndef STATIC
> +#define STATIC extern
> +#endif
> +
> +#ifndef INIT
> +#define INIT /* */
> +#endif

Are you sure you will never run into trouble with such defines ? I don't
see the reason for the #ifndef, maybe you'd prefer #undef to force their
declaration ?

> --- linux-2.6.26.3/init/do_mounts_rd.c	2008-08-20 20:11:37.000000000 +0200
> +++ linux-2.6.26.3udpcast/init/do_mounts_rd.c	2008-09-05 17:35:30.000000000 +0200
> @@ -72,6 +80,7 @@ identify_ramdisk_image(int fd, int start
>  	sys_lseek(fd, start_block * BLOCK_SIZE, 0);
>  	sys_read(fd, buf, size);
>  
> +#ifdef CONFIG_RD_GZIP
>  	/*
>  	 * If it matches the gzip magic numbers, return -1
>  	 */
> @@ -79,9 +88,39 @@ identify_ramdisk_image(int fd, int start
>  		printk(KERN_NOTICE
>  		       "RAMDISK: Compressed image found at block %d\n",
>  		       start_block);
> +		*ztype = 0;
> +		nblocks = 0;
> +		goto done;
> +	}
> +#endif
> +
> +#ifdef CONFIG_RD_BZIP2
> +	/*
> +	 * If it matches the bzip magic numbers, return -1
> +	 */
> +	if (buf[0] == 0x42 && (buf[1] == 0x5a)) {
> +		printk(KERN_NOTICE
> +		       "RAMDISK: Bzipped image found at block %d\n",
> +		       start_block);
> +		*ztype = 1;
> +		nblocks = 0;
> +		goto done;
> +	}
> +#endif
> +
> +#ifdef CONFIG_RD_LZMA
> +	/*
> +	 * If it matches the bzip magic numbers, return -1
> +	 */
> +	if (buf[0] == 0x5d && (buf[1] == 0x00)) {
> +		printk(KERN_NOTICE
> +		       "RAMDISK: Lzma image found at block %d\n",
> +		       start_block);
> +		*ztype = 2;
>  		nblocks = 0;
>  		goto done;
>  	}
> +#endif

I'm wondering if it's really worth having all those #ifdef/#endif.
After all, if you leave it to the caller to check ztype depending
on what is enabled, it would even be better, because the correct
image type will have been identified and indicated before being
refused in case of mismatch. This is helpful for people who will
use more than one format (eg: all those who will slowly migrate
from gzip).

> +#ifdef CONFIG_RD_GZIP
> +		case 0:
> +			if (crd_load(in_fd, out_fd) == 0)
> +				goto successful_load;
> +			break;
> +#endif
> +
> +#ifdef CONFIG_RD_BZIP2
> +		case 1:
> +			if (crd_load_bzip2(in_fd, out_fd) == 0)
> +				goto successful_load;
> +			break;
> +#endif
> +
> +#ifdef CONFIG_RD_LZMA
> +		case 2:
> +			if (crd_load_lzma(in_fd, out_fd) == 0)
> +				goto successful_load;
> +			break;
> +#endif

Just a suggestion : create an array filled with pointers to the
various decompression methods, or NULL when not defined. Here,
you'd just do :
     if (crd_loader[ztype]) {
        if (cdr_loader[ztype](in_fd, out_fd) == 0)
           goto successful_load;
     } else {
        printk(KERN_ERR "No decompressor for image type %d\n", ztype);
     }

> +#ifdef CONFIG_RD_BZIP2
> +#include <linux/decompress_bunzip2.h>
> +#undef STATIC
> +#endif

> +#ifdef CONFIG_RD_LZMA
> +#include <linux/decompress_unlzma.h>
> +#undef STATIC
> +#endif

This becomes a bit more horrible... It would be nice if you could get
rid of these STATIC and INIT defines.

> +#if (defined CONFIG_RD_BZIP2 || defined CONFIG_RD_LZMA)

Stupid question: can't we use the same code here for all 3 decompressors ?

> +static int __init compr_fill(void *buf, unsigned int len)
> +{
> +	int r = sys_read(crd_infd, buf, len);
> +	if (r < 0)
> +		printk(KERN_ERR "RAMDISK: error while reading compressed data");
> +	else if (r == 0)
> +		printk(KERN_ERR "RAMDISK: EOF while reading compressed data");
> +	return r;
> +}
> +#endif

> +#if (defined CONFIG_RD_BZIP2 || defined CONFIG_RD_LZMA)
> +static int __init compr_flush(void *window, unsigned int outcnt)

same question here ?

> +{
> +	int written = sys_write(crd_outfd, window, outcnt);
> +	if (written != outcnt) {
> +		printk(KERN_ERR "RAMDISK: incomplete write (%d != %d)\n",
> +		       written, outcnt);
> +	}
> +	return outcnt;
> +}
> +#endif
> +#if (defined CONFIG_RD_BZIP2 || defined CONFIG_RD_LZMA)
> +static int __init crd_load_compr(int in_fd, int out_fd, int size,

and here ?

> +				 int (*deco)(char *, int,
> +					     int(*fill)(void*, unsigned int),
> +					     int(*flush)(void*, unsigned int),
> +					     int *))


> --- linux-2.6.26.3/init/Kconfig	2008-08-20 20:11:37.000000000 +0200
> +++ linux-2.6.26.3udpcast/init/Kconfig	2008-09-05 07:35:43.000000000 +0200
> +config KERNEL_BZIP2
> +	bool "Bzip2"
> +	help
> +	  Its compression ratio and speed is intermediate.
> +	  Decompression speed is slowest among the 3.
> +	  The kernel size is about 10 per cent smaller with bzip2,
> +	  in comparison to gzip.
> +	  Bzip2 uses a large amount of memory. For modern kernels
> +	  you will need at least 8MB RAM or more for booting.

Ah, fine, this is indicated.

> +config KERNEL_LZMA
> +       bool "LZMA"
> +       help
> +         The most recent compression algorithm.
> +	 Its ratio is best, decompression speed is between the other
> +	 2. Compression is slowest.
> +	 The kernel size is about 33 per cent smaller with lzma,
> +	 in comparison to gzip.

isn't memory usage in the same range as bzip2 ?

> --- linux-2.6.26.3/scripts/Makefile.lib	2008-08-20 20:11:37.000000000 +0200
> +++ linux-2.6.26.3udpcast/scripts/Makefile.lib	2008-09-06 21:33:15.000000000 +0200
> @@ -173,3 +173,17 @@ quiet_cmd_gzip = GZIP    $@
>  cmd_gzip = gzip -f -9 < $< > $@
>  
>  
> +# Bzip2
> +# ---------------------------------------------------------------------------
> +
> +# Bzip2 does not include size in file... so we have to fake that
> +size_append=perl -e 'print(pack("i",(stat($$ARGV[0]))[7]));'
> +
> +quiet_cmd_bzip2 = BZIP2    $@
> +cmd_bzip2 = (bzip2 -9 < $< ; $(size_append) $<) > $@

It would be the only command in the build process that requires perl. While
not a disaster, it's a bit annoying to introduce a new build dependency.

You may want to experiment with command-line tools such as stat and printf,
I have one horrible version working at the command line below, I have
"makefilified" it but not tested it :

size_append = stat -c "%s"
cmd_bzip2 = (bzip2 -9 < $< ; x=$(size_append) $<; printf $$(printf '\\x%02x\\x%02x\\x%02x\\x%02x\n' $$((x&255)) $$(((x>>8)&255)) $$(((x>>16)&255)) $$(((x>>24)&255))))

The inner printf writes '\xXX' for each octet of the size, and the outer
printf outputs the equivalent characters.

That's all from me. I think I will give it a try, as I'm still interested
in reducing image sizes, especially when I put a whole rootfs in the initramfs,
because it creates very large kernel images.

Regards,
Willy

