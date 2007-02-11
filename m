Return-Path: <linux-kernel-owner+w=401wt.eu-S1752699AbXBKErN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbXBKErN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 23:47:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbXBKErN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 23:47:13 -0500
Received: from web36708.mail.mud.yahoo.com ([209.191.85.42]:47158 "HELO
	web36708.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752699AbXBKErL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 23:47:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=ND6WZ8PLwEI92eziWbU6oLp4cRPIOnaMe9HHMLhQLCnmN27VRBiOsEYkRtAy2X7WnjzjgEMQWCvnCMG56WCorqjaA1ofYjES9jCD7memVNOxs8eBxCmbndtTkL0l8nT5b/lZjb+XU+4TIFf2ZvAwx3NyO2P8lnR9dHICjEPnk5E=;
X-YMail-OSG: ROigYcQVM1lPT1HeZn_eDh8s9cMJvauI011240umo_Djvog1feQLgwuqcXKq6C4D9nYKQymraxKIi857HmlP1wyqUljJuz4zij86E1Y5dsa05rKRspGWrzQ4dH2SSFc6LsdZOp4PNetFSmA-
Date: Sat, 10 Feb 2007 20:47:10 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: Recent and not-so problems with tifm_sd driver
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45CCC72A.8020904@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <779217.2685.qm@web36708.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> This looks like the problem with races in mmc_block again. Add some printk:s in
> the remove function so that you can see if this oops is after the remove
> function (shouldn't be possible, but will cause crash if it is).

It just occurred to me that my synopsis of the problem was utterly lame.
Here, the correct description:
When the card is pulled out, I mark the host as "ejected" (so it fast-fails all the requests),
sleep a little for it to relax and then call mmc_remove_host. Otherwise, nasty things happen.
Here's the example not involving mmc_block at all (command 3 failed, hardware timeout was missed,
so software timeout picked it up; the sleep hack is disabled):

Feb 11 02:26:08 mortug tifm_sd tifm_sd0:3: executing opcode 0x3, arg: 0x0, mask:
0x1140
Feb 11 02:26:09 mortug tifm_sd: card failed to respond for a long period of time<
7>tifm_7xx1 0000:06:09.3: checking media set 8
Feb 11 02:26:09 mortug tifm_7xx1: demand removing card from socket 0:3
Feb 11 02:26:09 mortug tifm_sd tifm_sd0:3: Setting bus width 0, power 0
Feb 11 02:26:09 mortug tifm_sd tifm_sd0:3: Setting bus width 0, power 0
Feb 11 02:26:09 mortug general protection fault: 0000 [1] SMP
Feb 11 02:26:09 mortug CPU 0
Feb 11 02:26:09 mortug Modules linked in: tifm_sd tifm_7xx1 tifm_core mmc_block m
mc_core appletalk ipx p8022 psnap llc p8023 fglrx(P) ndiswrapper snd_pcm_oss snd_
mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device eth
1394 binfmt_misc firmware_class tg3 ohci1394 yenta_socket rsrc_nonstatic ieee1394
 pcmcia_core 8250_pci i2c_piix4 i2c_core snd_atiixp snd_atiixp_modem parport_pc p
arport k8temp hwmon snd_ac97_codec ac97_bus joydev snd_pcm ehci_hcd serio_raw tsd
ev pcspkr 8250_pnp 8250 serial_core snd_timer snd ohci_hcd evdev irda crc_ccitt s
oundcore snd_page_alloc usbcore
Feb 11 02:26:09 mortug Pid: 8318, comm: kmmcd Tainted: P      2.6.20 #1
Feb 11 02:26:09 mortug RIP: 0010:[<ffffffff88178d30>]  [<ffffffff88178d30>] :mmc_
core:mmc_rescan+0x440/0x1350
Feb 11 02:26:09 mortug RSP: 0018:ffff81002d6d5af0  EFLAGS: 00010202
Feb 11 02:26:09 mortug RAX: 2f4065766f6d6572 RBX: 2f4065766f6d6572 RCX: 000000000
0000000
Feb 11 02:26:09 mortug RDX: ffff81002d6d5fd8 RSI: 0000000000000286 RDI: ffff81002
d6d5a88
Feb 11 02:26:09 mortug RBP: ffff81002d6d5dc8 R08: 0000000000000000 R09: 000000000
000000a
Feb 11 02:26:09 mortug R10: 00000000ffffffff R11: ffffffff88178110 R12: ffff81002
976a000
Feb 11 02:26:09 mortug R13: ffff81002976a2c0 R14: ffff81002adee800 R15: ffff81002
d6d5dc0
Feb 11 02:26:09 mortug FS:  00002b8375adab00(0000) GS:ffffffff805d0000(0000) knlG
S:00000000f7e066c0
Feb 11 02:26:09 mortug CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Feb 11 02:26:09 mortug CR2: 000000000050e3c0 CR3: 00000000079a2000 CR4: 000000000
00006e0
Feb 11 02:26:09 mortug Process kmmcd (pid: 8318, threadinfo ffff81002d6d4000, tas
k ffff81002ea82820)
Feb 11 02:26:09 mortug Stack:  ffffffff80288770 ffff81002d6d5dc8 ffff81002976a2ac
 ffff81002d6d5b28
Feb 11 02:26:09 mortug ffffffff80288a38 00000cc03f1dc6bb 0000000000962228 037ffe4
382562228
Feb 11 02:26:09 mortug 00ffffff80248e8b 00ff800000000001 00000000000004d0 0000000
000000001
Feb 11 02:26:09 mortug Call Trace:
Feb 11 02:26:09 mortug [<ffffffff80288770>] task_rq_lock+0x50/0x90
Feb 11 02:26:09 mortug [<ffffffff80288a38>] __activate_task+0x38/0x50
Feb 11 02:26:09 mortug [<ffffffff8049d762>] unix_find_other+0x172/0x200
Feb 11 02:26:09 mortug [<ffffffff8028a5e0>] __wake_up_common+0x40/0x70
Feb 11 02:26:09 mortug [<ffffffff8020f199>] __alloc_pages+0x69/0x2f0
Feb 11 02:26:09 mortug [<ffffffff802110f1>] do_wp_page+0x4b1/0x510
Feb 11 02:26:09 mortug [<ffffffff80265d3e>] thread_return+0x0/0xe2
Feb 11 02:26:09 mortug [<ffffffff88178110>] :mmc_core:mmc_wait_done+0x0/0x10
Feb 11 02:26:09 mortug [<ffffffff881788f0>] :mmc_core:mmc_rescan+0x0/0x1350
Feb 11 02:26:09 mortug [<ffffffff80250001>] run_workqueue+0xb1/0x160
Feb 11 02:26:09 mortug [<ffffffff8029e670>] keventd_create_kthread+0x0/0x90
Feb 11 02:26:09 mortug [<ffffffff8024c6d1>] worker_thread+0x161/0x1a0
Feb 11 02:26:09 mortug [<ffffffff8028a590>] default_wake_function+0x0/0x10
Feb 11 02:26:09 mortug [<ffffffff8028a590>] default_wake_function+0x0/0x10
Feb 11 02:26:09 mortug [<ffffffff8024c570>] worker_thread+0x0/0x1a0
Feb 11 02:26:09 mortug [<ffffffff80233109>] kthread+0xd9/0x120
Feb 11 02:26:09 mortug [<ffffffff80262ec8>] child_rip+0xa/0x12
Feb 11 02:26:09 mortug [<ffffffff8029e670>] keventd_create_kthread+0x0/0x90
Feb 11 02:26:09 mortug [<ffffffff80233030>] kthread+0x0/0x120
Feb 11 02:26:09 mortug [<ffffffff80262ebe>] child_rip+0x0/0x12
Feb 11 02:26:09 mortug
Feb 11 02:26:09 mortug
Feb 11 02:26:09 mortug Code: 48 8b 03 0f 18 08 49 39 dd 0f 84 0c 04 00 00 f6 83 8
c 02 00
Feb 11 02:26:09 mortug RIP  [<ffffffff88178d30>] :mmc_core:mmc_rescan+0x440/0x135
0
Feb 11 02:26:09 mortug RSP <ffff81002d6d5af0>
Feb 11 02:28:09 mortug shutdown[17114]: shutting down for system halt
Feb 11 02:28:09 mortug init: Switching to runlevel: 0
Feb 11 02:28:18 mortug dhcpcd[7461]: terminating on signal 15
Feb 11 02:28:21 mortug <6>ACPI: PCI interrupt for device 0000:00:14.5 disabled
Feb 11 02:28:21 mortug ACPI: PCI interrupt for device 0000:00:14.6 disabled



 
____________________________________________________________________________________
Don't get soaked.  Take a quick peak at the forecast
with the Yahoo! Search weather shortcut.
http://tools.search.yahoo.com/shortcuts/#loc_weather
