Return-Path: <linux-kernel-owner+w=401wt.eu-S1756860AbZEPQ21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbZEPQ21 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 12:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbZEPQ2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 12:28:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:30003 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbZEPQ2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 12:28:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=vPG8jlxJq02hTqLthBdWQ51EkyKHh7JfHG8mHj66ZT342p0zM6WWQ8kWcHrLbdVfc8
         9kBy0S93v2IG7ZjfwWQCFTWba47Gme0O6o9qp0naCfF6CLZJHM3XdCqzKPMB8HCK3T85
         dmKi8rMqdBM4zjXSsVFFQdkiNSjepEAftnVCo=
Date: Sat, 16 May 2009 18:28:13 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-cifs-client@lists.samba.org
Subject: [2.6.30-rc6] cifs_close: NULL pointer dereference
Message-ID: <20090516162813.GA18098@nb-core2.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I just hit a NULL pointer dereference in cifs_close while accessing a file on a
remote Samba shared directory. The bug is reproducible, a simple:
touch foo; cat foo
is suffient to cause the OOPS. The machine is running kernel from git (1d80cac
- almost rc6), SMP w/ PREEMP. The remote server is running Samba 3.3.3.
I don't use CIFS frequently, but at some point it was certainly working; I can
try a bisection if you want.

BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
IP: [<ffffffffa05f105c>] cifs_close+0x1c1/0x2e8 [cifs]
PGD 9205f067 PUD 8f56c067 PMD 0 
Oops: 0002 [#1] PREEMPT SMP 
last sysfs file: /sys/devices/platform/coretemp.0/temp1_input
CPU 0 
Modules linked in: nls_iso8859_1 cifs radeon drm i2c_core af_packet binfmt_misc rfcomm l2cap kvm_intel kvm ipv6 acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_conservative cpufreq_powersave cpufreq_ondemand freq_table deflate zlib_deflate twofish_x86_64 twofish_common aes_x86_64 aes_generic blowfish des_generic cbc sha256_generic sha1_generic af_key ext3 jbd coretemp hwmon microcode loop arc4 snd_hda_codec_realtek ecb btusb snd_hda_intel snd_hda_codec iwlagn bluetooth snd_hwdep iwlcore snd_pcm snd_seq rfkill snd_timer snd_seq_device mac80211 snd video soundcore snd_page_alloc psmouse cfg80211 pcspkr evdev asus_laptop output rtc_cmos rtc_core rtc_lib processor battery ac button ext4 mbcache jbd2 crc16 usbhid hid dm_mod sg sd_mod sr_mod cdrom ahci ata_piix ohci1394 sdhci_pci sdhci ieee1394 mmc_core led_class uhci_hcd libata scsi_mod ehci_hcd intel_agp usbcore thermal fan unix
Pid: 17851, comm: cat Not tainted 2.6.30-rc5-00112-g1d80cac #110 F3Sa                
RIP: 0010:[<ffffffffa05f105c>]  [<ffffffffa05f105c>] cifs_close+0x1c1/0x2e8 [cifs]
RSP: 0018:ffff880098537e88  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8800bdbe7100 RCX: ffff880098537e08
RDX: 0000000000000000 RSI: 00000000fffffff7 RDI: ffffffffa0616bc4
RBP: ffff880098537ec8 R08: ffff88009573c870 R09: ffff88009227c940
R10: ffff880098537c58 R11: ffff88008f65dad0 R12: 0000000000000000
R13: 000000000000000a R14: 0000000000000000 R15: ffff8800bdbe7170
FS:  00007f7e12bba6f0(0000) GS:ffff88000101c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000008 CR3: 000000008f589000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process cat (pid: 17851, threadinfo ffff880098536000, task ffff88008f4c2b80)
Stack:
 ffff8800922b5900 ffff88006e019008 00000c216e0191f0 0000000000000010
 ffff88006e019008 ffff8800922b5900 ffff88006e019008 ffff8800be725100
 ffff880098537f08 ffffffff802ad55f ffff88006e0cdc00 ffff8800922b5900
Call Trace:
 [<ffffffff802ad55f>] __fput+0xeb/0x1ac
 [<ffffffff802ad638>] fput+0x18/0x1a
 [<ffffffff802aa94c>] filp_close+0x67/0x72
 [<ffffffff802aa9fc>] sys_close+0xa5/0xe4
 [<ffffffff8020bbab>] system_call_fastpath+0x16/0x1b
Code: 89 ef 45 31 e4 e8 f3 63 e7 df 41 bd 0a 00 00 00 48 c7 c7 c4 6b 61 a0 e8 b3 7f e7 df 48 8b 53 10 48 8b 43 18 48 c7 c7 c4 6b 61 a0 <48> 89 42 08 48 89 10 48 c7 43 18 00 02 20 00 48 8b 13 48 8b 43 
RIP  [<ffffffffa05f105c>] cifs_close+0x1c1/0x2e8 [cifs]
 RSP <ffff880098537e88>
CR2: 0000000000000008
---[ end trace c92994e7fd5bf7a2 ]---
note: cat[17851] exited with preempt_count 1
