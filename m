Return-Path: <linux-kernel-owner+w=401wt.eu-S1755790AbZHEPeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbZHEPeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 11:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755781AbZHEPeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 11:34:14 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:59033 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770AbZHEPeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 11:34:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=EQ5wAsHH59KYImizFNCHWdCf47NlBrAJKhElpbRJiejMzto5PYnZr0POZnkvGQD3HL
         88QT8CTQeyE8tLalGwwauz/m8Xn2NBR7uzpFGF3rVaqtK31ZOp17rjfVhpbbBRdL2PsP
         3nEbs42WUMpM+ZGJZvMEFDbTp7OE5+5N8GK5Q=
MIME-Version: 1.0
Date: Wed, 5 Aug 2009 17:34:12 +0200
Message-ID: <2d0a357f0908050834u52e85df3s20541d3f10914ae0@mail.gmail.com>
Subject: [binutils-gold][2.6.31-rc5-git3] ld error w/ LDFLAGS_vmlinux := 
	--emit-reloc (CONFIG_RELOCATABLE=y)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: binutils-cvs@sourceware.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is my first Email to Linux kernel mailing list and of course I
read parts of the sections in the FAQ [1]. Being not sure if this a
problem of the Linux kernel or the gold linker in binutils, I also
send this bug report to binutils-cvs ML.

After sending a bug report to Ian Lance Taylor via PM, he could offer
a patch [2] to finally be able to compile a 2.6.29-rc8 Linux-kernel
with gcc-4.4 and gold-from-cvs [3].
Days later there was another patch in Linus-tree concerning.eh_frame
section and unexpected relocation [4].
This time, I also prepared an archive with input-files and ld-script -
it's 3MByte big.
Unfortunately, Ian is on vacations.

Now, here is my description and an explanation what I *tried* to
discover and solve the problem:
While trying to compile a recent Linux-kernel v2.6.31-rc5-git3 with
gcc-4.4 (4.4.1-1) and binutils-gold (2.19.51.20090805-1) from the
Debian/unstable repository, I get the following error:

>From the build-log:
[...]
ld -m elf_i386 --emit-relocs --build-id -X -o .tmp_vmlinux1 -T
arch/x86/kernel/vmlinux.lds arch/x86/kernel/head_32.o
arch/x86/kernel/head32.o arch/x86/kernel/head.o
arch/x86/kernel/init_task.o  init/built-in.o --start-group
usr/built-in.o  arch/x86/built-in.o  kernel/built-in.o  mm/built-in.o
fs/built-in.o  ipc/built-in.o  security/built-in.o  crypto/built-in.o
block/built-in.o  lib/lib.a  arch/x86/lib/lib.a  lib/built-in.o
arch/x86/lib/built-in.o  drivers/built-in.o  sound/built-in.o
firmware/built-in.o  arch/x86/pci/built-in.o
arch/x86/power/built-in.o  arch/x86/video/built-in.o  net/built-in.o
--end-group
ld: error: invalid assignment to dot outside of SECTIONS
ld: error: invalid assignment to dot outside of SECTIONS
ld: internal error in relocate_for_relocatable, at ../../gold/target-reloc.h:490
make[2]: *** [.tmp_vmlinux1] Error 1

By eliminating "--emit-relocs" from this line, a .tmp_vmlinux1 file is
generated:

$ file .tmp_vmlinux1
.tmp_vmlinux1: ELF 32-bit LSB executable, Intel 80386, version 1
(SYSV), statically linked, not stripped

Investigating the source-code showed that LDFLAGS_vmlinux is appended
if CONFIG_RELOCATABLE=y is set in the kernel dot-config file:

[linux-2.6.31-rc5-git3/arch/x86/Makefile]
...
ifdef CONFIG_RELOCATABLE
       LDFLAGS_vmlinux := --emit-relocs
endif
...

All my kernels I used (distribution) or compiled myself have this
config-option set, an explanation can be read here [6].

Having a look into the extracted binutils Debian package (ErrMsg says
Line #490):
[binutils-2.19.51.20090805/gold/target-reloc.h]
...
      unsigned int new_symndx;
      if (r_sym < local_count)
        {
          switch (strategy)
            {
            case Relocatable_relocs::RELOC_COPY:
              new_symndx = object->symtab_index(r_sym);
              gold_assert(new_symndx != -1U); <=== LINE #490
              break;
...

Seems to me as a false calculation of the offset as in [7], but I am
not a toolchain expert.

For better reproducibility reasons, I copied all involved input files
- with keeping the directory structure - in a separate location and
"YES, we can" reproduce the error (message).
The problem exists also with gcc-4.3 (4.3.4-1).
For the sake of completeness: Debian's (e)glibc has version (2.9-23).

If you are interested in the input and configuration files, I can ask
a friend of mine to put them in a public web-space.

Kind Regards,
Sedat

P.S.:
Normally, I add the build-log and the corresponding kernel dot-config files.

[1] http://www.kernel.org/pub/linux/docs/lkml/#s3
[2] http://sourceware.org/ml/binutils/2009-03/msg00377.html
[3] http://sourceware.org/ml/binutils/2009-03/msg00381.html
[4] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=003086497f07f7f1e67c0c295e261740f822b377
[5] http://sourceware.org/ml/binutils/2008-05/msg00248.html
[6] http://cateee.net/lkddb/web-lkddb/RELOCATABLE.html
[7] http://sourceware.org/ml/binutils/2008-05/msg00248.html
