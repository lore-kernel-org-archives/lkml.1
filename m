Return-Path: <linux-kernel-owner+w=401wt.eu-S1751924AbZHaXKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbZHaXKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 19:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751046AbZHaXKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 19:10:00 -0400
Received: from mail-iw0-f204.google.com ([209.85.223.204]:41920 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbZHaXJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 19:09:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=CyW0SVv31TBl+4RPmnsmTI80fx88s4KdOBHKRyOHmFNILhIE19/a6IoMz1s9embqXT
         DhLb4Vr/UHkR/D7XlF5TtRAJ5+W1u6T2nKYGwlSgJ4Yttm96i1s2f3d96CGXXuC0IZf4
         Q5J0nVP/nPnupYm/rbChj9rPKy9dXQ4CwFc0I=
MIME-Version: 1.0
Date: Mon, 31 Aug 2009 16:10:01 -0700
Message-ID: <438397970908311610o424a9777rd786417468f1d7d7@mail.gmail.com>
Subject: Lost CALL_FUNCTION_IPI(0xfb) on Xeon X7350 causes soft lockup
From: Kallol Biswas <nucleodyne@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   I have been trying to track down the root cause of a lost call
function interrupt that results in soft lockup. On soft lockup a crash
dump is initiated and another call  function IPI is sent from the same
processor. This time all other processors get the 2nd call function
interrupt.

Somehow the first call function interrupt gets lost for a CPU. I have
a total of 16 CPUs, first IPI is received by 14 CPUs, one does not
get. The CPU that generates the IPI keeps waiting on all 15 to get
this interrupt. The saved_call_data indicates that 14 CPUs get the
interrupt and complete.  So the CPU that generates the IPI waits
forever in a loop, which causes the soft lockup detection code to take
over and a system crash dump is initiated.

While dumping kernel memory, a 2nd IPI is initiated from the same CPU
to freeze all other CPUs. The call_data indicates all 15 of them get
and complete the IPI.

The stack trace is similar to:
https://bugzilla.redhat.com/show_bug.cgi?id=234600

PID: 5679   TASK: ffff811018041040  CPU: 5   COMMAND: "dd_raid"
 #0 [ffff8110186bfe20] start_disk_dump at ffffffff8808e48f
 #1 [ffff8110186bfef0] try_dump at ffffffff8024a500
 #2 [ffff8110186bff50] try_crashdump at ffffffff8024a5c2
 #3 [ffff8110186bff60] update_process_times at ffffffff8023ac4d
 #4 [ffff8110186bff80] smp_local_timer_interrupt at ffffffff802186c4
 #5 [ffff8110186bff90] smp_apic_timer_interrupt at ffffffff802187aa
 #6 [ffff8110186bffb0] apic_timer_interrupt at ffffffff8020caa6
--- <IRQ stack> ---
 #7 [ffff8107fca51bb8] apic_timer_interrupt at ffffffff8020caa6
    [exception RIP: __smp_call_function+0x76]
    RIP: ffffffff80217cc6  RSP: ffff8107fca51c60  RFLAGS: 00000297
    RAX: 0000000000000020  RBX: 0000000000000001  RCX: 0000000000000010
    RDX: 0000000000000000  RSI: ffff8107fca51c20  RDI: 0000000000000020
    RBP: ffff8107fca51c38   R8: 0000000000000001   R9: ffff8107fca51c30
    R10: 0000000000000058  R11: ffffffff802d5310  R12: ffff81101874f898
    R13: 000000000000000e  R14: ffff8107fca51c50  R15: 0000000000000001
    ORIG_RAX: ffffffffffffff10  CS: 0010  SS: 0018
 #8 [ffff8107fca51ca8] smp_call_function at ffffffff80217d3f
 #9 [ffff8107fca51cd8] on_each_cpu at ffffffff8023703d
#10 [ffff8107fca51cf8] invalidate_bdev at ffffffff802b28fa
#11 [ffff8107fca51d08] __invalidate_device at ffffffff802b81b8
#12 [ffff8107fca51d28] invalidate_partition at ffffffff803535c8
#13 [ffff8107fca51d48] del_gendisk at ffffffff802d4684

Is there a chip erratum that a call function IPI may not be delivered
to a processor?

cat /proc/cpuinfo

processor       : 15
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Xeon(R) CPU           X7350  @ 2.93GHz
stepping        : 11
cpu MHz         : 2925.861
cache size      : 4096 KB
physical id     : 6
siblings        : 4
core id         : 3
cpu cores       : 4
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall lm constant_tsc arch_perfmon pebs bts rep_good pni monitor
ds_cpl vmx est tm2 ssse3 cx16 xtpr dca lahf_lm
bogomips        : 5851.34
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management:
......
Total 16 processors on the system.
Kallol
