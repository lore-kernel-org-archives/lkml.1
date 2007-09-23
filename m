Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbXIWWWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbXIWWWq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 18:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753766AbXIWWWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 18:22:38 -0400
Received: from mta-fs-be-07.sunrise.ch ([194.158.229.19]:43670 "EHLO
	mail-fs.sunrise.ch" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753100AbXIWWWi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 18:22:38 -0400
X-Greylist: delayed 1641 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Sep 2007 18:22:38 EDT
Date: Sun, 23 Sep 2007 21:55:13 +0000
Message-ID: <46E1184D0000CFD8@mta-fs-be-07.sunrise.ch>
From: osth@freesurf.ch
Subject: Xen kernel 2.6.23-rc7 bug at xen_mc_flush (arch/i386/xen/multicalls.c:68)
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Using kernel 2.6.23-rc7 as xen domU client system I observe a kernel bug
which occurs reproducibly when calling a shell from midnight commander F2
context menu or with testcase given below  (However most other programs seem
to
be well behaved and do not trigger this bug). - A kernel compiled with debug
info gives:

Kernel BUG at c01037dc [verbose debug info unavailable]
invalid opcode: 0000 [#5]
PREEMPT SMP
...
Call Trace:
[<c0103de9>] <0> [<c015d1d1>] <0> [<c0190078>] <0> [<c012633e>] <0> [<c016fa54>]
<0> [<c0106547>] <0> [<c01080d2>] <0> =======================
...
gdb) l *0xc01037dc
0xc01037dc is in xen_mc_flush (arch/i386/xen/multicalls.c:68).
63              } else
64                      BUG_ON(b->argidx != 0);
65
66              local_irq_restore(flags);
67
68              BUG_ON(ret);
69      }
0xc0103de9 is in xen_exit_mmap (arch/i386/xen/multicalls.h:42).
0xc015d1d1 is in exit_mmap (include/asm/paravirt.h:722).
0xc0190078 is in load_script (fs/binfmt_script.c:19).
0xc012633e is in mmput (kernel/fork.c:395).
0xc016fa54 is in do_execve (fs/exec.c:1421).
0xc0106547 is in sys_execve (arch/i386/kernel/process.c:793).
No source file for address 0xc01080d2.

/proc/cpuinfo: ...AMD Athlon(tm) X2 Dual Core Processor BE-2350 ...

full info is at http://spblinux.de/xen/20070923/

Same bug if preempt is disabled; same bug if vcpus is reduced to 1 in xen
domU.

Please cc to osth at freesurf.ch because I am not on the list.

Christian Ostheimer

testcase which triggers the bug:

#!/bin/bash
#
# modified configure script: max commandline length test
CONFIG_SHELL=/bin/bash
i=0
export teststring=ABCD
    while (test "X"`$CONFIG_SHELL -c "echo X$teststring" 2>/dev/null` \
	       = "XX$teststring") >/dev/null 2>&1 &&
	    new_result=`expr "X$teststring" : ".*" 2>&1` &&
	    lt_cv_sys_max_cmd_len=$new_result &&
	    test $i != 17 # 1/2 MB should be enough
    do 
      i=`expr $i + 1`
      teststring=$teststring$teststring
    done
    teststring=
    # Add a significant safety factor because C++ compilers can tack on massive
    # amounts of additional arguments before passing them to the linker.
    # It appears as though 1/2 is a usable value.
    echo `expr $lt_cv_sys_max_cmd_len \/ 2`


Neu: Das erste ADSL-Abo ohne Monatsgebühr! Steigen Sie jetzt auf sunrise
ADSL free um.
http://www.sunrise.ch/privatkunden/iminternetsurfen/adsl/adsl_abosundpreise/adsl_gelegenheitssurfer/adsl_free.htm



