Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562AbYFOXQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbYFOXQj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 19:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbYFOXQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 19:16:29 -0400
Received: from mailhub3.uq.edu.au ([130.102.148.131]:48163 "EHLO
	mailhub3.uq.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbYFOXQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 19:16:27 -0400
X-Greylist: delayed 554 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Jun 2008 19:16:26 EDT
Message-Id: <E109A827-1A6B-40AB-A0DE-CB713793E114@its.uq.edu.au>
From: Christian Unger <c.unger@its.uq.edu.au>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v924)
Subject: kernel:<3>Bug: soft lockup - CPU#3 stuck for 10s! [bond1:<pid>]
Date: Mon, 16 Jun 2008 09:07:09 +1000
X-Mailer: Apple Mail (2.924)
X-UQ-FilterTime: 1213571230
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello there

I'm getting two seemingly related issues. They are both reported as a  
soft lockup on CPU#3 ... Initially i didn't worry about it, because  
the two hosts affected by this were having other issues, but now that  
said other issues are resolved it's gotten worse (but most likely only  
because the cluster is failing for other reasons). On the off chance  
that the previous issue (which also involved bonding) is relevant i'll  
outline this also:

System configuration etc:
CentOS 5.2 current with Cluster Suite. I'm running a stack of RHEL  
systems so i'm updating all of them from the same repos (so there is  
the first ugliness). The systems are Dell PowerEdge 1950s with on  
board broadcom's and expansion intel NICs.

`uname -r` gives: 2.6.18-92.1.1.el5 (which is the Red Hat kernel  
package current today, but it has been happening on various kernel  
versions for month).

The error message indicates that the bnx2 module does not taint the  
kernel, and overall the kernel is not tainted:
`cat /proc/sys/kernel/tainted` gives:
0

The `lspci` is as follows:
00:00.0 Host bridge: Intel Corporation 5000X Chipset Memory Controller  
Hub (rev 12)
00:02.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express  
x4 Port 2 (rev 12)
00:03.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express  
x4 Port 3 (rev 12)
00:04.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express  
x8 Port 4-5 (rev 12)
00:05.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express  
x4 Port 5 (rev 12)
00:06.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express  
x8 Port 6-7 (rev 12)
00:07.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express  
x4 Port 7 (rev 12)
00:10.0 Host bridge: Intel Corporation 5000 Series Chipset FSB  
Registers (rev 12)
00:10.1 Host bridge: Intel Corporation 5000 Series Chipset FSB  
Registers (rev 12)
00:10.2 Host bridge: Intel Corporation 5000 Series Chipset FSB  
Registers (rev 12)
00:11.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved  
Registers (rev 12)
00:13.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved  
Registers (rev 12)
00:15.0 Host bridge: Intel Corporation 5000 Series Chipset FBD  
Registers (rev 12)
00:16.0 Host bridge: Intel Corporation 5000 Series Chipset FBD  
Registers (rev 12)
00:1c.0 PCI bridge: Intel Corporation 631xESB/632xESB/3100 Chipset PCI  
Express Root Port 1 (rev 09)
00:1d.0 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset  
UHCI USB Controller #1 (rev 09)
00:1d.1 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset  
UHCI USB Controller #2 (rev 09)
00:1d.2 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset  
UHCI USB Controller #3 (rev 09)
00:1d.7 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset  
EHCI USB2 Controller (rev 09)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d9)
00:1f.0 ISA bridge: Intel Corporation 631xESB/632xESB/3100 Chipset LPC  
Interface Controller (rev 09)
00:1f.1 IDE interface: Intel Corporation 631xESB/632xESB IDE  
Controller (rev 09)
01:00.0 PCI bridge: Intel Corporation 80333 Segment-A PCI Express-to- 
PCI Express Bridge
01:00.2 PCI bridge: Intel Corporation 80333 Segment-B PCI Express-to- 
PCI Express Bridge
02:0e.0 RAID bus controller: Dell PowerEdge Expandable RAID controller 5
04:00.0 PCI bridge: Broadcom EPB PCI-Express to PCI-X Bridge (rev c3)
05:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708  
Gigabit Ethernet (rev 12)
06:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express  
Upstream Port (rev 01)
06:00.3 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express to  
PCI-X Bridge (rev 01)
07:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express  
Downstream Port E1 (rev 01)
07:01.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express  
Downstream Port E2 (rev 01)
08:00.0 PCI bridge: Broadcom EPB PCI-Express to PCI-X Bridge (rev c3)
09:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708  
Gigabit Ethernet (rev 12)
0c:00.0 Fibre Channel: QLogic Corp. ISP2432-based 4Gb Fibre Channel to  
PCI Express HBA (rev 02)
0c:00.1 Fibre Channel: QLogic Corp. ISP2432-based 4Gb Fibre Channel to  
PCI Express HBA (rev 02)
0e:00.0 Ethernet controller: Intel Corporation 82571EB Gigabit  
Ethernet Controller (rev 06)
0e:00.1 Ethernet controller: Intel Corporation 82571EB Gigabit  
Ethernet Controller (rev 06)
10:0d.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02)



__Original Problem__

The two cluster nodes could not talk properly, certain services that  
are part of the cluster suite set of programs (especially rgmanager)  
were failing to run, and everything was a general mess. The fix came  
with switching bonding mode from mode=0 to mode=1 (/etc/modprobe.conf) :

alias eth0 bnx2
alias eth1 bnx2
alias eth2 e1000
alias eth3 e1000
alias bond0 bonding
options bond0 mode=1 miimon=100 use_carrier=0
alias bond1 bonding
options bond1 mode=1 miimon=100 use_carrier=0


__New Problem__

As off about two weeks ago i've started putting a bit of load across  
the active node, and found that after about 3-4 days at least one node  
will fail. The errors i get are in two forms

The short one which just has a soft lockup, and the long kind that  
includes an oom_killer message.

First the short kind:

2008-06-15T04:25:58.134710+10:00 fiction kernel:<3>BUG: soft lockup -  
CPU#3 stuck for 10s! [bond1:3095]
2008-06-15T04:25:58.134718+10:00 fiction kernel:<4>CPU 3:
2008-06-15T04:25:58.134923+10:00 fiction kernel:<4>Modules linked in:  
nfsd exportfs lockd nfs_acl auth_rpcgss autofs4 lock_dlm gfs2 dlm  
configfs sunrpc bonding ip_conntrack_netbios_ns ipt_REJECT ipt_LOG  
xt_limit xt_tcpudp xt_state ip_c
onntrack nfnetlink iptable_filter ip_tables ip6_tables x_tables  
dm_round_robin dm_multipath video sbs backlight i2c_ec i2c_core button  
battery asus_acpi acpi_memhotplug ac parport_pc lp parport joydev  
ide_cd shpchp sr_mod e1000e cdrom
i5000_edac bnx2 edac_mc pcspkr serio_raw sg dm_snapshot dm_zero  
dm_mirror dm_mod usb_storage qla2xxx scsi_transport_fc ata_piix libata  
megaraid_sas sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd
2008-06-15T04:25:58.134927+10:00 fiction kernel:<4>Pid: 3095, comm:  
bond1 Not tainted 2.6.18-92.1.1.el5 #1
2008-06-15T04:25:58.135186+10:00 fiction kernel:<4>RIP: 0010: 
[.text.lock.spinlock+41/48]  [.text.lock.spinlock 
+41/48] .text.lock.spinlock+0x29/0x30
2008-06-15T04:25:58.135191+10:00 fiction kernel:<4>RSP:  
0018:ffff81012c7cdd20  EFLAGS: 00000286
2008-06-15T04:25:58.135195+10:00 fiction kernel:<4>RAX:  
ffff81012c7cdfd8 RBX: ffff81012b138000 RCX: ffff81012c7cdd80
2008-06-15T04:25:58.135199+10:00 fiction kernel:<4>RDX:  
0000000000008948 RSI: ffff81012c7cdd70 RDI: ffff81012b138714
2008-06-15T04:25:58.135203+10:00 fiction kernel:<4>RBP:  
ffff81012d921a20 R08: ffff81012c7cdd50 R09: 000000000000003d
2008-06-15T04:25:58.135207+10:00 fiction kernel:<4>R10:  
ffff81012fc5c008 R11: 0000000000000003 R12: 000000000000000c
2008-06-15T04:25:58.135212+10:00 fiction kernel:<4>R13:  
ffff81012c7cdd70 R14: ffff81012b138000 R15: ffff81012fa64100
2008-06-15T04:25:58.135216+10:00 fiction kernel:<4>FS:   
0000000000000000(0000) GS:ffff81010439c640(0000) knlGS:0000000000000000
2008-06-15T04:25:58.135221+10:00 fiction kernel:<4>CS:  0010 DS: 0018  
ES: 0018 CR0: 000000008005003b
2008-06-15T04:25:58.135225+10:00 fiction kernel:<4>CR2:  
0000000011a4e388 CR3: 0000000000201000 CR4: 00000000000006e0
2008-06-15T04:25:58.135228+10:00 fiction kernel:<4>
2008-06-15T04:25:58.135232+10:00 fiction kernel:<4>Call Trace:
2008-06-15T04:25:58.135457+10:00 fiction kernel:<4> [bnx2:bnx2_ioctl 
+105/255] :bnx2:bnx2_ioctl+0x69/0xff
2008-06-15T04:25:58.135574+10:00 fiction kernel:<4>  
[bonding:bond_check_dev_link+211/441] :bonding:bond_check_dev_link 
+0xd3/0x1b9
2008-06-15T04:25:58.135596+10:00 fiction kernel:<4> [thread_return 
+0/223] thread_return+0x0/0xdf
2008-06-15T04:25:58.135707+10:00 fiction kernel:<4>  
[bonding:__bond_mii_monitor+136/1092] :bonding:__bond_mii_monitor 
+0x88/0x444
2008-06-15T04:25:58.135815+10:00 fiction kernel:<4>  
[bonding:bond_mii_monitor+0/140] :bonding:bond_mii_monitor+0x0/0x8c
2008-06-15T04:25:58.135922+10:00 fiction kernel:<4>  
[bonding:bond_mii_monitor+45/140] :bonding:bond_mii_monitor+0x2d/0x8c
2008-06-15T04:25:58.135981+10:00 fiction kernel:<4> [run_workqueue 
+148/228] run_workqueue+0x94/0xe4
2008-06-15T04:25:58.135999+10:00 fiction kernel:<4> [worker_thread 
+0/290] worker_thread+0x0/0x122
2008-06-15T04:25:58.136025+10:00 fiction kernel:<4>  
[keventd_create_kthread+0/196] keventd_create_kthread+0x0/0xc4
2008-06-15T04:25:58.136042+10:00 fiction kernel:<4> [worker_thread 
+240/290] worker_thread+0xf0/0x122
2008-06-15T04:25:58.136064+10:00 fiction kernel:<4>  
[<ffffffff8008ad26>] default_wake_function+0x0/0xe
2008-06-15T04:25:58.136088+10:00 fiction kernel:<4>  
[keventd_create_kthread+0/196] keventd_create_kthread+0x0/0xc4
2008-06-15T04:25:58.136117+10:00 fiction kernel:<4>  
[keventd_create_kthread+0/196] keventd_create_kthread+0x0/0xc4
2008-06-15T04:25:58.136133+10:00 fiction kernel:<4> [kthread+254/306]  
kthread+0xfe/0x132
2008-06-15T04:25:58.136151+10:00 fiction kernel:<4> [child_rip+10/17]  
child_rip+0xa/0x11
2008-06-15T04:25:58.136176+10:00 fiction kernel:<4>  
[keventd_create_kthread+0/196] keventd_create_kthread+0x0/0xc4
2008-06-15T04:25:58.136191+10:00 fiction kernel:<4> [kthread+0/306]  
kthread+0x0/0x132
2008-06-15T04:25:58.136209+10:00 fiction kernel:<4> [child_rip+0/17]  
child_rip+0x0/0x11
2008-06-15T04:25:58.136214+10:00 fiction kernel:<4>


And now a longer one:

2008-06-15T05:04:38.294604+10:00 fiction kernel:<3>BUG: soft lockup -  
CPU#3 stuck for 10s! [bond1:3095]
2008-06-15T05:04:38.294947+10:00 fiction kernel:<4>CPU 3:
2008-06-15T05:04:38.304072+10:00 fiction kernel:<4>Modules linked in:  
nfsd exportfs lockd nfs_acl auth_rpcgss autofs4 lock_dlm gfs2 dlm  
configfs sunrpc bonding ip_conntrack_netbios_ns ipt_REJECT ipt_LOG  
xt_limit xt_tcpudp xt_state ip_c
onntrack nfnetlink iptable_filter ip_tables ip6_tables x_tables  
dm_round_robin dm_multipath video sbs backlight i2c_ec i2c_core button  
battery asus_acpi acpi_memhotplug ac parport_pc lp parport joydev  
ide_cd shpchp sr_mod e1000e cdrom
i5000_edac bnx2 edac_mc pcspkr serio_raw sg dm_snapshot dm_zero  
dm_mirror dm_mod usb_storage qla2xxx scsi_transport_fc ata_piix libata  
megaraid_sas sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd
2008-06-15T05:04:38.304198+10:00 fiction kernel:<4>Pid: 3095, comm:  
bond1 Not tainted 2.6.18-92.1.1.el5 #1
2008-06-15T05:04:38.307077+10:00 fiction kernel:<4>RIP: 0010: 
[.text.lock.spinlock+38/48]  [.text.lock.spinlock 
+38/48] .text.lock.spinlock+0x26/0x30
2008-06-15T05:04:38.307089+10:00 fiction kernel:<4>RSP:  
0018:ffff81012c7cdd20  EFLAGS: 00000286
2008-06-15T05:04:38.307094+10:00 fiction kernel:<4>RAX:  
ffff81012c7cdfd8 RBX: ffff81012b138000 RCX: ffff81012c7cdd80
2008-06-15T05:04:38.307098+10:00 fiction kernel:<4>RDX:  
0000000000008948 RSI: ffff81012c7cdd70 RDI: ffff81012b138714
2008-06-15T05:04:38.307102+10:00 fiction kernel:<4>RBP:  
ffff81012d921a20 R08: ffff81012c7cdd50 R09: 000000000000003d
2008-06-15T05:04:38.307107+10:00 fiction kernel:<4>R10:  
ffff81012fc5c008 R11: 0000000000000003 R12: 000000000000000c
2008-06-15T05:04:38.307111+10:00 fiction kernel:<4>R13:  
ffff81012c7cdd70 R14: ffff81012b138000 R15: ffff81012fa64100
2008-06-15T05:04:38.307115+10:00 fiction kernel:<4>FS:   
0000000000000000(0000) GS:ffff81010439c640(0000) knlGS:0000000000000000
2008-06-15T05:04:38.307119+10:00 fiction kernel:<4>CS:  0010 DS: 0018  
ES: 0018 CR0: 000000008005003b
2008-06-15T05:04:38.307123+10:00 fiction kernel:<4>CR2:  
0000000011a4e388 CR3: 0000000000201000 CR4: 00000000000006e0
2008-06-15T05:04:38.307126+10:00 fiction kernel:<4>
2008-06-15T05:04:38.307130+10:00 fiction kernel:<4>Call Trace:
2008-06-15T05:04:38.310086+10:00 fiction kernel:<4> [bnx2:bnx2_ioctl 
+105/255] :bnx2:bnx2_ioctl+0x69/0xff
2008-06-15T05:04:38.310229+10:00 fiction kernel:<4>  
[bonding:bond_check_dev_link+211/441] :bonding:bond_check_dev_link 
+0xd3/0x1b9
2008-06-15T05:04:38.310260+10:00 fiction kernel:<4> [thread_return 
+0/223] thread_return+0x0/0xdf
2008-06-15T05:04:38.310369+10:00 fiction kernel:<4>  
[bonding:__bond_mii_monitor+136/1092] :bonding:__bond_mii_monitor 
+0x88/0x444
2008-06-15T05:04:38.310476+10:00 fiction kernel:<4>  
[bonding:bond_mii_monitor+0/140] :bonding:bond_mii_monitor+0x0/0x8c
2008-06-15T05:04:38.310583+10:00 fiction kernel:<4>  
[bonding:bond_mii_monitor+45/140] :bonding:bond_mii_monitor+0x2d/0x8c
2008-06-15T05:04:38.310725+10:00 fiction kernel:<4> [run_workqueue 
+148/228] run_workqueue+0x94/0xe4
2008-06-15T05:04:38.310749+10:00 fiction kernel:<4> [worker_thread 
+0/290] worker_thread+0x0/0x122
2008-06-15T05:04:38.310778+10:00 fiction kernel:<4>  
[keventd_create_kthread+0/196] keventd_create_kthread+0x0/0xc4
2008-06-15T05:04:38.310795+10:00 fiction kernel:<4> [worker_thread 
+240/290] worker_thread+0xf0/0x122
2008-06-15T05:04:38.310820+10:00 fiction kernel:<4>  
[<ffffffff8008ad26>] default_wake_function+0x0/0xe
2008-06-15T05:04:38.310845+10:00 fiction kernel:<4>  
[keventd_create_kthread+0/196] keventd_create_kthread+0x0/0xc4
2008-06-15T05:04:38.310869+10:00 fiction kernel:<4>  
[keventd_create_kthread+0/196] keventd_create_kthread+0x0/0xc4
2008-06-15T05:04:38.310890+10:00 fiction kernel:<4> [kthread+254/306]  
kthread+0xfe/0x132
2008-06-15T05:04:38.310911+10:00 fiction kernel:<4> [child_rip+10/17]  
child_rip+0xa/0x11
2008-06-15T05:04:38.310936+10:00 fiction kernel:<4>  
[keventd_create_kthread+0/196] keventd_create_kthread+0x0/0xc4
2008-06-15T05:04:38.310954+10:00 fiction kernel:<4> [kthread+0/306]  
kthread+0x0/0x132
2008-06-15T05:04:38.310972+10:00 fiction kernel:<4> [child_rip+0/17]  
child_rip+0x0/0x11
2008-06-15T05:04:38.310975+10:00 fiction kernel:<4>
2008-06-15T05:04:46.176360+10:00 fiction kernel:<4>ip.sh invoked oom- 
killer: gfp_mask=0xd0, order=1, oomkilladj=0
2008-06-15T05:04:46.176688+10:00 fiction kernel:<4>
2008-06-15T05:04:46.187169+10:00 fiction kernel:<4>Call Trace:
2008-06-15T05:04:46.190577+10:00 fiction kernel:<4> [out_of_memory 
+142/757] out_of_memory+0x8e/0x2f5
2008-06-15T05:04:46.190969+10:00 fiction kernel:<4>  
[<ffffffff8009df05>] autoremove_wake_function+0x0/0x2e
2008-06-15T05:04:46.191630+10:00 fiction kernel:<4> [__alloc_pages 
+581/718] __alloc_pages+0x245/0x2ce
2008-06-15T05:04:46.192083+10:00 fiction kernel:<4>  
[ip_conntrack:__get_free_pages+14/11954] __get_free_pages+0xe/0x71
2008-06-15T05:04:46.192103+10:00 fiction kernel:<4> [copy_process 
+198/5445] copy_process+0xc6/0x1545
2008-06-15T05:04:46.192430+10:00 fiction kernel:<4> [alloc_pid 
+494/650] alloc_pid+0x1ee/0x28a
2008-06-15T05:04:46.192455+10:00 fiction kernel:<4> [do_fork+104/391]  
do_fork+0x68/0x187
2008-06-15T05:04:46.193414+10:00 fiction kernel:<4> [tracesys+213/224]  
tracesys+0xd5/0xe0
2008-06-15T05:04:46.193438+10:00 fiction kernel:<4> [ptregscall_common 
+103/172] ptregscall_common+0x67/0xac
2008-06-15T05:04:46.193442+10:00 fiction kernel:<4>
2008-06-15T05:04:46.193446+10:00 fiction kernel:<6>Mem-info:
2008-06-15T05:04:46.193450+10:00 fiction kernel:<4>Node 0 DMA per-cpu:
2008-06-15T05:04:46.193457+10:00 fiction kernel:<4>cpu 0 hot: high 0,  
batch 1 used:0
2008-06-15T05:04:46.193578+10:00 fiction kernel:<4>cpu 0 cold: high 0,  
batch 1 used:0
2008-06-15T05:04:46.193584+10:00 fiction kernel:<4>cpu 1 hot: high 0,  
batch 1 used:0
2008-06-15T05:04:46.193588+10:00 fiction kernel:<4>cpu 1 cold: high 0,  
batch 1 used:0
2008-06-15T05:04:46.193592+10:00 fiction kernel:<4>cpu 2 hot: high 0,  
batch 1 used:0
2008-06-15T05:04:46.193609+10:00 fiction kernel:<4>cpu 2 cold: high 0,  
batch 1 used:0
2008-06-15T05:04:46.193613+10:00 fiction kernel:<4>cpu 3 hot: high 0,  
batch 1 used:0
2008-06-15T05:04:46.193629+10:00 fiction kernel:<4>cpu 3 cold: high 0,  
batch 1 used:0
2008-06-15T05:04:46.193646+10:00 fiction kernel:<4>Node 0 DMA32 per-cpu:
2008-06-15T05:04:46.193650+10:00 fiction kernel:<4>cpu 0 hot: high  
186, batch 31 used:169
2008-06-15T05:04:46.193668+10:00 fiction kernel:<4>cpu 0 cold: high  
62, batch 15 used:54
2008-06-15T05:04:46.193702+10:00 fiction kernel:<4>cpu 1 hot: high  
186, batch 31 used:172
2008-06-15T05:04:46.193733+10:00 fiction kernel:<4>cpu 1 cold: high  
62, batch 15 used:49
2008-06-15T05:04:46.193737+10:00 fiction kernel:<4>cpu 2 hot: high  
186, batch 31 used:157
2008-06-15T05:04:46.193740+10:00 fiction kernel:<4>cpu 2 cold: high  
62, batch 15 used:49
2008-06-15T05:04:46.193777+10:00 fiction kernel:<4>cpu 3 hot: high  
186, batch 31 used:20
2008-06-15T05:04:46.193781+10:00 fiction kernel:<4>cpu 3 cold: high  
62, batch 15 used:0
2008-06-15T05:04:46.193784+10:00 fiction kernel:<4>Node 0 Normal per- 
cpu:
2008-06-15T05:04:46.193791+10:00 fiction kernel:<4>cpu 0 hot: high  
186, batch 31 used:2
2008-06-15T05:04:46.193795+10:00 fiction kernel:<4>cpu 0 cold: high  
62, batch 15 used:61
2008-06-15T05:04:46.193798+10:00 fiction kernel:<4>cpu 1 hot: high  
186, batch 31 used:19
2008-06-15T05:04:46.193802+10:00 fiction kernel:<4>cpu 1 cold: high  
62, batch 15 used:56
2008-06-15T05:04:46.193805+10:00 fiction kernel:<4>cpu 2 hot: high  
186, batch 31 used:34
2008-06-15T05:04:46.193809+10:00 fiction kernel:<4>cpu 2 cold: high  
62, batch 15 used:59
2008-06-15T05:04:46.193813+10:00 fiction kernel:<4>cpu 3 hot: high  
186, batch 31 used:170
2008-06-15T05:04:46.193818+10:00 fiction kernel:<4>cpu 3 cold: high  
62, batch 15 used:0
2008-06-15T05:04:46.193822+10:00 fiction kernel:<4>Node 0 HighMem per- 
cpu: empty
2008-06-15T05:04:46.193826+10:00 fiction kernel:<4>Free pages:       
139240kB (0kB HighMem)
2008-06-15T05:04:46.193831+10:00 fiction kernel:<4>Active:4955  
inactive:4809 dirty:3 writeback:5 unstable:0 free:34810 slab:342993  
mapped-file:1503 mapped-anon:7239 pagetables:4338
2008-06-15T05:04:46.193836+10:00 fiction kernel:<4>Node 0 DMA free: 
11116kB min:20kB low:24kB high:28kB active:0kB inactive:0kB present: 
10768kB pages_scanned:0 all_unreclaimable? yes
2008-06-15T05:04:46.193840+10:00 fiction kernel:<4>lowmem_reserve[]: 0  
3255 4013 4013
2008-06-15T05:04:46.193846+10:00 fiction kernel:<4>Node 0 DMA32 free: 
80292kB min:6564kB low:8204kB high:9844kB active:0kB inactive:60kB  
present:3334016kB pages_scanned:3384 all_unreclaimable? yes
2008-06-15T05:04:46.193852+10:00 fiction kernel:<4>lowmem_reserve[]: 0  
0 757 757
2008-06-15T05:04:46.193857+10:00 fiction kernel:<4>Node 0 Normal free: 
47832kB min:1524kB low:1904kB high:2284kB active:19820kB inactive: 
19176kB present:775680kB pages_scanned:85543 all_unreclaimable? yes
2008-06-15T05:04:46.193861+10:00 fiction kernel:<4>lowmem_reserve[]: 0  
0 0 0
2008-06-15T05:04:46.193866+10:00 fiction kernel:<4>Node 0 HighMem free: 
0kB min:128kB low:128kB high:128kB active:0kB inactive:0kB present:0kB  
pages_scanned:0 all_unreclaimable? no
2008-06-15T05:04:46.193870+10:00 fiction kernel:<4>lowmem_reserve[]: 0  
0 0 0
2008-06-15T05:04:46.193877+10:00 fiction kernel:<4>Node 0 DMA: 1*4kB  
5*8kB 6*16kB 5*32kB 3*64kB 3*128kB 0*256kB 0*512kB 2*1024kB 0*2048kB  
2*4096kB = 11116kB
2008-06-15T05:04:46.193882+10:00 fiction kernel:<4>Node 0 DMA32:  
19253*4kB 0*8kB 1*16kB 0*32kB 1*64kB 1*128kB 0*256kB 0*512kB 1*1024kB  
1*2048kB 0*4096kB = 80292kB
2008-06-15T05:04:46.193887+10:00 fiction kernel:<4>Node 0 Normal:  
11774*4kB 0*8kB 0*16kB 1*32kB 1*64kB 1*128kB 0*256kB 1*512kB 0*1024kB  
0*2048kB 0*4096kB = 47832kB
2008-06-15T05:04:46.193891+10:00 fiction kernel:<4>Node 0 HighMem: empty
2008-06-15T05:04:46.194038+10:00 fiction kernel:<4>9806 pagecache pages
2008-06-15T05:04:46.194053+10:00 fiction kernel:<4>Swap cache: add  
125826, delete 118596, find 42649/62217, race 0+1
2008-06-15T05:04:46.194057+10:00 fiction kernel:<4>Free swap  =  
1919084kB
2008-06-15T05:04:46.194060+10:00 fiction kernel:<4>Total swap =  
2040212kB
2008-06-15T05:04:46.194064+10:00 fiction kernel:<6>Free swap:        
1919084kB
2008-06-15T05:04:46.204652+10:00 fiction kernel:<6>1245184 pages of RAM
2008-06-15T05:04:46.204659+10:00 fiction kernel:<6>233218 reserved pages
2008-06-15T05:04:46.204662+10:00 fiction kernel:<6>28717 pages shared
2008-06-15T05:04:46.204666+10:00 fiction kernel:<6>7648 pages swap  
cached
2008-06-15T05:04:46.204967+10:00 fiction kernel:<3>Out of memory:  
Killed process 22213 (crond).

As far as i can tell there is no rhyme or reason as to which process  
is killed, as i mentioned there were bigger problems early on, but  
while they were going it appeared to affect purely random processes  
(well random appearing to myself). Maybe a pattern will emerge now.

The error messages occur every ten seconds in the logs, continously.

Anything i could check / look into would be appreciated.

