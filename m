Return-Path: <linux-kernel-owner+w=401wt.eu-S1759026AbYDJWwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026AbYDJWwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 18:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbYDJWv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 18:51:59 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:44892 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbYDJWv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 18:51:58 -0400
Date: Fri, 11 Apr 2008 00:51:52 +0200 (CEST)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: LKML <linux-kernel@vger.kernel.org>
Subject: WARNING: at drivers/base/core.c:119 kobject_release
Message-ID: <alpine.DEB.1.10.0804110035070.6769@sheep.housecafe.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

following 2.6.25-rc more closely now, I'm running yesterday's git version.
The first boot was fine, then the box crashed due to disk errors. During 
the next bootup, it barfed a few times with:

Device '2-2' does not have a release() function, it is broken and must be fixed.
------------[ cut here ]------------
WARNING: at drivers/base/core.c:119 kobject_release+0x42/0xa0()
Modules linked in: fuse sg sr_mod twofish_i586 twofish_common eeprom w83l785ts asb100 hwmon_vid hwmon usb_storage zd1211rw firmware_class snd_intel8x0 snd_ac97_codec mac80211 ac97_bus snd_pcm snd_timer snd i2c_nforce2 cfg80211 soundcore snd_page_alloc i2c_core
Pid: 2385, comm: wpa_supplicant Not tainted 2.6.25-rc8 #1
  [<c011a90f>] warn_on_slowpath+0x5f/0xa0
  [<c011b17e>] release_console_sem+0x1de/0x200
  [<c02d4c52>] kobject_release+0x42/0xa0
  [<c02d4c10>] kobject_release+0x0/0xa0
  [<c02d5a39>] kref_put+0x29/0x60
  [<f8d47779>] _request_firmware+0x199/0x320 [firmware_class]
  [<f8d4798f>] request_firmware+0xf/0x14 [firmware_class]
  [<f8d876a8>] request_fw_file+0x18/0x60 [zd1211rw]
  [<f8d87ae8>] upload_firmware+0xa8/0x330 [zd1211rw]
  [<c013ac52>] trace_hardirqs_on+0xf2/0x130
  [<c0149890>] sync_page+0x0/0x50
  [<c045f6c0>] _read_unlock_irq+0x20/0x30
  [<c013ac52>] trace_hardirqs_on+0xf2/0x130
  [<c045f6c0>] _read_unlock_irq+0x20/0x30
  [<c0149b8f>] find_lock_page+0x8f/0xb0
  [<c045f824>] _spin_unlock+0x14/0x20
  [<c0156912>] __do_fault+0x1b2/0x390
  [<f8d87d82>] zd_usb_init_hw+0x12/0xa0 [zd1211rw]
  [<f8d85072>] zd_op_start+0x22/0xf0 [zd1211rw]
  [<f8fffaf3>] ieee80211_open+0x133/0x430 [mac80211]
  [<c011fc5d>] local_bh_enable_ip+0x5d/0xd0
  [<c03bd79e>] dev_open+0x6e/0xa0
  [<c03bd1e2>] dev_change_flags+0x82/0x1a0
  [<c03bad1d>] __dev_get_by_name+0x7d/0xa0
  [<c0403ba2>] devinet_ioctl+0x6f2/0x710
  [<c02dab32>] copy_to_user+0x42/0x130
  [<c03ae9c2>] sock_ioctl+0x72/0x260
  [<c03ae950>] sock_ioctl+0x0/0x260
  [<c0178fbf>] vfs_ioctl+0x1f/0x80
  [<c017923b>] do_vfs_ioctl+0x21b/0x2a0
  [<c01792fd>] sys_ioctl+0x3d/0x70
  [<c0102f26>] sysenter_past_esp+0x5f/0xa5
  =======================
---[ end trace d641ca65d10b75f9 ]---
usb 2-2: Could not load firmware file zd1211/zd1211_ub. Error number -2
zd1211rw 2-2:1.0: couldn't load firmware. Error number -2


The firmware needed for zd1211rw is of course in /lib/firmware/zd1211, as 
it was before (when it was working). The messages occured again a few 
times during bootup. When I did 'rmmod zd1211rw' the kernel printed:

  Device 'phy0' does not have a release() function, it is broken and must be fixed.
  ------------[ cut here ]------------
  WARNING: at drivers/base/core.c:119 kobject_release+0x42/0xa0()
  Modules linked in: pppoe pppox ipt_REJECT xt_limit xt_state xt_multiport xt_tcpudp ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_nat_ftp nf_nat nf_conntrack_ftp xt_conntrack nf_conntrack iptable_filter ip_tables ipt_ULOG x_tables ppp_generic slhc nfsd lockd nfs_acl auth_rpcgss exportfs tun sunrpc fuse sg sr_mod twofish_i586 twofish_common eeprom w83l785ts asb100 hwmon_vid hwmon usb_storage zd1211rw(-) firmware_class snd_intel8x0 snd_ac97_codec mac80211 ac97_bus snd_pcm snd_timer snd i2c_nforce2 cfg80211 soundcore snd_page_alloc i2c_core
  Pid: 5628, comm: rmmod Not tainted 2.6.25-rc8 #1
   [<c011a90f>] warn_on_slowpath+0x5f/0xa0
   [<c0116063>] __wake_up_common+0x43/0x70
   [<c0116ece>] __wake_up+0x3e/0x60
   [<c011af93>] wake_up_klogd+0x33/0x40
   [<c013ac52>] trace_hardirqs_on+0xf2/0x130
   [<c016989d>] kfree+0x9d/0x130
   [<c02d4c52>] kobject_release+0x42/0xa0
   [<c02d4c10>] kobject_release+0x0/0xa0
   [<c02d5a39>] kref_put+0x29/0x60
   [<c036c058>] usb_unbind_interface+0x38/0x90
   [<c031583d>] __device_release_driver+0x7d/0xd0
   [<c0315977>] driver_detach+0xe7/0xf0
   [<c0314b93>] bus_remove_driver+0x73/0xa0
   [<c036be48>] usb_deregister+0x88/0xa0
   [<f8d88bae>] usb_exit+0xa/0x14 [zd1211rw]
   [<c014465e>] sys_delete_module+0x15e/0x200
   [<c015b6af>] do_munmap+0x1ff/0x250
   [<c0102f61>] sysenter_past_esp+0x9a/0xa5
   [<c0102f26>] sysenter_past_esp+0x5f/0xa5
   =======================
  ---[ end trace d641ca65d10b75f9 ]---


Please see the .config and full dmesg: 
http://nerdbynature.de/bits/2.6.25-rc8/kobject_release/

I'm curious if this will happen again, as I'm currently unable to 
reproduce this one...

Thanks,
Christian.
-- 
BOFH excuse #218:

The UPS doesn't have a battery backup.
