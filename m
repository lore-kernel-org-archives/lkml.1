Return-Path: <linux-kernel-owner+w=401wt.eu-S1756875AbYGONsC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbYGONsC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 09:48:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755822AbYGONrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 09:47:53 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:50704 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755754AbYGONrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 09:47:53 -0400
Date: Tue, 15 Jul 2008 16:47:47 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: dhowells@redhat.com, sam@ravnborg.org, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
Subject: Re: binutils 2.18.50.0.8 frv build error
Message-ID: <20080715134747.GD24533@cs181140183.pp.htv.fi>
References: <20080715121327.GA24533@cs181140183.pp.htv.fi> <20080715132005.GA6517@lucon.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080715132005.GA6517@lucon.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 06:20:05AM -0700, H.J. Lu wrote:
> On Tue, Jul 15, 2008 at 03:13:27PM +0300, Adrian Bunk wrote:
> > Toolchain:
> > - gcc 4.3.1
> > - binutils 2.18.50.0.7 and 2.18.50.0.8
> > - configured for frv-linux
> > - kernel 2.6.26
> > 
> > Builds fine when using binutils 2.18.50.0.7,
> > but fails as follows with binutils 2.18.50.0.8:
> > 
> > <--  snip  -->
> > 
> > ...
> >   HOSTCC  scripts/kallsyms
> >   CC      init/main.o
> >   CHK     include/linux/compile.h
> >   UPD     include/linux/compile.h
> >   CC      init/version.o
> >   CC      init/do_mounts.o
> >   LD      init/mounts.o
> >   CC      init/noinitramfs.o
> >   LD      init/built-in.o
> > frv-linux-ld: init/mounts.o: compiled with -fpic and linked with modules that use non-pic relocations
> > frv-linux-ld: failed to merge target specific data of file init/mounts.o
> > make[2]: *** [init/built-in.o] Error 1
> > 
> > <--  snip  -->
> > 
> > Complete verbose log below.
> > 
> > Any hints what's going wrong?
> > 
> > cu
> > Adrian
> > 
> > 
> 
> ...
> 
> >    frv-linux-ld    -r -o init/built-in.o init/main.o init/version.o init/mounts.o init/noinitramfs.o 
> > frv-linux-ld: init/mounts.o: compiled with -fpic and linked with modules that use non-pic relocations
> > frv-linux-ld: failed to merge target specific data of file init/mounts.o
> > make[1]: *** [init/built-in.o] Error 1
> > make: *** [init] Error 2
> 
> This regression was introduced between 2008-05-02 10:10am and
> 2008-07-09 5:45pm PDT.  Does ld from binutils 2.18.50.0.7 work
> on the same init/main.o init/version.o init/mounts.o
> init/noinitramfs.o? If yes, please open a bug report at
> 
> http://www.sourceware.org/bugzilla/

No, it does not work with these .o files.

> with those .o files. If not, please find out why.

Tried it the other way round:
- compiled with 2.18.50.0.7.
- then changed binutils to 2.18.50.0.8

Works:
frv-linux-ld    -r -o init/built-in.o init/main.o init/version.o init/mounts.o init/noinitramfs.o

Fails:
frv-linux-ld    -r -o init/mounts.o init/do_mounts.o
frv-linux-ld    -r -o init/built-in.o init/main.o init/version.o init/mounts.o init/noinitramfs.o


I did an "frv-linux-objdump  -Dx" on the init/mounts.o files generated 
with both binutils versions, and the diff is:


--- working	2008-07-15 16:34:49.000000000 +0300
+++ broken	2008-07-15 16:34:40.000000000 +0300
 architecture: fr450, flags 0x00000011:
 HAS_RELOC, HAS_SYMS
 start address 0x00000000
-private flags = 0x800020d: -mcpu=fr450 -mgpr-32 -msoft-float non-pic relocations
+private flags = 0x800030d: -mcpu=fr450 -mgpr-32 -msoft-float -fpic non-pic relocations
 
 Sections:
 Idx Name          Size      VMA       LMA       File off  Algn


Is this an ld bug?


> Thanks.
> 
> H.J.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

