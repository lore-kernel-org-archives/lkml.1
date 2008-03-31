Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbYCaXOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbYCaXOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 19:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbYCaXOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 19:14:15 -0400
Received: from gate.crashing.org ([63.228.1.57]:58343 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbYCaXOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 19:14:14 -0400
Subject: Re: [PATCH] evdev: Release eventual input device grabs when
	getting disconnected
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Greg KH <greg@kroah.com>,
       Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Jiri Kosina <jkosina@suse.cz>
In-Reply-To: <alpine.LFD.1.00.0803311122040.14670@woody.linux-foundation.org>
References: <20080330184259.GB21375@atjola.homenet>
	 <alpine.LFD.1.00.0803301448190.14670@woody.linux-foundation.org>
	 <200803310215.39414.dtor@insightbb.com> <20080331172813.GA11583@kroah.com>
	 <20080331135653.ZZRA012@mailhub.coreip.homeip.net>
	 <alpine.LFD.1.00.0803311122040.14670@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 01 Apr 2008 10:12:44 +1100
Message-Id: <1207005164.10388.172.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I do agree that this might want reverting, unless there is some rally good 
> reason for it. People may have pefectly valid reasons to expect topology 
> and reachability to remain valid - it's certainly what we guarantee in the 
> VFS code for similar rules (ie the parent of a dentry is only free'd after 
> all children have gone away).
> 
> Greg, is it possible to get the old lifetime rules back wrt his? They seem 
> valid and sane..

Looks like we are seeing something similar with suspend, I just got this
oops log. I think what happens is that appletouch suspend causes it to
disconnect and then X console switches or closes the evdev, whatever,
kaboom ...

sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Result: hostbyte=0x01 driverbyte=0x00
usbcore: deregistering interface driver appletouch
input: appletouch disconnected
PM: Syncing filesystems ... done.
Oops: Kernel access of bad area, sig: 11 [#1]
PowerMac
Modules linked in: sg sd_mod binfmt_misc appletalk psnap llc hci_usb radeon drm rfcomm l2cap bluetooth cpufreq_userspace cpufreq_powersave cpufreq_ondemand cpufreq_conservative xt_tcpudp nf_conntrack_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables fuse i2c_dev therm_adt746x sr_mod sbp2 apm_emu apm_emulation arc4 ecb snd_aoa_codec_tas snd_aoa_fabric_layout snd_aoa b43 mac80211 joydev pcmcia cfg80211 rng_core ohci1394 snd_aoa_i2sbus ieee1394 snd_pcm snd_page_alloc snd_seq_midi snd_rawmidi pmac_zilog serial_core snd_seq_midi_event snd_seq snd_timer snd_seq_device snd soundcore snd_aoa_soundbus yenta_socket rsrc_nonstatic pcmcia_core ssb uninorth_agp agpgart [last unloaded: appletouch]
NIP: c02932a8 LR: c01f961c CTR: c002ac78
REGS: d26e7dc0 TRAP: 0300   Not tainted  (2.6.25-rc7-p1)
MSR: 00009032 <EE,ME,IR,DR>  CR: 24000888  XER: 00000000
DAR: 00000000, DSISR: 42000000
TASK = d5be6d30[14676] 'Xorg' THREAD: d26e6000
GPR00: d26e7e78 d26e7e70 d5be6d30 ef065640 c037b570 c03a60d0 00000f40 00000001 
GPR08: 00000008 00000000 d26e7ea4 00000000 24000888 101fba44 101f3bc4 101f3bec 
GPR16: bffb0660 00000000 102187e4 10218ae4 102186e4 10218764 102189e4 bffb0574 
GPR24: 102187e4 101f3cf8 ef63c0d4 ef80cc20 ef152c1c ef065644 d5be6d30 ef065640 
NIP [c02932a8] __mutex_lock_slowpath+0x2c/0xc0
LR [c01f961c] input_release_device+0x24/0x48
Call Trace:
[d26e7e70] [c0380000] 0xc0380000 (unreliable)
[d26e7ea0] [c01f961c] input_release_device+0x24/0x48
[d26e7ec0] [c01fd9c4] evdev_ungrab+0x4c/0x64
[d26e7ed0] [c01fdac8] evdev_release+0xec/0xf0
[d26e7ef0] [c008b744] __fput+0xbc/0x1a4
[d26e7f10] [c0088178] filp_close+0x68/0xb0
[d26e7f30] [c0088250] sys_close+0x90/0xb4
[d26e7f40] [c0011c78] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xfc1d34c
    LR = 0x10077d78
Instruction dump:
4bfffe70 9421ffd0 7c0802a6 bfa10024 3ba30004 7c7f1b78 90010034 38010008 
7c5e1378 93a10008 81230008 90030008 <90090000> 9121000c 3920ffff 90410010 
---[ end trace aeb589f151c28f3f ]---
agpgart: Putting AGP V2 device at 0000:00:0b.0 into 4x mode


