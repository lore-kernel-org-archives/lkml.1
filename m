Return-Path: <linux-kernel-owner+w=401wt.eu-S1756590AbZGEJ05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbZGEJ05 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 05:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755784AbZGEJ0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 05:26:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47465 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754298AbZGEJ0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 05:26:46 -0400
Message-ID: <4A50723E.6030305@redhat.com>
Date: Sun, 05 Jul 2009 12:28:30 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v9 0/5] irqfd fixes and enhancements
References: <20090702153454.20186.99191.stgit@dev.haskins.net> <4A4CD729.6050300@redhat.com>
In-Reply-To: <4A4CD729.6050300@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2009 06:50 PM, Avi Kivity wrote:
> On 07/02/2009 06:37 PM, Gregory Haskins wrote:
>> (Applies to kvm.git/master:1f9050fd)
>>
>> The following is the latest attempt to fix the races in 
>> irqfd/eventfd, as
>> well as restore DEASSIGN support.  For more details, please read the 
>> patch
>> headers.
>>
>> As always, this series has been tested against the kvm-eventfd unit test
>> and everything appears to be functioning properly. You can download this
>> test here:
>
> Applied, thanks.
>

... and unapplied.  There's a refcounting mismatch in irqfd_cleanup: a 
reference is taken for each irqfd, but dropped for each guest.  This 
causes an oops if a guest with no irqfds is created and destroyed:

IP: [<ffffffff8105254a>] flush_workqueue+0x23/0x6e
PGD 0
Oops: 0000 [4] SMP
CPU 1
Modules linked in: kvm_intel kvm nfs lockd nfs_acl sco bridge stp bnep 
l2cap bluetooth autofs4 sunrpc ipv6 dm_multipath uinput i5000_edac 
e1000e edac_core iTCO_wdt
  iTCO_vendor_support i2c_i801 i2c_core e100 mii floppy pcspkr shpchp 
serio_raw ata_generic pata_acpi [last unloaded: kvm]
Pid: 2088, comm: qemu Tainted: G      D   2.6.27.19-170.2.35.fc10.x86_64 
#1 TYAN Transport GT20-B5372
RIP: 0010:[<ffffffff8105254a>]  [<ffffffff8105254a>] 
flush_workqueue+0x23/0x6e
RSP: 0018:ffff8801077d1b08  EFLAGS: 00010292
RAX: ffffffff8156de08 RBX: ffff8801097e8a50 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 000000000000019f RDI: 0000000000000000
RBP: ffff8801077d1b28 R08: 0000000000000000 R09: ffffffff81140027
R10: ffff88012f402340 R11: ffff880125daf820 R12: ffffffff8156de10
R13: 0000000000000000 R14: ffff88012f449cd8 R15: ffff88012f002900
FS:  00007f9b67295950(0000) GS:ffff88012fc04980(0000) knlGS:0000000000000000
CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
CR2: 0000000000000020 CR3: 0000000000201000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process qemu (pid: 2088, threadinfo ffff8801077d0000, task ffff88012984c530)
Stack:  ffff8801077d1b28 ffff8801097e8a50 ffff8801097e8000 ffff8801097e8a68
  ffff8801077d1b58 ffffffffa01c4eec 0000000800000000 ffff8801097e8000
  ffff88012f449cd8 ffff88012c80c600 ffff8801077d1b78 ffffffffa01af34b
Call Trace:
  [<ffffffffa01c4eec>] kvm_irqfd_release+0x7a/0xcc [kvm]
  [<ffffffffa01af34b>] kvm_vm_release+0x18/0x27 [kvm]
  [<ffffffff810c14c7>] __fput+0xca/0x16d
  [<ffffffff810c157f>] fput+0x15/0x17
  [<ffffffff810bea29>] filp_close+0x67/0x72
  [<ffffffff810433ec>] put_files_struct+0x74/0xc8
  [<ffffffff81043488>] exit_files+0x48/0x51
  [<ffffffff81044de9>] do_exit+0x26a/0x8a0
  [<ffffffffa01da330>] ? vmx_vcpu_put+0x9/0xb [kvm_intel]
  [<ffffffff810454a1>] do_group_exit+0x82/0xaf
  [<ffffffff8104eabb>] get_signal_to_deliver+0x2b0/0x2dc
  [<ffffffff81010379>] ? sysret_signal+0x42/0x71
  [<ffffffff8100f45f>] do_notify_resume+0x90/0x93f
  [<ffffffff81060cca>] ? do_futex+0x90/0x973
  [<ffffffffa01ad956>] ? kvm_vcpu_ioctl+0x470/0x485 [kvm]
  [<ffffffff81333801>] ? trace_hardirqs_on_thunk+0x3a/0x3c
  [<ffffffff810616a2>] ? sys_futex+0xf5/0x113
  [<ffffffff81010379>] ? sysret_signal+0x42/0x71
  [<ffffffff81010737>] ptregscall_common+0x67/0xb0

irqfd_cleanup.wq has never been initialized, but is destroyed.

-- 
error compiling committee.c: too many arguments to function

