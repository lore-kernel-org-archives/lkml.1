Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbZIIU1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbZIIU1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 16:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbZIIU1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 16:27:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48519 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752046AbZIIU1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 16:27:13 -0400
Date: Wed, 9 Sep 2009 13:26:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kbowa@tuxedu.org
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: Kernel Oops with Kcore
Message-Id: <20090909132658.7a24b437.akpm@linux-foundation.org>
In-Reply-To: <20090903181902.fa1b6c28ccd88fecdf42878e07f4a71e.5b0f7c65f9.wbe@email03.secureserver.net>
References: <20090903181902.fa1b6c28ccd88fecdf42878e07f4a71e.5b0f7c65f9.wbe@email03.secureserver.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Sep 2009 18:19:02 -0700
kbowa@tuxedu.org wrote:

> Hey all,
> 
> Came across the following kernel oops caused by kcore.
> 
> BUG: unable to handle kernel paging request at fa54c000
> IP: [<c04f687a>] read_kcore+0x260/0x31a
> *pde = 3540b067 *pte = 00000000
> Oops: 0000 [#1] SMP
> last sysfs file: /sys/devices/pci0000:00/0000:00:1c.2/0000:03:00.0/ieee80211/phy0/rfkill0/state
> Modules linked in: fuse sco bridge stp llc bnep l2cap bluetooth sunrpc nf_conntrack_ftp ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 cpufreq_ondemand acpi_cpufreq dm_multipath uinput usb_storage arc4 ecb snd_hda_codec_realtek snd_hda_intel ath5k snd_hda_codec snd_hwdep iTCO_wdt snd_pcm iTCO_vendor_support pcspkr i2c_i801 mac80211 joydev snd_timer serio_raw r8169 snd soundcore mii snd_page_alloc ath cfg80211 ata_generic i915 drm i2c_algo_bit i2c_core video output [last unloaded: scsi_wait_scan]
> Sep  4 12:45:16 tuxedu kernel: Pid: 2266, comm: cat Not tainted (2.6.31-rc8 #2) Joybook Lite U101
> EIP: 0060:[<c04f687a>] EFLAGS: 00010286 CPU: 0
> EIP is at read_kcore+0x260/0x31a
> EAX: f5e5ea00 EBX: fa54d000 ECX: 00000400 EDX: 00001000
> ESI: fa54c000 EDI: f44ad000 EBP: e4533f4c ESP: e4533f24
> DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process cat (pid: 2266, ti=e4532000 task=f09d19a0 task.ti=e4532000)
> Stack:
> 00005000 00000000 f44ad000 09d9c000 00003000 fa54c000 00001000 f6d16f60
>  e4520b80 fffffffb e4533f70 c04ef8eb e4533f98 00008000 09d97000 c04f661a
>  e4520b80 09d97000 c04ef88c e4533f8c c04ba531 e4533f98 c04c0930 e4520b80
> Call Trace:
> [<c04ef8eb>] ? proc_reg_read+0x5f/0x73
> [<c04f661a>] ? read_kcore+0x0/0x31a
> [<c04ef88c>] ? proc_reg_read+0x0/0x73
> [<c04ba531>] ? vfs_read+0x82/0xe1
> [<c04c0930>] ? path_put+0x1a/0x1d
> [<c04ba62e>] ? sys_read+0x40/0x62
> [<c0403298>] ? sysenter_do_call+0x12/0x2d
> Code: 39 f3 89 ca 0f 43 f3 89 fb 29 f2 29 f3 39 cf 0f 46 d3 29 55 dc 8d 1c 32 f6 40 0c 01 75 18 89 d1 89 f7 c1 e9 02 2b 7d ec 03 7d e0 <f3> a5 89 d1 83 e1 03 74 02 f3 a4 8b 00 83 7d dc 00 74 04 85 c0
> EIP: [<c04f687a>] read_kcore+0x260/0x31a SS:ESP 0068:e4533f24
> CR2: 00000000fa54c000
> ---[ end trace ffffe041e89f7df7 ]---

Thanks.  Can you please see if the below patch fixes it?

I'll use your oops report in the changlog since the patch I have
doesn't have a very good description of the bug which it is fixing.

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Works around a BUG() which is triggered when the kernel accesses holes in
vmalloc regions.


To access vmalloc area which may have memory holes, copy_from_user is
useful. By this,

 # cat /proc/kcore > /dev/null

will not panic.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Tested-by: Nick Craig-Wood <nick@craig-wood.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Reported-by: <kbowa@tuxedu.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN fs/proc/kcore.c~reading-proc-kcore-causes-a-bug fs/proc/kcore.c
--- a/fs/proc/kcore.c~reading-proc-kcore-causes-a-bug
+++ a/fs/proc/kcore.c
@@ -361,7 +361,13 @@ read_kcore(struct file *file, char __use
 				/* don't dump ioremap'd stuff! (TA) */
 				if (m->flags & VM_IOREMAP)
 					continue;
-				memcpy(elf_buf + (vmstart - start),
+				/*
+				 * we may access memory holes, then use
+				 * ex_table. checking return value just for
+				 * avoid warnings.
+				 */
+				vmsize = __copy_from_user_inatomic(
+					elf_buf + (vmstart - start),
 					(char *)vmstart, vmsize);
 			}
 			read_unlock(&vmlist_lock);
_

