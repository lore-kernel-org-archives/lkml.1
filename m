Return-Path: <linux-kernel-owner+w=401wt.eu-S1756502AbZJAXic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502AbZJAXic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755903AbZJAXia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:38:30 -0400
Received: from kroah.org ([198.145.64.141]:42106 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820AbZJAXiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:38:25 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 16:33:23 2009
Message-Id: <20091001233322.964817376@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 16:31:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: stable-review@kernel.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, nick@craig-wood.com, kbowa@tuxedu.org,
       penberg@cs.helsinki.fi, kamezawa.hiroyu@jp.fujitsu.com
Subject: [patch 28/30] /proc/kcore: work around a BUG()
References: <20091001233116.947658905@mini.kroah.org>
Content-Disposition: inline; filename=proc-kcore-work-around-a-bug.patch
In-Reply-To: <20091001233504.GA17709@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Not upstream due to other fixes in .32


Works around a BUG() which is triggered when the kernel accesses holes in
vmalloc regions.

BUG: unable to handle kernel paging request at fa54c000
IP: [<c04f687a>] read_kcore+0x260/0x31a
*pde = 3540b067 *pte = 00000000
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1c.2/0000:03:00.0/ieee80211/phy0/rfkill0/state
Modules linked in: fuse sco bridge stp llc bnep l2cap bluetooth sunrpc nf_conntrack_ftp ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 cpufreq_ondemand acpi_cpufreq dm_multipath uinput usb_storage arc4 ecb snd_hda_codec_realtek snd_hda_intel ath5k snd_hda_codec snd_hwdep iTCO_wdt snd_pcm iTCO_vendor_support pcspkr i2c_i801 mac80211 joydev snd_timer serio_raw r8169 snd soundcore mii snd_page_alloc ath cfg80211 ata_generic i915 drm i2c_algo_bit i2c_core video output [last unloaded: scsi_wait_scan]
Sep  4 12:45:16 tuxedu kernel: Pid: 2266, comm: cat Not tainted (2.6.31-rc8 #2) Joybook Lite U101
EIP: 0060:[<c04f687a>] EFLAGS: 00010286 CPU: 0
EIP is at read_kcore+0x260/0x31a
EAX: f5e5ea00 EBX: fa54d000 ECX: 00000400 EDX: 00001000
ESI: fa54c000 EDI: f44ad000 EBP: e4533f4c ESP: e4533f24
DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process cat (pid: 2266, ti=e4532000 task=f09d19a0 task.ti=e4532000)
Stack:
00005000 00000000 f44ad000 09d9c000 00003000 fa54c000 00001000 f6d16f60
 e4520b80 fffffffb e4533f70 c04ef8eb e4533f98 00008000 09d97000 c04f661a
 e4520b80 09d97000 c04ef88c e4533f8c c04ba531 e4533f98 c04c0930 e4520b80
Call Trace:
[<c04ef8eb>] ? proc_reg_read+0x5f/0x73
[<c04f661a>] ? read_kcore+0x0/0x31a
[<c04ef88c>] ? proc_reg_read+0x0/0x73
[<c04ba531>] ? vfs_read+0x82/0xe1
[<c04c0930>] ? path_put+0x1a/0x1d
[<c04ba62e>] ? sys_read+0x40/0x62
[<c0403298>] ? sysenter_do_call+0x12/0x2d
Code: 39 f3 89 ca 0f 43 f3 89 fb 29 f2 29 f3 39 cf 0f 46 d3 29 55 dc 8d 1c 32 f6 40 0c 01 75 18 89 d1 89 f7 c1 e9 02 2b 7d ec 03 7d e0 <f3> a5 89 d1 83 e1 03 74 02 f3 a4 8b 00 83 7d dc 00 74 04 85 c0
EIP: [<c04f687a>] read_kcore+0x260/0x31a SS:ESP 0068:e4533f24
CR2: 00000000fa54c000


To access vmalloc area which may have memory holes, copy_from_user is
useful.  So this:

 # cat /proc/kcore > /dev/null

will not panic.

This is a minimal fix, suitable for 2.6.30.x and 2.6.31.  More extensive
/proc/kcore changes are planned for 2.6.32.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Tested-by: Nick Craig-Wood <nick@craig-wood.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Reported-by: <kbowa@tuxedu.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/kcore.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
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


