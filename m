Return-Path: <linux-kernel-owner+w=401wt.eu-S1754443AbZEaFk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbZEaFk5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 01:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbZEaFks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 01:40:48 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:43477 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbZEaFkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 01:40:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=NLrZ/wJlvgzR8ymwAZ2oX6njT8OseCV/BONeJIb3M5jWJvCnFwiyi0bTtPUaIzbHVT
         h1gE2+uhivZ9WocxV3ygko2lkffLkwv6tAUhGPOPMa4+3YQUTNgX4CcLmAo8gS/Qi18E
         MEHHgPjEMb1hCuT2meCtEa10eK2/D5n/7qbKA=
MIME-Version: 1.0
Date: Sun, 31 May 2009 10:10:48 +0430
Message-ID: <47a46110905302240w36d78bcbne506210dd7e9c1d2@mail.gmail.com>
Subject: kernel panic despite enabling math-emulation
From: Reza Mostafid <m.r.mostafid@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: m.r.mostafid@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am trying to build a stripped down v2.6.* kernel to run on a single
chip 386 processor.
As I understand it, the math emulation library must be enabled (
compiled into the kernel )
to cater for the absence of a proper HW FPU.

I am doing the builds on a more modern x86 desktop machine running Fedora 8
( based on 2.6.23.1 kernel ) using the source from Fedora 8 ( i.e.
with the F8 patches
  applied against a 2.6.23.1 kernel )

As a first step, after building the kernel with
'CONFIG_MATH_EMULATION=y' I tried to test
this feature on my build machine ( which does have an FPU ), by
supplying the 'no387'
boot parameter in order to simulate a non-existing FPU.

Running the math-emu enabled kernel in this way causes a kernel panic
which happens before
spawning 'init' and early-user space initialization.

I have observed this condition with several 2.6.* kernel versions and
several Intel/AMD boxes.

Using the 'earlyprintk=vga' bootparameter and some printk statements
sprinkled in the
appropriate corners of the code ( i.e. '__init' function 'no387()' in
bug.c ) I was able to
observe that in all three cases the 'no387()' code snippet executes
its stuff without hick ups
when the 'no388' boot parameter is processed

 37 static int __init no_387(char *s)
 38 {
 39         boot_cpu_data.hard_math = 0;
 40         write_cr0(0xE | read_cr0());
 41         return 1;
 42 }
 43
 44 __setup("no387", no_387);

The kernel freeze happens as a result of a panic in 'fpu_entry.c' (
here I have reproduced code
and line no.s from the file as it exists in v2.6.23.1 under
'arch/i386/math-emu' )

179   else if ( FPU_CS == __KERNEL_CS )
180     {
181       printk("math_emulate: %04x:%08lx\n",FPU_CS,FPU_EIP);
182       panic("Math emulation needed in kernel");
183     }
184   else

In all cases the following lines are the last outputs to the console:

  math_emulate: <some FPU_CS value>:<some FPU_EIP value>
  Kernel panic-not syncing: Math emulation needed in kernel

So it appears that even with math emulation enabled the logic of the
code in 'fpu_entry.c' takes
the kernel into the above 'else', i.e. the kernel thinks that there is
no 'math emulation'.

Searching the web I was able to find references to this problem in
several threads but no apparent
solution to it.

Math-emulation albeit not a widely used feature, should have been
around long enough for someone to
have stumbled upon such an obvious problem.

Q1) Am I overlooking anything?

 or

Q2) Is this a problem in the code?

 and finally

Q3) Any suggestions for how I could get a 2.6 kernel to actually run
with the math-emu?



Regards


Reza Mostafid



==========================================================================================================

Here is a reproduction of the steps I took:


i)   I downloaded the source rpms for the Fedora distro I am running (
Fedora Core 8 which runs
     a modified version of the 2.6.23.1 kernel ).

ii)  I compiled the Fedora kernel version thus obtained ( using the
supplied distro .config ) and
     it boots fine

iii) I then change a single parameter of the original configuration,
i.e. enable math-emulation and
     I observed the problem ( kernel panics with the 'no387' param
supplied )

iv)  I then reproduced the same problem booting a 'kernel.org' vanilla
2.6.23.1 kernel with the same
     configuration and observed the same problem.

v)   Finally several different versions of the 'kernel.org' vanilla
source were compiled with the same
     configuration ( the FC8 distro '.config' with just the 'math-emu'
enabled ) on three different PCs.
     Each time the same problem: Each math-emu enabled kernel boots
fine, until you supply the 'no387'
     option, in which case all of them hang at the same place.


Configuration used as base:    That of the Fedora 8 distro

Parameter changed:             CONFIG_MATH_EMULATION=y

Kernels tested:

2.6.23.1 source rpm for Fedora 8
2.6.23.1 'vanilla' from 'kernel.org'
2.6.11.12 'vanilla' from 'kernel.org'
2.6.12.6  'vanilla' from 'kernel.org'
2.6.28.8  'vanilla' from 'kernel.org'

CPUs/machines problem was observed on:

Intel Celeron 331 ( Netburst type P4 )
AMD Semperon
AMD Athlon
