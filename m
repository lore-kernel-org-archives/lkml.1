Return-Path: <linux-kernel-owner+w=401wt.eu-S1763564AbYESVNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763564AbYESVNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 17:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763340AbYESVNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 17:13:37 -0400
Received: from mail.fieldses.org ([66.93.2.214]:60301 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762967AbYESVNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 17:13:34 -0400
Date: Mon, 19 May 2008 17:13:14 -0400
To: Michael Lang <Michael.Lang@jackal-net.at>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: Kernel Panic when accessing NFS share and locking files
Message-ID: <20080519211314.GL11993@fieldses.org>
References: <482B2108.4090902@jackal-net.at> <20080514204932.13243cab.akpm@linux-foundation.org> <20080514205528.3bf3955d@infradead.org> <482C1EC4.9000901@jackal-net.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482C1EC4.9000901@jackal-net.at>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 01:30:12PM +0200, Michael Lang wrote:
> Arjan van de Ven wrote:
>> On Wed, 14 May 2008 20:49:32 -0700
>> Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>>   
>>> On Wed, 14 May 2008 19:27:36 +0200 Michael Lang
>>> <Michael.Lang@jackal-net.at> wrote:
>>>
>>>     
>>>> Hi,
>>>>
>>>> we encountered a serious problem, when using Solaris NFS (Server)  
>>>> accessing it with a CentOS5.1/RHEL5.1 client.
>>>>       
>>
>>
>>
>>   
>>> Which kernel version is being used?
>>>     
>>
>> that'll be a 2.6.18 variant ;)
>>
>> there have been some, but not too many, reports of a trace like this:
>> http://www.kerneloops.org/search.php?search=__fput
>>   
>
> at least 2.6.25-3 also reports it as a kernel bug, but doesn't panic any  
> more ...
> i attached the whole dmesg to the mail ...
> regards
>
> Michael Lang
>
> ------------[ cut here ]------------
> kernel BUG at fs/locks.c:2051!


	if (filp->f_op && filp->f_op->flock) {
		struct file_lock fl = {
			.fl_pid = current->tgid,
			.fl_file = filp,
			.fl_flags = FL_FLOCK,
			.fl_type = F_UNLCK,
			.fl_end = OFFSET_MAX,
		};
		filp->f_op->flock(filp, F_SETLKW, &fl);
		if (fl.fl_ops && fl.fl_ops->fl_release_private)
			fl.fl_ops->fl_release_private(&fl);
	}

So when the unlock above completed there should have been no posix file
locks left with fl_file == filp.

Nobody else should have a reference to filp when locks_remove_flock() is
called, which I think should ensure that no additional locks for filp
can appear after this point.

	lock_kernel();
	before = &inode->i_flock;

	while ((fl = *before) != NULL) {
		if (fl->fl_file == filp) {
			if (IS_FLOCK(fl)) {
				locks_delete_lock(before);
				continue;
			}
			if (IS_LEASE(fl)) {
				lease_modify(before, F_UNLCK);
				continue;
			}
			/* What? */
			BUG();

OK, but the fact that this BUG() is triggering means that a posix lock
was found.

--b.

 		}
		before = &fl->fl_next;
	}
	unlock_kernel();

	

> invalid opcode: 0000 [1] SMP
> CPU 1
> Modules linked in: ipt_REJECT iptable_filter ip_tables bridge nfsd  
> auth_rpcgss exportfs autofs4 hidp nfs lockd nfs_acl rfcomm l2cap  
> bluetooth sunrpc raid1 dm_round_robin tun ip6t_REJECT xt_tcpudp  
> ip6table_filter ip6_tables x_tables ib_iser rdma_cm ib_cm iw_cm ib_sa  
> ib_mad ib_core ib_addr iscsi_tcp libiscsi scsi_transport_iscsi  
> cpufreq_ondemand acpi_cpufreq ipv6 dm_multipath sbs sbshc battery  
> acpi_memhotplug ac lp sg floppy ide_cd_mod cdrom serio_raw snd_hda_intel  
> parport_pc snd_seq_dummy snd_seq_oss button parport snd_seq_midi_event  
> snd_seq snd_seq_device 8139too 8139cp snd_pcm_oss i2c_i801 mii  
> snd_mixer_oss snd_pcm i2c_core snd_timer snd pcspkr soundcore shpchp  
> snd_page_alloc dm_snapshot dm_zero dm_mirror dm_mod ata_piix libata  
> sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd [last unloaded:  
> microcode]
> Pid: 4763, comm: python Not tainted 2.6.25.3 #1
> RIP: 0010:[<ffffffff80299f5d>] [<ffffffff80299f5d>]  
> locks_remove_flock+0xe2/0x102
> RSP: 0018:ffff81000d1dfe38 EFLAGS: 00010246
> RAX: 0000000000000081 RBX: ffff81000d31d2e8 RCX: ffff81001cc638c0
> RDX: ffff81000f4101c0 RSI: 0000000000000286 RDI: ffffffff80580dc0
> RBP: ffff810011232140 R08: ffff81001747aac0 R09: ffff81000d1dfb00
> R10: 0000000000000004 R11: 000000200000001f R12: ffff81000d31d1e8
> R13: ffff81000d31d1e8 R14: ffff81001ac4c680 R15: ffff81000df68220
> FS: 00000000421e6940(0063) GS:ffff81001d979840(0000) knlGS:0000000000000000
> CS: 0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000003335ebfe80 CR3: 000000000ee12000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process python (pid: 4763, threadinfo ffff81000d1de000, task  
> ffff81000f4101c0)
> Stack: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
> 0000000000000000 ffff810011232140 0000000000001299 0000000000000000
> 0000000000000000 0000000000000000 0000000000000000 ffff810011232140
> Call Trace:
> [<ffffffff8028d229>] ? __fput+0x97/0x17e
> [<ffffffff80297692>] ? sys_fcntl+0x2eb/0x2f7
> [<ffffffff8020be19>] ? tracesys+0xdc/0xe1
>
>
> Code: 48 39 68 58 75 29 0f b6 40 60 a8 02 74 0a 48 89 df e8 5f fe ff ff  
> eb 1a a8 20 74 0f be 02 00 00 00 48 89 df e8 e9 fe ff ff eb 07 <0f> 0b  
> eb fe 48 89 c3 48 8b 03 48 85 c0 75 c6 e8 97 9d 1d 00 48
> RIP [<ffffffff80299f5d>] locks_remove_flock+0xe2/0x102
> RSP <ffff81000d1dfe38>
> ---[ end trace e4d79afa854e3611 ]---
>
>
