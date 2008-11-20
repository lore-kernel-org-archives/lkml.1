Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbYKTJE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbYKTJE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 04:04:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbYKTJEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 04:04:00 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60317 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003AbYKTJD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 04:03:56 -0500
Message-ID: <492527DF.1080602@redhat.com>
Date: Thu, 20 Nov 2008 11:03:27 +0200
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ryota OZAKI <ozaki.ryota@gmail.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kvm@vger.kernel.org, aarcange@redhat.com,
       chrisw@redhat.com, avi@redhat.com, dlaor@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com, cl@linux-foundation.org, corbet@lwn.net
Subject: Re: [PATCH 0/4] ksm - dynamic page sharing driver for linux v2
References: <1226888432-3662-1-git-send-email-ieidus@redhat.com> <5e93dcec0811192344l3813867egcc6b5a3c666142b9@mail.gmail.com>
In-Reply-To: <5e93dcec0811192344l3813867egcc6b5a3c666142b9@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------070701050102010309050809"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070701050102010309050809
Content-Type: text/plain; charset=windows-1255; format=flowed
Content-Transfer-Encoding: 8bit

φιθεθ Ryota OZAKI:
> Hi Izik,
>
> I've tried your patch set, but ksm doesn't work in my machine.
>
> I compiled linux patched with the four patches and configured with KSM
> and KVM enabled. After boot with the linux, I run two VMs running linux
> using QEMU with a patch in your mail and started KSM scanner with your
> script, then the host linux caused panic with the following oops.
>   

Yes you are right, we are missing pte_unmap(pte); in get_pte()!
that will effect just 32bits with highmem so this why you see it
thanks for the reporting, i will fix it for v3

below patch should fix it (i cant test it now, will test it for v3)

can you report if it fix your problem? thanks
>
> == BEGINNING of OOPS
> kernel BUG at arch/x86/mm/highmem_32.c:87!
> invalid opcode: 0000 [#1] SMP
> last sysfs file: /sys/class/net/vnet-ssh2/address
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Modules linked in: netconsole autofs4 nf_conntrack_ipv4 nf_defrag_ipv4
> xt_state nf_conntrack xt_tcpudp ipt_REJECT iptable_filter ip_tables
> x_tables loop kvm_intel kvm iTCO_wdt iTCO_vendor_support igb
> netxen_nic button ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd usbcore
> [last unloaded: microcode]
>
> Pid: 343, comm: kksmd Not tainted
> (2.6.28-rc5-linus-head-20081119-sparsemem #1) X7DWA
> EIP: 0060:[<c041eff9>] EFLAGS: 00010206 CPU: 6
> EIP is at kmap_atomic_prot+0x7d/0xeb
> EAX: c0008d94 EBX: c1ff6240 ECX: 00000163 EDX: 7e000000
> ESI: 00000154 EDI: 00000055 EBP: f5cdbf10 ESP: f5cdbef8
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process kksmd (pid: 343, ti=f5cda000 task=f617b140 task.ti=f5cda000)
> Stack:
>  7fa12163 fffff000 c204efbc f50479e8 9eb7e000 c08a34d0 f5cdbf18 c041f07a
>  f5cdbf28 c048339c 00000000 f5c271e0 f5cdbf30 c04833bc f5cdbfb0 c0483b0d
>  f5cdbf50 c0425845 00000000 00000064 00000009 c08a34d0 f5cdbfb0 c06384c1
> Call Trace:
>  [<c041f07a>] ? kmap_atomic+0x13/0x15
>  [<c048339c>] ? get_pte+0x50/0x63
>  [<c04833bc>] ? is_present_pte+0xd/0x1f
>  [<c0483b0d>] ? ksm_scan_start+0x9a/0x7ac
>  [<c0425845>] ? finish_task_switch+0x29/0xa4
>  [<c06384c1>] ? schedule+0x6bf/0x719
>  [<c041b3fc>] ? default_spin_lock_flags+0x8/0xc
>  [<c043bffa>] ? finish_wait+0x49/0x4e
>  [<c04845f4>] ? kthread_ksm_scan_thread+0x0/0xdc
>  [<c048462e>] ? kthread_ksm_scan_thread+0x3a/0xdc
>  [<c043bf31>] ? autoremove_wake_function+0x0/0x38
>  [<c043be3e>] ? kthread+0x40/0x66
>  [<c043bdfe>] ? kthread+0x0/0x66
>  [<c0404997>] ? kernel_thread_helper+0x7/0x10
> Code: 86 00 00 00 64 a1 04 a0 82 c0 6b c0 0d 8d 3c 30 a1 78 b0 77 c0
> 8d 34 bd 00 00 00 00 89 45 ec a1 0c d0 84 c0 29 f0 83 38 00 74 04 <0f>
> 0b eb fe c1 ea 1a 8b 04 d5 80 32 8a c0 83 e0 fc 29 c3 c1 fb
> EIP: [<c041eff9>] kmap_atomic_prot+0x7d/0xeb SS:ESP 0068:f5cdbef8
> Kernel panic - not syncing: Fatal exception
> == END of OOPS
>   


--------------070701050102010309050809
Content-Type: text/plain;
 name="fix_32highmem"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix_32highmem"

diff --git a/mm/ksm.c b/mm/ksm.c
index 707be52..e14448a 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -562,6 +562,7 @@ static pte_t *get_pte(struct mm_struct *mm, unsigned long addr)
 		goto out;
 
 	ptep = pte_offset_map(pmd, addr);
+	pte_unmap(ptep);
 out:
 	return ptep;
 }

--------------070701050102010309050809--
