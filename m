Return-Path: <linux-kernel-owner+w=401wt.eu-S940187AbXGaAP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940187AbXGaAP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 20:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938560AbXGaAPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 20:15:14 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:58844 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934132AbXGaAPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 20:15:11 -0400
Subject: Re: [PATCH] add check do_direct_IO() return val
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Zach Brown <zach.brown@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Jin <joe.jin@oracle.com>,
       gurudas pai <gurudas.pai@oracle.com>, torvalds@linux-foundation.org,
       jens.axboe@oracle.com, lkml <linux-kernel@vger.kernel.org>,
       wen.gang.wang@oracle.com
In-Reply-To: <05506FB8-1164-4E62-8C02-3AC3681E7D89@oracle.com>
References: <20070726090400.GA18640@joejin-pc.cn.oracle.com>
	 <20070726221307.3d7b3446.akpm@linux-foundation.org>
	 <20070727071547.GA25084@joejin-pc.cn.oracle.com>
	 <46A9E6F9.20603@oracle.com>
	 <20070728034719.GA24448@joejin-pc.cn.oracle.com>
	 <20070730135316.2ce21b28.akpm@linux-foundation.org>
	 <1185830683.24525.2.camel@dyn9047017100.beaverton.ibm.com>
	 <6C87D322-FB28-4DA8-A130-327FE35C2DCC@oracle.com>
	 <1185832738.24525.4.camel@dyn9047017100.beaverton.ibm.com>
	 <05506FB8-1164-4E62-8C02-3AC3681E7D89@oracle.com>
Content-Type: text/plain
Date: Mon, 30 Jul 2007 17:17:12 -0700
Message-Id: <1185841032.24525.14.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-30 at 16:38 -0700, Zach Brown wrote:
> On Jul 30, 2007, at 2:58 PM, Badari Pulavarty wrote:
> 
> > On Mon, 2007-07-30 at 14:45 -0700, Zach Brown wrote:
> >>> I am also taking a look at it right now.
> >>
> >> Are we having a race to write a little test app that reproduces the
> >> problem? :)
> >
> > Nope. Feel free to write the test case.
> 
> Well, I'm having a heck of a time getting this to fail.  It looks  
> possible, though.  Joe, were you guys able to narrow it down to a  
> reproducible test case?  Do you have any oops output messages from  
> the crashes?

Here is what I got earlier..

Thanks,
Badari


Hi all,
Add some backgrounds:

When doing fio test on kernel 2.6.22,  we got oops,
--------------------------------------------------------------
BUG: unable to handle kernel paging request at virtual address 23c070bf
 printing eip:
c04a07fd
*pdpt = 000000001ff88001
*pde = 0000000000000000
Oops: 0000 [#1]
SMP
Modules linked in: netconsole autofs4 hidp nfs lockd nfs_acl rfcomm l2cap
bluetooth sunrpc ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr
/@ iscsi_tcp libiscsi scsi_transport_iscsi dm_mirror dm_multipath dm_mod 
video /
sbs button battery ac ipv6 parport_pc lp parport i2c_piix4 i2c_core 
cfi_probe
gen_probe floppy scb2_flash sg mtdcore chipreg tg3 e1000 serio_raw ide_cd
/@ cdrom aic7xxx scsi_transport_spi sd_mod scsi_mod ext3 jbd ehci_hcd 
ohci_hcd /
uhci_hcd
CPU:    0
EIP:    0060:[<c04a07fd>]    Not tainted VLI
EFLAGS: 00010293   (2.6.22 #2)
EIP is at bio_get_nr_vecs+0x0/0x30
eax: 23c07063   ebx: 00000003   ecx: ffffffff   edx: 00000000
esi: de5cef74   edi: f54a9600   ebp: 00000000   esp: de5ceca8
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process fio (pid: 17820, ti=de5ce000 task=de6570e0 task.ti=de5ce000)
Stack: c04a1c9d ffffffff ffffffff 00000009 f54a9600 de5cef74 00000000
f54a9600
       c04a1f43 00000000 c04a2b46 c0460466 c2c5baa0 c0812500 c0462c0a
00000001
       00000001 df4b90d4 de5ceee4 00000011 00000001 00000009 00000009
00000000
Call Trace:
 [<c04a1c9d>] dio_new_bio+0x82/0xfe
 [<c04a1f43>] dio_send_cur_page+0x4a/0x92
 [<c04a2b46>] __blockdev_direct_IO+0xa09/0xc83
 [<c0460466>] __pagevec_free+0x14/0x1a
 [<c0462c0a>] release_pages+0x137/0x13f
 [<f8856f30>] journal_start+0xaf/0xdd [jbd]
 [<f8890fec>] ext3_direct_IO+0xfd/0x190 [ext3]
 [<f888f6af>] ext3_get_block+0x0/0xd0 [ext3]
 [<c045d803>] generic_file_direct_IO+0xe5/0x116
 [<c045d890>] generic_file_direct_write+0x5c/0x137
 [<c045e285>] __generic_file_aio_write_nolock+0x37b/0x4df
 [<c045e43e>] generic_file_aio_write+0x55/0xb3
 [<f888cfdc>] ext3_file_write+0x24/0x8f [ext3]
 [<c0481af9>] do_sync_write+0xc7/0x10a
 [<c04347d2>] check_kill_permission+0xec/0xf5
 [<c043c557>] autoremove_wake_function+0x0/0x35
 [<c0481a32>] do_sync_write+0x0/0x10a
 [<c048233e>] vfs_write+0xa8/0x154
/@  [<c0482a1a>] sys_pwrite64+0x48/0x5f/
 [<c0404e12>] syscall_call+0x7/0xb
 [<c0620000>] xfrm_replay_timer_handler+0x3e/0x44
 =======================
Code: 89 c5 c7 44 24 14 f4 ff ff ff 74 d2 e9 b3 fe ff ff 83 7c 24 34 00 
0f 84
0b ff ff ff e9 51 ff ff ff 83 c4 20 89 e8 5b 5e 5f 5d c3 <8b> 40 5c 8b 
48 38
8b 81 20 01 00 00 0f b7 91 2a 01 00 00 0f b7
EIP: [<c04a07fd>] bio_get_nr_vecs+0x0/0x30 SS:ESP 0068:de5ceca8

-----------------------------------------------------------

jobfile is
-------------------------------
/@ [global]/
/@ bs=8k/
/@ iodepth=1024/
/@ iodepth_batch=60/
/@ randrepeat=1/
/@ size=1m/
/@ directory=/home/oracle/
/@ numjobs=20/
/@ [job1]/
/@ ioengine=sync/
/@ bs=1k/
/@ direct=1/
/@ rw=randread/
/@ filename=file1:file2/
/@ [job2]/
/@ ioengine=libaio/
/@ rw=randwrite/
/@ direct=1/
/@ filename=file1:file2/
/@ [job3]/
/@ bs=1k/
/@ ioengine=posixaio/
/@ rw=randwrite/
/@ direct=1/
/@ filename=file1:file2/
/@ [job4]/
/@ ioengine=splice/
/@ direct=1/
/@ rw=randwrite/
/@ filename=file1:file2/
/@ [job5]/
/@ bs=1k/
/@ ioengine=sync/
/@ rw=randread/
/@ filename=file1:file2/
/@ [job7]/
/@ ioengine=libaio/
/@ rw=randwrite/
/@ filename=file1:file2/
/@ [job8]/
/@ ioengine=posixaio/
/@ rw=randwrite/
/@ filename=file1:file2/
/@ [job9]/
/@ ioengine=splice/
/@ rw=randwrite/
/@ filename=file1:file2/
/@ [job10]/
/@ ioengine=mmap/
/@ rw=randwrite/
/@ bs=1k/
/@ filename=file1:file2/
/@ [job11]/
/@ ioengine=mmap/
/@ rw=randwrite/
/@ direct=1/
/@ filename=file1:file2/
-------------------------------
ignore the @ please.


With Joe's patch, seems the oops solved.
So, please give a review to see if there is any problem for that patch.

thanks,
wengang.



