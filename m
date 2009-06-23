Return-Path: <linux-kernel-owner+w=401wt.eu-S1760479AbZFWQaD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760479AbZFWQaD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 12:30:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760244AbZFWQ3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 12:29:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:64854 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757722AbZFWQ3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 12:29:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=GNXK1btEWOygCXtBOPDwVcib4GQ4h9QKbtjsrqyGIocruh2b/MV++kGG6DgZFG6af1
         i7YrHGMB0bpsNbkjkQ1wDK+j51QDQ8DN0pWCqik7qzKj8cSYJ4ljQLkcg6ZX8swnCZlf
         BnTksXtVLsm51/BuUpUahf6Oh0aT/o9DaEzFA=
Message-ID: <4A410300.6040804@gmail.com>
Date: Tue, 23 Jun 2009 18:29:52 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.5 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: ath9k-devel@venema.h4ckr.net
CC: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
Subject: debugfs related oops in mac80211/ath9k
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got the oops attached below while running 2 threads:
cat /sys/kernel/debug/ieee80211/phy*/*
while :; do echo '0000:02:00.0' > unbind ; echo '0000:02:00.0' > bind; done
note that the oops is from suse kernel-of-the-day kernel. Happens with
vanilla 2.6.30 too.

sc->ah is NULL in ath9k_hw_gettsf64. Not good. file->private_data points
to freed memory (which is allocated by the same buddy a bit later in
this case). I got also another oopses in mac80211 layer, like in
frequency_read function. It has the same root cause.

The reading process still holds a reference to the node, so it's not
deleted. fops->read is called from vfs_read, but memory pointed by
file->private_data might be freed already.

We need some kind of barrier in debugfs_remove, so that all processes
with that file opened finishes first. Any ideas?

BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
IP: [<ffffffffa08704a0>] ath9k_ioread32+0x22/0x94 [ath9k]
PGD 8df2067 PUD 7dd28067 PMD 0
Oops: 0000 [#3] SMP
last sysfs file: /sys/bus/pci/drivers/ath9k/bind
CPU 1
Modules linked in: ath9k snd_seq_dummy btusb cryptd aes_x86_64
aes_generic cpufreq_stats tun radeon drm nfs lockd fscache(N) nfs_acl
auth_rpcgss sunrpc af_packet bridge stp llc(N) bnep sco rfcomm l2cap
bluetooth snd_pcm_oss snd_mixer_oss snd_seq ipv6 snd_seq_device
cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq
fuse loop snd_hda_codec_si3054(N) snd_hda_codec_realtek(N) arc4 ecb
snd_hda_intel snd_hda_codec(N) snd_hwdep snd_pcm mac80211 snd_timer
rfkill iTCO_wdt stkwebcam snd iTCO_vendor_support processor video
thermal videodev soundcore tpm_infineon i2c_i801 cfg80211 thermal_sys
v4l1_compat sr_mod asus_laptop kvm_intel tpm r8169 snd_page_alloc
intel_agp pcspkr i2c_core button battery ac output serio_raw cdrom
v4l2_compat_ioctl32(N) hwmon joydev tpm_bios led_class kvm sg uinput
usbhid hid uhci_hcd ata_piix ehci_hcd dm_mod [last unloaded: ath9k]
Supported: Yes
Pid: 25328, comm: cat Tainted: G      D   N
2.6.30-master_20090610141226_1b1ebc88-default #1 F2JE
RIP: 0010:[<ffffffffa08704a0>]  [<ffffffffa08704a0>]
ath9k_ioread32+0x22/0x94 [ath9k]
RSP: 0018:ffff880074687d88  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff880074687f50
RDX: ffffffffa0884016 RSI: 0000000000008050 RDI: 0000000000000000
RBP: ffff880074687dc8 R08: ffffffffa0261769 R09: 00007f5be6f09665
R10: 0000000000001fff R11: 0000000000000246 R12: 0000000000008050
R13: 0000000000001000 R14: 000000000060d000 R15: 0000000000000000
FS:  00007f5be6ed76f0(0000) GS:ffff88000104c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000068 CR3: 000000001339c000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process cat (pid: 25328, threadinfo ffff880074686000, task ffff88005a0fa680)
Stack:
 ffff880076c96cb8 ffffffff809221f8 ffff880074687dd8 0000000012d27d63
 ffff880074687dd8 0000000000000000 ffff88003fb71100 0000000000001000
 ffff880074687df8 ffffffffa0870539 ffffffff802449b7 0000000012d27d63
Call Trace:
 [<ffffffffa0870539>] ath9k_hw_gettsf64+0x27/0x5b [ath9k]
 [<ffffffffa0884054>] ath9k_get_tsf+0x3e/0x6b [ath9k]
 [<ffffffffa02617ab>] tsf_read+0x42/0x9b [mac80211]
 [<ffffffff80303f18>] vfs_read+0xb5/0x126
 [<ffffffff80304071>] sys_read+0x54/0x8c
 [<ffffffff8020c142>] system_call_fastpath+0x16/0x1b
 [<00007f5be6a617c0>] 0x7f5be6a617c0
Code: 74 05 e8 51 4b 9e df c9 c3 55 48 89 e5 41 55 41 54 41 89 f4 53 48
89 fb 48 83 ec 28 65 48 8b 04 25 28 00 00 00 48 89 45 d8 31 c0 <83> 7f
68 01 48 8b 3f 75 3b 48 81 c7 58 01 00 00 e8 7a c3 d7 df
RIP  [<ffffffffa08704a0>] ath9k_ioread32+0x22/0x94 [ath9k]
 RSP <ffff880074687d88>
CR2: 0000000000000068
---[ end trace b782e2e515247664 ]---
