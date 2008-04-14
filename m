Return-Path: <linux-kernel-owner+w=401wt.eu-S1760070AbYDNNtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760070AbYDNNtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 09:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbYDNNtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 09:49:04 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:42396 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753404AbYDNNtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 09:49:01 -0400
Message-Id: <1208180940.6883.1247762729@webmail.messagingengine.com>
X-Sasl-Enc: KoWy7nj5YBknQFhTyvIS304Y1uN5y46CIdLmBW7O4VSS 1208180940
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Ingo Molnar" <mingo@elte.hu>,
       "Alexander van Heukelum" <heukelum@mailshack.com>
Cc: linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20080413112308.GA23426@mailshack.com> <20080414075204.GI16163@elte.hu>
Subject: Re: [PATCH] x86: always_inline wrapper for x86's test_bit
In-Reply-To: <20080414075204.GI16163@elte.hu>
Date: Mon, 14 Apr 2008 15:49:00 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 09:52:04 +0200, "Ingo Molnar" <mingo@elte.hu> said:
> the behavior on tiny is interesting - could you post the config you used 
> for your tiny kernel?

I use the following mini-config (../klibc.i386.mini). To expand it:
make allnoconfig KCONFIG_ALLCONFIG="../klibc.i386.mini"


CONFIG_EXPERIMENTAL=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE="../initramfs"
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_EMBEDDED=y
CONFIG_KALLSYMS=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_SLOB=y
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MPENTIUMII=y
CONFIG_HZ_100=y
CONFIG_PHYSICAL_START=0x110000
CONFIG_PHYSICAL_ALIGN=0x10000
CONFIG_BINFMT_ELF=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_PROC_FS=y
CONFIG_SYSFS=y
CONFIG_OPTIMIZE_INLINING=y


This references the file initramfs:


#####################
# Shared klibc initramfs
# See gen_init_cpio for syntax

dir dev 0755 0 0
dir lib 0755 0 0
dir lib/modules 0755 0 0
dir bin 0755 0 0

nod dev/console 0600 0 0 c 5 1
file lib/klibc-K9OvCTU5pCdyhCSkxwBjXuR7KA4.so
../klibc/usr/klibc/klibc-K9OvCTU5pCdyhCSkxw$
file init ../init 0755 0 0

file bin/sh ../klibc/usr/dash/sh.shared 0755 0 0
file bin/kinit ../klibc/usr/kinit/kinit.shared 0755 0 0
file bin/gzip ../klibc/usr/gzip/gzip 0755 0 0
file bin/cat ../klibc/usr/utils/shared/cat 0755 0 0
file bin/chroot ../klibc/usr/utils/shared/chroot 0755 0 0
file bin/cpio ../klibc/usr/utils/shared/cpio 0755 0 0
file bin/dd ../klibc/usr/utils/shared/dd 0755 0 0
file bin/false ../klibc/usr/utils/shared/false 0755 0 0
file bin/halt ../klibc/usr/utils/shared/halt 0755 0 0
file bin/kill ../klibc/usr/utils/shared/kill 0755 0 0
file bin/ln ../klibc/usr/utils/shared/ln 0755 0 0
file bin/ps ../klibc/usr/utils/shared/minips 0755 0 0
file bin/mkdir ../klibc/usr/utils/shared/mkdir 0755 0 0
file bin/mkfifo ../klibc/usr/utils/shared/mkfifo 0755 0 0
file bin/mknod ../klibc/usr/utils/shared/mknod 0755 0 0
file bin/mount ../klibc/usr/utils/shared/mount 0755 0 0
file bin/nuke ../klibc/usr/utils/shared/nuke 0755 0 0
file bin/pivot_root ../klibc/usr/utils/shared/pivot_root 0755 0 0
file bin/poweroff ../klibc/usr/utils/shared/poweroff 0755 0 0
file bin/readlink ../klibc/usr/utils/shared/readlink 0755 0 0
file bin/reboot ../klibc/usr/utils/shared/reboot 0755 0 0
file bin/sleep ../klibc/usr/utils/shared/sleep 0755 0 0
file bin/sync ../klibc/usr/utils/shared/sync 0755 0 0
file bin/true ../klibc/usr/utils/shared/true 0755 0 0
file bin/umount ../klibc/usr/utils/shared/umount 0755 0 0
file bin/uname ../klibc/usr/utils/shared/uname 0755 0 0


And ../init is a small script:


#! /bin/sh
mkdir proc
mount -t proc proc /proc
mkdir sys
mount -t sysfs sysfs /sys
bin/sh -i
reboot


This is usually the first config I try to build if I change something.
Klibc is here: git://git.kernel.org/pub/scm/libs/klibc/klibc.git
If all goes well you will be able to boot to a shell with a recent
qemu using: qemu -m 4 -smp 2 -cpu pentium2 -nographic -no-reboot
-serial stdio -cdrom arch/x86/boot/image.iso.

> what would be interesting to see is the effect of allowing gcc to 
> optimize for size (CONFIG_CC_OPTIMIZE_FOR_SIZE=y) - and compare 
> !CC_OPTIMIZE_FOR_SIZE+!OPTIMIZE_INLINING against 
> CC_OPTIMIZE_FOR_SIZE=y+OPTIMIZE_INLINING=y kernels - the size difference 
> should be _brutal_.

I see I had CONFIG_DEBUG_SECTION_MISMATCH enabled all the time.
This has quite a bit of influence on code generation! I did not
expect that. Here are the numbers for the configuration given
above for all combinations of the three settings.

Using: gcc (GCC) 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)

CONFIG_DEBUG_SECTION_MISMATCH=y
   text    data     bss     dec     hex vmlinux/i386
 806039   81464   73728  961231   eaacf OPT_SIZE=y OPT_INL=y
 778053   81464   73728  933245   e3d7d OPT_SIZE=y OPT_INL=n
 929940   81464   73728 1085132  108ecc OPT_SIZE=n OPT_INL=y
 929541   81464   73728 1084733  108d3d OPT_SIZE=n OPT_INL=n

CONFIG_DEBUG_SECTION_MISMATCH=n
   text    data     bss     dec     hex vmlinux/i386
 768031   81464   73728  923223   e1657 OPT_SIZE=y OPT_INL=y
 763675   81464   73728  918867   e0553 OPT_SIZE=y OPT_INL=n
 904284   81464   73728 1059476  102a94 OPT_SIZE=n OPT_INL=y
 904764   81464   73728 1059956  102c74 OPT_SIZE=n OPT_INL=n

The patch still helps OPT_SIZE=y OPT_INL=y, though:
 765896   81464   73728  921088   e0e00 OPT_SIZE=y OPT_INL=y, patched
 763717   81464   73728  918909   e057d OPT_SIZE=y OPT_INL=n, patched
 904490   81464   73728 1059682  102b62 OPT_SIZE=n OPT_INL=y, patched
 904938   81464   73728 1060130  102d22 OPT_SIZE=n OPT_INL=n, patched

> > If gcc decides to emit a separate function instead of inlining it, the 
> > image can have multiple instances of this uninlined function. 
> > Moreover, gcc decides if a function is too big to be inlined using a 
> > heuristic and sometimes gets it wrong. In particular, it uninlined 
> > constant_bit_test which indeed looks a bit big, but should reduce to a 
> > single assembly instruction after constant folding.
> 
> yep, gcc could definitely improve here. But if we never give it the 
> possibility to do so (by always forcing inlining) then gcc (or any other 
> compiler) wont really be optimized for Linux in this area.
> 
> we saw that with CC_OPTIMIZE_FOR_SIZE=y well - when the Linux kernel 
> started using it then both the correctness and the quality of gcc's -Os 
> output improved.
> 
> > So I guess we should sprinkle some __always_inlines in the core parts 
> > of the kernel? The most problematic ones are easily spotted using: nm 
> > -S vmlinux|uniq -f2 -D
> 
> yes - butwe should use a separate (new) __hint_always_inline tag - and 
> keep __always_inline for the cases where the code _must_ be inlined for 
> correctness reasons. (there are a few places where we do that)

That's becoming quite long. What about __wrapper? It should only be
applied to functions that do nothing more than select an implementation
based on compile-time properties of the arguments of the function or on
configuration variables.

Greetings,
    Alexander

> 	Ingo
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - Or how I learned to stop worrying and
                          love email again

