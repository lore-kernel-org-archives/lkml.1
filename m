Return-Path: <linux-kernel-owner+w=401wt.eu-S1763318AbXGYGdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763318AbXGYGdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 02:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbXGYGdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 02:33:37 -0400
Received: from deine-taler.de ([217.160.107.63]:65445 "EHLO deine-taler.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755746AbXGYGdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 02:33:36 -0400
Date: Wed, 25 Jul 2007 08:32:43 +0200
From: Ulrich Kunitz <kune@deine-taler.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       honza@jikos.cz, jkosina@suse.cz
Subject: Re: Is PIE randomization breaking klibc binaries?
Message-ID: <20070725063243.GA25148@deine-taler.de>
References: <20070720211300.GA21644@deine-taler.de> <46A131BF.4080404@zytor.com> <46A6624E.60003@redhat.com> <46A667BD.5080106@redhat.com> <20070724220053.GA20531@deine-taler.de> <46A68003.6060901@redhat.com> <46A68118.9080902@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A68118.9080902@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07-07-24 15:45 H. Peter Anvin wrote:

> Chuck Ebbert wrote:
> >
> >Okay, I tested with Fedora on x86_64 and it worked there too.
> >(Not that that proves much.)
> >
> >Did you capture any of the error messages, like the address
> >of the segfault?
> >
> 
> FWIW, on x86-64, this should show up in dmesg.
> 
> 	-hpa

Ok, I have tested it again.

The message looks like:

sleep[7888]: segfault at 000000000004001C rip 000000000004001C rsp 00007fff14776468 error 14

Repeated calls get the same message with the stack pointer
changing. Other binaries (mount) have a segmentation fault at
another addressi (0x400184). It appears that the instruction
pointer fails at the start address of the klibc binary. Notify
that this lies in the binary itself and not in the /lib/klibc*.so
object, so it appears that the klibc binary sections are loaded at
randomized addresses.

Here is some output from objdump:

$ objdump -x bin/sleep

bin/sleep:     file format elf64-x86-64
bin/sleep
architecture: i386:x86-64, flags 0x00000102:
EXEC_P, D_PAGED
start address 0x000000000040014c

Program Header:
    PHDR off    0x0000000000000040 vaddr 0x0000000000400040 paddr 0x0000000000400040 align 2**3
         filesz 0x00000000000000e0 memsz 0x00000000000000e0 flags r-x
  INTERP off    0x0000000000000120 vaddr 0x0000000000400120 paddr 0x0000000000400120 align 2**0
         filesz 0x000000000000002a memsz 0x000000000000002a flags r--
    LOAD off    0x0000000000000000 vaddr 0x0000000000400000 paddr 0x0000000000400000 align 2**21
         filesz 0x00000000000001c3 memsz 0x00000000000001c3 flags r-x
   STACK off    0x0000000000000000 vaddr 0x0000000000000000 paddr 0x0000000000000000 align 2**3
         filesz 0x0000000000000000 memsz 0x0000000000000000 flags rwx

Sections:
Idx Name          Size      VMA               LMA               File off  Algn
  0 .interp       0000002a  0000000000400120  0000000000400120  00000120  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  1 .text         00000059  000000000040014c  000000000040014c  0000014c  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  2 .rodata       0000001e  00000000004001a5  00000000004001a5  000001a5  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  3 .gnu_debuglink 0000000c  0000000000000000  0000000000000000  000001c3  2**0
                  CONTENTS, READONLY
SYMBOL TABLE:
no symbols


$ objdump -x lib/klibc-7q-hWrI8UIRMp59zIo378Yl2X7A.so 

lib/klibc-7q-hWrI8UIRMp59zIo378Yl2X7A.so:     file format elf64-x86-64
lib/klibc-7q-hWrI8UIRMp59zIo378Yl2X7A.so
architecture: i386:x86-64, flags 0x00000102:
EXEC_P, D_PAGED
start address 0x0000000000200200

Program Header:
    LOAD off    0x0000000000000000 vaddr 0x0000000000200000 paddr 0x0000000000200000 align 2**21
         filesz 0x000000000001197e memsz 0x000000000001197e flags r-x
    LOAD off    0x0000000000011980 vaddr 0x0000000000411980 paddr 0x0000000000411980 align 2**21
         filesz 0x0000000000000100 memsz 0x0000000000004288 flags rw-
   STACK off    0x0000000000000000 vaddr 0x0000000000000000 paddr 0x0000000000000000 align 2**3
         filesz 0x0000000000000000 memsz 0x0000000000000000 flags rwx

Sections:
Idx Name          Size      VMA               LMA               File off  Algn
  0 .text         0000da94  0000000000200200  0000000000200200  00000200  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  1 .rodata       00003cde  000000000020dca0  000000000020dca0  0000dca0  2**5
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  2 .data         00000100  0000000000411980  0000000000411980  00011980  2**5
                  CONTENTS, ALLOC, LOAD, DATA
  3 .bss          00004188  0000000000411a80  0000000000411a80  00011a80  2**5
                  ALLOC
  4 .gnu_debuglink 0000002c  0000000000000000  0000000000000000  00011a80  2**0
                  CONTENTS, READONLY
SYMBOL TABLE:
no symbols

-- 
Uli Kunitz
