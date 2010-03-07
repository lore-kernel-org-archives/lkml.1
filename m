Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362Ab0CGCtl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 21:49:41 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60897 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab0CGCtj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 21:49:39 -0500
MIME-Version: 1.0
From: "Michael Lawson (mshindo)" <michael@sphinix.com>
Date: Sun, 7 Mar 2010 15:49:18 +1300
Message-ID: <c97a47b91003061849l1133250bg895516ea191eac11@mail.gmail.com>
Subject: PROBLEM: Null pointer deference in nf_reinject()
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have found a weird bug caused by calls to nf_reinject in the 64Bit
version of 2.6.32 and 2.6.33.

We have a test module that captures all incoming packets on a queue
and then calls nf_reinject on that entry. On calling nf_reinject, the
kernel panics complaining about a null pointer. The arguments being
parsed to nf_reinject are _not_ null. And neither is the skb structure
inside the entry.

The module test code is as follows:

static struct nf_hook_ops* in_hook;
static struct nf_queue_handler* nfqh;

unsigned int hook_func(unsigned int hooknum,
                        struct sk_buff *pskb,
                        const struct net_device *in,
                        const struct net_device *out,
                        int (*okfn)(struct sk_buff *))
{
	return NF_QUEUE;
}

int squeue_add_packet(struct nf_queue_entry *entry, unsigned int queuenum){
	//This is where things get nasty --->
	if(entry && entry->skb)
		nf_reinject(entry, NF_ACCEPT);
return 0;
}

static void register_hooks(){
        in_hook                 = (struct nf_hook_ops*)
kmalloc(sizeof(struct nf_hook_ops), GFP_ATOMIC);
        in_hook->hook           = hook_func;
        in_hook->hooknum        = NF_INET_LOCAL_IN;
        in_hook->pf             = 2;
        in_hook->priority       = NF_IP_PRI_FIRST;

        nfqh                    = (struct nf_queue_handler*)
kmalloc(sizeof(struct nf_queue_handler),GFP_ATOMIC);
        nfqh->name              = "queue";
        nfqh->outfn             = &squeue_add_packet;

        nf_register_hook(in_hook);

        nf_register_queue_handler(2, nfqh);
}

The resulting panic:

[  35.944199J BUG: unable to handle kernel NULL pointer dereference at
0000000000000002
[       35.948124]   IP: [<ffffffff81259ad4>] __nf_queue+0xaf/0x25f
[       35.949358]   PGD 37870067 PUD 860dd067 PMD 0
[       35.950538]   Thread overran stack, or stack corrupted
[       35.951638]   Oops: 0000 [#1] SMP
[       35.954663]   last sysfs file: /sys/devices/virtual/net/lo/operstate
[       35.957962]   CPU 0
[       35.959177]   Modules linked in: queue loop snd_ensl371
parport_pc gameport snd_rawmidi snd_seq_device snd_ac97_codec
serio_raui ac97_bus snd_pcm parport snd_ti
mer  pcspkr psmouse snd soundcore snd_page_alloc shpchp i2c_piix4
container i2c_core processor ac evdev pci_hotplug ext3 jbd mbcache
sd_mod crc_tlOdif ide_cd_mod
cdrom ide_pci_generic ata_generic libata uhci_hcd intel_agp mptspi
mptscsih mptbase scsi_transport_spi button floppy ehci_hcd piix elOOO
scsi_mod ide_core agpg
art   usbcore nls_base thermal fan thermal_sys [last unloaded: scsi_uiait_scan]
[       35.991694]   Pid: 0, comm: swapper Not tainted
2.6.32-trunk-amd64 #1 VMuiare Virtual Platform
[       36.000926]   RIP: 0010: [<ffffffff81259ad4>]
[<ffffffff81259ad4>] __nf_queue+0xaf/0x25f
[       36.012149]   RSP: 0018:ffff880001803C10 EFLAGS: 00010202
[       36.031984]   RAX: 0000000000000000 RBX: 0000000000000002 RCX:
0000000000000000
[       36.041312]   RDX: 0000000000000058 RSI: ffff88003765ae40 RDI:
ffff88003765ae88
[       36.052140]   RBP: ffff88003765ae40 R08: 0000000000000020 R09:
0000000000000000
[       36.055722]   RIO: 00008020ff00a8c0 Rll: ffff880086980600 R12:
0000000000000002
[       36.057163]   R13: ffff88003781d000 R14: 0000000000000000 R15:
0000000000000001
[       36.058517]   FS: 0000000000000000(0000)
GS:ffff880001800000(0000) knlGS:0000000000000000
[       36.059896]   CS: 0010 DS: 0018 ES: 0018 CRO: 000000008005003b
[       36.061246]   CR2: 0000000000000002 CR3: 000000008620a000 CR4:
00000000000006f0
[       36.071174]   DRO: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[       36.075407]   DR3: 0000000000000000 DR6: OOOOOOOOffffOff0 DR7:
0000000000000400
[       36.076844]   Process swapper (pid: 0, threadinfo
ffffffff8140a000, task ffffffff8143flfO)
[       36.078274]   Stack:
[       36.079649]  ffff880087204d00 ffffffff81327ff0 ffff880087fe0530
0000000000000001
[       36.079687]   <0> ffff880087204d00 ffffffff814b4f30
ffffffff8125f6d6 0000000000000000
[       36.081093]   <0> ffff88003781d000 ffffffff8125923c
ffffffff8125f6d6 0000000000000000
[       36.102951]   Call Trace:
[       36.105623]  <IRQ>
[       36.107111]  [<ffffffff8125f6d6>] ? ip_local_deliver_finish+0x0/0xle9
[       36.108539]  [<ffffffff8125923c>] ? nf_hook_sloui+0xae/0xc3
[       36.109969]  [<ffffffff8125f6d6>] ? ip_local_deliver_finish+0x0/0xle9
[       36.111381]  [<ffffffff8125f91e>] ? ip_local_deliver+0x5f/0x77
[       36.121758]  [<ffffffff8125f36b>] ? ip_rcv_finish+0x373/0x38d
[       36.125598]  [<ffffffffa00b3bld>] ?
el000_clean_rx_irq+0x326/0x3ea [elOOO]
[       36.127118]  [<ffffffffa00b78c2>] ? el000_clean+0x2fa/0x49c [elOOO]
[       36.128730]  [<ffffffff8105aal8>] ? __mod_timer+Ox141/0x153
[       36.130154]  [<ffffffff810c6b05>] ? sync_supers_timer_fn+0x0/0xl3
[       36.131572]  [<ffffffff8123c7bb>] ? net_rx_action+0xae/0xlc9
[       36.142427]  [<ffffffff810539ca>] ? __do_softirq+0xdd/0xl9f
[       36.162124]  [<ffffffff81011c6c>] ? call_softirq+0xlc/0x30
[       36.171237]  [<ffffffff810138c3>] ? do_softirq+0x3f/0x7c
[       36.182263]  [<ffffffff81053839>] ? irq_exit+0x36/0x76
[       36.202031]  [<ffffffff81012fba>] ? do_IRQ+0xa0/0xb6
{       36.205138]  [<ffffffff81011493>] ? ret_from_intr+0x0/0xll
{       36.206542]  <E0I>
{       36.207920]  [<ffffffff8102c55c>] ? native.safe_halt+0x2/0x3
{       36.209259]  [<ffffffff81017d0d>] ? default_idle+0x34/0x51
{       36.210628]  [<ffffffff8100fe6f>] ? cpu_idle+0xa2/0xda
[       36.211945]  [<ffffffff814cel40>] ? early_idt_handler+0x0/0x71
[       36.220268]  [<ffffffff814cecd7>] ? Start_kernel+0x3d0/0x3dc
{       36.231257]  [<ffffffff814ce3b7>] ? x86_64_start_kernel+0xf9/0xl06
[       36.251002]   Code: 44 89 7d 2c 4c 89 6d 30 4c 89 75 38 48 89
45 10 48 8b 44 24 50 48 89 45 40 4d 8b 64 24 18 4d 85 e4 74 6d 65 8b
04 25 a8 e3 00 00 <41> 83 3c
24  02 Of 84 99 01 00 00 48 63 dO 49 8b 84 24 28 02 00
{       36.262593]   RIP  [<ffffffff81259ad4>] __nf_queue+0xaf/0x25f
[       36.290513]  RSP <ffff880001803cl0>
[       36.299797]   CR2: 0000000000000002
[       36.302571]   —[ end trace c4b32f6153873714 ] —
[       36.322849]   Kernel panic - not syncing: Fatal exception in interrupt

I have tested this on several different machines, but the particular
vmware image this individual stack trace came from was:

root@debian2:~# cat /proc/version
Linux version 2.6.32-trunk-amd64 (Debian 2.6.32-5)
(ben@decadent.org.uk) (gcc version 4.3.4 (Debian 4.3.4-6) ) #1 SMP Sun
Jan 10 22:40:40 UTC 2010

The code in question works perfectly in 32Bit linux.

Please consider looking at this, and when required any further
information can be provided

-- 
Thanks,
Michael Lawson
