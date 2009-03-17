Return-Path: <linux-kernel-owner+w=401wt.eu-S1753860AbZCQOry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbZCQOry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 10:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbZCQOro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 10:47:44 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:46905 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbZCQOrn (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 10:47:43 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: jkosina@suse.cz, gregkh@suse.de
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: 29-rc-mmotm - HID/USB wedge w/ WARNING: at kernel/workqueue.c:371
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1237271588_3230P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 17 Mar 2009 02:33:09 -0400
Message-ID: <6648.1237271589@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1237271588_3230P
Content-Type: text/plain; charset=us-ascii

29-rc3-mmotm0129 is OK, I hit it a few times under rc5-mmotm0214, but I'm
seeing it a lot under -rc8-mmotm0313 (have triggered it 6 times in the past 4
hours).  Very consistent traceback out of the HID and USB stack - the events/0
kernel thread loses its shit:

[ 3816.196809] ------------[ cut here ]------------
[ 3816.196815] WARNING: at kernel/workqueue.c:371 flush_cpu_workqueue+0x32/0x82()
[ 3816.196820] Hardware name: Latitude D820                   
[ 3816.196823] Modules linked in: irnet ppp_generic slhc irtty_sir sir_dev ircomm_tty ircomm irda crc_ccitt coretemp sunrpc nf_conntrack_ftp xt_pkttype nf_conntrack_ipv4 nf_defrag_ipv4 ipt_REJECT xt_recent ipt_LOG xt_u32 xt_multiport iptable_filter ip_tables xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6t_LOG xt_limit ip6table_filter ip6_tables x_tables sha256_generic aes_x86_64 aes_generic rtc acpi_cpufreq tpm_tis tpm tpm_bios arc4 ecb nvidia(P) iwl3945 iwlcore mac80211 ohci1394 pcmcia ieee1394 dell_laptop yenta_socket led_class snd_hda_codec_idt video processor uhci_hcd iTCO_wdt rsrc_nonstatic cfg80211 snd_hda_intel intel_agp pcmcia_core iTCO_vendor_support rfkill output snd_hda_codec button battery thermal ac dcdbas [last unloaded: microcode]
[ 3816.196950] Pid: 9, comm: events/0 Tainted: P           2.6.29-rc8-mmotm0313 #3
[ 3816.196955] Call Trace:
[ 3816.196965]  [<ffffffff80233e53>] warn_slowpath+0xaf/0xd6
[ 3816.196974]  [<ffffffff803b78a5>] ? extract_buf+0x8e/0xc3
[ 3816.196983]  [<ffffffff8027e07a>] ? list_add+0xc/0xe
[ 3816.196990]  [<ffffffff8027eb0b>] ? __free_one_page+0x17f/0x1e6
[ 3816.196997]  [<ffffffff80243ea6>] flush_cpu_workqueue+0x32/0x82
[ 3816.197032]  [<ffffffff804214dd>] ? usb_hcd_unlink_urb+0x48/0x84
[ 3816.197040]  [<ffffffff80422762>] ? usb_kill_urb+0x21/0xce
[ 3816.197046]  [<ffffffff802444d7>] flush_workqueue+0x4d/0x67
[ 3816.197053]  [<ffffffff80244501>] flush_scheduled_work+0x10/0x12
[ 3816.197061]  [<ffffffff8045da33>] hid_cease_io+0x3b/0x40
[ 3816.197067]  [<ffffffff8045da7b>] hid_pre_reset+0x43/0x4a
[ 3816.197073]  [<ffffffff8041e627>] usb_reset_device+0x6c/0x11c
[ 3816.197080]  [<ffffffff8045e535>] hid_reset+0x9e/0x12e
[ 3816.197086]  [<ffffffff8045e497>] ? hid_reset+0x0/0x12e
[ 3816.197092]  [<ffffffff80243bca>] worker_thread+0x1d3/0x27b
[ 3816.197100]  [<ffffffff802477c1>] ? autoremove_wake_function+0x0/0x34
[ 3816.197106]  [<ffffffff802439f7>] ? worker_thread+0x0/0x27b
[ 3816.197113]  [<ffffffff802473bb>] kthread+0x55/0x80
[ 3816.197120]  [<ffffffff8020c15a>] child_rip+0xa/0x20
[ 3816.197128]  [<ffffffff8020bb2d>] ? restore_args+0x0/0x30
[ 3816.197135]  [<ffffffff80247366>] ? kthread+0x0/0x80
[ 3816.197140]  [<ffffffff8020c150>] ? child_rip+0x0/0x20
[ 3816.197145] ---[ end trace 1e05d800555b77d7 ]---

Yes, there's an NVidia driver loaded - but this looks like an HID/USB
bug, where it's shooting itself in the foot by flushing the workqueue while
not realizing it's in a worker thread already, thus deadlocking.

After that traceback happens, the keyboard and USB mouse are dead. The onboard
touchpad that presents as a PS/2 mouse still works, and alt-sysrq semi-works (
-S and -U work to get the disks unmounted, but -B fails to reboot).

After that, things slowly grind to a halt as processes get blocked because
they're waiting for events/0, or they're waiting on something else that
blocked - I can hit the power button and it will *start* a shutdown, but
that too will wedge pretty quickly.

About 2 minutes later, if I wait that long, I'll get this:

[ 3240.474270] INFO: task events/0:9 blocked for more than 120 seconds.
[ 3240.474273] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 3240.474275] events/0      D ffff8800010287c0  5352     9      2
[ 3240.474281]  ffff88007f24fc30 0000000000000046 ffff88007f24fbb0 0031f9ec188eafbf
[ 3240.474287]  ffff880001018000 ffff88007f24fa80 ffff88007f24fa20 0000000000000000
[ 3240.474291]  ffff88007f2333a0 00000000000107c0 ffff88007f2333a0 00000000000107c0
[ 3240.474296] Call Trace:
[ 3240.474305]  [<ffffffff805429d1>] schedule+0x13/0x3d
[ 3240.474308]  [<ffffffff80542bca>] schedule_timeout+0x22/0xb9
[ 3240.474312]  [<ffffffff8054483e>] ? _spin_unlock_irqrestore+0x45/0x52
[ 3240.474317]  [<ffffffff8022cbeb>] ? get_parent_ip+0x11/0x41
[ 3240.474321]  [<ffffffff80546ca5>] ? sub_preempt_count+0x35/0x48
[ 3240.474324]  [<ffffffff8054209b>] wait_for_common+0xb7/0x106
[ 3240.474327]  [<ffffffff8022de49>] ? default_wake_function+0x0/0xf
[ 3240.474331]  [<ffffffff80542174>] wait_for_completion+0x18/0x1a
[ 3240.474335]  [<ffffffff80243eea>] flush_cpu_workqueue+0x76/0x82
[ 3240.474338]  [<ffffffff80243f9b>] ? wq_barrier_func+0x0/0xf
[ 3240.474341]  [<ffffffff802444d7>] flush_workqueue+0x4d/0x67
[ 3240.474345]  [<ffffffff80244501>] flush_scheduled_work+0x10/0x12
[ 3240.474349]  [<ffffffff8045da33>] hid_cease_io+0x3b/0x40
[ 3240.474352]  [<ffffffff8045da7b>] hid_pre_reset+0x43/0x4a
[ 3240.474357]  [<ffffffff8041e627>] usb_reset_device+0x6c/0x11c
[ 3240.474360]  [<ffffffff8045e535>] hid_reset+0x9e/0x12e
[ 3240.474363]  [<ffffffff8045e497>] ? hid_reset+0x0/0x12e
[ 3240.474366]  [<ffffffff80243bca>] worker_thread+0x1d3/0x27b
[ 3240.474370]  [<ffffffff802477c1>] ? autoremove_wake_function+0x0/0x34
[ 3240.474373]  [<ffffffff802439f7>] ? worker_thread+0x0/0x27b
[ 3240.474377]  [<ffffffff802473bb>] kthread+0x55/0x80
[ 3240.474381]  [<ffffffff8020c15a>] child_rip+0xa/0x20
[ 3240.474385]  [<ffffffff8020bb2d>] ? restore_args+0x0/0x30
[ 3240.474388]  [<ffffffff80247366>] ? kthread+0x0/0x80
[ 3240.474391]  [<ffffffff8020c150>] ? child_rip+0x0/0x20

Yeah, it's wedged good and solid.


--==_Exmh_1237271588_3230P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJv0QkcC3lWbTT17ARAr/CAJ9iepSKxj41xuR+tiGiv4GYCMzjngCeIzL7
xnGYL65S7WPDTDhjA2ELwBo=
=PjEZ
-----END PGP SIGNATURE-----

--==_Exmh_1237271588_3230P--
