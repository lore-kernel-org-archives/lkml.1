Return-Path: <linux-kernel-owner+w=401wt.eu-S1753883AbXDYLsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbXDYLsw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 07:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbXDYLsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 07:48:52 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753883AbXDYLsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 07:48:51 -0400
Date: Wed, 25 Apr 2007 04:48:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Zachary Amsden <zach@vmware.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386: For debugging, make the initial page table setup
 less forgiving.
Message-Id: <20070425044813.f83dde4e.akpm@linux-foundation.org>
In-Reply-To: <200704132149.l3DLnvUY012097@tazenda.hos.anvin.org>
References: <200704132149.l3DLnvUY012097@tazenda.hos.anvin.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007 14:49:57 -0700 "H. Peter Anvin" <hpa@zytor.com> wrote:

> We just discovered that the accounting for initial memory usage
> (head.S: INIT_MAP_BEYOND_END) has been way, way off for a very long
> time.  This patch makes the initial page table not round up to the
> nearest 4M boundary, but instead stop dead (and zero the rest of the
> final page table) as soon as it hits the configured limit.
> 
> This patch is intended as a debugging aid.  If it goes into the
> kernel, it should go in at the very beginning of a review cycle, as it
> may very well expose real failures (without Jeremy's patch to fix the
> accounting, it *will* crash.)
> 
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> 
> diff --git a/arch/i386/kernel/head.S b/arch/i386/kernel/head.S
> index 3fa7f93..db6735a 100644
> --- a/arch/i386/kernel/head.S
> +++ b/arch/i386/kernel/head.S
> @@ -131,15 +131,27 @@ page_pde_offset = (__PAGE_OFFSET >> 20);
>  	movl %ecx,page_pde_offset(%edx)		/* Store kernel PDE entry */
>  	addl $4,%edx
>  	movl $1024, %ecx
> +	/*
> +	 * End condition: we must map up to and including
> +	 * INIT_MAP_BEYOND_END bytes beyond the end of our
> +	 * own page tables; 0x1000 is the size of the page
> +	 * table were about to write, and +0x007 is the
> +	 * attribute bits.
> +	 */
> +	leal (INIT_MAP_BEYOND_END+0x1000+0x007)(%edi),%ebp
>  11:
>  	stosl
>  	addl $0x1000,%eax
> -	loop 11b
> -	/* End condition: we must map up to and including INIT_MAP_BEYOND_END */
> -	/* bytes beyond the end of our own page tables; the +0x007 is the attribute bits */
> -	leal (INIT_MAP_BEYOND_END+0x007)(%edi),%ebp
>  	cmpl %ebp,%eax
> -	jb 10b
> +	jae 12f
> +	loop 11b
> +	jmp 10b
> +12:
> +	/* Clear the remainder of the last page table */
> +	decl %ecx
> +	xorl %eax,%eax
> +	rep; stosl
> +	
>  	movl %edi,(init_pg_tables_end - __PAGE_OFFSET)
>  
>  	xorl %ebx,%ebx				/* This is the boot CPU (BSP) */

This patch causes oopses after a minute or so running LTP's

./testcases/bin/growfiles -W gf16 -b -e 1 -i 0 -L 120 -u -g 4090 -T 100 -t 408990 -l -C 10 -c 1000 -S 10 -f Lgf02_

on everyone's favoutite Vaio, configured with
http://userweb.kernel.org/~akpm/config-sony.txt

BUG: unable to handle kernel paging request at virtual address c084fa8c
 printing eip:
c0174c46
*pde = 0042a027
*pte = 00000000
Oops: 0002 [#1]
Modules linked in: ipw2200 sonypi ipv6 autofs4 hidp l2cap bluetooth sunrpc nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink xt_tcpudp iptable_filter ip_tables x_tables cpufreq_ondemand video sbs button battery asus_acpi ac nvram ohci1394 ieee1394 ehci_hcd uhci_hcd sg joydev snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss sr_mod snd_pcm cdrom ieee80211 ieee80211_crypt snd_timer piix snd soundcore snd_page_alloc i2c_i801 generic i2c_core pcspkr ext3 jbd ide_disk ide_core
CPU:    0
EIP:    0060:[<c0174c46>]    Not tainted VLI
EFLAGS: 00010212   (2.6.21-rc7 #13)
EIP is at __block_prepare_write+0x246/0x445
eax: 00000000   ebx: c084f000   ecx: 0000015d   edx: 00000574
esi: 00000000   edi: c084fa8c   ebp: 00000000   esp: f51e3bc8
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process growfiles (pid: 2913, ti=f51e2000 task=f5f31340 task.ti=f51e2000)
Stack: c08317b8 00000001 0000000a 00000000 c08317f0 f6c0f9b0 00000980 00000574 
       f58953d8 00000000 c10109e0 f7dbb0d8 00005e1a 00000000 00001000 c08317b8 
       f51e3c24 fffff000 00000000 01000286 00001000 00001000 0000000a f58953d8 
Call Trace:
 [<c0174e67>] block_prepare_write+0x22/0x30
 [<f8b853b8>] ext3_get_block+0x0/0xd0 [ext3]
 [<f8b866e2>] ext3_prepare_write+0x0/0x151 [ext3]
 [<f8b86778>] ext3_prepare_write+0x96/0x151 [ext3]
 [<f8b853b8>] ext3_get_block+0x0/0xd0 [ext3]
 [<f8b866e2>] ext3_prepare_write+0x0/0x151 [ext3]
 [<c0142832>] generic_file_buffered_write+0x26d/0x5eb
 [<c024d691>] ata_altstatus+0x1d/0x24
 [<c011e314>] current_fs_time+0x37/0x3c
 [<c0143096>] __generic_file_aio_write_nolock+0x4e6/0x562
 [<f8b91728>] ext3_permission+0x0/0xa [ext3]
 [<c02e3322>] __mutex_lock_slowpath+0x1ac/0x1b4
 [<c0143173>] generic_file_aio_write+0x61/0xc1
 [<f8b82dfc>] ext3_file_write+0x24/0x90 [ext3]
 [<c015a444>] do_sync_write+0xc7/0x10a
 [<c012907c>] autoremove_wake_function+0x0/0x35
 [<c015a37d>] do_sync_write+0x0/0x10a
 [<c015ac89>] vfs_write+0xa8/0x155
 [<c015b1c5>] sys_write+0x41/0x67
 [<c0163e2a>] sys_fcntl64+0x7d/0x87
 [<c0103b68>] syscall_call+0x7/0xb
 =======================
Code: fa ff 80 7c 24 4f 00 89 c3 74 2f 8b 54 24 50 2b 94 24 80 00 00 00 8b 84 24 80 00 00 00 89 d1 89 54 24 1c c1 e9 02 8d 3c 03 89 f0 <f3> ab f6 c2 02 74 02 66 ab f6 c2 01 74 01 aa 80 7c 24 4e 00 74 
EIP: [<c0174c46>] __block_prepare_write+0x246/0x445 SS:ESP 0068:f51e3bc8
note: growfiles[2913] exited with preempt_count 1
BUG: unable to handle kernel paging request at virtual address c0850048


Dropped, with alacrity, at 4:47AM.  More care and better testing and
reviewing, please.
