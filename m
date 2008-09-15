Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbYIOBhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbYIOBhs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 21:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbYIOBhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 21:37:39 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:55299
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbYIOBhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 21:37:39 -0400
From: Rob Landley <rob@landley.net>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH] init: bzip2 or lzma -compressed kernels and initrds
Date: Sun, 14 Sep 2008 20:37:47 -0500
User-Agent: KMail/1.9.9
Cc: Alain Knaff <alain@knaff.lu>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <200809062119.m86LJ5Of026101@hitchhiker.org.lu> <20080907054831.GA2244@1wt.eu>
In-Reply-To: <20080907054831.GA2244@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809142037.48204.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 September 2008 00:48:31 Willy Tarreau wrote:
> Hi Alain,
> > +config KERNEL_LZMA
> > +       bool "LZMA"
> > +       help
> > +         The most recent compression algorithm.
> > +	 Its ratio is best, decompression speed is between the other
> > +	 2. Compression is slowest.
> > +	 The kernel size is about 33 per cent smaller with lzma,
> > +	 in comparison to gzip.
>
> isn't memory usage in the same range as bzip2 ?

Last I checked it was more.  (I very vaguely recall somebody saying 16 megs 
working space back when this was first submitted to busybox, but that was a 
few years ago...)

A quick Google found a page that benchmarks them.  Apparently it depends 
heavily on which compression option you use:

http://tukaani.org/lzma/benchmarks

Something compressed with lzma -6 takes 5 megabytes to decompress, -7 takes 9 
megs, -8 takes 17 megs, and -9 takes 33.  (Plus your source and target 
buffers for in-memory compression.)

So decompressing anything more than an "allnoconfig" kernel with lzma -6 
probably wouldn't quite fit in 8 megs (800k source data, 2.5 megs destination 
data, 5 megs working space... boing.).  You'd need to bump up to 12 or so.  
And compressed with -7 or -8 you're talking 32 megs or more.

> > +# Bzip2
> > +#
> > -------------------------------------------------------------------------
> >-- +
> > +# Bzip2 does not include size in file... so we have to fake that
> > +size_append=perl -e 'print(pack("i",(stat($$ARGV[0]))[7]));'
> > +
> > +quiet_cmd_bzip2 = BZIP2    $@
> > +cmd_bzip2 = (bzip2 -9 < $< ; $(size_append) $<) > $@
>
> It would be the only command in the build process that requires perl. While
> not a disaster, it's a bit annoying to introduce a new build dependency.

While I despise requiring perl to build the kernel, I'd like to point out that 
H. Peter Anvin introduced Perl as a build requirement for 2.6.25:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=bdc807871d58285737d50dc6163d0feb72cb0dc2

Before that perl was only required for optional things like bloat-o-meter, not 
to actually _build_ the kernel.

My argument about it with him and Sam Ravnborg back in February was at:
http://lkml.org/lkml/2008/2/15/541

And their position was "perl is inevitable, go ahead and add python too if you 
like".  Apparently your build environment can have an infinite number of 
requirements, including things like perl where the implementation is the 
spec.  (There is no perl spec, there's only a perl implementation.  Python at 
least has a java implementation...)

My updated patch to remove the dependency from 2.6.26 was here:
http://www.mail-archive.com/linux-embedded%40vger.kernel.org/msg00748.html

Rob
