Return-Path: <linux-kernel-owner+w=401wt.eu-S1755545AbZHJPqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545AbZHJPqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 11:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755386AbZHJPqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 11:46:33 -0400
Received: from bitwagon.com ([74.82.39.175]:58877 "HELO bitwagon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755458AbZHJPqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 11:46:32 -0400
Message-ID: <4A8040D8.8020504@bitwagon.com>
Date: Mon, 10 Aug 2009 08:46:32 -0700
From: John Reiser <jreiser@bitwagon.com>
Organization: -
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <srostedt@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: recordmcount commutes with "ld -r"
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Executing recordmcount.pl for each *.o is adding minutes to the duration
of my full kernel builds.  Here is a way to recoup most of those minutes.

recordmcount commutes with "ld -r".  Run "ld -r" on the outputs from
running recordmcount on each *.o, or run recordmcount on the output from
aggregating the original *.o using "ld -r".  Either way, the final
__mcount_loc section contains a list of locations of calls to mcount.
The ELF32_R_SYM (ELF64_R_SYM) of the relocations may be different, but
they will be equivalent.  Subsequent static binding (ld without -r)
will produce identical results.  Instead of running recordmcount on each
*.o input file that is part of built-in.o or <module>.ko,  then
just run recordmcount on built-in.o or <module>.ko that is constructed
from the original compiler-generated *.o.

There is a special case for building vmlinux, namely the archive
libraries lib/lib.a and arch/$ARCH/lib/lib.a.  recordmcount must be run
on each member individually.  Alternately, recordmcount could be run
on vmlinux.o (exactly once per build; not on any built-in.o)
if vmlinux.o is then used to build vmlinux.

I noticed another property.  Logically, recordmcount could modify a
.o file in place.  Both /bin/ld and the kernel module loader ignore
bytes that are not designated by the ElfXX_Shdr[].  The __mcount_loc
section and its relocations can be appended to the original file, then
"activated" by rewriting the ElfXX_Ehdr fields .e_shnum and .e_shoff.
This avoids some file operations as well as several fork+exec that are
performed by recordmcount.pl.  recordmcount becomes very fast.
The bytes for the old ElfXX_Shdr[] remain as uncollected "garbage",
typically a few kilobytes in each built-in.o or <module>.ko.
If desired then the garbage may be excised quickly by running "ld -r".

I have written recordmcount.c which does such modify-in-place for all
architectures supported by recordcmount, and tested it successfully on
i686, x86_64, and 32-bit PowerPC, including cross-platform processing
of *.o from any architecture.  The differing data structures between
Elf32 and Elf64 require parallel code in many places, so the C file is
900 lines.  That might be too long for a mailing list, so I will defer
posting the file.

-- 
