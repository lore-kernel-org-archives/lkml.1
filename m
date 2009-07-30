Return-Path: <linux-kernel-owner+w=401wt.eu-S1751549AbZG3JW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbZG3JW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 05:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbZG3JW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 05:22:56 -0400
Received: from mail.gmx.net ([213.165.64.20]:39341 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751057AbZG3JWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 05:22:54 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18kU1EwO+Ikk//bGjuFT0uJRh0v4kb5aDXN42P1AF
	yuvGhQwUsfRiA6
Subject: [wireless] rt2870sta BUGs on shutdown,
 2.6.30.2->git.today+git.wireless.today
From: Mike Galbraith <efault@gmx.de>
To: linux-wireless@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain
Date: Thu, 30 Jul 2009 11:22:50 +0200
Message-Id: <1248945770.7910.24.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

$subject appears (at glance) to happen because threads have already
exited when we get to BUG_ON(), I haven't pursued it though.  Using
rt3070sta instead of rt2870sta works a treat with same box/adapter.

(the 2009_0521_RT2870_Linux_STA_V2.1.2.0 tree patches and rpm'd up for
opensuse-11.1 with kernels 27->29 doesn't BUG.. for 30 onward, I'm using
the in kernel staging drivers)

Box is el-cheapo (Aldi supermarket:) Q6600
lsusb: Bus 001 Device 003: ID 13d3:3247 IMC Networks 802.11 n/g/b Wireless LAN Adapter

Other than the BUG on shutdown, the thing works fine.

[  962.934582] Terminate the TimerQThr pid=4557!
[  962.934586] Terminate the MLMEThr pid=4554!
[  962.934588] Terminate the RTUSBCmdThr pid=4556!
[  962.940928] ---> RTMPFreeTxRxRingMemory
[  962.944807] <--- ReleaseAdapter

drivers/staging/rt2870/../rt2860/sta_ioctl.c
1079                 RT28XX_MLME_HANDLER(pAdapter);

drivers/staging/rt2870/rt2870.h
499 #define RT28XX_MLME_HANDLER(pAd)                        RTUSBMlmeUp(pAd)
586 #ifndef RT30xx
587 #define RTUSBMlmeUp(pAd)                \
588 {                                                                   \
589         POS_COOKIE pObj = (POS_COOKIE) pAd->OS_Cookie;  \
590         BUG_ON(pObj->MLMEThr_task == NULL);                 \
591         CHECK_PID_LEGALITY(task_pid(pObj->MLMEThr_task))                    \
592         up(&(pAd->mlme_semaphore)); \
593 }

[  962.962117] ------------[ cut here ]------------
[  962.966079] kernel BUG at drivers/staging/rt2870/../rt2860/sta_ioctl.c:1079!
[  962.968800] invalid opcode: 0000 [#1] SMP 
[  962.968800] last sysfs file: /sys/devices/pci0000:00/0000:00:1a.7/usb1/1-5/net/wlan0/type
[  962.985994] CPU 0 
[  962.985994] Modules linked in: xt_tcpudp xt_pkttype xt_limit snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs ip6t_REJECT nf_conntrack_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT xt_state iptable_raw iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables ip6table_filter cpufreq_conservative ip6_tables cpufreq_ondemand cpufreq_userspace x_tables cpufreq_powersave acpi_cpufreq ipv6 microcode fuse loop dm_mod snd_hda_codec_realtek snd_hda_intel firewire_ohci snd_hda_codec firewire_core snd_hwdep crc_itu_t snd_pcm snd_timer snd usb_storage ohci1394 soundcore rtc_cmos i2c_i801 rt2870sta(C) sr_mod usb_libusual rtc_core snd_page_alloc ieee1394 i2c_core thermal e1000e cdrom intel_agp button processor rtc_lib sg usbhid hid ehci_hcd uhci_hcd sd_mod usbcore edd fan ext3 mbcache jbd ahci libata scsi_mod
[  963.064503] Pid: 4752, comm: wpa_supplicant Tainted: G         C 2.6.31-wireless-smp #78 MS-7502
[  963.076503] RIP: 0010:[<ffffffffa0227043>]  [<ffffffffa0227043>] rt_ioctl_siwscan+0x1ad/0x1d6 [rt2870sta]
[  963.084502] RSP: 0018:ffff8800bf293bf8  EFLAGS: 00010246
[  963.088502] RAX: 0000000000000000 RBX: ffffc900127c7000 RCX: 0000000000000000
[  963.096503] RDX: 0000000000000508 RSI: 0000000000000508 RDI: ffffffffa01f6bca
[  963.100505] RBP: ffff8800bf293c08 R08: 0000000000000000 R09: ffff8800bf293d48
[  963.112503] R10: ffffffffa0226e96 R11: 0000000000000246 R12: 000000010002876c
[  963.112503] R13: ffff8800bdcfca00 R14: ffffffff812c0730 R15: 0000000000008b18
[  963.124502] FS:  00007fc25d6e36f0(0000) GS:ffff8800014e1000(0000) knlGS:0000000000000000
[  963.124502] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  963.124502] CR2: 00007fc25d72a000 CR3: 00000000be091000 CR4: 00000000000006f0
[  963.124502] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  963.124502] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  963.124502] Process wpa_supplicant (pid: 4752, threadinfo ffff8800bf292000, task ffff880037848660)
[  963.124502] Stack:
[  963.124502]  00000000fffffff4 ffff8800bf293de8 ffff8800bf293ca8 ffffffff8126a17e
[  963.124502] <0> ffff8800bf293c98 ffff8800bf293d48 ffff8800378b6000 ffffffffa0226e96
[  963.124502] <0> 0000000000000000 0000000000000000 0000000000001290 ffffffff00000000
[  963.192503] Call Trace:
[  963.196502]  [<ffffffff8126a17e>] ioctl_standard_iw_point+0x198/0x227
[  963.204503]  [<ffffffffa0226e96>] ? rt_ioctl_siwscan+0x0/0x1d6 [rt2870sta]
[  963.208503]  [<ffffffff8126a2a2>] ioctl_standard_call+0x95/0xb4
[  963.216505]  [<ffffffff8126a3f7>] wext_ioctl_dispatch+0x9a/0x172
[  963.220503]  [<ffffffff81269f6d>] ? ioctl_private_call+0x0/0x79
[  963.228503]  [<ffffffff8126a20d>] ? ioctl_standard_call+0x0/0xb4
[  963.234729]  [<ffffffff8126a5ba>] wext_handle_ioctl+0x39/0x6f
[  963.240503]  [<ffffffff810ca59b>] ? core_sys_select+0x23d/0x270
[  963.244503]  [<ffffffff811f73ae>] dev_ioctl+0x60e/0x637
[  963.252502]  [<ffffffff811e6096>] sock_ioctl+0x217/0x226
[  963.256502]  [<ffffffff810c8614>] vfs_ioctl+0x2a/0x78
[  963.256502]  [<ffffffff810c8b75>] do_vfs_ioctl+0x498/0x4d9
[  963.268502]  [<ffffffff810c8c0b>] sys_ioctl+0x55/0x77
[  963.268502]  [<ffffffff8100ba6b>] system_call_fastpath+0x16/0x1b
[  963.276503] Code: 00 00 00 00 00 00 4c 89 a3 90 19 00 00 ba 08 05 00 00 be 05 00 00 00 48 89 df e8 90 fa fc ff 48 8b 03 48 8b 40 08 48 85 c0 75 04 <0f> 0b eb fe 48 8b 80 00 02 00 00 48 85 c0 74 06 83 78 30 00 78 
[  963.292503] RIP  [<ffffffffa0227043>] rt_ioctl_siwscan+0x1ad/0x1d6 [rt2870sta]
[  963.304502]  RSP <ffff8800bf293bf8>
[  963.310285] ---[ end trace 292b4b823f542e3f ]---


