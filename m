Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbZBACz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbZBACz0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 21:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbZBACzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 21:55:12 -0500
Received: from main.gmane.org ([80.91.229.2]:36859 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbZBACzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 21:55:08 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bryon Roche <kain@kain.org>
Subject: 2.6.27.8 (+?) softlockup BUG (inotify still raceable)?
Date: Sun, 1 Feb 2009 02:53:06 +0000 (UTC)
Message-ID: <gm32qh$m3p$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p548a7326.dip.t-dialin.net
User-Agent: Pan/0.132 (Waxed in Black)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all, I think i've hit another race BUG in inotify causing soft 
lockup on a heavily loaded system.  Amusingly enough, the only actual 
user of inotify in this case on said system is console-kit-daemon which 
has since been expunged.

Any ideas?

BUG outputs, kernel config, System.map: http://kain.org/kcrash/jan31-2.6.27.8.tar.bz2

System is a quad-core Xeon X3320, 8GB of RAM running in 64-bit mode.  As I am
processing some very large directories (on XFS), I have set the
xfs_vnode,inode_cache,xfs_inode,dentry,page_cgroup slabs to order 3 allocations
by default.  At the time of the lockup, I was at 697.8 or so MB of slab usage,
687.1MB free, 4.9GB cached, 16.5M buffers.  No swap.

BUGs follow:

[1027681.529987] BUG: soft lockup - CPU#0 stuck for 61s! [console-kit-dae:8072]
[1027681.547086] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat kvm_intel kvm tun ipt_LOG xt_hashlimit xt_limit xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip6table_filter ip6_tables autofs4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs md_mod binfmt_misc megaraid_mm af_packet rfcomm l2cap bluetooth ppdev acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative wmi video output sbs sbshc pci_slot dock battery ipv6 bridge stp iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop parport_pc psmouse parport e1000e pcspkr iTCO_wdt container iTCO_vendor_support shpchp pci_hotplug button evdev usb_storage xfs libusual ses enclosure sd_mod crc_t10dif sg ehci_hcd uhci_hcd floppy megaraid_sas scsi_mod usbcore dm_mirror dm_log dm_snapshot dm_mod thermal processor fan thermal_sys fuse
[1027681.547086] CPU 0:
[1027681.547086] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat kvm_intel kvm tun ipt_LOG xt_hashlimit xt_limit xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip6table_filter ip6_tables autofs4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs md_mod binfmt_misc megaraid_mm af_packet rfcomm l2cap bluetooth ppdev acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative wmi video output sbs sbshc pci_slot dock battery ipv6 bridge stp iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop parport_pc psmouse parport e1000e pcspkr iTCO_wdt container iTCO_vendor_support shpchp pci_hotplug button evdev usb_storage xfs libusual ses enclosure sd_mod crc_t10dif sg ehci_hcd uhci_hcd floppy megaraid_sas scsi_mod usbcore dm_mirror dm_log dm_snapshot dm_mod thermal processor fan thermal_sys fuse
[1027681.547086] Pid: 8072, comm: console-kit-dae Not tainted 2.6.27.8 #1
[1027681.547086] RIP: 0010:[<ffffffff802e5821>]  [<ffffffff802e5821>] put_inotify_watch+0x21/0x70
[1027681.547086] RSP: 0018:ffff88022892fb78  EFLAGS: 00000246
[1027681.547086] RAX: ffff880222890200 RBX: ffff88022389e000 RCX: 0000000000000006
[1027681.547086] RDX: ffff88022c9a3810 RSI: 0000000000000001 RDI: ffff88022f26c0e0
[1027681.547086] RBP: ffff88022f063b10 R08: 0000000000000000 R09: 000000000000000a
[1027681.547086] R10: 0000000000000001 R11: ffffffff803acdf0 R12: ffff88022397c830
[1027681.547086] R13: 0000000000000000 R14: ffff88022d9c74a0 R15: 0000000000000086
[1027681.547086] FS:  00007fe1dd18e780(0000) GS:ffffffff8064ca80(0000) knlGS:0000000000000000
[1027681.547086] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[1027681.547086] CR2: 00007f48f47acfbb CR3: 0000000201d07000 CR4: 00000000000026e0
[1027681.547086] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[1027681.547086] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[1027681.547086] 
[1027681.547086] Call Trace:
[1027681.547086]  [<ffffffff802e5890>] ? unpin_and_kill+0x20/0x70
[1027681.547086]  [<ffffffff802e5a7c>] ? inotify_destroy+0x9c/0xe0
[1027681.547086]  [<ffffffff802e6073>] ? inotify_release+0x23/0xb0
[1027681.547086]  [<ffffffff802b6b21>] ? __fput+0xb1/0x1d0
[1027681.547086]  [<ffffffff802b3a74>] ? filp_close+0x54/0x90
[1027681.547086]  [<ffffffff8023dfc1>] ? put_files_struct+0xb1/0xd0
[1027681.547086]  [<ffffffff8023f55d>] ? do_exit+0x19d/0x970
[1027681.547086]  [<ffffffff80247af5>] ? __dequeue_signal+0x115/0x160
[1027681.547086]  [<ffffffff8023fd63>] ? do_group_exit+0x33/0x90
[1027681.547086]  [<ffffffff80249f58>] ? get_signal_to_deliver+0x178/0x340
[1027681.547086]  [<ffffffff8020b4f0>] ? do_notify_resume+0xa0/0x920
[1027681.547086]  [<ffffffff8022ecdf>] ? task_rq_lock+0x4f/0xa0
[1027681.547086]  [<ffffffff80233b40>] ? try_to_wake_up+0xf0/0x1c0
[1027681.547086]  [<ffffffff8022ed85>] ? __dequeue_entity+0x55/0x80
[1027681.547086]  [<ffffffff8022f335>] ? pick_next_task_fair+0xa5/0xc0
[1027681.547086]  [<ffffffff804872b2>] ? do_page_fault+0x772/0x830
[1027681.547086]  [<ffffffff804872b2>] ? do_page_fault+0x772/0x830
[1027681.547086]  [<ffffffff8020c938>] ? retint_signal+0x3d/0x75
[1027681.547086] 
[1027747.019987] BUG: soft lockup - CPU#0 stuck for 61s! [console-kit-dae:8072]
[1027747.040417] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat kvm_intel kvm tun ipt_LOG xt_hashlimit xt_limit xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip6table_filter ip6_tables autofs4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs md_mod binfmt_misc megaraid_mm af_packet rfcomm l2cap bluetooth ppdev acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative wmi video output sbs sbshc pci_slot dock battery ipv6 bridge stp iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop parport_pc psmouse parport e1000e pcspkr iTCO_wdt container iTCO_vendor_support shpchp pci_hotplug button evdev usb_storage xfs libusual ses enclosure sd_mod crc_t10dif sg ehci_hcd uhci_hcd floppy megaraid_sas scsi_mod usbcore dm_mirror dm_log dm_snapshot dm_mod thermal processor fan thermal_sys fuse
[1027747.040417] CPU 0:
[1027747.040417] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat kvm_intel kvm tun ipt_LOG xt_hashlimit xt_limit xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip6table_filter ip6_tables autofs4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs md_mod binfmt_misc megaraid_mm af_packet rfcomm l2cap bluetooth ppdev acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative wmi video output sbs sbshc pci_slot dock battery ipv6 bridge stp iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop parport_pc psmouse parport e1000e pcspkr iTCO_wdt container iTCO_vendor_support shpchp pci_hotplug button evdev usb_storage xfs libusual ses enclosure sd_mod crc_t10dif sg ehci_hcd uhci_hcd floppy megaraid_sas scsi_mod usbcore dm_mirror dm_log dm_snapshot dm_mod thermal processor fan thermal_sys fuse
[1027747.041253] Pid: 8072, comm: console-kit-dae Not tainted 2.6.27.8 #1
[1027747.041253] RIP: 0010:[<ffffffff80483553>]  [<ffffffff80483553>] mutex_unlock+0x3/0x10
[1027747.041253] RSP: 0018:ffff88022892fbb0  EFLAGS: 00000202
[1027747.041253] RAX: 0000000000000000 RBX: ffff8802270a5a20 RCX: 0000000000000006
[1027747.041253] RDX: ffff88022c9a3810 RSI: 0000000000000081 RDI: ffff880222890428
[1027747.041253] RBP: ffff88022c9a3810 R08: 0000000000000000 R09: 000000000000000a
[1027747.041253] R10: 0000000000000001 R11: ffffffff803acdf0 R12: 0000000000000006
[1027747.041253] R13: ffff880222890238 R14: 0000000000000000 R15: 000000000000000a
[1027747.041253] FS:  00007fe1dd18e780(0000) GS:ffffffff8064ca80(0000) knlGS:0000000000000000
[1027747.041253] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[1027747.041253] CR2: 00007f48f47acfbb CR3: 0000000201d07000 CR4: 00000000000026e0
[1027747.041253] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[1027747.041253] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[1027747.041253] 
[1027747.041253] Call Trace:
[1027747.041253]  [<ffffffff802e5a71>] ? inotify_destroy+0x91/0xe0
[1027747.041253]  [<ffffffff802e6073>] ? inotify_release+0x23/0xb0
[1027747.041253]  [<ffffffff802b6b21>] ? __fput+0xb1/0x1d0
[1027747.041253]  [<ffffffff802b3a74>] ? filp_close+0x54/0x90
[1027747.041427]  [<ffffffff8023dfc1>] ? put_files_struct+0xb1/0xd0
[1027747.041427]  [<ffffffff8023f55d>] ? do_exit+0x19d/0x970
[1027747.041427]  [<ffffffff80247af5>] ? __dequeue_signal+0x115/0x160
[1027747.041427]  [<ffffffff8023fd63>] ? do_group_exit+0x33/0x90
[1027747.041427]  [<ffffffff80249f58>] ? get_signal_to_deliver+0x178/0x340
[1027747.041427]  [<ffffffff8020b4f0>] ? do_notify_resume+0xa0/0x920
[1027747.041427]  [<ffffffff8022ecdf>] ? task_rq_lock+0x4f/0xa0
[1027747.041427]  [<ffffffff80233b40>] ? try_to_wake_up+0xf0/0x1c0
[1027747.041427]  [<ffffffff8022ed85>] ? __dequeue_entity+0x55/0x80
[1027747.041427]  [<ffffffff8022f335>] ? pick_next_task_fair+0xa5/0xc0
[1027747.041427]  [<ffffffff804872b2>] ? do_page_fault+0x772/0x830
[1027747.041427]  [<ffffffff804872b2>] ? do_page_fault+0x772/0x830
[1027747.041427]  [<ffffffff8020c938>] ? retint_signal+0x3d/0x75
[1027747.041427] 
[1027812.519988] BUG: soft lockup - CPU#0 stuck for 61s! [console-kit-dae:8072]
[1027812.536656] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat kvm_intel kvm tun ipt_LOG xt_hashlimit xt_limit xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip6table_filter ip6_tables autofs4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs md_mod binfmt_misc megaraid_mm af_packet rfcomm l2cap bluetooth ppdev acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative wmi video output sbs sbshc pci_slot dock battery ipv6 bridge stp iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop parport_pc psmouse parport e1000e pcspkr iTCO_wdt container iTCO_vendor_support shpchp pci_hotplug button evdev usb_storage xfs libusual ses enclosure sd_mod crc_t10dif sg ehci_hcd uhci_hcd floppy megaraid_sas scsi_mod usbcore dm_mirror dm_log dm_snapshot dm_mod thermal processor fan thermal_sys fuse
[1027812.536656] CPU 0:
[1027812.536656] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat kvm_intel kvm tun ipt_LOG xt_hashlimit xt_limit xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip6table_filter ip6_tables autofs4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs md_mod binfmt_misc megaraid_mm af_packet rfcomm l2cap bluetooth ppdev acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative wmi video output sbs sbshc pci_slot dock battery ipv6 bridge stp iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop parport_pc psmouse parport e1000e pcspkr iTCO_wdt container iTCO_vendor_support shpchp pci_hotplug button evdev usb_storage xfs libusual ses enclosure sd_mod crc_t10dif sg ehci_hcd uhci_hcd floppy megaraid_sas scsi_mod usbcore dm_mirror dm_log dm_snapshot dm_mod thermal processor fan thermal_sys fuse
[1027812.541253] Pid: 8072, comm: console-kit-dae Not tainted 2.6.27.8 #1
[1027812.541253] RIP: 0010:[<ffffffff802e5019>]  [<ffffffff802e5019>] pin_to_kill+0x69/0x120
[1027812.541253] RSP: 0018:ffff88022892fb88  EFLAGS: 00000202
[1027812.541253] RAX: 0000000040000000 RBX: ffff88022f26c0e0 RCX: 0000000000000003
[1027812.541253] RDX: 0000000000000000 RSI: ffff88022f26c0e0 RDI: ffff8802270a5a40
[1027812.541253] RBP: ffffffff803acdf0 R08: 0000000000000000 R09: 000000000000000a
[1027812.541253] R10: 0000000000000001 R11: ffffffff803acdf0 R12: ffffffff8074ba20
[1027812.541253] R13: ffff88022f063b10 R14: ffff88022397c830 R15: 0000000000000000
[1027812.541253] FS:  00007fe1dd18e780(0000) GS:ffffffff8064ca80(0000) knlGS:0000000000000000
[1027812.541253] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[1027812.541253] CR2: 00007f48f47acfbb CR3: 0000000201d07000 CR4: 00000000000026e0
[1027812.541253] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[1027812.541253] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[1027812.541253] 
[1027812.541253] Call Trace:
[1027812.541253]  [<ffffffff802e5019>] ? pin_to_kill+0x69/0x120
[1027812.541253]  [<ffffffff802e5a1c>] ? inotify_destroy+0x3c/0xe0
[1027812.541253]  [<ffffffff802e6073>] ? inotify_release+0x23/0xb0
[1027812.541253]  [<ffffffff802b6b21>] ? __fput+0xb1/0x1d0
[1027812.541253]  [<ffffffff802b3a74>] ? filp_close+0x54/0x90
[1027812.541433]  [<ffffffff8023dfc1>] ? put_files_struct+0xb1/0xd0
[1027812.541433]  [<ffffffff8023f55d>] ? do_exit+0x19d/0x970
[1027812.541433]  [<ffffffff80247af5>] ? __dequeue_signal+0x115/0x160
[1027812.541433]  [<ffffffff8023fd63>] ? do_group_exit+0x33/0x90
[1027812.541433]  [<ffffffff80249f58>] ? get_signal_to_deliver+0x178/0x340
[1027812.541433]  [<ffffffff8020b4f0>] ? do_notify_resume+0xa0/0x920
[1027812.541433]  [<ffffffff8022ecdf>] ? task_rq_lock+0x4f/0xa0
[1027812.541433]  [<ffffffff80233b40>] ? try_to_wake_up+0xf0/0x1c0
[1027812.541433]  [<ffffffff8022ed85>] ? __dequeue_entity+0x55/0x80
[1027812.541433]  [<ffffffff8022f335>] ? pick_next_task_fair+0xa5/0xc0
[1027812.541433]  [<ffffffff804872b2>] ? do_page_fault+0x772/0x830
[1027812.541433]  [<ffffffff804872b2>] ? do_page_fault+0x772/0x830
[1027812.541433]  [<ffffffff8020c938>] ? retint_signal+0x3d/0x75
[1027812.541433] 
[1027878.019987] BUG: soft lockup - CPU#0 stuck for 61s! [console-kit-dae:8072]
[1027878.040415] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat kvm_intel kvm tun ipt_LOG xt_hashlimit xt_limit xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip6table_filter ip6_tables autofs4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs md_mod binfmt_misc megaraid_mm af_packet rfcomm l2cap bluetooth ppdev acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative wmi video output sbs sbshc pci_slot dock battery ipv6 bridge stp iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop parport_pc psmouse parport e1000e pcspkr iTCO_wdt container iTCO_vendor_support shpchp pci_hotplug button evdev usb_storage xfs libusual ses enclosure sd_mod crc_t10dif sg ehci_hcd uhci_hcd floppy megaraid_sas scsi_mod usbcore dm_mirror dm_log dm_snapshot dm_mod thermal processor fan thermal_sys fuse
[1027878.040415] CPU 0:
[1027878.040415] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat kvm_intel kvm tun ipt_LOG xt_hashlimit xt_limit xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip6table_filter ip6_tables autofs4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs md_mod binfmt_misc megaraid_mm af_packet rfcomm l2cap bluetooth ppdev acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative wmi video output sbs sbshc pci_slot dock battery ipv6 bridge stp iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop parport_pc psmouse parport e1000e pcspkr iTCO_wdt container iTCO_vendor_support shpchp pci_hotplug button evdev usb_storage xfs libusual ses enclosure sd_mod crc_t10dif sg ehci_hcd uhci_hcd floppy megaraid_sas scsi_mod usbcore dm_mirror dm_log dm_snapshot dm_mod thermal processor fan thermal_sys fuse
[1027878.040415] Pid: 8072, comm: console-kit-dae Not tainted 2.6.27.8 #1
[1027878.040415] RIP: 0010:[<ffffffff80483553>]  [<ffffffff80483553>] mutex_unlock+0x3/0x10
[1027878.040415] RSP: 0018:ffff88022892fbb0  EFLAGS: 00000202
[1027878.040415] RAX: 0000000000000000 RBX: ffff8802270a5a20 RCX: 0000000000000006
[1027878.040415] RDX: ffff88022c9a3810 RSI: 0000000000000081 RDI: ffff880222890428
[1027878.040415] RBP: 0000000000000003 R08: 0000000000000000 R09: 000000000000000a
[1027878.040415] R10: 0000000000000001 R11: ffffffff803acdf0 R12: 0000000000000003
[1027878.040415] R13: 0000000000000003 R14: 0000000000000000 R15: 000000000000000a
[1027878.040415] FS:  00007fe1dd18e780(0000) GS:ffffffff8064ca80(0000) knlGS:0000000000000000
[1027878.040415] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[1027878.040415] CR2: 00007f48f47acfbb CR3: 0000000201d07000 CR4: 00000000000026e0
[1027878.040415] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[1027878.041254] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[1027878.041254] 
[1027878.041254] Call Trace:
[1027878.041254]  [<ffffffff802e5a71>] ? inotify_destroy+0x91/0xe0
[1027878.041254]  [<ffffffff802e6073>] ? inotify_release+0x23/0xb0
[1027878.041254]  [<ffffffff802b6b21>] ? __fput+0xb1/0x1d0
[1027878.041254]  [<ffffffff802b3a74>] ? filp_close+0x54/0x90
[1027878.041254]  [<ffffffff8023dfc1>] ? put_files_struct+0xb1/0xd0
[1027878.041254]  [<ffffffff8023f55d>] ? do_exit+0x19d/0x970
[1027878.041254]  [<ffffffff80247af5>] ? __dequeue_signal+0x115/0x160
[1027878.041254]  [<ffffffff8023fd63>] ? do_group_exit+0x33/0x90
[1027878.041254]  [<ffffffff80249f58>] ? get_signal_to_deliver+0x178/0x340
[1027878.041254]  [<ffffffff8020b4f0>] ? do_notify_resume+0xa0/0x920
[1027878.041254]  [<ffffffff8022ecdf>] ? task_rq_lock+0x4f/0xa0
[1027878.041254]  [<ffffffff80233b40>] ? try_to_wake_up+0xf0/0x1c0
[1027878.041254]  [<ffffffff8022ed85>] ? __dequeue_entity+0x55/0x80
[1027878.041254]  [<ffffffff8022f335>] ? pick_next_task_fair+0xa5/0xc0
[1027878.041254]  [<ffffffff804872b2>] ? do_page_fault+0x772/0x830
[1027878.041254]  [<ffffffff804872b2>] ? do_page_fault+0x772/0x830
[1027878.041254]  [<ffffffff8020c938>] ? retint_signal+0x3d/0x75
[1027878.041254] 
[1027943.519987] BUG: soft lockup - CPU#0 stuck for 61s! [console-kit-dae:8072]
[1027943.537989] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat kvm_intel kvm tun ipt_LOG xt_hashlimit xt_limit xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip6table_filter ip6_tables autofs4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs md_mod binfmt_misc megaraid_mm af_packet rfcomm l2cap bluetooth ppdev acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative wmi video output sbs sbshc pci_slot dock battery ipv6 bridge stp iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop parport_pc psmouse parport e1000e pcspkr iTCO_wdt container iTCO_vendor_support shpchp pci_hotplug button evdev usb_storage xfs libusual ses enclosure sd_mod crc_t10dif sg ehci_hcd uhci_hcd floppy megaraid_sas scsi_mod usbcore dm_mirror dm_log dm_snapshot dm_mod thermal processor fan thermal_sys fuse
[1027943.537989] CPU 0:
[1027943.537989] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat kvm_intel kvm tun ipt_LOG xt_hashlimit xt_limit xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip6table_filter ip6_tables autofs4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs md_mod binfmt_misc megaraid_mm af_packet rfcomm l2cap bluetooth ppdev acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative wmi video output sbs sbshc pci_slot dock battery ipv6 bridge stp iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop parport_pc psmouse parport e1000e pcspkr iTCO_wdt container iTCO_vendor_support shpchp pci_hotplug button evdev usb_storage xfs libusual ses enclosure sd_mod crc_t10dif sg ehci_hcd uhci_hcd floppy megaraid_sas scsi_mod usbcore dm_mirror dm_log dm_snapshot dm_mod thermal processor fan thermal_sys fuse
[1027943.537989] Pid: 8072, comm: console-kit-dae Not tainted 2.6.27.8 #1
[1027943.537989] RIP: 0010:[<ffffffff802e5001>]  [<ffffffff802e5001>] pin_to_kill+0x51/0x120
[1027943.537989] RSP: 0018:ffff88022892fb88  EFLAGS: 00000206
[1027943.537989] RAX: 0000000040000000 RBX: ffff88022f26c0e0 RCX: 0000000000000003
[1027943.537989] RDX: 0000000000000000 RSI: ffff88022f26c0e0 RDI: ffffffff8074ba20
[1027943.537989] RBP: ffffffff803acdf0 R08: 0000000000000000 R09: 000000000000000a
[1027943.537989] R10: 0000000000000001 R11: ffffffff803acdf0 R12: ffff88022389e000
[1027943.537989] R13: ffff88022f063b10 R14: ffff88022397c830 R15: 0000000000000000
[1027943.537989] FS:  00007fe1dd18e780(0000) GS:ffffffff8064ca80(0000) knlGS:0000000000000000
[1027943.537989] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[1027943.537989] CR2: 00007f48f47acfbb CR3: 0000000201d07000 CR4: 00000000000026e0
[1027943.537989] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[1027943.541253] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[1027943.541253] 
[1027943.541253] Call Trace:
[1027943.541253]  [<ffffffff802e4fed>] ? pin_to_kill+0x3d/0x120
[1027943.541253]  [<ffffffff802e5a1c>] ? inotify_destroy+0x3c/0xe0
[1027943.541253]  [<ffffffff802e6073>] ? inotify_release+0x23/0xb0
[1027943.541253]  [<ffffffff802b6b21>] ? __fput+0xb1/0x1d0
[1027943.541253]  [<ffffffff802b3a74>] ? filp_close+0x54/0x90
[1027943.541253]  [<ffffffff8023dfc1>] ? put_files_struct+0xb1/0xd0
[1027943.541253]  [<ffffffff8023f55d>] ? do_exit+0x19d/0x970
[1027943.541253]  [<ffffffff80247af5>] ? __dequeue_signal+0x115/0x160
[1027943.541253]  [<ffffffff8023fd63>] ? do_group_exit+0x33/0x90
[1027943.541253]  [<ffffffff80249f58>] ? get_signal_to_deliver+0x178/0x340
[1027943.541253]  [<ffffffff8020b4f0>] ? do_notify_resume+0xa0/0x920
[1027943.541253]  [<ffffffff8022ecdf>] ? task_rq_lock+0x4f/0xa0
[1027943.541253]  [<ffffffff80233b40>] ? try_to_wake_up+0xf0/0x1c0
[1027943.541253]  [<ffffffff8022ed85>] ? __dequeue_entity+0x55/0x80
[1027943.541253]  [<ffffffff8022f335>] ? pick_next_task_fair+0xa5/0xc0
[1027943.541253]  [<ffffffff804872b2>] ? do_page_fault+0x772/0x830
[1027943.541253]  [<ffffffff804872b2>] ? do_page_fault+0x772/0x830
[1027943.541253]  [<ffffffff8020c938>] ? retint_signal+0x3d/0x75
[1027943.541253] 
[1028055.189987] BUG: soft lockup - CPU#0 stuck for 61s! [console-kit-dae:8072]
[1028055.206915] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat kvm_intel kvm tun ipt_LOG xt_hashlimit xt_limit xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip6table_filter ip6_tables autofs4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs md_mod binfmt_misc megaraid_mm af_packet rfcomm l2cap bluetooth ppdev acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative wmi video output sbs sbshc pci_slot dock battery ipv6 bridge stp iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop parport_pc psmouse parport e1000e pcspkr iTCO_wdt container iTCO_vendor_support shpchp pci_hotplug button evdev usb_storage xfs libusual ses enclosure sd_mod crc_t10dif sg ehci_hcd uhci_hcd floppy megaraid_sas scsi_mod usbcore dm_mirror dm_log dm_snapshot dm_mod thermal processor fan thermal_sys fuse
[1028055.206915] CPU 0:
[1028055.206915] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat kvm_intel kvm tun ipt_LOG xt_hashlimit xt_limit xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip6table_filter ip6_tables autofs4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs md_mod binfmt_misc megaraid_mm af_packet rfcomm l2cap bluetooth ppdev acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative wmi video output sbs sbshc pci_slot dock battery ipv6 bridge stp iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop parport_pc psmouse parport e1000e pcspkr iTCO_wdt container iTCO_vendor_support shpchp pci_hotplug button evdev usb_storage xfs libusual ses enclosure sd_mod crc_t10dif sg ehci_hcd uhci_hcd floppy megaraid_sas scsi_mod usbcore dm_mirror dm_log dm_snapshot dm_mod thermal processor fan thermal_sys fuse
[1028055.206915] Pid: 8072, comm: console-kit-dae Not tainted 2.6.27.8 #1
[1028055.206915] RIP: 0010:[<ffffffff802e502c>]  [<ffffffff802e502c>] pin_to_kill+0x7c/0x120
[1028055.206915] RSP: 0018:ffff88022892fb88  EFLAGS: 00000202
[1028055.211254] RAX: 0000000000000001 RBX: ffff8802270a5a20 RCX: 0000000000000003
[1028055.211254] RDX: 0000000000000000 RSI: ffff88022f26c0e0 RDI: ffff8802270a5a40
[1028055.211254] RBP: ffffffff80322540 R08: 0000000000000000 R09: 00000000ffffffff
[1028055.211254] R10: 0000000000000001 R11: ffffffff80322540 R12: ffffffff8074ba20
[1028055.211254] R13: ffff88022f065550 R14: ffff88022397c830 R15: ffffffff80239138
[1028055.211254] FS:  00007fe1dd18e780(0000) GS:ffffffff8064ca80(0000) knlGS:0000000000000000
[1028055.211254] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[1028055.211254] CR2: 00007fffec481108 CR3: 00000000c1555000 CR4: 00000000000026e0
[1028055.211254] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[1028055.211254] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[1028055.211254] 
[1028055.211254] Call Trace:
[1028055.211254]  [<ffffffff802e5019>] ? pin_to_kill+0x69/0x120
[1028055.211254]  [<ffffffff802e5a1c>] ? inotify_destroy+0x3c/0xe0
[1028055.211254]  [<ffffffff802e6073>] ? inotify_release+0x23/0xb0
[1028055.211254]  [<ffffffff802b6b21>] ? __fput+0xb1/0x1d0
[1028055.211254]  [<ffffffff802b3a74>] ? filp_close+0x54/0x90
[1028055.211254]  [<ffffffff8023dfc1>] ? put_files_struct+0xb1/0xd0
[1028055.211254]  [<ffffffff8023f55d>] ? do_exit+0x19d/0x970
[1028055.211254]  [<ffffffff80247af5>] ? __dequeue_signal+0x115/0x160
[1028055.211254]  [<ffffffff8023fd63>] ? do_group_exit+0x33/0x90
[1028055.211254]  [<ffffffff80249f58>] ? get_signal_to_deliver+0x178/0x340
[1028055.211254]  [<ffffffff8020b4f0>] ? do_notify_resume+0xa0/0x920
[1028055.211254]  [<ffffffff8022ecdf>] ? task_rq_lock+0x4f/0xa0
[1028055.211254]  [<ffffffff80233b40>] ? try_to_wake_up+0xf0/0x1c0
[1028055.211254]  [<ffffffff8022ed85>] ? __dequeue_entity+0x55/0x80
[1028055.211254]  [<ffffffff8022f335>] ? pick_next_task_fair+0xa5/0xc0
[1028055.211254]  [<ffffffff804872b2>] ? do_page_fault+0x772/0x830
[1028055.211254]  [<ffffffff804872b2>] ? do_page_fault+0x772/0x830
[1028055.211254]  [<ffffffff8020c938>] ? retint_signal+0x3d/0x75
[1028055.211254] 
[1028120.689987] BUG: soft lockup - CPU#0 stuck for 61s! [console-kit-dae:8072]
[1028120.704127] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat kvm_intel kvm tun ipt_LOG xt_hashlimit xt_limit xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip6table_filter ip6_tables autofs4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs md_mod binfmt_misc megaraid_mm af_packet rfcomm l2cap bluetooth ppdev acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative wmi video output sbs sbshc pci_slot dock battery ipv6 bridge stp iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop parport_pc psmouse parport e1000e pcspkr iTCO_wdt container iTCO_vendor_support shpchp pci_hotplug button evdev usb_storage xfs libusual ses enclosure sd_mod crc_t10dif sg ehci_hcd uhci_hcd floppy megaraid_sas scsi_mod usbcore dm_mirror dm_log dm_snapshot dm_mod thermal processor fan thermal_sys fuse
[1028120.704127] CPU 0:
[1028120.704127] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat kvm_intel kvm tun ipt_LOG xt_hashlimit xt_limit xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip6table_filter ip6_tables autofs4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs md_mod binfmt_misc megaraid_mm af_packet rfcomm l2cap bluetooth ppdev acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative wmi video output sbs sbshc pci_slot dock battery ipv6 bridge stp iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop parport_pc psmouse parport e1000e pcspkr iTCO_wdt container iTCO_vendor_support shpchp pci_hotplug button evdev usb_storage xfs libusual ses enclosure sd_mod crc_t10dif sg ehci_hcd uhci_hcd floppy megaraid_sas scsi_mod usbcore dm_mirror dm_log dm_snapshot dm_mod thermal processor fan thermal_sys fuse
[1028120.704127] Pid: 8072, comm: console-kit-dae Not tainted 2.6.27.8 #1
[1028120.704127] RIP: 0010:[<ffffffff80483543>]  [<ffffffff80483543>] mutex_lock+0x3/0x10
[1028120.704127] RSP: 0018:ffff88022892fbb0  EFLAGS: 00000246
[1028120.704127] RAX: 0000000000000000 RBX: ffff8802270a5a20 RCX: 0000000000000003
[1028120.704127] RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffff8802270a5a40
[1028120.704127] RBP: 0000000040000000 R08: 0000000000000000 R09: 00000000ffffffff
[1028120.704127] R10: 0000000000000001 R11: ffffffff80322540 R12: 0000000000000000
[1028120.704127] R13: 00000000ffffffff R14: 0000000000000001 R15: ffffffff80322540
[1028120.704127] FS:  00007fe1dd18e780(0000) GS:ffffffff8064ca80(0000) knlGS:0000000000000000
[1028120.704127] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[1028120.704127] CR2: 00007fffec481108 CR3: 00000000c1555000 CR4: 00000000000026e0
[1028120.704127] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[1028120.704127] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[1028120.704127] 
[1028120.704127] Call Trace:
[1028120.704127]  [<ffffffff802e5a08>] ? inotify_destroy+0x28/0xe0
[1028120.704127]  [<ffffffff802e6073>] ? inotify_release+0x23/0xb0
[1028120.704127]  [<ffffffff802b6b21>] ? __fput+0xb1/0x1d0
[1028120.704127]  [<ffffffff802b3a74>] ? filp_close+0x54/0x90
[1028120.704127]  [<ffffffff8023dfc1>] ? put_files_struct+0xb1/0xd0
[1028120.704127]  [<ffffffff8023f55d>] ? do_exit+0x19d/0x970
[1028120.704127]  [<ffffffff80247af5>] ? __dequeue_signal+0x115/0x160
[1028120.704127]  [<ffffffff8023fd63>] ? do_group_exit+0x33/0x90
[1028120.704127]  [<ffffffff80249f58>] ? get_signal_to_deliver+0x178/0x340
[1028120.704127]  [<ffffffff8020b4f0>] ? do_notify_resume+0xa0/0x920
[1028120.704127]  [<ffffffff8022ecdf>] ? task_rq_lock+0x4f/0xa0
[1028120.704127]  [<ffffffff80233b40>] ? try_to_wake_up+0xf0/0x1c0
[1028120.704127]  [<ffffffff8022ed85>] ? __dequeue_entity+0x55/0x80
[1028120.704127]  [<ffffffff8022f335>] ? pick_next_task_fair+0xa5/0xc0
[1028120.704127]  [<ffffffff804872b2>] ? do_page_fault+0x772/0x830
[1028120.704127]  [<ffffffff804872b2>] ? do_page_fault+0x772/0x830
[1028120.704127]  [<ffffffff8020c938>] ? retint_signal+0x3d/0x75
[1028120.704127] 
[1028208.733737] BUG: soft lockup - CPU#3 stuck for 61s! [console-kit-dae:8072]
[1028208.752504] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat kvm_intel kvm tun ipt_LOG xt_hashlimit xt_limit xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip6table_filter ip6_tables autofs4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs md_mod binfmt_misc megaraid_mm af_packet rfcomm l2cap bluetooth ppdev acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative wmi video output sbs sbshc pci_slot dock battery ipv6 bridge stp iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop parport_pc psmouse parport e1000e pcspkr iTCO_wdt container iTCO_vendor_support shpchp pci_hotplug button evdev usb_storage xfs libusual ses enclosure sd_mod crc_t10dif sg ehci_hcd uhci_hcd floppy megaraid_sas scsi_mod usbcore dm_mirror dm_log dm_snapshot dm_mod thermal processor fan thermal_sys fuse
[1028208.752504] CPU 3:
[1028208.752504] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat kvm_intel kvm tun ipt_LOG xt_hashlimit xt_limit xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip6table_filter ip6_tables autofs4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs md_mod binfmt_misc megaraid_mm af_packet rfcomm l2cap bluetooth ppdev acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative wmi video output sbs sbshc pci_slot dock battery ipv6 bridge stp iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop parport_pc psmouse parport e1000e pcspkr iTCO_wdt container iTCO_vendor_support shpchp pci_hotplug button evdev usb_storage xfs libusual ses enclosure sd_mod crc_t10dif sg ehci_hcd uhci_hcd floppy megaraid_sas scsi_mod usbcore dm_mirror dm_log dm_snapshot dm_mod thermal processor fan thermal_sys fuse
[1028208.752504] Pid: 8072, comm: console-kit-dae Not tainted 2.6.27.8 #1
[1028208.752504] RIP: 0010:[<ffffffff8035492a>]  [<ffffffff8035492a>] _atomic_dec_and_lock+0x2a/0x70
[1028208.752504] RSP: 0018:ffff88022892fb78  EFLAGS: 00000246
[1028208.752504] RAX: 0000000000000003 RBX: ffffffff8074ba20 RCX: 0000000000000003
[1028208.752504] RDX: 0000000000000003 RSI: 0000000000000002 RDI: ffff88022389e0ac
[1028208.752504] RBP: ffff88022f060d20 R08: 0000000000000000 R09: 0000000000000000
[1028208.752504] R10: 0000000000000001 R11: ffffffff803226d0 R12: ffff88022397c830
[1028208.752504] R13: 0000000000000001 R14: ffff880028068b80 R15: ffff88022892fb00
[1028208.752504] FS:  00007fe1dd18e780(0000) GS:ffff88022f054080(0000) knlGS:0000000000000000
[1028208.752504] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[1028208.752504] CR2: 000000000061a9e8 CR3: 00000000c1521000 CR4: 00000000000026e0
[1028208.752504] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[1028208.752504] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[1028208.752504] 
[1028208.752504] Call Trace:
[1028208.752504]  [<ffffffff802b7c30>] ? deactivate_super+0x20/0x80
[1028208.752504]  [<ffffffff802e5a7c>] ? inotify_destroy+0x9c/0xe0
[1028208.752504]  [<ffffffff802e6073>] ? inotify_release+0x23/0xb0
[1028208.752504]  [<ffffffff802b6b21>] ? __fput+0xb1/0x1d0
[1028208.752504]  [<ffffffff802b3a74>] ? filp_close+0x54/0x90
[1028208.752504]  [<ffffffff8023dfc1>] ? put_files_struct+0xb1/0xd0
[1028208.752504]  [<ffffffff8023f55d>] ? do_exit+0x19d/0x970
[1028208.752504]  [<ffffffff80247af5>] ? __dequeue_signal+0x115/0x160
[1028208.752504]  [<ffffffff8023fd63>] ? do_group_exit+0x33/0x90
[1028208.752504]  [<ffffffff80249f58>] ? get_signal_to_deliver+0x178/0x340
[1028208.752504]  [<ffffffff8020b4f0>] ? do_notify_resume+0xa0/0x920
[1028208.752504]  [<ffffffff8022ecdf>] ? task_rq_lock+0x4f/0xa0
[1028208.752504]  [<ffffffff80233b40>] ? try_to_wake_up+0xf0/0x1c0
[1028208.752504]  [<ffffffff8022ed85>] ? __dequeue_entity+0x55/0x80
[1028208.752504]  [<ffffffff8022f335>] ? pick_next_task_fair+0xa5/0xc0
[1028208.752504]  [<ffffffff804872b2>] ? do_page_fault+0x772/0x830
[1028208.752504]  [<ffffffff804872b2>] ? do_page_fault+0x772/0x830
[1028208.752504]  [<ffffffff8020c938>] ? retint_signal+0x3d/0x75
[1028208.752504] 
[1028274.233736] BUG: soft lockup - CPU#3 stuck for 61s! [console-kit-dae:8072]
[1028274.252505] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat kvm_intel kvm tun ipt_LOG xt_hashlimit xt_limit xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip6table_filter ip6_tables autofs4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs md_mod binfmt_misc megaraid_mm af_packet rfcomm l2cap bluetooth ppdev acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative wmi video output sbs sbshc pci_slot dock battery ipv6 bridge stp iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop parport_pc psmouse parport e1000e pcspkr iTCO_wdt container iTCO_vendor_support shpchp pci_hotplug button evdev usb_storage xfs libusual ses enclosure sd_mod crc_t10dif sg ehci_hcd uhci_hcd floppy megaraid_sas scsi_mod usbcore dm_mirror dm_log dm_snapshot dm_mod thermal processor fan thermal_sys fuse
[1028274.252505] CPU 3:
[1028274.252505] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat kvm_intel kvm tun ipt_LOG xt_hashlimit xt_limit xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip6table_filter ip6_tables autofs4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs md_mod binfmt_misc megaraid_mm af_packet rfcomm l2cap bluetooth ppdev acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative wmi video output sbs sbshc pci_slot dock battery ipv6 bridge stp iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop parport_pc psmouse parport e1000e pcspkr iTCO_wdt container iTCO_vendor_support shpchp pci_hotplug button evdev usb_storage xfs libusual ses enclosure sd_mod crc_t10dif sg ehci_hcd uhci_hcd floppy megaraid_sas scsi_mod usbcore dm_mirror dm_log dm_snapshot dm_mod thermal processor fan thermal_sys fuse
[1028274.252505] Pid: 8072, comm: console-kit-dae Not tainted 2.6.27.8 #1
[1028274.252505] RIP: 0010:[<ffffffff802e5001>]  [<ffffffff802e5001>] pin_to_kill+0x51/0x120
[1028274.252505] RSP: 0018:ffff88022892fb88  EFLAGS: 00000206
[1028274.252505] RAX: 0000000040000000 RBX: ffff88022f26c0e0 RCX: 0000000000000003
[1028274.252505] RDX: 0000000000000000 RSI: ffff88022f26c0e0 RDI: ffffffff8074ba20
[1028274.252505] RBP: ffffffff803226d0 R08: 0000000000000000 R09: 0000000000000000
[1028274.252505] R10: 0000000000000001 R11: ffffffff803226d0 R12: ffffffff8074ba20
[1028274.252505] R13: ffff88022f060d20 R14: ffff88022397c830 R15: 0000000000000001
[1028274.252505] FS:  00007fe1dd18e780(0000) GS:ffff88022f054080(0000) knlGS:0000000000000000
[1028274.252505] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[1028274.252505] CR2: 000000000061a9e8 CR3: 00000000c1521000 CR4: 00000000000026e0
[1028274.252505] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[1028274.252505] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[1028274.252505] 
[1028274.252505] Call Trace:
[1028274.252505]  [<ffffffff802e4fed>] ? pin_to_kill+0x3d/0x120
[1028274.252505]  [<ffffffff802e5a1c>] ? inotify_destroy+0x3c/0xe0
[1028274.252505]  [<ffffffff802e6073>] ? inotify_release+0x23/0xb0
[1028274.252505]  [<ffffffff802b6b21>] ? __fput+0xb1/0x1d0
[1028274.252505]  [<ffffffff802b3a74>] ? filp_close+0x54/0x90
[1028274.252505]  [<ffffffff8023dfc1>] ? put_files_struct+0xb1/0xd0
[1028274.252505]  [<ffffffff8023f55d>] ? do_exit+0x19d/0x970
[1028274.252505]  [<ffffffff80247af5>] ? __dequeue_signal+0x115/0x160
[1028274.252505]  [<ffffffff8023fd63>] ? do_group_exit+0x33/0x90
[1028274.252505]  [<ffffffff80249f58>] ? get_signal_to_deliver+0x178/0x340
[1028274.252505]  [<ffffffff8020b4f0>] ? do_notify_resume+0xa0/0x920
[1028274.252505]  [<ffffffff8022ecdf>] ? task_rq_lock+0x4f/0xa0
[1028274.252505]  [<ffffffff80233b40>] ? try_to_wake_up+0xf0/0x1c0
[1028274.252505]  [<ffffffff8022ed85>] ? __dequeue_entity+0x55/0x80
[1028274.252505]  [<ffffffff8022f335>] ? pick_next_task_fair+0xa5/0xc0
[1028274.252505]  [<ffffffff804872b2>] ? do_page_fault+0x772/0x830
[1028274.252505]  [<ffffffff804872b2>] ? do_page_fault+0x772/0x830
[1028274.252505]  [<ffffffff8020c938>] ? retint_signal+0x3d/0x75
[1028274.252505] 
[1028398.781237] BUG: soft lockup - CPU#1 stuck for 61s! [console-kit-dae:8072]
[1028398.800004] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat kvm_intel kvm tun ipt_LOG xt_hashlimit xt_limit xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip6table_filter ip6_tables autofs4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs md_mod binfmt_misc megaraid_mm af_packet rfcomm l2cap bluetooth ppdev acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative wmi video output sbs sbshc pci_slot dock battery ipv6 bridge stp iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop parport_pc psmouse parport e1000e pcspkr iTCO_wdt container iTCO_vendor_support shpchp pci_hotplug button evdev usb_storage xfs libusual ses enclosure sd_mod crc_t10dif sg ehci_hcd uhci_hcd floppy megaraid_sas scsi_mod usbcore dm_mirror dm_log dm_snapshot dm_mod thermal processor fan thermal_sys fuse
[1028398.800004] CPU 1:
[1028398.800004] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat kvm_intel kvm tun ipt_LOG xt_hashlimit xt_limit xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip6table_filter ip6_tables autofs4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs md_mod binfmt_misc megaraid_mm af_packet rfcomm l2cap bluetooth ppdev acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative wmi video output sbs sbshc pci_slot dock battery ipv6 bridge stp iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop parport_pc psmouse parport e1000e pcspkr iTCO_wdt container iTCO_vendor_support shpchp pci_hotplug button evdev usb_storage xfs libusual ses enclosure sd_mod crc_t10dif sg ehci_hcd uhci_hcd floppy megaraid_sas scsi_mod usbcore dm_mirror dm_log dm_snapshot dm_mod thermal processor fan thermal_sys fuse
[1028398.800004] Pid: 8072, comm: console-kit-dae Not tainted 2.6.27.8 #1
[1028398.800004] RIP: 0010:[<ffffffff802e5a69>]  [<ffffffff802e5a69>] inotify_destroy+0x89/0xe0
[1028398.800004] RSP: 0018:ffff88022892fbb8  EFLAGS: 00000202
[1028398.800004] RAX: 0000000000000000 RBX: ffff8802270a5a20 RCX: 0000000000000006
[1028398.800004] RDX: ffff88022c9a3810 RSI: 0000000000000081 RDI: ffff8802270a5a40
[1028398.800004] RBP: 0000000040000000 R08: 0000000000000000 R09: fefefefefefefeff
[1028398.800004] R10: 0000000000000001 R11: ffffffff80322540 R12: 0000000000000000
[1028398.800004] R13: fefefefefefefeff R14: 0000000000000001 R15: ffffffff80322540
[1028398.802507] FS:  00007fe1dd18e780(0000) GS:ffff88022fc02980(0000) knlGS:0000000000000000
[1028398.802507] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[1028398.802507] CR2: 00007f0a8a75b0b6 CR3: 00000000c1521000 CR4: 00000000000026e0
[1028398.802507] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[1028398.802507] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[1028398.802507] 
[1028398.802507] Call Trace:
[1028398.802507]  [<ffffffff802e5a69>] ? inotify_destroy+0x89/0xe0
[1028398.802507]  [<ffffffff802e6073>] ? inotify_release+0x23/0xb0
[1028398.802507]  [<ffffffff802b6b21>] ? __fput+0xb1/0x1d0
[1028398.802507]  [<ffffffff802b3a74>] ? filp_close+0x54/0x90
[1028398.802507]  [<ffffffff8023dfc1>] ? put_files_struct+0xb1/0xd0
[1028398.802507]  [<ffffffff8023f55d>] ? do_exit+0x19d/0x970
[1028398.802507]  [<ffffffff80247af5>] ? __dequeue_signal+0x115/0x160
[1028398.802507]  [<ffffffff8023fd63>] ? do_group_exit+0x33/0x90
[1028398.802507]  [<ffffffff80249f58>] ? get_signal_to_deliver+0x178/0x340
[1028398.802507]  [<ffffffff8020b4f0>] ? do_notify_resume+0xa0/0x920
[1028398.802507]  [<ffffffff8022ecdf>] ? task_rq_lock+0x4f/0xa0
[1028398.802507]  [<ffffffff80233b40>] ? try_to_wake_up+0xf0/0x1c0
[1028398.802507]  [<ffffffff8022ed85>] ? __dequeue_entity+0x55/0x80
[1028398.802507]  [<ffffffff8022f335>] ? pick_next_task_fair+0xa5/0xc0
[1028398.802507]  [<ffffffff804872b2>] ? do_page_fault+0x772/0x830
[1028398.802507]  [<ffffffff804872b2>] ? do_page_fault+0x772/0x830
[1028398.802507]  [<ffffffff8020c938>] ? retint_signal+0x3d/0x75
[1028398.802507] 
[1028464.281237] BUG: soft lockup - CPU#1 stuck for 61s! [console-kit-dae:8072]
[1028464.300005] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat kvm_intel kvm tun ipt_LOG xt_hashlimit xt_limit xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip6table_filter ip6_tables autofs4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs md_mod binfmt_misc megaraid_mm af_packet rfcomm l2cap bluetooth ppdev acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative wmi video output sbs sbshc pci_slot dock battery ipv6 bridge stp iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop parport_pc psmouse parport e1000e pcspkr iTCO_wdt container iTCO_vendor_support shpchp pci_hotplug button evdev usb_storage xfs libusual ses enclosure sd_mod crc_t10dif sg ehci_hcd uhci_hcd floppy megaraid_sas scsi_mod usbcore dm_mirror dm_log dm_snapshot dm_mod thermal processor fan thermal_sys fuse
[1028464.300005] CPU 1:
[1028464.300005] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat kvm_intel kvm tun ipt_LOG xt_hashlimit xt_limit xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip6table_filter ip6_tables autofs4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs md_mod binfmt_misc megaraid_mm af_packet rfcomm l2cap bluetooth ppdev acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative wmi video output sbs sbshc pci_slot dock battery ipv6 bridge stp iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop parport_pc psmouse parport e1000e pcspkr iTCO_wdt container iTCO_vendor_support shpchp pci_hotplug button evdev usb_storage xfs libusual ses enclosure sd_mod crc_t10dif sg ehci_hcd uhci_hcd floppy megaraid_sas scsi_mod usbcore dm_mirror dm_log dm_snapshot dm_mod thermal processor fan thermal_sys fuse
[1028464.300005] Pid: 8072, comm: console-kit-dae Not tainted 2.6.27.8 #1
[1028464.300005] RIP: 0010:[<ffffffff80354938>]  [<ffffffff80354938>] _atomic_dec_and_lock+0x38/0x70
[1028464.300005] RSP: 0018:ffff88022892fb88  EFLAGS: 00000292
[1028464.300005] RAX: 0000000000000000 RBX: ffffffff8074ba20 RCX: 0000000000000003
[1028464.300005] RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffff88022389e0ac
[1028464.300005] RBP: ffffffff80322540 R08: 0000000000000000 R09: fefefefefefefeff
[1028464.300005] R10: 0000000000000001 R11: ffffffff80322540 R12: ffffffff8074ba20
[1028464.302507] R13: ffff88022f061a40 R14: ffff88022397c830 R15: 0000000000000001
[1028464.302507] FS:  00007fe1dd18e780(0000) GS:ffff88022fc02980(0000) knlGS:0000000000000000
[1028464.302507] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[1028464.302507] CR2: 00007f0a8a75b0b6 CR3: 00000000c1521000 CR4: 00000000000026e0
[1028464.302507] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[1028464.302507] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[1028464.302507] 
[1028464.302507] Call Trace:
[1028464.302507]  [<ffffffff802b7c30>] ? deactivate_super+0x20/0x80
[1028464.302507]  [<ffffffff802e5a7c>] ? inotify_destroy+0x9c/0xe0
[1028464.302507]  [<ffffffff802e6073>] ? inotify_release+0x23/0xb0
[1028464.302507]  [<ffffffff802b6b21>] ? __fput+0xb1/0x1d0
[1028464.302507]  [<ffffffff802b3a74>] ? filp_close+0x54/0x90
[1028464.302507]  [<ffffffff8023dfc1>] ? put_files_struct+0xb1/0xd0
[1028464.302507]  [<ffffffff8023f55d>] ? do_exit+0x19d/0x970
[1028464.302507]  [<ffffffff80247af5>] ? __dequeue_signal+0x115/0x160
[1028464.302507]  [<ffffffff8023fd63>] ? do_group_exit+0x33/0x90
[1028464.302507]  [<ffffffff80249f58>] ? get_signal_to_deliver+0x178/0x340
[1028464.302507]  [<ffffffff8020b4f0>] ? do_notify_resume+0xa0/0x920
[1028464.302507]  [<ffffffff8022ecdf>] ? task_rq_lock+0x4f/0xa0
[1028464.302507]  [<ffffffff80233b40>] ? try_to_wake_up+0xf0/0x1c0
[1028464.302507]  [<ffffffff8022ed85>] ? __dequeue_entity+0x55/0x80
[1028464.302507]  [<ffffffff8022f335>] ? pick_next_task_fair+0xa5/0xc0
[1028464.302507]  [<ffffffff804872b2>] ? do_page_fault+0x772/0x830
[1028464.302507]  [<ffffffff804872b2>] ? do_page_fault+0x772/0x830
[1028464.302507]  [<ffffffff8020c938>] ? retint_signal+0x3d/0x75
[1028464.302507] 
[1028574.879988] BUG: soft lockup - CPU#0 stuck for 61s! [console-kit-dae:8072]
[1028574.892515] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat kvm_intel kvm tun ipt_LOG xt_hashlimit xt_limit xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip6table_filter ip6_tables autofs4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs md_mod binfmt_misc megaraid_mm af_packet rfcomm l2cap bluetooth ppdev acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative wmi video output sbs sbshc pci_slot dock battery ipv6 bridge stp iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop parport_pc psmouse parport e1000e pcspkr iTCO_wdt container iTCO_vendor_support shpchp pci_hotplug button evdev usb_storage xfs libusual ses enclosure sd_mod crc_t10dif sg ehci_hcd uhci_hcd floppy megaraid_sas scsi_mod usbcore dm_mirror dm_log dm_snapshot dm_mod thermal processor fan thermal_sys fuse
[1028574.892515] CPU 0:
[1028574.892515] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat kvm_intel kvm tun ipt_LOG xt_hashlimit xt_limit xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip6table_filter ip6_tables autofs4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs md_mod binfmt_misc megaraid_mm af_packet rfcomm l2cap bluetooth ppdev acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative wmi video output sbs sbshc pci_slot dock battery ipv6 bridge stp iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop parport_pc psmouse parport e1000e pcspkr iTCO_wdt container iTCO_vendor_support shpchp pci_hotplug button evdev usb_storage xfs libusual ses enclosure sd_mod crc_t10dif sg ehci_hcd uhci_hcd floppy megaraid_sas scsi_mod usbcore dm_mirror dm_log dm_snapshot dm_mod thermal processor fan thermal_sys fuse
[1028574.892515] Pid: 8072, comm: console-kit-dae Not tainted 2.6.27.8 #1
[1028574.892515] RIP: 0010:[<ffffffff8048470a>]  [<ffffffff8048470a>] _spin_lock+0xa/0x20
[1028574.892515] RSP: 0018:ffff88022892fb80  EFLAGS: 00000206
[1028574.892515] RAX: 0000000000000909 RBX: ffff88022f26c0e0 RCX: 0000000000000003
[1028574.892515] RDX: 0000000000000000 RSI: ffff88022f26c0e0 RDI: ffffffff8074ba20
[1028574.892515] RBP: ffffffffa0147ec0 R08: 0000000000000000 R09: 00007882e11d36e2
[1028574.892515] R10: 0000000000000001 R11: ffffffffa0147ec0 R12: ffffffff8074ba20
[1028574.892515] R13: ffff88022f130690 R14: ffff88022397c830 R15: ffff88022892fb00
[1028574.892515] FS:  00007fe1dd18e780(0000) GS:ffffffff8064ca80(0000) knlGS:0000000000000000
[1028574.892515] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[1028574.892515] CR2: 00007f0060841000 CR3: 00000001f7de9000 CR4: 00000000000026e0
[1028574.892515] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[1028574.892515] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[1028574.892515] 
[1028574.892515] Call Trace:
[1028574.892515]  [<ffffffff802e4fed>] ? pin_to_kill+0x3d/0x120
[1028574.892515]  [<ffffffff802e5a1c>] ? inotify_destroy+0x3c/0xe0
[1028574.892515]  [<ffffffff802e6073>] ? inotify_release+0x23/0xb0
[1028574.892515]  [<ffffffff802b6b21>] ? __fput+0xb1/0x1d0
[1028574.892515]  [<ffffffff802b3a74>] ? filp_close+0x54/0x90
[1028574.892515]  [<ffffffff8023dfc1>] ? put_files_struct+0xb1/0xd0
[1028574.892515]  [<ffffffff8023f55d>] ? do_exit+0x19d/0x970
[1028574.892515]  [<ffffffff80247af5>] ? __dequeue_signal+0x115/0x160
[1028574.892515]  [<ffffffff8023fd63>] ? do_group_exit+0x33/0x90
[1028574.892515]  [<ffffffff80249f58>] ? get_signal_to_deliver+0x178/0x340
[1028574.892515]  [<ffffffff8020b4f0>] ? do_notify_resume+0xa0/0x920
[1028574.892515]  [<ffffffff8022ecdf>] ? task_rq_lock+0x4f/0xa0
[1028574.892515]  [<ffffffff80233b40>] ? try_to_wake_up+0xf0/0x1c0
[1028574.892515]  [<ffffffff8022ed85>] ? __dequeue_entity+0x55/0x80
[1028574.892515]  [<ffffffff8022f335>] ? pick_next_task_fair+0xa5/0xc0
[1028574.892515]  [<ffffffff804872b2>] ? do_page_fault+0x772/0x830
[1028574.892515]  [<ffffffff804872b2>] ? do_page_fault+0x772/0x830
[1028574.892515]  [<ffffffff8020c938>] ? retint_signal+0x3d/0x75
[1028574.892515] 
[1028640.379988] BUG: soft lockup - CPU#0 stuck for 61s! [console-kit-dae:8072]
[1028640.392516] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat kvm_intel kvm tun ipt_LOG xt_hashlimit xt_limit xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip6table_filter ip6_tables autofs4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs md_mod binfmt_misc megaraid_mm af_packet rfcomm l2cap bluetooth ppdev acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative wmi video output sbs sbshc pci_slot dock battery ipv6 bridge stp iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop parport_pc psmouse parport e1000e pcspkr iTCO_wdt container iTCO_vendor_support shpchp pci_hotplug button evdev usb_storage xfs libusual ses enclosure sd_mod crc_t10dif sg ehci_hcd uhci_hcd floppy megaraid_sas scsi_mod usbcore dm_mirror dm_log dm_snapshot dm_mod thermal processor fan thermal_sys fuse
[1028640.392516] CPU 0:
[1028640.392516] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat kvm_intel kvm tun ipt_LOG xt_hashlimit xt_limit xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip6table_filter ip6_tables autofs4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs md_mod binfmt_misc megaraid_mm af_packet rfcomm l2cap bluetooth ppdev acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative wmi video output sbs sbshc pci_slot dock battery ipv6 bridge stp iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop parport_pc psmouse parport e1000e pcspkr iTCO_wdt container iTCO_vendor_support shpchp pci_hotplug button evdev usb_storage xfs libusual ses enclosure sd_mod crc_t10dif sg ehci_hcd uhci_hcd floppy megaraid_sas scsi_mod usbcore dm_mirror dm_log dm_snapshot dm_mod thermal processor fan thermal_sys fuse
[1028640.392516] Pid: 8072, comm: console-kit-dae Not tainted 2.6.27.8 #1
[1028640.392516] RIP: 0010:[<ffffffff80483553>]  [<ffffffff80483553>] mutex_unlock+0x3/0x10
[1028640.392516] RSP: 0018:ffff88022892fbb0  EFLAGS: 00000202
[1028640.392516] RAX: 0000000000000000 RBX: ffff8802270a5a20 RCX: 0000000000000006
[1028640.392516] RDX: ffff88022c9a3810 RSI: 0000000000000081 RDI: ffff880222890428
[1028640.392516] RBP: 0000000000000707 R08: 0000000000000000 R09: 00007882e11d36e2
[1028640.392516] R10: 0000000000000001 R11: ffffffffa0147ec0 R12: 0000000000000000
[1028640.392516] R13: 00007882e11d36e2 R14: 0000000000000001 R15: ffffffffa0147ec0
[1028640.392516] FS:  00007fe1dd18e780(0000) GS:ffffffff8064ca80(0000) knlGS:0000000000000000
[1028640.392516] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[1028640.392516] CR2: 00007f0060841000 CR3: 00000001f7de9000 CR4: 00000000000026e0
[1028640.392516] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[1028640.392516] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[1028640.392516] 
[1028640.392516] Call Trace:
[1028640.392516]  [<ffffffff802e5a71>] ? inotify_destroy+0x91/0xe0
[1028640.392516]  [<ffffffff802e6073>] ? inotify_release+0x23/0xb0
[1028640.392516]  [<ffffffff802b6b21>] ? __fput+0xb1/0x1d0
[1028640.392516]  [<ffffffff802b3a74>] ? filp_close+0x54/0x90
[1028640.392516]  [<ffffffff8023dfc1>] ? put_files_struct+0xb1/0xd0
[1028640.392516]  [<ffffffff8023f55d>] ? do_exit+0x19d/0x970
[1028640.392516]  [<ffffffff80247af5>] ? __dequeue_signal+0x115/0x160
[1028640.392516]  [<ffffffff8023fd63>] ? do_group_exit+0x33/0x90
[1028640.392516]  [<ffffffff80249f58>] ? get_signal_to_deliver+0x178/0x340
[1028640.392516]  [<ffffffff8020b4f0>] ? do_notify_resume+0xa0/0x920
[1028640.392516]  [<ffffffff8022ecdf>] ? task_rq_lock+0x4f/0xa0
[1028640.392516]  [<ffffffff80233b40>] ? try_to_wake_up+0xf0/0x1c0
[1028640.392516]  [<ffffffff8022ed85>] ? __dequeue_entity+0x55/0x80
[1028640.392516]  [<ffffffff8022f335>] ? pick_next_task_fair+0xa5/0xc0
[1028640.392516]  [<ffffffff804872b2>] ? do_page_fault+0x772/0x830
[1028640.392516]  [<ffffffff804872b2>] ? do_page_fault+0x772/0x830
[1028640.392516]  [<ffffffff8020c938>] ? retint_signal+0x3d/0x75
[1028640.392516] 
[1028749.902488] BUG: soft lockup - CPU#2 stuck for 61s! [console-kit-dae:8072]
[1028749.902502] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat kvm_intel kvm tun ipt_LOG xt_hashlimit xt_limit xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip6table_filter ip6_tables autofs4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs md_mod binfmt_misc megaraid_mm af_packet rfcomm l2cap bluetooth ppdev acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative wmi video output sbs sbshc pci_slot dock battery ipv6 bridge stp iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop parport_pc psmouse parport e1000e pcspkr iTCO_wdt container iTCO_vendor_support shpchp pci_hotplug button evdev usb_storage xfs libusual ses enclosure sd_mod crc_t10dif sg ehci_hcd uhci_hcd floppy megaraid_sas scsi_mod usbcore dm_mirror dm_log dm_snapshot dm_mod thermal processor fan thermal_sys fuse
[1028749.902502] CPU 2:
[1028749.902502] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat kvm_intel kvm tun ipt_LOG xt_hashlimit xt_limit xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip6table_filter ip6_tables autofs4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs md_mod binfmt_misc megaraid_mm af_packet rfcomm l2cap bluetooth ppdev acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative wmi video output sbs sbshc pci_slot dock battery ipv6 bridge stp iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop parport_pc psmouse parport e1000e pcspkr iTCO_wdt container iTCO_vendor_support shpchp pci_hotplug button evdev usb_storage xfs libusual ses enclosure sd_mod crc_t10dif sg ehci_hcd uhci_hcd floppy megaraid_sas scsi_mod usbcore dm_mirror dm_log dm_snapshot dm_mod thermal processor fan thermal_sys fuse
[1028749.902502] Pid: 8072, comm: console-kit-dae Not tainted 2.6.27.8 #1
[1028749.902502] RIP: 0010:[<ffffffff802e5a2e>]  [<ffffffff802e5a2e>] inotify_destroy+0x4e/0xe0
[1028749.902502] RSP: 0018:ffff88022892fbb8  EFLAGS: 00000286
[1028749.902502] RAX: 0000000000000001 RBX: ffff8802270a5a20 RCX: 0000000000000003
[1028749.902502] RDX: 0000000000000000 RSI: ffff88022f26c0e0 RDI: ffff8802270a5a40
[1028749.902502] RBP: 0000000040000000 R08: 0000000000000000 R09: 0000000000000001
[1028749.902502] R10: 0000000000000001 R11: ffffffff80322540 R12: 0000000000000000
[1028749.902502] R13: 0000000000000001 R14: 0000000000000001 R15: ffffffff80322540
[1028749.902502] FS:  00007fe1dd18e780(0000) GS:ffff88022fc02d00(0000) knlGS:0000000000000000
[1028749.902502] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[1028749.902502] CR2: 00007fc4540fe4a8 CR3: 000000006c851000 CR4: 00000000000026e0
[1028749.902502] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[1028749.902502] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[1028749.902502] 
[1028749.902502] Call Trace:
[1028749.902502]  [<ffffffff802e5a1c>] ? inotify_destroy+0x3c/0xe0
[1028749.902502]  [<ffffffff802e6073>] ? inotify_release+0x23/0xb0
[1028749.902502]  [<ffffffff802b6b21>] ? __fput+0xb1/0x1d0
[1028749.902502]  [<ffffffff802b3a74>] ? filp_close+0x54/0x90
[1028749.902502]  [<ffffffff8023dfc1>] ? put_files_struct+0xb1/0xd0
[1028749.902502]  [<ffffffff8023f55d>] ? do_exit+0x19d/0x970
[1028749.902502]  [<ffffffff80247af5>] ? __dequeue_signal+0x115/0x160
[1028749.902502]  [<ffffffff8023fd63>] ? do_group_exit+0x33/0x90
[1028749.902502]  [<ffffffff80249f58>] ? get_signal_to_deliver+0x178/0x340
[1028749.902502]  [<ffffffff8020b4f0>] ? do_notify_resume+0xa0/0x920
[1028749.902502]  [<ffffffff8022ecdf>] ? task_rq_lock+0x4f/0xa0
[1028749.902502]  [<ffffffff80233b40>] ? try_to_wake_up+0xf0/0x1c0
[1028749.902502]  [<ffffffff8022ed85>] ? __dequeue_entity+0x55/0x80
[1028749.902502]  [<ffffffff8022f335>] ? pick_next_task_fair+0xa5/0xc0
[1028749.902502]  [<ffffffff804872b2>] ? do_page_fault+0x772/0x830
[1028749.902502]  [<ffffffff804872b2>] ? do_page_fault+0x772/0x830
[1028749.902502]  [<ffffffff8020c938>] ? retint_signal+0x3d/0x75
[1028749.902502] 
[1028941.021237] BUG: soft lockup - CPU#1 stuck for 61s! [console-kit-dae:8072]
[1028941.040417] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat kvm_intel kvm tun ipt_LOG xt_hashlimit xt_limit xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip6table_filter ip6_tables autofs4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs md_mod binfmt_misc megaraid_mm af_packet rfcomm l2cap bluetooth ppdev acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative wmi video output sbs sbshc pci_slot dock battery ipv6 bridge stp iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop parport_pc psmouse parport e1000e pcspkr iTCO_wdt container iTCO_vendor_support shpchp pci_hotplug button evdev usb_storage xfs libusual ses enclosure sd_mod crc_t10dif sg ehci_hcd uhci_hcd floppy megaraid_sas scsi_mod usbcore dm_mirror dm_log dm_snapshot dm_mod thermal processor fan thermal_sys fuse
[1028941.040417] CPU 1:
[1028941.040417] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat kvm_intel kvm tun ipt_LOG xt_hashlimit xt_limit xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip6table_filter ip6_tables autofs4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs md_mod binfmt_misc megaraid_mm af_packet rfcomm l2cap bluetooth ppdev acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative wmi video output sbs sbshc pci_slot dock battery ipv6 bridge stp iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop parport_pc psmouse parport e1000e pcspkr iTCO_wdt container iTCO_vendor_support shpchp pci_hotplug button evdev usb_storage xfs libusual ses enclosure sd_mod crc_t10dif sg ehci_hcd uhci_hcd floppy megaraid_sas scsi_mod usbcore dm_mirror dm_log dm_snapshot dm_mod thermal processor fan thermal_sys fuse
[1028941.042510] Pid: 8072, comm: console-kit-dae Not tainted 2.6.27.8 #1
[1028941.042510] RIP: 0010:[<ffffffff80354908>]  [<ffffffff80354908>] _atomic_dec_and_lock+0x8/0x70
[1028941.042510] RSP: 0018:ffff88022892fb80  EFLAGS: 00000292
[1028941.042510] RAX: ffff880222890200 RBX: ffffffff8074ba20 RCX: 0000000000000006
[1028941.042510] RDX: ffff88022c9a3810 RSI: ffffffff8074ba20 RDI: ffff88022389e0ac
[1028941.042510] RBP: 0000000000000202 R08: 0000000000000000 R09: ffff880053a9fc88
[1028941.042510] R10: 0000000000000001 R11: 0000000000000202 R12: ffff88022389e000
[1028941.042510] R13: ffff88022f060d20 R14: ffff88022397c830 R15: ffffffff8022d4e6
[1028941.042510] FS:  00007fe1dd18e780(0000) GS:ffff88022fc02980(0000) knlGS:0000000000000000
[1028941.042510] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[1028941.042510] CR2: 00007f0060841000 CR3: 0000000000201000 CR4: 00000000000026e0
[1028941.042510] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[1028941.042510] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[1028941.042510] 
[1028941.042510] Call Trace:
[1028941.042510]  [<ffffffff802b7c30>] ? deactivate_super+0x20/0x80
[1028941.042510]  [<ffffffff802e5a7c>] ? inotify_destroy+0x9c/0xe0
[1028941.042510]  [<ffffffff802e6073>] ? inotify_release+0x23/0xb0
[1028941.042510]  [<ffffffff802b6b21>] ? __fput+0xb1/0x1d0
[1028941.042510]  [<ffffffff802b3a74>] ? filp_close+0x54/0x90
[1028941.042510]  [<ffffffff8023dfc1>] ? put_files_struct+0xb1/0xd0
[1028941.042510]  [<ffffffff8023f55d>] ? do_exit+0x19d/0x970
[1028941.042510]  [<ffffffff80247af5>] ? __dequeue_signal+0x115/0x160
[1028941.042510]  [<ffffffff8023fd63>] ? do_group_exit+0x33/0x90
[1028941.042510]  [<ffffffff80249f58>] ? get_signal_to_deliver+0x178/0x340
[1028941.042510]  [<ffffffff8020b4f0>] ? do_notify_resume+0xa0/0x920
[1028941.042510]  [<ffffffff8022ecdf>] ? task_rq_lock+0x4f/0xa0
[1028941.042510]  [<ffffffff80233b40>] ? try_to_wake_up+0xf0/0x1c0
[1028941.042510]  [<ffffffff8022ed85>] ? __dequeue_entity+0x55/0x80
[1028941.042510]  [<ffffffff8022f335>] ? pick_next_task_fair+0xa5/0xc0
[1028941.042510]  [<ffffffff804872b2>] ? do_page_fault+0x772/0x830
[1028941.042510]  [<ffffffff804872b2>] ? do_page_fault+0x772/0x830
[1028941.042510]  [<ffffffff8020c938>] ? retint_signal+0x3d/0x75
[1028941.042510] 
[1029006.521236] BUG: soft lockup - CPU#1 stuck for 61s! [console-kit-dae:8072]
[1029006.540005] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat kvm_intel kvm tun ipt_LOG xt_hashlimit xt_limit xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip6table_filter ip6_tables autofs4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs md_mod binfmt_misc megaraid_mm af_packet rfcomm l2cap bluetooth ppdev acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative wmi video output sbs sbshc pci_slot dock battery ipv6 bridge stp iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop parport_pc psmouse parport e1000e pcspkr iTCO_wdt container iTCO_vendor_support shpchp pci_hotplug button evdev usb_storage xfs libusual ses enclosure sd_mod crc_t10dif sg ehci_hcd uhci_hcd floppy megaraid_sas scsi_mod usbcore dm_mirror dm_log dm_snapshot dm_mod thermal processor fan thermal_sys fuse
[1029006.540005] CPU 1:
[1029006.540005] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat kvm_intel kvm tun ipt_LOG xt_hashlimit xt_limit xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip6table_filter ip6_tables autofs4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs md_mod binfmt_misc megaraid_mm af_packet rfcomm l2cap bluetooth ppdev acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative wmi video output sbs sbshc pci_slot dock battery ipv6 bridge stp iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop parport_pc psmouse parport e1000e pcspkr iTCO_wdt container iTCO_vendor_support shpchp pci_hotplug button evdev usb_storage xfs libusual ses enclosure sd_mod crc_t10dif sg ehci_hcd uhci_hcd floppy megaraid_sas scsi_mod usbcore dm_mirror dm_log dm_snapshot dm_mod thermal processor fan thermal_sys fuse
[1029006.540005] Pid: 8072, comm: console-kit-dae Not tainted 2.6.27.8 #1
[1029006.540005] RIP: 0010:[<ffffffff80483543>]  [<ffffffff80483543>] mutex_lock+0x3/0x10
[1029006.540005] RSP: 0018:ffff88022892fbb0  EFLAGS: 00000246
[1029006.540005] RAX: 0000000000000001 RBX: ffff8802270a5a20 RCX: 0000000000000003
[1029006.540005] RDX: 0000000000000000 RSI: ffff88022f26c0e0 RDI: ffff8802270a5a40
[1029006.540005] RBP: ffff880053a9fc88 R08: 0000000000000000 R09: ffff880053a9fc88
[1029006.540005] R10: 0000000000000001 R11: 0000000000000202 R12: 0000000000000001
[1029006.540005] R13: 0000000000000202 R14: ffff88022389e000 R15: ffff880053a9fc88
[1029006.540005] FS:  00007fe1dd18e780(0000) GS:ffff88022fc02980(0000) knlGS:0000000000000000
[1029006.540005] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[1029006.540005] CR2: 00007f0060841000 CR3: 0000000000201000 CR4: 00000000000026e0
[1029006.540005] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[1029006.540005] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[1029006.540005] 
[1029006.540005] Call Trace:
[1029006.540005]  [<ffffffff802e5a3e>] ? inotify_destroy+0x5e/0xe0
[1029006.540005]  [<ffffffff802e6073>] ? inotify_release+0x23/0xb0
[1029006.540005]  [<ffffffff802b6b21>] ? __fput+0xb1/0x1d0
[1029006.540005]  [<ffffffff802b3a74>] ? filp_close+0x54/0x90
[1029006.540005]  [<ffffffff8023dfc1>] ? put_files_struct+0xb1/0xd0
[1029006.540005]  [<ffffffff8023f55d>] ? do_exit+0x19d/0x970
[1029006.540005]  [<ffffffff80247af5>] ? __dequeue_signal+0x115/0x160
[1029006.540005]  [<ffffffff8023fd63>] ? do_group_exit+0x33/0x90
[1029006.540005]  [<ffffffff80249f58>] ? get_signal_to_deliver+0x178/0x340
[1029006.540005]  [<ffffffff8020b4f0>] ? do_notify_resume+0xa0/0x920
[1029006.540005]  [<ffffffff8022ecdf>] ? task_rq_lock+0x4f/0xa0
[1029006.540005]  [<ffffffff80233b40>] ? try_to_wake_up+0xf0/0x1c0
[1029006.540005]  [<ffffffff8022ed85>] ? __dequeue_entity+0x55/0x80
[1029006.540005]  [<ffffffff8022f335>] ? pick_next_task_fair+0xa5/0xc0
[1029006.540005]  [<ffffffff804872b2>] ? do_page_fault+0x772/0x830
[1029006.540005]  [<ffffffff804872b2>] ? do_page_fault+0x772/0x830
[1029006.540005]  [<ffffffff8020c938>] ? retint_signal+0x3d/0x75
[1029006.540005

Cheers,
/B

