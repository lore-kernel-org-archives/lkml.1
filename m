Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbYIGJAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbYIGJAb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 05:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbYIGJAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 05:00:22 -0400
Received: from crmm.lgl.lu ([158.64.72.228]:55537 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbYIGJAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 05:00:20 -0400
Message-ID: <48C397ED.4010201@knaff.lu>
Date: Sun, 07 Sep 2008 10:59:25 +0200
From: Alain Knaff <alain@knaff.lu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] init: bzip2 or lzma -compressed kernels and initrds
References: <200809062119.m86LJ5Of026101@hitchhiker.org.lu> <20080907054831.GA2244@1wt.eu>
In-Reply-To: <20080907054831.GA2244@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> Hi Alain,
> 
> On Sat, Sep 06, 2008 at 11:19:05PM +0200, Alain Knaff wrote:
>> From: Alain Knaff <alain@knaff.lu>
>>
>> This patch, based on an idea by Christian Ludwig, includes support for
>> compressing the kernel with bzip2 or lzma rather than gzip. Both
>> compressors give smaller sizes than gzip.  Moreover, lzma's
>> decompresses faster than gzip.
> 
> So it must have evolved a lot, because last time I considered it
> (about 2 years ago), it was the opposite, it needed about 2 minutes
> to decompress a kernel on a small machine (650 MHz). It was a shame
> because there was a huge space gain, which is important on flash.

See my other mail. This was a typo, lzma decompresses faster than
_bzip_, but not _gzip_.  Sorry for the confusion. Nowadays lzma is about
twice as slow as gzip.

>> +#ifdef CONFIG_KERNEL_BZIP2
>> +	putstr("\nBunzipping Linux... ");
>> +	bunzip2(input_data, input_len-4, NULL, compr_flush, NULL);
>> +#endif
>> +#ifdef CONFIG_KERNEL_LZMA
>> +	putstr("\nUnlzmaing Linux... ");
>> +	unlzma(input_data, input_len, NULL, output, NULL);
>> +#endif
> 
> You should not change the messages above, it does not make sense.

It does make sense for the clumsy who forget to actually copy their
kernel to where it will be booted from. These messages make it obvious
whether you are indeed booting lzma when you think you should.. :)

> What struck me is "unlzmaing" which is almost an unparsable word.
> If you really want to indicate the algo, better add it in parenthesis :
> "Decompressing Linux (LZMA)..."

ok for that. Decompressing Linux (LZMA)... it will be.

> but even that I don't find very useful.
> 
>> +#ifdef CONFIG_KERNEL_GZIP
>>  	makecrc();
>>  	putstr("\nDecompressing Linux... ");
>>  	gunzip();
>> +#endif
> 
>> --- linux-2.6.26.3/include/asm-x86/boot.h	2008-08-20 20:11:37.000000000 +0200
>> +++ linux-2.6.26.3udpcast/include/asm-x86/boot.h	2008-09-06 21:33:56.000000000 +0200
>> @@ -17,12 +17,23 @@
>>  				+ (CONFIG_PHYSICAL_ALIGN - 1)) \
>>  				& ~(CONFIG_PHYSICAL_ALIGN - 1))
>>  
>> +#if (defined CONFIG_KERNEL_BZIP2 || defined CONFIG_KERNEL_LZMA)
>> +#define BOOT_HEAP_SIZE             0x400000
>> +#else
> 
> Does it mean it will always need at least 4 MB for decompressing ?

It's complicated... Lzma's memory needs depend on the file being
decompressed. The first byte tells how much is needed. Here is the
relevant info from decompress_unlzma.c:

...
#define LZMA_BASE_SIZE 1846
#define LZMA_LIT_SIZE 768
...
	uint16_t *p;
...
	mi = header.pos / 9;
	lc = header.pos % 9;
	pb = mi / 5;
	lp = mi % 5;
...
	num_probs = LZMA_BASE_SIZE + (LZMA_LIT_SIZE << (lc + lp));
	p = large_malloc(num_probs * sizeof(*p));

Where header.pos is the first byte of the file.

In most cases of kernel compression that I saw, even with lzma -9, that
first byte was 0x5d = 93.
So lc = 3 and lp = 0.
Meaning a malloc of (1846 + 768 << 3) * 2 = 15980 which would even fit
into the default heap of 16384 bytes.

However, in a theoretical worst case, this could balloon up to lc=8 lp=4:

(1846 + 768 << 12) * 2 = 6295148, i.e. more than 6MB.

bzip2, on the other hand, needs a constant space of a little bit more
than 40000 bytes.

The best move would probably be sure to move the heap at end of memory
(rather than in the middle of bss segment where it is now) and not
specify any size at all.


... but now that I think about it, I've actually got 0x5d hardwired as a
magic number for the initrd (see below), and in all the years since I
use this in udpcast, it never happened that it was anything else (or
else it would have failed to boot, as initrd would not have recognized
the magic number). So 15980 bytes should be ok in almost all cases => no
extra heap space needed for LZMA!

> If
> so, you should explicitly state it in the config help so that persons
> running embedded systems (the more tempted ones by LZMA/BZIP2) do not
> waste their time on it if they have too low resources.

Noted. I'll add this to the next version.

>> --- linux-2.6.26.3/include/linux/decompress_bunzip2.h	1970-01-01 01:00:00.000000000 +0100
>> +++ linux-2.6.26.3udpcast/include/linux/decompress_bunzip2.h	2008-09-05 23:51:20.000000000 +0200
>> +#ifndef STATIC
>> +#define STATIC extern
>> +#endif
>> +
>> +#ifndef INIT
>> +#define INIT /* */
>> +#endif
> 
> Are you sure you will never run into trouble with such defines ? I don't
> see the reason for the #ifndef, maybe you'd prefer #undef to force their
> declaration ?

This is done to make the file work in both contexts:
 - initrd/initramfs where everything is linked, so functions should be
extern
 - boot/compressed/misc.c where everything (including code) is
#include'd where functions should be static.

... but on a second though, in the last case, I actually don't need to
include the header, so this will go away in next version (this evening
or tomorrow)

>> --- linux-2.6.26.3/init/do_mounts_rd.c	2008-08-20 20:11:37.000000000 +0200
>> +++ linux-2.6.26.3udpcast/init/do_mounts_rd.c	2008-09-05 17:35:30.000000000 +0200
>> @@ -72,6 +80,7 @@ identify_ramdisk_image(int fd, int start
>>  	sys_lseek(fd, start_block * BLOCK_SIZE, 0);
>>  	sys_read(fd, buf, size);
>>  
>> +#ifdef CONFIG_RD_GZIP
>>  	/*
>>  	 * If it matches the gzip magic numbers, return -1
>>  	 */
>> @@ -79,9 +88,39 @@ identify_ramdisk_image(int fd, int start
>>  		printk(KERN_NOTICE
>>  		       "RAMDISK: Compressed image found at block %d\n",
>>  		       start_block);
>> +		*ztype = 0;
>> +		nblocks = 0;
>> +		goto done;
>> +	}
>> +#endif
>> +
>> +#ifdef CONFIG_RD_BZIP2
>> +	/*
>> +	 * If it matches the bzip magic numbers, return -1
>> +	 */
>> +	if (buf[0] == 0x42 && (buf[1] == 0x5a)) {
>> +		printk(KERN_NOTICE
>> +		       "RAMDISK: Bzipped image found at block %d\n",
>> +		       start_block);
>> +		*ztype = 1;
>> +		nblocks = 0;
>> +		goto done;
>> +	}
>> +#endif
>> +
>> +#ifdef CONFIG_RD_LZMA
>> +	/*
>> +	 * If it matches the bzip magic numbers, return -1
>> +	 */
>> +	if (buf[0] == 0x5d && (buf[1] == 0x00)) {
                      ^^^^
Yeah, that's the accidentally hardwired magic number that I mentioned.

>> +		printk(KERN_NOTICE
>> +		       "RAMDISK: Lzma image found at block %d\n",
>> +		       start_block);
>> +		*ztype = 2;
>>  		nblocks = 0;
>>  		goto done;
>>  	}
>> +#endif
> 
> I'm wondering if it's really worth having all those #ifdef/#endif.
> After all, if you leave it to the caller to check ztype depending
> on what is enabled, it would even be better, because the correct
> image type will have been identified and indicated before being
> refused in case of mismatch. This is helpful for people who will
> use more than one format (eg: all those who will slowly migrate
> from gzip).

Well, the #ifdef's are there to avoid booting an image type that would
not be supported. But I could print out an error message instead, if
somebody tries to load an initramfs compressed by an unconfigured
compressor.

> 
>> +#ifdef CONFIG_RD_GZIP
>> +		case 0:
>> +			if (crd_load(in_fd, out_fd) == 0)
>> +				goto successful_load;
>> +			break;
>> +#endif
>> +
>> +#ifdef CONFIG_RD_BZIP2
>> +		case 1:
>> +			if (crd_load_bzip2(in_fd, out_fd) == 0)
>> +				goto successful_load;
>> +			break;
>> +#endif
>> +
>> +#ifdef CONFIG_RD_LZMA
>> +		case 2:
>> +			if (crd_load_lzma(in_fd, out_fd) == 0)
>> +				goto successful_load;
>> +			break;
>> +#endif
> 
> Just a suggestion : create an array filled with pointers to the
> various decompression methods, or NULL when not defined. Here,
> you'd just do :
>      if (crd_loader[ztype]) {
>         if (cdr_loader[ztype](in_fd, out_fd) == 0)
>            goto successful_load;
>      } else {
>         printk(KERN_ERR "No decompressor for image type %d\n", ztype);
>      }

Noted.

>> +#ifdef CONFIG_RD_BZIP2
>> +#include <linux/decompress_bunzip2.h>
>> +#undef STATIC
>> +#endif
> 
>> +#ifdef CONFIG_RD_LZMA
>> +#include <linux/decompress_unlzma.h>
>> +#undef STATIC
>> +#endif
> 
> This becomes a bit more horrible... It would be nice if you could get
> rid of these STATIC and INIT defines.

Will go away. The #define STATIC was only necessary for compilation of
misc.c, but in that case, I could get by by not including the .h files
in the first palce.

>> +#if (defined CONFIG_RD_BZIP2 || defined CONFIG_RD_LZMA)
> 
> Stupid question: can't we use the same code here for all 3 decompressors ?

We could. However, in the existing code, gzip exposed parts of its
internal variables (insize and inptr) to its callers, which I wanted to
avoid for the new decompressors. At the same time, I wanted to "disturb"
gzip as little as possible. This is probably an error. I really should
only have one function (compr_fill) and wrap that within lib/inflate.c
in order to satisfy gzip.

>> +static int __init compr_fill(void *buf, unsigned int len)
>> +{
>> +	int r = sys_read(crd_infd, buf, len);
>> +	if (r < 0)
>> +		printk(KERN_ERR "RAMDISK: error while reading compressed data");
>> +	else if (r == 0)
>> +		printk(KERN_ERR "RAMDISK: EOF while reading compressed data");
>> +	return r;
>> +}
>> +#endif
> 
>> +#if (defined CONFIG_RD_BZIP2 || defined CONFIG_RD_LZMA)
>> +static int __init compr_flush(void *window, unsigned int outcnt)
> 
> same question here ?

same answer...

[...]
>> +config KERNEL_LZMA
>> +       bool "LZMA"
>> +       help
>> +         The most recent compression algorithm.
>> +	 Its ratio is best, decompression speed is between the other
>> +	 2. Compression is slowest.
>> +	 The kernel size is about 33 per cent smaller with lzma,
>> +	 in comparison to gzip.
> 
> isn't memory usage in the same range as bzip2 ?

Common case is less (15K vs 40K), worst case (never observed in
practice...) is much more (6MB)

>> --- linux-2.6.26.3/scripts/Makefile.lib	2008-08-20 20:11:37.000000000 +0200
>> +++ linux-2.6.26.3udpcast/scripts/Makefile.lib	2008-09-06 21:33:15.000000000 +0200
>> @@ -173,3 +173,17 @@ quiet_cmd_gzip = GZIP    $@
>>  cmd_gzip = gzip -f -9 < $< > $@
>>  
>>  
>> +# Bzip2
>> +# ---------------------------------------------------------------------------
>> +
>> +# Bzip2 does not include size in file... so we have to fake that
>> +size_append=perl -e 'print(pack("i",(stat($$ARGV[0]))[7]));'
>> +
>> +quiet_cmd_bzip2 = BZIP2    $@
>> +cmd_bzip2 = (bzip2 -9 < $< ; $(size_append) $<) > $@
> 
> It would be the only command in the build process that requires perl. While
> not a disaster, it's a bit annoying to introduce a new build dependency.

ok. I thought that perl is already used elsewhere during kernel
compilation... or has that been cleaned up? (... it was already a while
ago since I first wrote this...)

> You may want to experiment with command-line tools such as stat and printf,
> I have one horrible version working at the command line below, I have
> "makefilified" it but not tested it :

ok

> size_append = stat -c "%s"
> cmd_bzip2 = (bzip2 -9 < $< ; x=$(size_append) $<; printf $$(printf '\\x%02x\\x%02x\\x%02x\\x%02x\n' $$((x&255)) $$(((x>>8)&255)) $$(((x>>16)&255)) $$(((x>>24)&255))))

ooops... I'm not a big fan of hacky one-liners, it's too easy for errors
to sneak in...

> The inner printf writes '\xXX' for each octet of the size, and the outer
> printf outputs the equivalent characters.

I think I'll put that into a shell script under scripts/ and call the
script...

> That's all from me. I think I will give it a try, as I'm still interested
> in reducing image sizes, especially when I put a whole rootfs in the initramfs,
> because it creates very large kernel images.
> 
> Regards,
> Willy

Thanks for your interest. I think I'll have a new version ready with
most of your suggestions by tomorrow evening.

Alain
