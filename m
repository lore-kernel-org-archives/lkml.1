Return-Path: <linux-kernel-owner+w=401wt.eu-S1755023AbZFDFRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023AbZFDFRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 01:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750923AbZFDFQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 01:16:54 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:63635 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbZFDFQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 01:16:53 -0400
Message-Id: <200906040516.n545Gj0B004100@www262.sakura.ne.jp>
Subject: [X86/KVM] gcc 3.3 internal error.
From: penguin-kernel@i-love.sakura.ne.jp
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Thu, 04 Jun 2009 14:16:45 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 04062009 #2082812, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I tried "make allmodconfig" on linux-2.6.30-rc8 using gcc 3.3.5
and got below compilation error.

-----
# make
/usr/src/all/vanilla/src/linux-2.6.30-rc8/arch/x86/Makefile:82: stack protector enabled but no compiler support
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  CC [M]  arch/x86/kvm/x86_emulate.o
{standard input}: Assembler messages:
{standard input}:4274: Warning: end of file not at end of a line; newline inserted
{standard input}:4975: Error: unrecognized symbol type ""
gcc: Internal error: Segmentation fault (program cc1)
Please submit a full bug report.
See <URL:http://gcc.gnu.org/bugs.html> for instructions.
For Debian GNU/Linux specific bug reporting instructions,
see <URL:file:///usr/share/doc/gcc-3.3/README.Bugs>.

make[1]: *** [arch/x86/kvm/x86_emulate.o] Error 1
make: *** [arch/x86/kvm] Error 2
-----

It turned out that linux-2.6.29.4 succeeds, linux-2.6.30-rc1 and later fail.
According to "git bisect", 9e111f3e167a14dd6252cff14fc7dd2ba4c650c6 is the
cause.

-----
$ cat ~/buildtest.sh
#! /bin/sh
make -s allmodconfig || exit 125
touch arch/x86/kvm/x86_emulate.c
make -s arch/x86/kvm/x86_emulate.o 2>&1 | grep -q gcc && exit 1
exit 0
$ git bisect start v2.6.30-rc1 v2.6.29
$ git bisect run ~/buildtest.sh
Bisecting: 5117 revisions left to test after this
(...snipped...)
9e111f3e167a14dd6252cff14fc7dd2ba4c650c6 is first bad commit
commit 9e111f3e167a14dd6252cff14fc7dd2ba4c650c6
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Jan 27 18:18:25 2009 +0100

    x86: move ELAN to the NON_STANDARD_PLATFORM section

    Move X86_ELAN (old, AMD based web-boxes) from the subarchitecture
    menu to the non-standard-platform section.

    Signed-off-by: Ingo Molnar <mingo@elte.hu>

:040000 040000 9d55953d05b0aeac76d59d36dceb90f6358cdfc9 4e806f764ace35e5395c9e95d54840a04eaa43e4 M      arch
bisect run success
-----

That commit changed some other config options.

-----
$ diff config-good config-bad
4c4
< # Thu Jun  4 14:00:29 2009
---
> # Thu Jun  4 14:02:48 2009
200d199
< # CONFIG_X86_ELAN is not set
205a205
> CONFIG_X86_ELAN=y
216,241d215
< # CONFIG_M386 is not set
< # CONFIG_M486 is not set
< # CONFIG_M586 is not set
< # CONFIG_M586TSC is not set
< # CONFIG_M586MMX is not set
< CONFIG_M686=y
< # CONFIG_MPENTIUMII is not set
< # CONFIG_MPENTIUMIII is not set
< # CONFIG_MPENTIUMM is not set
< # CONFIG_MPENTIUM4 is not set
< # CONFIG_MK6 is not set
< # CONFIG_MK7 is not set
< # CONFIG_MK8 is not set
< # CONFIG_MCRUSOE is not set
< # CONFIG_MEFFICEON is not set
< # CONFIG_MWINCHIPC6 is not set
< # CONFIG_MWINCHIP3D is not set
< # CONFIG_MGEODEGX1 is not set
< # CONFIG_MGEODE_LX is not set
< # CONFIG_MCYRIXIII is not set
< # CONFIG_MVIAC3_2 is not set
< # CONFIG_MVIAC7 is not set
< # CONFIG_MPSC is not set
< # CONFIG_MCORE2 is not set
< # CONFIG_GENERIC_CPU is not set
< CONFIG_X86_GENERIC=y
246c220
< CONFIG_X86_L1_CACHE_SHIFT=5
---
> CONFIG_X86_L1_CACHE_SHIFT=4
248d221
< CONFIG_X86_PPRO_FENCE=y
253,256c226
< CONFIG_X86_INTEL_USERCOPY=y
< CONFIG_X86_USE_PPRO_CHECKSUM=y
< CONFIG_X86_TSC=y
< CONFIG_X86_CMOV=y
---
> CONFIG_X86_ALIGNMENT_16=y
421a392,393
> CONFIG_ELAN_CPUFREQ=m
> CONFIG_SC520_CPUFREQ=m
-----

Regards.
