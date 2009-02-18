Return-Path: <linux-kernel-owner+w=401wt.eu-S1754357AbZBRHt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357AbZBRHt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 02:49:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbZBRHtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 02:49:19 -0500
Received: from crmm.lgl.lu ([158.64.72.228]:47505 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237AbZBRHtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 02:49:18 -0500
Message-ID: <499BBD62.5090506@knaff.lu>
Date: Wed, 18 Feb 2009 08:48:50 +0100
From: Alain Knaff <alain@knaff.lu>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Jan Engelhardt <jengelh@medozas.de>,
       the arch/x86 maintainers <x86@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: tip: bzip2/lzma now in tip:x86/setup-lzma
References: <200901042146.n04LkHgP005837@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu> <4961415C.1050708@zytor.com> <49614243.70102@knaff.lu> <496142E4.8040308@zytor.com> <49614491.7020903@knaff.lu> <49614D1F.8020900@zytor.com> <alpine.LSU.2.00.0902172202230.5620@fbirervta.pbzchgretzou.qr> <499B267E.2090509@zytor.com> <20090217220825.GA24337@elte.hu> <20090217233708.GA10756@elte.hu> <499B5BCA.8000905@zytor.com>
In-Reply-To: <499B5BCA.8000905@zytor.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Ingo Molnar wrote:
>> still fails:
>>
>> [    3.196037] initcall inet_init+0x0/0x1e9 returned 0 after 101777 usecs           
>> [    3.202886] calling  af_unix_init+0x0/0x55 @ 1                                   
>> [    3.207461] NET: Registered protocol family 1                                    
>> [    3.211950] initcall af_unix_init+0x0/0x55 returned 0 after 4394 usecs           
>> [    3.218624] calling  populate_rootfs+0x0/0xd2 @ 1                                
>> [    3.223460] Kernel panic - not syncing: compression method gzip not configured   
>>
>> config attached.
>>
> 
> Okay, I think I've tracked down the problem.
> 
> The issue is that usr/Makefile doesn't correctly filter compression 
> methods which we don't support.  This particular case will happen when 
> you're building with Ingo's attached configuration *and no bzip2 tool 
> installed on the system*.

Weird. When I tried to reproduce this, I got the following error
instead, already during compilation:

  GEN     usr/initramfs_data.cpio.bz2
/home/alain/Projects/Udpcast/Kernels/linux.trees.git/scripts/gen_initramfs_list.sh:
line 295: bzip2: command not found
make[2]: *** [usr/initramfs_data.cpio.bz2] Error 127
make[1]: *** [usr] Error 2
make: *** [sub-make] Error 2


hmmm, but on a second glance, there seems to be indeed an issue. When
compiling it a _second time_, compilation will "succeed" but produce a
bad kernel because the first attempt left an empty
usr/initramfs_data.cpio.bz2 .

I'll look into it this evening, probably a case of "bad" failure
recovery in the Makefile.

> Basically, the algorithm used in usr/Makefile is simply wrong.

Wow, those are mightily strong words...

> The claim is:
> 
> +# Find out "preferred" ramdisk compressor. Order of preference is
> +#  1. bzip2 efficient, and likely to be present
> +#  2. gzip former default
> +#  3. lzma
> +#  4. none
> +
> +# None of the above
> +suffix_y                   =
> +
> +# Lzma, but no gzip nor bzip2
> +suffix_$(CONFIG_RD_LZMA)   = .lzma
> +
> +# Gzip, but no bzip2
> +suffix_$(CONFIG_RD_GZIP)   = .gz
> +
> +# Bzip2
> +suffix_$(CONFIG_RD_BZIP2)  = .bz2
> 
> This doesn't end up make any sense.

Huh? Can't we just stay polite here...

>  The sanest thing to do is to 
> compress with all the compressors that are configured into the kernel, 
> and then use the smallest image of the ones that can be produced, 
> *including the uncompressed image*.

... so, if I understood correctly, that would mean compressing the
kernel 4 times, and keeping the smallest?
Given the relatively low speed of compression, I feel that such a
feature would really annoy people who compile their kernel often (such
as kernel or module developers). Indeed, when only changing a single
file, kernel compression is the most time-consuming part of recompilation.

>  Including the uncompressed image 
> will guarantee that we always have a working option.

Indeed, Ingo's example had the following config:
# CONFIG_RD_GZIP is not set
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y

So, in his case an uncompressed builtin ramdisk would indeed: be the
only solution because
 1. gzip is not configured
 2. bzip2 is not present on build system as per hypothesis
 3. lzma being more "exotic" than bzip2 would probably be absent too.

> 	-hpa

Maybe another solution would be to make the choice of builtin ramdisk
compression user-selectable, and default to no compression at all.

Indeed, in the default case, the builtin ramdisk is so small (950 bytes
uncompressed), that it probably wouldn't really matter anyways.

The only case where it matters is for developers of embedded systems who
want to replace the builtin ramdisk with a fully populated one, because
their boot loader does not support loading a "normal" initrd.

These people are (hopefully) knowledgeable enough to pick an appropriate
compressor (but there's still the issue of notifying them about the
change, obviously).

Btw, what *is* the standard work flow of supplying your own built-in
initramfs? Do such developers usually supply a directory tree, or do
they already cpio it before supplying it to the kernel? Or do they even
compress it themselves?

Regards,

Alain
