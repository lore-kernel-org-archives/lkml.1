Return-Path: <linux-kernel-owner+w=401wt.eu-S1758245AbYHaWMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245AbYHaWMn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 18:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYHaWMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 18:12:35 -0400
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:56509 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbYHaWMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 18:12:34 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <48BB174C.4080900@citrix.com>
Date: Sun, 31 Aug 2008 23:12:28 +0100
From: Alex Nixon <alex.nixon@citrix.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Bernhard Schmidt <berni@birkenwald.de>, jeremy@goop.org
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc xen pvops regression?
References: <20080831171848.GA11653@pest>
In-Reply-To: <20080831171848.GA11653@pest>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernhard Schmidt wrote:
> Hello,
>
> I've been a happy user of vanilla 2.6.26 with pvops in my Xen domU for
> a couple of months. I wanted to test 2.6.27-rc (-rc3 a couple of weeks
> ago, -rc5 just now) to verify another issue and ran into the following
> error
>   
Thanks Bernhard - I'm able to reproduce it with your config.

I've had a look, and it seems the register_vcpu_info hypercall is being 
made twice, failing on the second time.  In fact, 
paravirt_pagetable_setup_{start,done} are both being called twice - once 
from arch/x86/kernel/setup.c, and then again from arch/x86/mm/init_32.c

I suspect one of them should go, but I'm not familiar enough with this 
code to suggest which one.

But still with that crudely resolved, the kernel BUGs (see below).  
Jeremy - any ideas?

- Alex


`xm dmesg':

(XEN) mm.c:2249:d168 Mfn 24384 not pinned

dmesg:

EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 160k freed
------------[ cut here ]------------
kernel BUG at 
/local/scratch/hotplug.linux.trees.git/arch/x86/xen/enlighten.c:850!
invalid opcode: 0000 [#1]

Pid: 1, comm: init Tainted: G        W 
(2.6.27-rc5-tip-00672-ge5c5407-dirty #52)
EIP: 0061:[<c0102b04>] EFLAGS: 00010282 CPU: 0
EIP is at pin_pagetable_pfn+0x3f/0x4b
EAX: ffffffea EBX: e242dd74 ECX: 00000001 EDX: 00000000
ESI: 00007ff0 EDI: 00000000 EBP: e242dd8c ESP: e242dd74
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: e021
Process init (pid: 1, ti=e242c000 task=e242a000 task.ti=e242c000)
Stack: 00000004 00024384 00000000 c144e8e0 00022747 00000000 e242dd9c 
c0102ee8
       c02fe5d4 c144e8e0 e242dda4 c0102f23 e242ddbc c0116722 00000000 
00000000
       00000000 00000000 e242de2c c01467a8 00000000 c1000000 00000000 
22747067
Call Trace:
 [<c0102ee8>] ? xen_release_ptpage+0x52/0x71
 [<c0102f23>] ? xen_release_pte+0xd/0xf
 [<c0116722>] ? __pte_free_tlb+0x35/0x4b
 [<c01467a8>] ? free_pgd_range+0x377/0x38c
 [<c015a4bf>] ? setup_arg_pages+0x1b8/0x22b
 [<c017a80f>] ? load_elf_binary+0x3f1/0x10a4
 [<c0104ffa>] ? check_events+0x8/0xe
 [<c0104f71>] ? xen_restore_fl_direct_end+0x0/0x3
 [<c0104937>] ? xen_force_evtchn_callback+0xf/0x14
 [<c0104f71>] ? xen_restore_fl_direct_end+0x0/0x3
 [<c014298a>] ? page_address+0x85/0xa2
 [<c0159c51>] ? put_arg_page+0x8/0xa
 [<c0159e27>] ? copy_strings+0x156/0x160
 [<c0159ea8>] ? search_binary_handler+0x42/0x10a
 [<c015ad64>] ? do_execve+0x129/0x192
 [<c0105354>] ? sys_execve+0x29/0x50
 [<c0106b1e>] ? syscall_call+0x7/0xb
 [<c0109b2f>] ? kernel_execve+0x17/0x1c
 [<c0102140>] ? run_init_process+0x17/0x19
 [<c01021e3>] ? init_post+0xa1/0xf2
 [<c01077df>] ? kernel_thread_helper+0x7/0x10

