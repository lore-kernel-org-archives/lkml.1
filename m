Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbZFPI1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbZFPI1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbZFPI1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:27:31 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:34490 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbZFPI1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:27:30 -0400
MIME-Version: 1.0
From: David Lindsay <dav7@dav7.net>
Date: Tue, 16 Jun 2009 18:27:11 +1000
Message-ID: <af7719af0906160127n36be4aa2qf5a309f44077b4b1@mail.gmail.com>
Subject: Kernel 2.4.0 ramdisk decompression infinite loop
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I know kernel 2.4.0 is old, but it's the oldest kernel my system will
compile (with binutils 2.9.1 downloaded from kernel.org/lib/ and GCC
2.95.3), and I want a small kernel. ;-)
If anyone knows how to make a (useful ;p) ~350kB 2.6, please do tell! :P

I'm using the good ol' dd-a-kernel-and-root-filesystem-to-floppy disk
method and if I compress the root filesystem the kernel fails to
unpack it... except it doesn't print an error. It just hangs, and from
what I've seen, apparently for good. I'm using gzip 1.3.12, if that
helps - did anything with gzip change between 2000 and now (2009)?

I'm not much of a debugger, but for fun I jumped into the kernel and
printk()d myself all the way to inflate.c. I know, printk() is
probably the Wrong Way(TM) to do it, but after discovering a couple of
empty debugging defines at the top of inflate.c (there are DEBGs and
to a lesser extent DEBG1s scattered throughout the code, very
thoughtful), I filled these in with...
#define DEBG(x) printk("DEBG:  %s\n", x);
#define DEBG1(x) printk("DEBG1: %s\n", x);
...and almost immediately found the likely culprit thanks to these
defines - lines 536 to 608 in inflate_codes(): what looks like a loop
apparently gone infinite. It's a for(;;) and does have a break in
there (of course), but it looks like the break condition (e = 15) is
never met in the ramdisk unpack context. Wonder why. I mean, this code
decompresses the kernel, right?

I printk()'d e: I got a few widely varied integers back then 0 forever. Weird.

http://lxr.linux.no/linux-old+v2.4.31/lib/inflate.c#L513 will send you
straight to line 513, the start of inflate_codes().

(De)compression is definitely not my field (web development, design,
ideas and *basic* C are more my forte :P) so I'm wayyy outta my league
here. Any ideas, guys?

What's important to note is that I can create and write an
/uncompressed/ ext2 filesystem to the disk and the kernel will
discover, read, and load it just fine. I haven't progressed to
actually getting a usable shell (since I'm trying to use the asmutils
(http://asm.sourceforge.net/asmutils.html) shell, but that's a
different story) but I can load uncompressed ext2 filesystems and they
do work - for example, dropping a nasm/ld'd "hello world" from off the
web into /bin/init will produce "hello world" (then the kernel will
complain that init just died).

I've taken the info I used to put my floppy creation script together
from wide and varied corners of the 'Net so, suspecting it, tried a
different script, the one that comes with the asmutils. Same problem -
if the ramdisk is compressed, it simply goes splat (ie it hangs), if
it's uncompressed it'll proceed (but not do anything useful beyond
that point).

Thanks in advance for any help you can give.

-dav7
