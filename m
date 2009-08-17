Return-Path: <linux-kernel-owner+w=401wt.eu-S1755081AbZHQOeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbZHQOeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 10:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbZHQOd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 10:33:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37038 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557AbZHQOd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 10:33:56 -0400
Date: Mon, 17 Aug 2009 10:33:55 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: John Reiser <jreiser@bitwagon.com>
cc: Steven Rostedt <srostedt@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: recordmcount commutes with "ld -r"
In-Reply-To: <4A8040D8.8020504@bitwagon.com>
Message-ID: <alpine.DEB.2.00.0908171025140.20915@gandalf.stny.rr.com>
References: <4A8040D8.8020504@bitwagon.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi John,

Sorry for the late reply, but I just got back from vacation.

On Mon, 10 Aug 2009, John Reiser wrote:

> Executing recordmcount.pl for each *.o is adding minutes to the duration
> of my full kernel builds.  Here is a way to recoup most of those minutes.
> 
> recordmcount commutes with "ld -r".  Run "ld -r" on the outputs from
> running recordmcount on each *.o, or run recordmcount on the output from
> aggregating the original *.o using "ld -r".  Either way, the final
> __mcount_loc section contains a list of locations of calls to mcount.
> The ELF32_R_SYM (ELF64_R_SYM) of the relocations may be different, but
> they will be equivalent.  Subsequent static binding (ld without -r)
> will produce identical results.  Instead of running recordmcount on each
> *.o input file that is part of built-in.o or <module>.ko,  then
> just run recordmcount on built-in.o or <module>.ko that is constructed
> from the original compiler-generated *.o.

Running the linking on the built-in.o and *.ko files is a good idea.

> 
> There is a special case for building vmlinux, namely the archive
> libraries lib/lib.a and arch/$ARCH/lib/lib.a.  recordmcount must be run
> on each member individually.  Alternately, recordmcount could be run
> on vmlinux.o (exactly once per build; not on any built-in.o)
> if vmlinux.o is then used to build vmlinux.

I avoided performing on the vmlinux.o. Because myself (and a lot of 
others) use distcc to compile our kernels. The longest part of the average 
compile is the final linking stage of vmlinux.o. Most of my compiles are 
done when I only modify a couple of files, and the work on individual .o 
files is not that big of a deal. But to do the work on vmlinux, will 
increase the compile time for all compiles even if you only modified a 
single file.


> 
> I noticed another property.  Logically, recordmcount could modify a
> .o file in place.  Both /bin/ld and the kernel module loader ignore
> bytes that are not designated by the ElfXX_Shdr[].  The __mcount_loc
> section and its relocations can be appended to the original file, then
> "activated" by rewriting the ElfXX_Ehdr fields .e_shnum and .e_shoff.
> This avoids some file operations as well as several fork+exec that are
> performed by recordmcount.pl.  recordmcount becomes very fast.
> The bytes for the old ElfXX_Shdr[] remain as uncollected "garbage",
> typically a few kilobytes in each built-in.o or <module>.ko.
> If desired then the garbage may be excised quickly by running "ld -r".
> 
> I have written recordmcount.c which does such modify-in-place for all
> architectures supported by recordcmount, and tested it successfully on
> i686, x86_64, and 32-bit PowerPC, including cross-platform processing
> of *.o from any architecture.  The differing data structures between
> Elf32 and Elf64 require parallel code in many places, so the C file is
> 900 lines.  That might be too long for a mailing list, so I will defer
> posting the file.

I would be interested in seeing it. Do you require any of the elf 
libraries to use this? If so, that would make the kernel build 
dependent on having the development elf libraries installed.

I've thought about converting recordmcount into a C file before, but I was 
a bit hesitant on rewriting elf routines (although I've done it before 
and they are quite trivial) but even more concerned on breaking other 
archs.

-- Steve

