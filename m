Return-Path: <linux-kernel-owner+w=401wt.eu-S1752437AbXCUL3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbXCUL3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 07:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbXCUL3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 07:29:23 -0400
Received: from mail.nagafix.co.uk ([194.145.196.85]:43858 "EHLO
	mail.nagafix.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbXCUL3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 07:29:21 -0400
Message-ID: <4601170E.7080901@nagafix.co.uk>
Date: Wed, 21 Mar 2007 11:29:18 +0000
From: Antoine Martin <antoine@nagafix.co.uk>
User-Agent: Thunderbird 1.5.0.10 (X11/20070304)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       mbligh@mbligh.org
Subject: Re: Bug report : reproducible memory allocator bug in 2.6.20-rc6
Content-Type: multipart/mixed;
 boundary="------------080802040600090504030409"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080802040600090504030409
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Re:
http://lkml.org/lkml/2007/1/28/146

Just got a similar OOPS on a system under heavy load (transcode + p2p), 
with kernel 2.6.20.3 / x86_64 (in free_block).

[<ffffffff802c5b95>] free_block+0xae/0x13c
[<ffffffff802c5cb6>] drain_array+0x93/0xd1
[<ffffffff802c6820>] cache_reap+0xea/0x239
[<ffffffff802c6736>] cache_reap+0x0/0x239
[<ffffffff8024a644>] run_workqueue+0x95/0x140
[<ffffffff802471e5>] worker_thread+0x0/0x150
[<ffffffff802472ff>] worker_thread+0x11a/0x150
[<ffffffff80284806>] default_wake_function+0x0/0xe
[<ffffffff802319e7>] kthread+0xd1/0x100
[<ffffffff8025aec8>] child_rip+0xa/0x12
[<ffffffff80231916>] kthread+0x0/0x100
[<ffffffff8025aebe>] child_rip+0x0/0x12

Not sure this is relevant, but transcode uses nice/ionice:
ionice -n 7 -c 3 nice -n 19 transcode [...]
No forced pre-emption, 100HZ, etc...
Note: this is not an SMP system, just a SMP kernel. So if it is a race, 
it is not an SMP triggered race. (or I could just be unlucky again - 
damn those cosmic rays)

Antoine


--------------080802040600090504030409
Content-Type: text/plain;
 name="summary.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="summary.txt"

Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel: list_del corruption. next-=
>prev should be ffff8100007c6000, but was ffffffffffffffff
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel: ------------[ cut here ]--=
----------
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel: kernel BUG at lib/list_deb=
ug.c:72!
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel: invalid opcode: 0000 [1] S=
MP
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel: CPU 0
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel: Modules linked in: ipt_LOG=
 ipt_MASQUERADE iptable_nat nf_nat ip6table_filter ip6_tables iptable_fil=
ter ip_tables pegasus autofs4 hidp rfcomm l2cap bluetooth sunrpc nf_connt=
rack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetl=
ink ip6t_REJECT xt_tcpudp x_tables ipv6 dm_mirror dm_multipath dm_mod rai=
d0 video thermal sbs processor i2c_ec dock button battery asus_acpi backl=
ight ac lp bt878 pata_via snd_hda_intel snd_hda_codec snd_bt87x snd_seq_d=
ummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss sn=
d_mixer_oss snd_pcm snd_timer snd soundcore ide_cd sg shpchp parport_pc s=
nd_page_alloc pata_ali i2c_viapro sata_uli via_rhine mii cdrom parport tu=
ner tvaudio bttv k8temp hwmon video_buf pcspkr ir_common compat_ioctl32 i=
2c_algo_bit btcx_risc tveeprom i2c_core videodev v4l2_common serio_raw v4=
l1_compat sata_sil ata_generic sata_via libata sd_mod scsi_mod raid456 xo=
r raid1 ext3 jbd ehci_hcd ohci_hcd uhci_hcd
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel: Pid: 5, comm: events/0 Not=
 tainted 2.6.20.3 #5
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel: RIP: 0010:[<ffffffff803332=
ae>]  [<ffffffff803332ae>] list_del+0x3f/0x5b
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel: RSP: 0018:ffff81000148ddb0=
  EFLAGS: 00010082
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel: RAX: 0000000000000058 RBX:=
 ffff8100007c6000 RCX: ffffffff8051b718
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel: RDX: ffffffff8051b718 RSI:=
 0000000000000082 RDI: ffffffff8051b700
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel: RBP: ffff81000140ff40 R08:=
 ffffffff8051b718 R09: 0000000000000010
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel: R10: 0000000000000000 R11:=
 0000000000000000 R12: ffff8100007c6f00
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel: R13: ffff810001420580 R14:=
 ffff810001425218 R15: 000000000000003e
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel: FS:  0000000041001940(0000=
) GS:ffffffff8055f000(0000) knlGS:00000000f7f328e0
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel: CS:  0010 DS: 0018 ES: 001=
8 CR0: 000000008005003b
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel: CR2: 00002b7cf8af2000 CR3:=
 000000000532c000 CR4: 00000000000006e0
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel: Process events/0 (pid: 5, =
threadinfo ffff81000148c000, task ffff810001476820)
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel: Stack:  ffff8100066cf000 f=
fffffff802c5b95 0000006000000000 ffff810001425028
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel:  0000000000000060 ffff8100=
01425000 ffff81000140ff80 0000000000000000
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel:  ffff810001420580 ffffffff=
802c5cb6 00000001ffffff86 0000000000000000
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel: Call Trace:
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel:  [<ffffffff802c5b95>] free=
_block+0xae/0x13c
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel:  [<ffffffff802c5cb6>] drai=
n_array+0x93/0xd1
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel:  [<ffffffff802c6820>] cach=
e_reap+0xea/0x239
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel:  [<ffffffff802c6736>] cach=
e_reap+0x0/0x239
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel:  [<ffffffff8024a644>] run_=
workqueue+0x95/0x140
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel:  [<ffffffff802471e5>] work=
er_thread+0x0/0x150
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel:  [<ffffffff802472ff>] work=
er_thread+0x11a/0x150
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel:  [<ffffffff80284806>] defa=
ult_wake_function+0x0/0xe
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel:  [<ffffffff802319e7>] kthr=
ead+0xd1/0x100
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel:  [<ffffffff8025aec8>] chil=
d_rip+0xa/0x12
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel:  [<ffffffff80231916>] kthr=
ead+0x0/0x100
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel:  [<ffffffff8025aebe>] chil=
d_rip+0x0/0x12
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel:
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel:
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel: Code: 0f 0b eb fe 48 89 48=
 08 48 89 01 48 c7 47 08 00 02 20 00 48
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel: RIP  [<ffffffff803332ae>] =
list_del+0x3f/0x5b
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel:  RSP <ffff81000148ddb0>
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel:  NMI Watchdog detected LOC=
KUP on CPU 0
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel: CPU 0
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel: Modules linked in: ipt_LOG=
 ipt_MASQUERADE iptable_nat nf_nat ip6table_filter ip6_tables iptable_fil=
ter ip_tables pegasus autofs4 hidp rfcomm l2cap bluetooth sunrpc nf_connt=
rack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetl=
ink ip6t_REJECT xt_tcpudp x_tables ipv6 dm_mirror dm_multipath dm_mod rai=
d0 video thermal sbs processor i2c_ec dock button battery asus_acpi backl=
ight ac lp bt878 pata_via snd_hda_intel snd_hda_codec snd_bt87x snd_seq_d=
ummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss sn=
d_mixer_oss snd_pcm snd_timer snd soundcore ide_cd sg shpchp parport_pc s=
nd_page_alloc pata_ali i2c_viapro sata_uli via_rhine mii cdrom parport tu=
ner tvaudio bttv k8temp hwmon video_buf pcspkr ir_common compat_ioctl32 i=
2c_algo_bit btcx_risc tveeprom i2c_core videodev v4l2_common serio_raw v4=
l1_compat sata_sil ata_generic sata_via libata sd_mod scsi_mod raid456 xo=
r raid1 ext3 jbd ehci_hcd ohci_hcd uhci_hcd
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel: Pid: 211, comm: kswapd0 No=
t tainted 2.6.20.3 #5
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel: RIP: 0010:[<ffffffff802077=
56>]  [<ffffffff80207756>] _raw_spin_lock+0x76/0xf3
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel: RSP: 0000:ffff81000fe1db10=
  EFLAGS: 00000097
Mar 21 06:15:27 x1-6-00-18-f3-f6-fa-fb kernel: RAX: 0000000000000008 RBX:=
 ffff81000140ff80 RCX: 0000000027ec466b
Mar 21 06:15:28 x1-6-00-18-f3-f6-fa-fb kernel: RDX: 000000000000288f RSI:=
 ffffffff804c5865 RDI: 0000000000000001
Mar 21 06:15:28 x1-6-00-18-f3-f6-fa-fb kernel: RBP: 0000000019ba8b10 R08:=
 ffff8100056d9698 R09: ffff81000140fe03
Mar 21 06:15:28 x1-6-00-18-f3-f6-fa-fb kernel: R10: ffff8100056d9698 R11:=
 ffffffff88032aba R12: 0000000000000001
Mar 21 06:15:28 x1-6-00-18-f3-f6-fa-fb kernel: R13: 0000000077020c98 R14:=
 ffff810001420580 R15: ffff81000140ff80
Mar 21 06:15:28 x1-6-00-18-f3-f6-fa-fb kernel: FS:  00002ba96ff4b600(0000=
) GS:ffffffff8055f000(0000) knlGS:00000000f7f328e0
Mar 21 06:15:28 x1-6-00-18-f3-f6-fa-fb kernel: CS:  0010 DS: 0018 ES: 001=
8 CR0: 000000008005003b
Mar 21 06:15:28 x1-6-00-18-f3-f6-fa-fb kernel: CR2: 00002aeee011afd0 CR3:=
 000000000532c000 CR4: 00000000000006e0
Mar 21 06:15:28 x1-6-00-18-f3-f6-fa-fb kernel: Process kswapd0 (pid: 211,=
 threadinfo ffff81000fe1c000, task ffff81000fc97040)
Mar 21 06:15:28 x1-6-00-18-f3-f6-fa-fb kernel: Stack:  ffff81000140fde0 f=
fff81000140ff40 000000000000003c ffff810001421400
Mar 21 06:15:28 x1-6-00-18-f3-f6-fa-fb kernel:  0000000000000000 ffffffff=
802c5d28 ffff81000fe1dea0 ffff810001421400
Mar 21 06:15:28 x1-6-00-18-f3-f6-fa-fb kernel:  0000000000000000 ffff8100=
0c15df68 ffff810001420580 0000000000000246
Mar 21 06:15:28 x1-6-00-18-f3-f6-fa-fb kernel: Call Trace:
Mar 21 06:15:28 x1-6-00-18-f3-f6-fa-fb kernel:  [<ffffffff802c5d28>] cach=
e_flusharray+0x34/0xae
Mar 21 06:15:28 x1-6-00-18-f3-f6-fa-fb kernel:  [<ffffffff80207678>] kmem=
_cache_free+0x1e6/0x203
Mar 21 06:15:28 x1-6-00-18-f3-f6-fa-fb kernel:  [<ffffffff80226799>] free=
_buffer_head+0x24/0x3d

--------------080802040600090504030409--
