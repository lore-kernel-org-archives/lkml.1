Return-Path: <linux-kernel-owner+w=401wt.eu-S1764211AbYF3Tr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764211AbYF3Tr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 15:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754945AbYF3Tqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 15:46:45 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:43637 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbYF3Tqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 15:46:42 -0400
Date: Mon, 30 Jun 2008 21:47:27 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Andy Whitcroft <apw@shadowen.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BUILD-FAILURE] linux-next: Tree for June 30
Message-ID: <20080630194727.GA26682@uranus.ravnborg.org>
References: <20080701001656.e156585c.sfr@canb.auug.org.au> <48690385.7030500@linux.vnet.ibm.com> <48690D3C.1060803@linux.vnet.ibm.com> <20080630185943.GA24692@uranus.ravnborg.org> <20080630192610.GA6584@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630192610.GA6584@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 09:26:10PM +0200, Ingo Molnar wrote:
> 
> * Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > On Mon, Jun 30, 2008 at 10:13:40PM +0530, Kamalesh Babulal wrote:
> > > Kamalesh Babulal wrote:
> > > > Hi Stephen,
> > > > 
> > > > next-20080630 kernel build fails x86 box 
> > > > 
> > > > fs/bio-integrity.c: In function `bio_integrity_add_page':
> > > > include/linux/bio.h:368: sorry, unimplemented: inlining failed in call to 'bvec_nr_vecs': function body not available
> > > > fs/bio-integrity.c:135: sorry, unimplemented: called from here
> > > > make[1]: *** [fs/bio-integrity.o] Error 1
> > > > make: *** [fs] Error 2
> > > > 
> > > > # gcc -v
> > > > Reading specs from /usr/lib/gcc/i386-redhat-linux/3.4.6/specs
> > > > Configured with: ../configure --prefix=/usr --mandir=/usr/share/man
> > > > --infodir=/usr/share/info --enable-shared --enable-threads=posix
> > > > --disable-checking --with-system-zlib --enable-__cxa_atexit
> > > > --disable-libunwind-exceptions --enable-java-awt=gtk
> > > > --host=i386-redhat-linux
> > > > Thread model: posix
> > > > gcc version 3.4.6 20060404 (Red Hat 3.4.6-10)
> > > > 
> > > > 
> > > Another build failure on the same box/config file
> > > 
> > > make[2]: `scripts/unifdef' is up to date.
> > >   RELOCS  arch/x86/boot/compressed/vmlinux.relocs
> > > 101 section headers supported: 100
> > > make[2]: *** [arch/x86/boot/compressed/vmlinux.relocs] Error 1
> > > make[1]: *** [arch/x86/boot/compressed/vmlinux] Error 2
> > > make: *** [bzImage] Error 2
> > 
> > In a i386 specific part of the kernel - so let's cc x86 maintainers.
> 
> that's an allyesconfig kernel and i cannot reproduce the failure with 
> linux-next v2.6.26-rc8-6206-gf1c7436:
> 
>   [...]
>   RELOCS  arch/x86/boot/compressed/vmlinux.relocs
>   BUILD   arch/x86/boot/compressed/vmlinux.bin.all
>   GZIP    arch/x86/boot/compressed/vmlinux.bin.gz
>   LD      arch/x86/boot/compressed/piggy.o
>   LD      arch/x86/boot/compressed/vmlinux
>   OFFSETS arch/x86/boot/offsets.h
>   OBJCOPY arch/x86/boot/vmlinux.bin
>   AS      arch/x86/boot/header.o
>   LD      arch/x86/boot/setup.elf
>   OBJCOPY arch/x86/boot/setup.bin
>   BUILD   arch/x86/boot/bzImage
>  Root device is (8, 17)
>  Setup is 12524 bytes (padded to 12800 bytes).
>  System is 17840 kB
>  CRC bccb6201
>  Kernel: arch/x86/boot/bzImage is ready  (#10848)
> 
> (nor has anything substantial change in that area changed in the x86 
> tree recently that sticks out at first sight.)

Just to see the number of sections you hit could you try following stupid patch.
It will casue relocs to terminate but will print out the section header count we have
in your allyesconfig build.

It is 'funny' that we just passed the limit in the error report.

	Sam

diff --git a/arch/x86/boot/compressed/relocs.c b/arch/x86/boot/compressed/relocs.c
index edaadea..88d27f6 100644
--- a/arch/x86/boot/compressed/relocs.c
+++ b/arch/x86/boot/compressed/relocs.c
@@ -244,7 +244,7 @@ static void read_ehdr(FILE *fp)
 static void read_shdrs(FILE *fp)
 {
 	int i;
-	if (ehdr.e_shnum > MAX_SHDRS) {
+	if (1 || ehdr.e_shnum > MAX_SHDRS) {
 		die("%d section headers supported: %d\n",
 			ehdr.e_shnum, MAX_SHDRS);
 	}

> 
> 	Ingo
