Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbYIGGSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbYIGGSS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 02:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbYIGGSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 02:18:04 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:46261
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbYIGGSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 02:18:01 -0400
From: Rob Landley <rob@landley.net>
To: Alain Knaff <alain@knaff.lu>
Subject: Re: [PATCH] init: bzip2 or lzma -compressed kernels and initrds
Date: Sun, 7 Sep 2008 01:17:55 -0500
User-Agent: KMail/1.9.9
Cc: Leon Woestenberg <leon.woestenberg@gmail.com>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
References: <200809062119.m86LJ5Of026101@hitchhiker.org.lu> <c384c5ea0809061529g2c7280d8j216f7791ceeb439a@mail.gmail.com> <48C30B4D.7030700@knaff.lu>
In-Reply-To: <48C30B4D.7030700@knaff.lu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809070117.56503.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 September 2008 17:59:25 Alain Knaff wrote:
> Leon Woestenberg wrote:
> > Hello,
> >
> > a small remark on the non-code parts:
> >
> > On Sat, Sep 6, 2008 at 11:19 PM, Alain Knaff <alain@knaff.lu> wrote:
> >> compressing the kernel with bzip2 or lzma rather than gzip. Both
> >> compressors give smaller sizes than gzip.  Moreover, lzma's
> >> decompresses faster than gzip.
> >
> > versus
> >
> >> +config KERNEL_GZIP
> >> +       bool "Gzip"
> >> +       help
> >> +         The old and tried gzip compression. Its compression ratio is
> >> +        the poorest among the 3 choices; however its speed (both
> >> +        compression and decompression) is the fastest.
> >> +
> >
> > This seems contradictionary information.
>
> Oops, sorry for that. Actually the Kconfig text is correct. On
> decompression, Lzma is faster than bzip2 but slower than gzip:
>
> Compressor	Compression	Decompression	Size
> gzip -9		1,01s		0,11s		833069
> lzma -9		3,43s		0,24s		705125
> bzip2 -9	2,88s		0,38s		777706
>
> On compression, lzma is actually slowest of the 3, but that should be of
> little concern, as this happens only once, whereas decompression happens
> many times (on each boot).
>
> So, overall lzma looks like the best (acceptable decompression speed,
> best decompression ratio). I only included Bzip2 because it's much
> better known than lzma.

I vaguely recall that lzma requires more memory to decompress than bzip2 does, 
although I don't remember the details.  I know that bzip2 takes around 4 megs 
(although you need space for the decompressed kernel on _top_ of that, so you 
should be able to do it in about 8 megs total).  gunzip uses a 64k sliding 
window plus dictionary and the whole mess should fit in about 1/4 of a meg.

Actually, from what I've seen the main reason lzma doesn't get used for 
tarballs a lot is that whoever originally created it didn't include a 
fingerprint.  You can go "file tar.gz" or "file tar.bz2" and it can figure 
out by looking at the contents of the file what it _is_, but last I checked 
there's no obvious way to tell an lzma file from the output of /dev/urandom.  
This causes all sorts of small but annoying problems, and discourages its use 
a bit...

(Also, the decompressor's not so bad but the compressor was _painfully_ slow, 
last I checked.  It's been a couple years since I was really paying 
attention, though...)

> Unfortunately, I didn't have any such machine available for testing, so
> I just for Intel 32/64.

Eh, anybody can mess with arm, powerpc, and mips.

1) Install qemu 0.9.1.

2) Go to http://landley.net/code/firmware/downloads

In the binaries/system-image directory are tarballs of prebuilt systems with 
zImage files of kernels qemu can boot, and ext2 image files of uClibc/busybox 
root filesystems.  There are also ./run-emulator.sh scripts that will boot 
the above under qemu 0.9.1 (giving you a shell prompt).

If you'd like to replace the zImage files with ones you build yourself, you'll 
need to either grab the source tarballs at the top level and run the whole 
build yourself (try "./build.sh armv4l" for example; you can run it with no 
arguments to see available targets) or grab the appropriate tarball out of 
binaries/cross-compiler/host-x86_64, extract it, add its "bin" subdirectory 
to your $PATH, and then build the kernel via something like:

  make CROSS_COMPILE=armv4l- ARCH=arm

With the appropriate .config of course (look at the defconfig files under 
arch/arm/config or grab mine out of the source).  I'm using arm as an example 
because it's pretty much the most popular embedded processor and has 90% 
share in the cell phone market.  FWL also supports powerpc, mips, and so on.  
(Sparc's boots but won't give you a shell prompt, it's a uClibc 0.9.29 bug.  
sh4 isn't properly supported by qemu yet, hopefully next release.)

Feel free to email me if you've got any questions, this is a hobby of mine. :)

Rob
