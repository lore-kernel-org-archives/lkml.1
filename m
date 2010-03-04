Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab0CDJHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 04:07:35 -0500
Received: from mailhost14.gawab.com ([66.220.20.14]:35711 "HELO
	info88.gawab.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754929Ab0CDJH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 04:07:28 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Mar 2010 04:07:28 EST
Message-ID: <20100304090047.23689.qmail@info88.gawab.com>
From: "Justin Madru" <jdm64@gawab.com>
To: Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org
Subject: [BUG] NULL pointer dereference in i915_gem_object_save_bit_17_swizzle
Date: Thu, 04 Mar 2010 09:00:47 GMT
Content-Type: text/plain ; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [68.183.209.34]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've had this same oops happen several times. Seems to happen when I'm
playing a video.
The function i915_gem_object_save_bit_17_swizzle (referenced in the oops)
was last edited
by the following commit. I'm running 2.6.33 with an i945 gpu.

commit 280b713b5b0fd84cf2469098aee88acbb5de859c
Author: Eric Anholt <eric@anholt.net>
Date:   Thu Mar 12 16:56:27 2009 -0700

    drm/i915: Allow tiling of objects with bit 17 swizzling by the CPU.
    
    Save the bit 17 state of the pages when freeing the page list, and
    reswizzle them if necessary when rebinding the pages (in case they were
    swapped out).  Since we have userland with expectations that the
swizzle
    enums let it pread and pwrite contents accurately, we can't expose a
new
    swizzle enum for bit 17 (which it would have to GTT map to handle), so
we
    handle it down in pread and pwrite by swizzling the copy when bit 17 of
the
    page address is set.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>

BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<f82b5d2b>] i915_gem_object_save_bit_17_swizzle+0x5b/0xc0 [i915]
*pde = 00000000 
Oops: 0000 [#1] PREEMPT SMP 
last sysfs file:
/sys/devices/pci0000:00/0000:00:1c.0/0000:0b:00.0/net/wlan0/statistics/collisions
Modules linked in: binfmt_misc ipv6 nfs lockd fscache nfs_acl auth_rpcgss
sunrpc ext4 mbcache jbd2 crc16 arc4 ecb cryptomgr crypto_hash aead
pcompress snd_hda_codec_idt crypto_blkcipher crypto_algapi snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm_oss iwl3945 snd_mixer_oss snd_pcm iwlcore
sdhci_pci snd_timer mac80211 snd sdhci soundcore mmc_core ac processor
battery psmouse evdev snd_page_alloc cfg80211 rfkill rtc_cmos rtc_core
rtc_lib reiserfs fan fuse usbhid hid fbcon font bitblit softcursor sr_mod
cdrom sg i915 drm_kms_helper fb cfbcopyarea intel_agp button ata_piix
thermal ehci_hcd video uhci_hcd backlight output usbcore cfbimgblt
cfbfillrect nls_base
Mar  4 00:16:56 justin-laptop kernel:
Pid: 3279, comm: Xorg Not tainted 2.6.33-git-dirty #1 0KD882/MM061         
                 
EIP: 0060:[<f82b5d2b>] EFLAGS: 00013212 CPU: 1
EIP is at i915_gem_object_save_bit_17_swizzle+0x5b/0xc0 [i915]
EAX: f6590000 EBX: f6444700 ECX: f771c000 EDX: 00000092
ESI: 00000100 EDI: 00000000 EBP: f666cdb4 ESP: f666cda0
DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process Xorg (pid: 3279, ti=f666c000 task=f650d4e0 task.ti=f666c000)
Stack:
00000000 000213da 00100000 f6444700 00000001 f666cdcc f82aea55 00000400
<0> fffffff4 f6444700 f76747f0 f666cdec f82aeb71 ef419360 00001200 00000100
<0> ef419360 f6444700 00100000 f666ce20 f82b0de8 00000000 c02db74d 00003202
Call Trace:
[<f82aea55>] ? i915_gem_object_put_pages+0x125/0x150 [i915]
[<f82aeb71>] ? i915_gem_object_get_pages+0xf1/0x110 [i915]
[<f82b0de8>] ? i915_gem_object_bind_to_gtt+0xb8/0x2a0 [i915]
[<c02db74d>] ? drm_mm_get_block_generic+0x4d/0x180
[<f82b11cd>] ? i915_gem_mmap_gtt_ioctl+0x16d/0x240 [i915]
[<f82ae786>] ? i915_gem_madvise_ioctl+0x86/0x120 [i915]
[<c0106464>] ? alloc_ldt+0xc4/0x240
[<c02d1cfc>] ? drm_ioctl+0x24c/0x3f0
[<c0106464>] ? alloc_ldt+0xc4/0x240
[<f82b1060>] ? i915_gem_mmap_gtt_ioctl+0x0/0x240 [i915]
[<c01d1b19>] ? do_sync_read+0xb9/0x120
[<c016248c>] ? T.500+0x27c/0x540
[<c0106464>] ? alloc_ldt+0xc4/0x240
[<c02d1ab0>] ? drm_ioctl+0x0/0x3f0
[<c01e2851>] ? do_vfs_ioctl+0x81/0x640
[<c016278a>] ? hrtimer_start+0x1a/0x20
[<c0147fa5>] ? do_setitimer+0x175/0x200
[<c0167f3b>] ? ktime_get_ts+0xdb/0x110
[<c01e2e49>] ? sys_ioctl+0x39/0x60
[<c0103310>] ? sysenter_do_call+0x12/0x26
[<c0106464>] ? alloc_ldt+0xc4/0x240
Code: 8b 43 54 c1 ee 0c 85 c0 74 46 31 d2 85 f6 7f 15 eb df 8d b6 00 00 00
00 0f ab 10 83 c2 01 39 d6 74 cf 8b 43 54 8b 4b 2c 8b 3c 91 <8b> 0f c1 e9
1a 8b 0c cd 80 ed 5a c0 83 e1 fc 29 cf 81 e7 00 04 
EIP: [<f82b5d2b>] i915_gem_object_save_bit_17_swizzle+0x5b/0xc0 [i915]
SS:ESP 0068:f666cda0
CR2: 0000000000000000
---[ end trace ee82e251ffaa363c ]---

Justin Madru

-----------------------------------------------------------------------------------------------------------------------
Send big files for free. Simple steps. No registration.
Visit now http://www.nawelny.com
