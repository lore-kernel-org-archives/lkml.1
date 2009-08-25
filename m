Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbZHYILM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbZHYILM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 04:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754452AbZHYILL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 04:11:11 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:63097 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445AbZHYIK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 04:10:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=n0tnFgoD2FyITrnBLi22l1zsrwbFwVsJRUWNZe37iRAZT2vzxjmkgk3+u4ZK7xDARG
         xM4X6bSivXGBOeLkcBNx5nq4CDoPxvJrL6d91ra432ZnsbT1LIYG1quQWxQLNsBKTUbg
         ELaltvEREXI2sET97Ra5+us2MlRNbNKovFm0M=
MIME-Version: 1.0
Date: Tue, 25 Aug 2009 10:10:58 +0200
Message-ID: <c4e36d110908250110xe16720o977c8cf5c3386c4b@mail.gmail.com>
Subject: INFO: possible circular locking dependency - kacpid 
	acpi_os_wait_events_complete
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: bjorn.helgaas@hp.com, len.brown@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Now with 2.6.31-rc7 (3edf2fb9d80a46d6c32ba12547a42419845b4b76)
 I'm getting this  INFO trace - also I've noticed complete reset during resume
which could be eventually related to this ?

My machine - T61, 4GB, C2D
I suspect that some resent  thinkpad-acpi changes.

ACPI: Preparing to enter system sleep state S3
Disabling non-boot CPUs ...
kvm: disabling virtualization on CPU1
CPU 1 is now offline
lockdep: fixing up alternatives.
SMP alternatives: switching to UP code
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching NULL sched-domain.
CPU1 is down
Extended CMOS year: 2000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Back to C!
CPU0: Thermal monitoring handled by SMI
Extended CMOS year: 2000
Enabling non-boot CPUs ...
lockdep: fixing up alternatives.
SMP alternatives: switching to SMP code
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4390.86 BogoMIPS (lpj=7314990)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
mce: CPU supports 6 MCE banks
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0a
kvm: enabling virtualization on CPU1
CPU0 attaching NULL sched-domain.
Switched to high resolution mode on CPU 1
CPU0 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 1 0
CPU1 is up
ACPI: Waking up from system sleep state S3

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.31-rc7-00015-ge740538 #18
-------------------------------------------------------
kacpi_hotplug/114 is trying to acquire lock:
 (kacpid){+.+.+.}, at: [<ffffffff81064df0>] flush_workqueue+0x0/0xc0

but task is already holding lock:
 (&dpc->work){+.+.+.}, at: [<ffffffff81065183>] worker_thread+0x193/0x3f0

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&dpc->work){+.+.+.}:
       [<ffffffff8107eeac>] __lock_acquire+0xc5c/0x1090
       [<ffffffff8107f37a>] lock_acquire+0x9a/0x180
       [<ffffffff810651ce>] worker_thread+0x1de/0x3f0
       [<ffffffff810690e6>] kthread+0xa6/0xb0
       [<ffffffff8100d2da>] child_rip+0xa/0x20
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (kacpid){+.+.+.}:
       [<ffffffff8107ef7f>] __lock_acquire+0xd2f/0x1090
       [<ffffffff8107f37a>] lock_acquire+0x9a/0x180
       [<ffffffff81064e4f>] flush_workqueue+0x5f/0xc0
       [<ffffffff81261524>] acpi_os_wait_events_complete+0x15/0x23
       [<ffffffff81261561>] acpi_os_execute_hp_deferred+0x2f/0x43
       [<ffffffff810651d4>] worker_thread+0x1e4/0x3f0
       [<ffffffff810690e6>] kthread+0xa6/0xb0
       [<ffffffff8100d2da>] child_rip+0xa/0x20
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

2 locks held by kacpi_hotplug/114:
 #0:  (kacpi_hotplug){+.+...}, at: [<ffffffff81065183>]
worker_thread+0x193/0x3f0
 #1:  (&dpc->work){+.+.+.}, at: [<ffffffff81065183>] worker_thread+0x193/0x3f0

stack backtrace:
Pid: 114, comm: kacpi_hotplug Not tainted 2.6.31-rc7-00015-ge740538 #18
Call Trace:
 [<ffffffff8107cf0d>] print_circular_bug_tail+0x9d/0xe0
 [<ffffffff8107ef7f>] __lock_acquire+0xd2f/0x1090
 [<ffffffff8107b5ff>] ? save_trace+0x3f/0xb0
 [<ffffffff8107f37a>] lock_acquire+0x9a/0x180
 [<ffffffff81064df0>] ? flush_workqueue+0x0/0xc0
 [<ffffffff81261532>] ? acpi_os_execute_hp_deferred+0x0/0x43
 [<ffffffff81064e4f>] flush_workqueue+0x5f/0xc0
 [<ffffffff81064df0>] ? flush_workqueue+0x0/0xc0
 [<ffffffff81261524>] acpi_os_wait_events_complete+0x15/0x23
 [<ffffffff81261561>] acpi_os_execute_hp_deferred+0x2f/0x43
 [<ffffffff810651d4>] worker_thread+0x1e4/0x3f0
 [<ffffffff81065183>] ? worker_thread+0x193/0x3f0
 [<ffffffff8107b2fe>] ? put_lock_stats+0xe/0x30
 [<ffffffff81069540>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81064ff0>] ? worker_thread+0x0/0x3f0
 [<ffffffff810690e6>] kthread+0xa6/0xb0
 [<ffffffff8100d2da>] child_rip+0xa/0x20
 [<ffffffff8100cc40>] ? restore_args+0x0/0x30
 [<ffffffff81069040>] ? kthread+0x0/0xb0
 [<ffffffff8100d2d0>] ? child_rip+0x0/0x20
ACPI: \_SB_.GDCK - docking
acpi IBM0079:00: parent device:00 should not be sleeping
pci 0000:00:02.0: restoring config space at offset 0x1 (was 0x900007,
writing 0x900403)
pci 0000:00:02.1: restoring config space at offset 0x1 (was 0x900000,
writing 0x900007)
uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was
0x2800005, writing 0x2800001)
uhci_hcd 0000:00:1a.1: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 (was
0x2800005, writing 0x2800001)
ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 (was
0x2900106, writing 0x2900102)
ehci_hcd 0000:00:1a.7: PME# disabled
HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was
0x100106, writing 0x100102)


Zdenek
