Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677AbZFURI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbZFURI0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 13:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbZFURIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 13:08:19 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:57067 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbZFURIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 13:08:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=ClCs1lgGosCDiR8TRMfHT9m/VSuausZyK8xqlODqiYmgShAnhxhl7YgyJqgaJVmV/u
         P/GScS9Vuly9OX8f35QEBxR7bzmFnkjruIb25kVk1bTItlZ2yI2c92HkvHGDZgVxG5Vj
         eA9Ct5C2b575Ino+1AYMEF2BDpj5csmOMjkaw=
MIME-Version: 1.0
Date: Sun, 21 Jun 2009 19:02:11 +0200
Message-ID: <8db1092f0906211002y2b391212ve2902fc3a6517586@mail.gmail.com>
Subject: 2.6.30-git(16 and 17) system hangs after resume from suspend to disk, 
	mce related?
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ak@linux.intel.com, "H. Peter Anvin" <hpa@zytor.com>,
       seto.hidetoshi@jp.fujitsu.com, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested kernel version: 2.6.30-git16 and 2.6.30-git17
Last known good: 2.6.30

System hangs few minutes after resume from suspend to disk. I have
tried bisection and here is result:

4efc0670baf4b14bc95502e54a83ccf639146125 is first bad commit
commit 4efc0670baf4b14bc95502e54a83ccf639146125
Author: Andi Kleen <ak@linux.intel.com>
Date:   Tue Apr 28 19:07:31 2009 +0200

    x86, mce: use 64bit machine check code on 32bit

    The 64bit machine check code is in many ways much better than
    the 32bit machine check code: it is more specification compliant,
    is cleaner, only has a single code base versus one per CPU,
    has better infrastructure for recovery, has a cleaner way to communicate
    with user space etc. etc.

    Use the 64bit code for 32bit too.

    This is the second attempt to do this. There was one a couple of years
    ago to unify this code for 32bit and 64bit.  Back then this ran into some
    trouble with K7s and was reverted.

    I believe this time the K7 problems (and some others) are addressed.
    I went over the old handlers and was very careful to retain
    all quirks.

    But of course this needs a lot of testing on old systems. On newer
    64bit capable systems I don't expect much problems because they have been
    already tested with the 64bit kernel.

    I made this a CONFIG for now that still allows to select the old
    machine check code. This is mostly to make testing easier,
    if someone runs into a problem we can ask them to try
    with the CONFIG switched.

    The new code is default y for more coverage.

    Once there is confidence the 64bit code works well on older hardware
    too the CONFIG_X86_OLD_MCE and the associated code can be easily
    removed.

    This causes a behaviour change for 32bit installations. They now
    have to install the mcelog package to be able to log
    corrected machine checks.

    The 64bit machine check code only handles CPUs which support the
    standard Intel machine check architecture described in the IA32 SDM.
    The 32bit code has special support for some older CPUs which
    have non standard machine check architectures, in particular
    WinChip C3 and Intel P5.  I made those a separate CONFIG option
    and kept them for now. The WinChip variant could be probably
    removed without too much pain, it doesn't really do anything
    interesting. P5 is also disabled by default (like it
    was before) because many motherboards have it miswired, but
    according to Alan Cox a few embedded setups use that one.

    Forward ported/heavily changed version of old patch, original patch
    included review/fixes from Thomas Gleixner, Bert Wesarg.

    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>
    Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

:040000 040000 3ed45ebe46fdbb0df7f4190400fa4640be9f4c6c
e1fbb6da0ce70b944894d47c7e6fef0d30b5ff71 M      arch


Unfortunately, because system hangs, I haven't any information in logs.

/proc/cpuinfo:
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Pentium(R) Dual  CPU  E2180  @ 2.00GHz
stepping        : 13
cpu MHz         : 1200.000
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
lm constant_tsc arch_perfmon pebs bts pni dtes64 monitor ds_cpl est
tm2 ssse3 cx16 xtpr pdcm lahf_lm
bogomips        : 3999.98
clflush size    : 64
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Pentium(R) Dual  CPU  E2180  @ 2.00GHz
stepping        : 13
cpu MHz         : 1200.000
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
apicid          : 1
initial apicid  : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
lm constant_tsc arch_perfmon pebs bts pni dtes64 monitor ds_cpl est
tm2 ssse3 cx16 xtpr pdcm lahf_lm
bogomips        : 3999.72
clflush size    : 64
power management:

dmesg, config from 2.6.30-git17:
http://unixy.pl/maciek/download/kernel/2.6.30-git17/pc/

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
