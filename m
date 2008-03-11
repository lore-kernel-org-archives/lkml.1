Return-Path: <linux-kernel-owner+w=401wt.eu-S1754909AbYCKVnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbYCKVnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 17:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750924AbYCKVnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 17:43:35 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:38526 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbYCKVne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 17:43:34 -0400
From: Chr <chunkeey@web.de>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: endless loop in native_flush_tlb_others in smp_64.c
Date: Tue, 11 Mar 2008 22:43:26 +0100
User-Agent: KMail/1.9.9
Cc: "Jike Song" <albcamus@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Brown, Len" <len.brown@intel.com>
References: <200803102316.54457.chunkeey@web.de> <200803111130.55355.chunkeey@web.de> <924EFEDD5F540B4284297C4DC59F3DEEAF9755@orsmsx423.amr.corp.intel.com>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEEAF9755@orsmsx423.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803112243.27056.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX19PjOQKJdMGemqZ7TVSoR6QAt8sx/1PzUD3Ad4R
	Np8kfDNsA2tmX7bTCFNpycsyk5WhNG1qTzB3HdAC6eIo+v0HnA
	AU0gV8dcc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 March 2008 12:09:24 you wrote:
> On Tue, 11 Mar 2008, Jike Song wrote:
>
> Any chance that you can capture SYSRQ-T output via serial or
> netconsole, so we can see the stacktrace and what the other CPUs are
> doing, if they are doing anything.

this time with a 2.6.25-rc4-wl: (unfortunatly tainted again)
the serial console seems to work: GFPs all over the place...
take a look here: 
http://www.pastebin.ca/938757

Since I get so many different Oopses. I'm beginning to suspect my
fancy JFS/ReiserFS/Ext3:DM-Crypt:LVM2:MD(Raid1) combo causes 
memory corruptions/leaks/voodoo...  

like this other tragic incident: 
loop0         D ffff810079331bd0     0 15716      2
 ffff810079331b40 0000000000000046 ffff810062295c90 ffffffff804028e0
 ffff810069608800 ffff810079331af0 ffffc20010af7040 ffffffff805f6700
 ffffffff805f6700 ffffffff805f2f50 ffffffff805f6700 ffff81007a7df830
Call Trace:
 [<ffffffff804028e0>] __split_bio+0x367/0x378
 [<ffffffff8033e442>] generic_unplug_device+0x18/0x24
 [<ffffffff804040b5>] dm_table_unplug_all+0x2a/0x3d
 [<ffffffff802930c5>] sync_buffer+0x0/0x3f
 [<ffffffff8048476d>] io_schedule+0x28/0x34
 [<ffffffff80293100>] sync_buffer+0x3b/0x3f
 [<ffffffff8048499e>] __wait_on_bit+0x40/0x6e
 [<ffffffff802930c5>] sync_buffer+0x0/0x3f
 [<ffffffff80484a38>] out_of_line_wait_on_bit+0x6c/0x78
 [<ffffffff8023eb3d>] wake_bit_function+0x0/0x23
 [<ffffffff802932b7>] ll_rw_block+0x8c/0xaf
 [<ffffffff8029385b>] __block_prepare_write+0x366/0x3b9
 [<ffffffff802e2a1c>] ext3_get_block+0x0/0xf9
 [<ffffffff8029394b>] block_write_begin+0x78/0xc9
 [<ffffffff802e3f1f>] ext3_write_begin+0xeb/0x1aa
 [<ffffffff802e2a1c>] ext3_get_block+0x0/0xf9
 [<ffffffff803b5928>] do_lo_send_aops+0x9f/0x177
 [<ffffffff803b5889>] do_lo_send_aops+0x0/0x177
 [<ffffffff803b5732>] loop_thread+0x2ce/0x425
 [<ffffffff803b5464>] loop_thread+0x0/0x425
 [<ffffffff8023e9ed>] kthread+0x47/0x76
 [<ffffffff80229404>] schedule_tail+0x28/0x5c
 [<ffffffff8020be68>] child_rip+0xa/0x12
 [<ffffffff8023e9a6>] kthread+0x0/0x76
 [<ffffffff8020be5e>] child_rip+0x0/0x12

situation: the system died after writing >2 Gb from /dev/zero 
(gosh, about only 1Mb/s-500kb/s!!) into a file in a _mounted_ 
loopdevice of a old-hdd-image-file on a jfs/dm-crypt/lvm2 combo. 

BTW: bisect is still running... the regression seems to have sneaked in
between 2.6.24 and 2.6.25-rc1 however 4000 diffs will take a while... 

(it takes so long since the raid has to resync each reboot... 
Thank *** that this is just a stress-testing system that can take some 
beating without _failing_ apart. ;-) )

Regards,
	Chr
