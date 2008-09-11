Return-Path: <linux-kernel-owner+w=401wt.eu-S1755960AbYIKXRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbYIKXRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 19:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624AbYIKXRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 19:17:10 -0400
Received: from crmm.lgl.lu ([158.64.72.228]:41681 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962AbYIKXRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 19:17:09 -0400
Message-ID: <48C9A6C0.4070802@knaff.lu>
Date: Fri, 12 Sep 2008 01:16:16 +0200
From: Alain Knaff <alain@knaff.lu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, w@1wt.eu
Subject: Re: [update3] [PATCH] init: bzip2 or lzma -compressed kernels and
 initrds
References: <200809090641.m896fscX028849@hitchhiker.org.lu> <48C99F29.2030007@zytor.com>
In-Reply-To: <48C99F29.2030007@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Looks a lot better now.  See the following, though:

Thanks :)

> 
>> -#define OF(args)    args
>>  #define STATIC        static
>> +#define NEW_CODE
> 
> Should be deleted, right?

Is already deleted in update4, posted yesterday.

>> -    phdrs = malloc(sizeof(*phdrs) * ehdr.e_phnum);
>> +    phdrs = (void *) malloc(sizeof(*phdrs) * ehdr.e_phnum);
>>      if (!phdrs)
> 
> malloc() returns a void pointer already...

ok, I'll consider this for update5

>> +
>> +#ifdef CONFIG_RD_BZIP2
>> +    /*
>> +     * If it matches the bzip magic numbers, return -1
>> +     */
>> +    if (buf[0] == 0x42 && (buf[1] == 0x5a)) {
>> +        printk(KERN_NOTICE
>> +               "RAMDISK: Bzipped image found at block %d\n",
>> +               start_block);
>> +        *uncompressor = bunzip2;
>>          nblocks = 0;
>>          goto done;
>>      }
>> +#endif
>> +
>> +#ifdef CONFIG_RD_LZMA
>> +    /*
>> +     * If it matches the bzip magic numbers, return -1
>                              ^^^^
>                              ????
>> +     */
>> +    if (buf[0] == 0x5d && (buf[1] == 0x00)) {
>> +        printk(KERN_NOTICE
>> +               "RAMDISK: Lzma image found at block %d\n",
>> +               start_block);

noted, will be fixed in update5

>> -#define OF(args)  args
>> +#ifdef CONFIG_RD_BZIP2
>> +#include <linux/decompress_bunzip2.h>
>> +#endif
>> +#ifdef CONFIG_RD_LZMA
>> +#include <linux/decompress_unlzma.h>
>>  #endif
> 
> There is no reason to include header files conditionally.
> 
> It might be worthwhile to create a proper subdirectory rather than using
> an underscored namespace (also, in general, dashes are preferred in
> filenames.)

I hate to contradict you, but in that case, lots of other filenames
would need fixing too:

> ls include/linux/*_*.h
include/linux/8250_pci.h             include/linux/linux_logo.h
include/linux/ac97_codec.h           include/linux/lm_interface.h
include/linux/acpi_pmtmr.h           include/linux/memory_hotplug.h
include/linux/adfs_fs.h              include/linux/minix_fs.h
include/linux/adfs_fs_i.h            include/linux/mm_inline.h
include/linux/adfs_fs_sb.h           include/linux/mm_types.h
include/linux/affs_hardblocks.h      include/linux/mmu_notifier.h
include/linux/agp_backend.h          include/linux/mnt_namespace.h
include/linux/aio_abi.h              include/linux/mod_devicetable.h
include/linux/anon_inodes.h          include/linux/msdos_fs.h
....

And dashes are not even in the majority:

> ls include/linux/*-*.h | wc
     67      67    1867
> ls include/linux/*_*.h | wc
    282     282    7598

Any other people want to chime in about this before I make update5? I'm
all for adopting common coding standards, but only if they are actually
common...

>> +#ifndef always_inline
>> +#  if defined(__GNUC__) && (__GNUC__ > 3 || __GNUC__ == 3 &&
>> __GNUC_MINOR__ > 0)
>> +#    define always_inline __attribute__((always_inline)) inline
>> +#  else
>> +#    define always_inline inline
>> +#  endif
>> +#endif
> 
> Any reason to not just use <linux/compiler.h> here?

As you may have understood, the decompressors themselves are samples
and/or reference implementations downloaded from elsewhere, and thus
might not be up to the coding standards of the rest of the kernel.

... but the same can be said of inflate.c (the existing gzip
decompressor), which would not pass muster either (and indeed, the only
scripts/checkpatch.pl WARNINGS of my patch are about funny indentation
of inflate.c that happen in the context of my changes...)

There's a fine line to walk here between "bringing up" these codes to
standard (at the risk of breaking them...) or touching the decompressing
engines as little as possible.

But, I've taken note for update5...

>> +#ifdef CONFIG_FEATURE_LZMA_FAST
>> +#  define speed_inline always_inline
>> +#else
>> +#  define speed_inline
>> +#endif
> 
> Should this be always_inline or just plain inline?
> 
>     -hpa

Same remark: this is 3rd party code which I preferred to touch as little
as possible...

Alain
