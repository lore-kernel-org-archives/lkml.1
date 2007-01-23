Return-Path: <linux-kernel-owner+w=401wt.eu-S932437AbXAWSQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437AbXAWSQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 13:16:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933099AbXAWSQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 13:16:10 -0500
Received: from mail.alkar.net ([195.248.191.95]:59539 "EHLO mail.alkar.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932437AbXAWSQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 13:16:09 -0500
From: "Vladimir V. Saveliev" <vs@namesys.com>
To: reiserfs-list@namesys.com, Andrew Morton <akpm@osdl.org>
Subject: Re: linux-2.6.20-rc4-mm1 Reiser4 filesystem freeze and corruption
Date: Tue, 23 Jan 2007 22:15:36 +0300
User-Agent: KMail/1.8.2
Cc: Vince <fuzzy77@laposte.net>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Zan Lynx <zlynx@acm.org>
References: <1169229490.6266.11.camel@oberon> <45B5BB5E.4010802@laposte.net>
In-Reply-To: <45B5BB5E.4010802@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701232215.37321.vs@namesys.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

On Tuesday 23 January 2007 10:38, Vince wrote:
> Zan Lynx wrote:
> > I have been running 2.6.20-rc2-mm1 without problems, but both rc3-mm1
> > and rc4-mm1 have been giving me these freezes.  They were happening
> > inside X and without external console it was impossible to get anything,
> > plus I was reluctant to test it since the freeze sometimes requires a
> > full fsck.reiser4 --build-fs to recover the filesystem.
>  > [...]
> 
> Hi,
> 
> I don't know if it is related, but I've had the following BUG on 
> 2.6.20-rc4-mm1 (+ hot-fixes patches applied) :
> 
> -------------------
> kernel BUG at fs/reiser4/plugin/item/extent_file_ops.c:973!

This is another problem than Zan's one. The attached patch should fix it.

Andrew, please apply.


From: Vladimir Saveliev <vs@namesys.com>

remove_suid may open a transaction in reiser4 which is to be restarted
before entering into main write loop.

Signed-off-by: Vladimir Saveliev <vs@namesys.com>




diff -puN fs/reiser4/plugin/file/file.c~reiser4-restart-transaction-after-remove_suid fs/reiser4/plugin/file/file.c
--- linux-2.6.20-rc3-mm1/fs/reiser4/plugin/file/file.c~reiser4-restart-transaction-after-remove_suid	2007-01-23 18:59:14.000000000 +0300
+++ linux-2.6.20-rc3-mm1-vs/fs/reiser4/plugin/file/file.c	2007-01-23 19:00:37.000000000 +0300
@@ -2175,6 +2175,8 @@ ssize_t write_unix_file(struct file *fil
 		reiser4_exit_context(ctx);
 		return result;
 	}
+	/* remove_suid might create a transaction */
+	reiser4_txn_restart(ctx);
 
 	uf_info = unix_file_inode_data(inode);
 

_


> invalid opcode: 0000 [#1]
> PREEMPT
> last sysfs file: /devices/pci0000:00/0000:00:13.0/eth0/statistics/collisions
> Modules linked in: binfmt_misc nfs lockd sunrpc radeon drm reiser4 
> ati_remote fuse usbhid snd_via82xx snd_ac97_codec ac97_bus snd_pcm_oss 
> snd_mixer_oss snd_pcm snd_page_alloc snd_mpu401_uart snd_seq_oss 
> snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer 
> snd_seq_device ohci1394 ieee1394 psmouse sr_mod cdrom sg ehci_hcd 
> via_agp agpgart uhci_hcd usbcore i2c_viapro snd soundcore
> CPU:    0
> EIP:    0060:[<f9b8a2e0>]    Not tainted VLI
> EFLAGS: 00010282   (2.6.20-rc4-mm1 #1)
> EIP is at reiser4_write_extent+0xd5/0x626 [reiser4]
> eax: ccca139c   ebx: 00000200   ecx: f5bec400   edx: ffffffe4
> esi: 00000000   edi: f5bec414   ebp: da6ff274   esp: e17d7e34
> ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> Process sstrip (pid: 23858, ti=e17d6000 task=d8ffc570 task.ti=e17d6000)
> Stack: 00000000 00100100 00200200 00100100 00000034 bf826a50 e083ff00 
> 00000000
>         c0000000 da6ff2c8 dccba4c0 00000005 000001ff 0000021e 00000000 
> 00000000
>         00000000 00000000 00000004 f9b6cdad 00000000 00000004 00000004 
> 00000001
> Call Trace:
>   [<f9b6cdad>] reiser4_update_sd+0x22/0x28 [reiser4]
>   [<c0162459>] notify_change+0x200/0x20f
>   [<c01b89ed>] vsscanf+0x1e2/0x3ff
>   [<f9b75c80>] write_unix_file+0x0/0x495 [reiser4]
>   [<c013630d>] __remove_suid+0x10/0x14
>   [<c013d847>] mark_page_accessed+0x1c/0x2e
>   [<f9b5fbc2>] reiser4_txn_begin+0x1c/0x2e [reiser4]
>   [<f9b8a20b>] reiser4_write_extent+0x0/0x626 [reiser4]
>   [<f9b75eda>] write_unix_file+0x25a/0x495 [reiser4]
>   [<c0142601>] __handle_mm_fault+0x2bd/0x79b
>   [<f9b75c80>] write_unix_file+0x0/0x495 [reiser4]
>   [<c01514e9>] vfs_write+0x8a/0x136
>   [<c0151a27>] sys_write+0x41/0x67
>   [<c0103c86>] sysenter_past_esp+0x5f/0x85
>   =======================
> Code: 04 89 0c 24 31 c9 89 5c 24 04 e8 52 fc ff ff 31 d2 e9 59 05 00 00 
> 64 a1 08 00 00 00 8b 80 b4 04 00 00 8b 40 38 83 78 08 00 74 04 <0f> 0b 
> eb fe 8b 8c 24 e0 00 00 00 31 db 8b 01 8b 51 04 89 c1 0f
> EIP: [<f9b8a2e0>] reiser4_write_extent+0xd5/0x626 [reiser4] SS:ESP 
> 0068:e17d7e34
>   <4>reiser4[sstrip(23858)]: release_unix_file 
> (fs/reiser4/plugin/file/file.c:2417)[vs-44]:
> WARNING: out of memory?
> reiser4[sstrip(23858)]: release_unix_file 
> (fs/reiser4/plugin/file/file.c:2417)[vs-44]:
> WARNING: out of memory?
> 
> 
> 
