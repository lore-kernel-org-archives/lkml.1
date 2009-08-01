Return-Path: <linux-kernel-owner+w=401wt.eu-S1752363AbZHAV0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbZHAV0Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 17:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbZHAV0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 17:26:23 -0400
Received: from thunk.org ([69.25.196.29]:45889 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbZHAV0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 17:26:22 -0400
Date: Sat, 1 Aug 2009 17:26:16 -0400
From: Theodore Tso <tytso@mit.edu>
To: linux-kernel@vger.kernel.org
Cc: avi@redhat.com
Subject: Problems with CONFIG_KVM_GUEST?
Message-ID: <20090801212616.GD734@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	linux-kernel@vger.kernel.org, avi@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the XFS QA regression test suites to test ext4, I reliably get
lock-ups and OOPS's with I run a kernel using KVM with
CONFIG_KVM_GUEST configured.  This is with 2.6.31-rc3 and 2.6.31-rc4.  

The problems disappear if I turn off CONFIG_KVM_GUEST; the XFS tests
run without problem to completion once I turn this configuration
option off.  That's what I'll do for now, but if someone could look
into this, I'd appreciate it.

The KVM command-line which I am using is:

/usr/local/bin/qemu-system-x86_64 /kbuild/root_fs.img -net nic,model=ne2k_pci -net tap \
	-hdb /dev/closure/test-4k -hdc /dev/closure/scratch \
	-hdd /dev/closure/test-1k -serial telnet::4444,server -smp 2 -m 512 \
	--kernel /kbuild/ext4/arch/x86/boot/bzImage \
	--append "root=0800 console=ttyS0,115200 console=tty0"

... and here's a typical soft lockup report

[ 2666.103359] BUG: soft lockup - CPU#1 stuck for 61s! [sh:21485]
[ 2666.103359] Modules linked in:
[ 2666.112563] irq event stamp: 183767754
[ 2666.112563] hardirqs last  enabled at (183767753): [<c011ce56>] restore_all_notrace+0x0/0x18
[ 2666.112563] hardirqs last disabled at (183767754): [<c011d774>] apic_timer_interrupt+0x28/0x34
[ 2666.112563] softirqs last  enabled at (183758120): [<c01515c8>] __do_softirq+0x162/0x16a
[ 2666.112563] softirqs last disabled at (183758115): [<c011ed17>] do_softirq+0x68/0xc1
[ 2666.112563] 
[ 2666.112563] Pid: 21485, comm: sh Not tainted (2.6.31-rc3 #270) 
[ 2666.112563] EIP: 0060:[<c01bb04f>] EFLAGS: 00010282 CPU: 1
[ 2666.112563] EIP is at handle_mm_fault+0x102/0x82e
[ 2666.112563] EAX: d5028110 EBX: 00000000 ECX: 00000110 EDX: d5028110
[ 2666.112563] ESI: 00000007 EDI: c11a6000 EBP: d51d7f2c ESP: d51d7ed8
[ 2666.112563]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[ 2666.112563] CR0: 8005003b CR2: d5028110 CR3: 1f93d000 CR4: 000006f0
[ 2666.112563] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 2666.112563] DR6: ffff0ff0 DR7: 00000400
[ 2666.112563] Call Trace:
[ 2666.112563]  [<c0161f7e>] ? down_read_trylock+0x39/0x43
[ 2666.112563]  [<c0625252>] do_page_fault+0x307/0x31d
[ 2666.112563]  [<c0624f4b>] ? do_page_fault+0x0/0x31d
[ 2666.112563]  [<c06235bb>] error_code+0x6b/0x70
[ 2666.112563]  [<c0624f4b>] ? do_page_fault+0x0/0x31d
[ 2666.112563]  [<c0345ca5>] ? __put_user_4+0x11/0x18
[ 2666.112563]  [<c014610a>] ? schedule_tail+0x4f/0x52
[ 2666.112563]  [<c011cc46>] ret_from_fork+0x6/0x1c

							- Ted
