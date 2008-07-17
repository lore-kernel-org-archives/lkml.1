Return-Path: <linux-kernel-owner+w=401wt.eu-S933294AbYGQVmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294AbYGQVmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 17:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793AbYGQVmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 17:42:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43681 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbYGQVmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 17:42:42 -0400
Date: Thu, 17 Jul 2008 23:42:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [bug, netconsole, SLUB] BUG skbuff_head_cache: Poison overwritten
Message-ID: <20080717214222.GA29449@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A regression to v2.6.26:

I started getting this skb-head corruption message today, on a T60 
laptop with e1000:

PM: Removing info for No Bus:vcs11
device: 'vcs11': device_create_release
=============================================================================
BUG skbuff_head_cache: Poison overwritten
-----------------------------------------------------------------------------

INFO: 0xf658ae9c-0xf658ae9c. First byte 0x6a instead of 0x6b
INFO: Allocated in __alloc_skb+0x2c/0x110 age=0 cpu=0 pid=5098
INFO: Freed in __kfree_skb+0x31/0x80 age=0 cpu=1 pid=4440
INFO: Slab 0xc16cc140 objects=16 used=1 fp=0xf658ae00 flags=0x400000c3
INFO: Object 0xf658ae00 @offset=3584 fp=0xf658af00

Bytes b4 0xf658adf0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xf658ae00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xf658ae10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xf658ae20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xf658ae30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xf658ae40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xf658ae50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xf658ae60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xf658ae70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
 Redzone 0xf658aea0:  bb bb bb bb                                     ����            
 Padding 0xf658aec8:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
 Padding 0xf658aed8:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
 Padding 0xf658aee8:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
 Padding 0xf658aef8:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
Pid: 5098, comm: gdm-binary Not tainted 2.6.26-tip #3094
 [<c0186f99>] print_trailer+0xa9/0xf0
 [<c018707b>] check_bytes_and_report+0x9b/0xc0
 [<c01874ae>] check_object+0x19e/0x1e0
 [<c0187ef1>] __slab_alloc+0x371/0x4e0
 [<c0188552>] kmem_cache_alloc+0xb2/0xc0
 [<c06732dc>] ? __alloc_skb+0x2c/0x110
 [<c06732dc>] ? __alloc_skb+0x2c/0x110
 [<c06732dc>] __alloc_skb+0x2c/0x110
 [<c0685b6c>] find_skb+0x3c/0x80
 [<c068624b>] netpoll_send_udp+0x2b/0x1f0
 [<c0322e62>] ? notify_update+0x22/0x30
 [<c046d405>] write_msg+0x95/0xe0
 [<c046d370>] ? write_msg+0x0/0xe0
 [<c012df70>] __call_console_drivers+0x60/0x70
 [<c012dff9>] _call_console_drivers+0x79/0x90
 [<c012e3f4>] release_console_sem+0xc4/0x1f0
 [<c012e89e>] vprintk+0x15e/0x3b0
 [<c01ce683>] ? release_sysfs_dirent+0x43/0xa0
 [<c01ce683>] ? release_sysfs_dirent+0x43/0xa0
 [<c01ce683>] ? release_sysfs_dirent+0x43/0xa0
 [<c012eb0b>] printk+0x1b/0x20
 [<c0367597>] device_create_release+0x27/0x40
 [<c0367955>] device_release+0x15/0x70
 [<c02b1d29>] kobject_release+0x39/0x80
 [<c02b1cf0>] ? kobject_release+0x0/0x80
 [<c02b2a0d>] kref_put+0x2d/0x70
 [<c02b1c30>] kobject_put+0x20/0x50
 [<c02b1ce2>] ? kobject_del+0x22/0x30
 [<c03680f3>] ? device_del+0x123/0x140
 [<c0367b7f>] put_device+0xf/0x20
 [<c0368145>] device_unregister+0x35/0x40
 [<c0368179>] device_destroy+0x29/0x30
 [<c031e66c>] vcs_remove_sysfs+0x1c/0x40
 [<c032480e>] con_close+0x5e/0x70
 [<c0317289>] release_dev+0x139/0x600
 [<c0188222>] ? __slab_free+0x1c2/0x240
 [<c019fd59>] ? destroy_inode+0x39/0x40
 [<c019d4d3>] ? __d_free+0x23/0x30
 [<c019d4d3>] ? __d_free+0x23/0x30
 [<c019d4d3>] ? __d_free+0x23/0x30
 [<c0317762>] tty_release+0x12/0x20
 [<c018dba2>] __fput+0xb2/0x1d0
 [<c018dfe9>] fput+0x19/0x20
 [<c018ad59>] filp_close+0x49/0x70
 [<c018c3a6>] sys_close+0x66/0xb0
 [<c0103d01>] sysenter_past_esp+0x6a/0x99
 =======================
FIX skbuff_head_cache: Restoring 0xf658ae9c-0xf658ae9c=0x6b

FIX skbuff_head_cache: Marking all objects used
device: 'vcsa11': device_unregister
PM: Removing info for No Bus:vcsa11
device: 'vcsa11': device_create_release

With this config:

   http://redhat.com/~mingo/misc/config-Thu_Jul_17_20_24_45_CEST_2008.bad
	
The box uses netconsole.

Suspected range of breakage is v2.6.26..a3cf859, or around 3000 commits. 
But a fair portion of those commit were tested on this box before.

Perhaps SLUB debugging got smarter?

	Ingo
