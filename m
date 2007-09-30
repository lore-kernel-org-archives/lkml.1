Return-Path: <linux-kernel-owner+w=401wt.eu-S1757244AbXI3Kqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbXI3Kqn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 06:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754542AbXI3Kqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 06:46:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44166 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750946AbXI3Kqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 06:46:35 -0400
Date: Sun, 30 Sep 2007 03:45:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [2.6.23-rc8-mm2] kernel BUG at mm/slab.c:591! | invalid opcode:
 0000 [#1] SMP
Message-Id: <20070930034556.43b9704d.akpm@linux-foundation.org>
In-Reply-To: <200709300015.36169.elendil@planet.nl>
References: <200709282225.21530.elendil@planet.nl>
	<200709300015.36169.elendil@planet.nl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Sep 2007 00:15:35 +0200 Frans Pop <elendil@planet.nl> wrote:

> On Friday 28 September 2007, you wrote:
> > My Toshiba Satellite A40 (i386, P4 Mobile) hangs during boot after:
> 
> With 'hpet-force-enable-on-ich34' reverted the system boots OK again.
> 
> We're not yet done though. It now fails to resume from suspend

suspend-to-RAM?  Can you describe this failure a bit more?

> and there's
> also the BUG (see subject) during power off. Possibly these are related.
> 
> Attached a diff of dmesg between 2.6.23-6 and 2.6.23-8. Nothing spectacular
> AFAICT, except that I activated netconsole.
> 
> The details of that BUG are at the end of the diff.
> 
> I have some idea where to start looking for this one. If I'm not mistaken,
> it should be somewhere between these two changes:
> # good: [01762341418efa818f28dc69426ca7cc582cdc8c] git-wireless
> # good: [ecdd2a3cb73af8b4659a4cb150bdf2a3ac908791] i386-pit-remove-the-useless-ifdefs
> 

> +------------[ cut here ]------------
> +kernel BUG at mm/slab.c:591!
> +invalid opcode: 0000 [#1] SMP 
> +last sysfs file: /devices/pci0000:00/0000:00:1e.0/0000:01:0b.0/resource
> +Modules linked in: ipv6 fuse dm_snapshot eeprom lm90 i2c_i801 i2c_core speedstep_ich speedstep_lib toshiba_acpi joydev tsdev pcmcia firmware_class snd_intel8x0 snd_intel8x0m snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss yenta_socket snd_pcm rsrc_nonstatic pcmcia_core snd_timer iTCO_wdt video output snd battery psmouse ac watchdog_core watchdog_dev button parport_pc parport shpchp pci_hotplug soundcore snd_page_alloc intel_agp agpgart evdev serio_raw pcspkr rtc ext3 jbd mbcache dm_mirror dm_mod ide_cd cdrom ide_disk piix generic ide_core ata_generic libata scsi_mod ehci_hcd uhci_hcd usbcore thermal processor fan
> +
> +Pid: 3763, comm: rmmod Not tainted (2.6.23-rc8-mm2 #1)
> +EIP: 0060:[<c016df71>] EFLAGS: 00010046 CPU: 0
> +EIP is at kfree+0x5e/0x97
> +EAX: 00000000 EBX: dfe704b8 ECX: c2340d84 EDX: c13fcd40
> +ESI: 00000286 EDI: dfe6ac65 EBP: c7204000 ESP: c7205f14
> + DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> +Process rmmod (pid: 3763, ti=c7204000 task=c201eab0 task.ti=c7204000)
> +last branch before last exception/interrupt
> + from c016df66 (kfree+0x53/0x97)
> + to c016df6b (kfree+0x58/0x97)
> +Stack: dfe704b8 dfe6ac65 dfe704c8 c01d975c dfe7048c c01d9772 00000880 c01da45a 
> +       00000000 00000880 dfe70488 00000000 dfe705c0 00000000 dfe69395 dfe6a5f2 
> +       dfe6aba0 c01465a0 65737566 00000000 00000000 c21e75c0 c0163e91 c18df200 
> +Call Trace:
> + [<c01d975c>] kobject_cleanup+0x31/0x47
> + [<c01da45a>] kref_put+0x76/0x84
> + [<dfe69395>] fuse_sysfs_cleanup+0xa/0x14 [fuse]
> + [<dfe6a5f2>] fuse_exit+0x19/0x24 [fuse]
> + [<c01465a0>] sys_delete_module+0x1c0/0x228
> + [<c0103ece>] sysenter_past_esp+0x6b/0xa1
> + [<ffffe410>] 0xffffe410
> + =======================
> +Code: aa 43 c0 8b 02 25 00 40 02 00 3d 00 40 02 00 75 03 8b 52 0c 8b 02 25 00 40 02 00 3d 00 40 02 00 75 03 8b 52 0c 8b 02 84 c0 78 04 <0f> 0b eb fe 8b 4a 18 64 a1 08 00 40 c0 8b 1c 81 8b 03 3b 43 04 
> +EIP: [<c016df71>] kfree+0x5e/0x97 SS:ESP 0068:c7205f14
> 

I think we have now fixed that - Miklos, do you recall?
