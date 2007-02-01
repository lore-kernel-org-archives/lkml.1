Return-Path: <linux-kernel-owner+w=401wt.eu-S1422935AbXBASob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422935AbXBASob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 13:44:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422934AbXBASob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 13:44:31 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:45611 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422935AbXBASoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 13:44:30 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <45C23480.30805@s5r6.in-berlin.de>
Date: Thu, 01 Feb 2007 19:42:08 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20070121 SeaMonkey/1.0.7
MIME-Version: 1.0
To: Nicolas Turro <Nicolas.Turro@inrialpes.fr>
CC: linux-kernel@vger.kernel.org, sebastien.rougeaux@anu.edu.au,
       GordPeters@smarttech.com, linux1394-devel@lists.sourceforge.net
Subject: Re: rmmod ohci1394 -> BUG
References: <20070130155608615.00000003564@rodal>
In-Reply-To: <20070130155608615.00000003564@rodal>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(quoting in full for linux1394-devel)

Nicolas Turro wrote on 2007-01-30:
> Setup :
> 64 bit dual core Xeon bi-processor, Fedora kernels
> 
> Bug :
> Rmmoding ohci1394 produces ce following bug : 
> 
> 
> List corruption. prev->next should be ffff810138d46e40, but was ffffffff882b9000
> ----------- [cut here ] --------- [please bite here ] ---------
> Kernel BUG at include/linux/list.h:180
> invalid opcode: 0000 [1] SMP
> last sysfs file: /class/ieee1394_protocol/raw1394/dev
> CPU 2
> Modules linked in: parport_pc lp parport autofs4 rfcomm l2cap bluetooth sunrpc dm_mod video button battery acpi_mem
> hotplug ac ipv6 ohci1394 ieee1394 uhci_hcd ehci_hcd hw_random i2c_i801 i2c_core snd_hda_intel snd_hda_codec snd_seq
> _dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd soundc
> ore snd_page_alloc tg3 mptsas mptscsih scsi_transport_sas mptbase ahci libata sd_mod scsi_mod
> Pid: 3841, comm: rmmod Not tainted 2.6.17-1.2142_FC4smp #1
> RIP: 0010:[<ffffffff88256f37>] <ffffffff88256f37>{:ieee1394:__delete_addr+35}

I can't see how any of the lists which __delete_addr touches could get
corrupted. My guess is that there is something unrelated corrupting the
memory.

> RSP: 0018:ffff81012c4e9d98  EFLAGS: 00010092
> RAX: 0000000000000054 RBX: ffff810138d46e40 RCX: ffffffff805524b8
> RDX: 0000000000000000 RSI: 0000000000000046 RDI: ffffffff805524a0
> RBP: ffff81013931c000 R08: ffffffff805524b8 R09: 0000000000000001
> R10: ffff81012c4e99f8 R11: 0000000000000002 R12: ffffffff882939c0
> R13: 0000000000000282 R14: 0000000000000000 R15: 0000000000000880
> FS:  00002aaaaaabe3c0(0000) GS:ffff81013b8d1d40(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000003a012928f0 CR3: 000000012c69e000 CR4: 00000000000006e0
> Process rmmod (pid: 3841, threadinfo ffff81012c4e8000, task ffff8101356ae820)
> Stack: ffffffff88293a18 ffff810138d46e10 ffff81013931c000 ffffffff88257049
>        ffffffff882939c0 ffff81013931c000 ffff81013931ebf0 ffff81013b632100
>        ffffffff882c4778 ffffffff882570ec
> Call Trace: <ffffffff88257049>{:ieee1394:__unregister_host+71}
>        <ffffffff882570ec>{:ieee1394:highlevel_remove_host+62}
>        <ffffffff88256373>{:ieee1394:hpsb_remove_host+60} <ffffffff882be227>{:ohci1394:ohci1394_pci_remove+75}
>        <ffffffff8033f83f>{pci_device_remove+33} <ffffffff8039b45d>{__device_release_driver+120}
>        <ffffffff8039b80c>{driver_detach+202} <ffffffff8039ae6d>{bus_remove_driver+111}
>        <ffffffff8039ba8b>{driver_unregister+13} <ffffffff8033f724>{pci_unregister_driver+26}
>        <ffffffff802a403f>{sys_delete_module+406} <ffffffff80262485>{tracesys+209}
> 
> Code: 0f 0b 68 98 fa 25 88 c2 b4 00 48 8b 03 48 8b 50 08 48 39 da
> RIP <ffffffff88256f37>{:ieee1394:__delete_addr+35} RSP <ffff81012c4e9d98>
>  <3>BUG: sleeping function called from invalid context at include/linux/rwsem.h:43
> in_atomic():0, irqs_disabled():1
> 
> Call Trace: <ffffffff80299b11>{blocking_notifier_call_chain+31}
>        <ffffffff80215bb0>{do_exit+34} <ffffffff8027000a>{kernel_math_error+0}
>        <ffffffff80270485>{do_invalid_op+173} <ffffffff88256f37>{:ieee1394:__delete_addr+35}

I don't know what that's supposed to tell us. There simply are no
sleeping functions called from __delete_addr. Seems the kernel went off
on a tangent here.

>        <ffffffff80278680>{__smp_call_function+98} <ffffffff802784cc>{do_flush_tlb_all+0}
>        <ffffffff80290415>{printk+84} <ffffffff802631e9>{error_exit+0}
>        <ffffffff88256f37>{:ieee1394:__delete_addr+35} <ffffffff88256f37>{:ieee1394:__delete_addr+35}
>        <ffffffff88257049>{:ieee1394:__unregister_host+71} <ffffffff882570ec>{:ieee1394:highlevel_remove_host+62}
>        <ffffffff88256373>{:ieee1394:hpsb_remove_host+60} <ffffffff882be227>{:ohci1394:ohci1394_pci_remove+75}
>        <ffffffff8033f83f>{pci_device_remove+33} <ffffffff8039b45d>{__device_release_driver+120}
>        <ffffffff8039b80c>{driver_detach+202} <ffffffff8039ae6d>{bus_remove_driver+111}
>        <ffffffff8039ba8b>{driver_unregister+13} <ffffffff8033f724>{pci_unregister_driver+26}
>        <ffffffff802a403f>{sys_delete_module+406} <ffffffff80262485>{tracesys+209}
> 
> 
> Any idea ? (if any, please cc Nicolas.Turro@inrialpes.fr since i didn't subscribe to LKML)
> 
> Nicolas
> 

-- 
Stefan Richter
-=====-=-=== --=- ----=
http://arcgraph.de/sr/
