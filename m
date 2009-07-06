Return-Path: <linux-kernel-owner+w=401wt.eu-S1752052AbZGFQXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbZGFQXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 12:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbZGFQXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 12:23:13 -0400
Received: from aun.it.uu.se ([130.238.12.36]:38953 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbZGFQXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 12:23:12 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19026.9449.780724.147224@pilspetsen.it.uu.se>
Date: Mon, 6 Jul 2009 18:23:05 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.31-rc tty layer instabilities
In-Reply-To: <20090706154054.7755e07b@lxorguk.ukuu.org.uk>
References: <200907061343.n66DhDbC004009@pilspetsen.it.uu.se>
	<20090706154054.7755e07b@lxorguk.ukuu.org.uk>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox writes:
 > > With 2.6.31-rc1 I saw warnings like the following:
 > 
 > Somehow you got a closed ldisc being closed again which means the hangup
 > raced some other event.
 > 
 > > With 2.6.31-rc2 I instead see oopses:
 > 
 > I put in a NULL assignment to force any offenders to explode.
 > 
 > We've executed tty_ldisc_release on the port meaning we already took the
 > path through tty_release_dev() which is called when the final close() of
 > the tty occurs.
 > 
 > After this we've come via disassociate_ctty into a hangup (caused by us
 > being the controlling tty owner who exits).
 > 
 > > Jul  6 15:23:49 brewer kernel:  [<c0232c1c>] ? tty_ldisc_hangup+0xdc/0x1d0
 > > Jul  6 15:23:49 brewer kernel:  [<c022bbb5>] ? do_tty_hangup+0xc5/0x340
 > > Jul  6 15:23:49 brewer kernel:  [<c022c19f>] ? disassociate_ctty+0x3f/0x1d0
 > 
 > At this point we hold a kref to the tty still but the tty->ldisc is dead
 > 
 > In the normal case we would be fine as we kill off any pending hangup
 > processing in the close down. In this case we are not because the hangup
 > process was initiated after the last close
 > 
 > > This happens perhaps once every 5 or so reboots. I haven't yet seen
 > > any specific usage pattern that might be the trigger.
 > 
 > I suspect its simply a matter of timing randomness.
 > 
 > Does this help:
 > 
 > tty: defer ldisc kill

Unfortunately this made things worse. Now I get loads of warnings during
bootup before the login prompt is shown:

Adding 2008116k swap on /dev/sda2.  Priority:-1 extents:1 across:2008116k 
------------[ cut here ]------------
WARNING: at drivers/char/tty_ldisc.c:210 tty_ldisc_put+0x81/0x90()
Hardware name: System Product Name
Modules linked in: snd_hda_intel snd_hda_codec snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss sg snd_pcm sr_mod cdrom 8139too snd_timer mii bitrev crc32 snd soundcore snd_page_alloc floppy ehci_hcd uhci_hcd usbcore
Pid: 1387, comm: init Not tainted 2.6.31-rc2 #1
Call Trace:
 [<ffffffff811642f1>] ? tty_ldisc_put+0x81/0x90
 [<ffffffff811642f1>] ? tty_ldisc_put+0x81/0x90
 [<ffffffff81037e74>] ? warn_slowpath_common+0x74/0xd0
 [<ffffffff811642f1>] ? tty_ldisc_put+0x81/0x90
 [<ffffffff81164e20>] ? tty_ldisc_hangup+0x130/0x210
 [<ffffffff8115d1ee>] ? do_tty_hangup+0xde/0x3d0
 [<ffffffff81090afa>] ? filp_close+0x4a/0x80
 [<ffffffff8115d87b>] ? disassociate_ctty+0x4b/0x230
 [<ffffffff8103b80a>] ? do_exit+0x69a/0x6f0
 [<ffffffff8103b899>] ? do_group_exit+0x39/0xa0
 [<ffffffff8103b912>] ? sys_exit_group+0x12/0x20
 [<ffffffff8100b3ab>] ? system_call_fastpath+0x16/0x1b
---[ end trace 2068c4982373eafa ]---
tty_ldisc_deref: no references.
NET: Registered protocol family 17
eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
warning: `dbus-daemon' uses 32-bit capabilities (legacy support in use)
------------[ cut here ]------------
WARNING: at drivers/char/tty_ldisc.c:210 tty_ldisc_put+0x81/0x90()
Hardware name: System Product Name
Modules linked in: sunrpc af_packet snd_hda_intel snd_hda_codec snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss sg snd_pcm sr_mod cdrom 8139too snd_timer mii bitrev crc32 snd soundcore snd_page_alloc floppy ehci_hcd uhci_hcd usbcore
Pid: 1996, comm: mingetty Tainted: G        W  2.6.31-rc2 #1
Call Trace:
 [<ffffffff811642f1>] ? tty_ldisc_put+0x81/0x90
 [<ffffffff811642f1>] ? tty_ldisc_put+0x81/0x90
 [<ffffffff81037e74>] ? warn_slowpath_common+0x74/0xd0
 [<ffffffff811642f1>] ? tty_ldisc_put+0x81/0x90
 [<ffffffff81164e20>] ? tty_ldisc_hangup+0x130/0x210
 [<ffffffff8115d1ee>] ? do_tty_hangup+0xde/0x3d0
 [<ffffffff8115d50a>] ? tty_vhangup_self+0x1a/0x30
 [<ffffffff810909be>] ? sys_vhangup+0x1e/0x30
 [<ffffffff8100b3ab>] ? system_call_fastpath+0x16/0x1b
---[ end trace 2068c4982373eafb ]---
tty_ldisc_deref: no references.
------------[ cut here ]------------
WARNING: at drivers/char/tty_ldisc.c:210 tty_ldisc_put+0x81/0x90()
Hardware name: System Product Name
Modules linked in: sunrpc af_packet snd_hda_intel snd_hda_codec snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss sg snd_pcm sr_mod cdrom 8139too snd_timer mii bitrev crc32 snd soundcore snd_page_alloc floppy ehci_hcd uhci_hcd usbcore
Pid: 1993, comm: mingetty Tainted: G        W  2.6.31-rc2 #1
Call Trace:
 [<ffffffff811642f1>] ? tty_ldisc_put+0x81/0x90
 [<ffffffff811642f1>] ? tty_ldisc_put+0x81/0x90
 [<ffffffff81037e74>] ? warn_slowpath_common+0x74/0xd0
 [<ffffffff811642f1>] ? tty_ldisc_put+0x81/0x90
 [<ffffffff81164e20>] ? tty_ldisc_hangup+0x130/0x210
 [<ffffffff8115d1ee>] ? do_tty_hangup+0xde/0x3d0
 [<ffffffff8115d50a>] ? tty_vhangup_self+0x1a/0x30
 [<ffffffff810909be>] ? sys_vhangup+0x1e/0x30
 [<ffffffff8100b3ab>] ? system_call_fastpath+0x16/0x1b
---[ end trace 2068c4982373eafc ]---
tty_ldisc_deref: no references.
------------[ cut here ]------------
WARNING: at drivers/char/tty_ldisc.c:210 tty_ldisc_put+0x81/0x90()
Hardware name: System Product Name
Modules linked in: sunrpc af_packet snd_hda_intel snd_hda_codec snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss sg snd_pcm sr_mod cdrom 8139too snd_timer mii bitrev crc32 snd soundcore snd_page_alloc floppy ehci_hcd uhci_hcd usbcore
Pid: 1994, comm: mingetty Tainted: G        W  2.6.31-rc2 #1
Call Trace:
 [<ffffffff811642f1>] ? tty_ldisc_put+0x81/0x90
 [<ffffffff811642f1>] ? tty_ldisc_put+0x81/0x90
 [<ffffffff81037e74>] ? warn_slowpath_common+0x74/0xd0
 [<ffffffff811642f1>] ? tty_ldisc_put+0x81/0x90
 [<ffffffff81164e20>] ? tty_ldisc_hangup+0x130/0x210
 [<ffffffff8115d1ee>] ? do_tty_hangup+0xde/0x3d0
 [<ffffffff8115d50a>] ? tty_vhangup_self+0x1a/0x30
 [<ffffffff810909be>] ? sys_vhangup+0x1e/0x30
 [<ffffffff8100b3ab>] ? system_call_fastpath+0x16/0x1b
---[ end trace 2068c4982373eafd ]---
tty_ldisc_deref: no references.
------------[ cut here ]------------
WARNING: at drivers/char/tty_ldisc.c:210 tty_ldisc_put+0x81/0x90()
Hardware name: System Product Name
Modules linked in: sunrpc af_packet snd_hda_intel snd_hda_codec snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss sg snd_pcm sr_mod cdrom 8139too snd_timer mii bitrev crc32 snd soundcore snd_page_alloc floppy ehci_hcd uhci_hcd usbcore
Pid: 1992, comm: mingetty Tainted: G        W  2.6.31-rc2 #1
Call Trace:
 [<ffffffff811642f1>] ? tty_ldisc_put+0x81/0x90
 [<ffffffff811642f1>] ? tty_ldisc_put+0x81/0x90
 [<ffffffff81037e74>] ? warn_slowpath_common+0x74/0xd0
 [<ffffffff811642f1>] ? tty_ldisc_put+0x81/0x90
 [<ffffffff81164e20>] ? tty_ldisc_hangup+0x130/0x210
 [<ffffffff8115d1ee>] ? do_tty_hangup+0xde/0x3d0
 [<ffffffff8115d50a>] ? tty_vhangup_self+0x1a/0x30
 [<ffffffff810909be>] ? sys_vhangup+0x1e/0x30
 [<ffffffff8100b3ab>] ? system_call_fastpath+0x16/0x1b
---[ end trace 2068c4982373eafe ]---
tty_ldisc_deref: no references.
------------[ cut here ]------------
WARNING: at drivers/char/tty_ldisc.c:210 tty_ldisc_put+0x81/0x90()
Hardware name: System Product Name
Modules linked in: sunrpc af_packet snd_hda_intel snd_hda_codec snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss sg snd_pcm sr_mod cdrom 8139too snd_timer mii bitrev crc32 snd soundcore snd_page_alloc floppy ehci_hcd uhci_hcd usbcore
Pid: 1995, comm: mingetty Tainted: G        W  2.6.31-rc2 #1
Call Trace:
 [<ffffffff811642f1>] ? tty_ldisc_put+0x81/0x90
 [<ffffffff811642f1>] ? tty_ldisc_put+0x81/0x90
 [<ffffffff81037e74>] ? warn_slowpath_common+0x74/0xd0
 [<ffffffff811642f1>] ? tty_ldisc_put+0x81/0x90
 [<ffffffff81164e20>] ? tty_ldisc_hangup+0x130/0x210
 [<ffffffff8115d1ee>] ? do_tty_hangup+0xde/0x3d0
 [<ffffffff8115d50a>] ? tty_vhangup_self+0x1a/0x30
 [<ffffffff810909be>] ? sys_vhangup+0x1e/0x30
 [<ffffffff8100b3ab>] ? system_call_fastpath+0x16/0x1b
---[ end trace 2068c4982373eaff ]---
tty_ldisc_deref: no references.
------------[ cut here ]------------
WARNING: at drivers/char/tty_ldisc.c:210 tty_ldisc_put+0x81/0x90()
Hardware name: System Product Name
Modules linked in: sunrpc af_packet snd_hda_intel snd_hda_codec snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss sg snd_pcm sr_mod cdrom 8139too snd_timer mii bitrev crc32 snd soundcore snd_page_alloc floppy ehci_hcd uhci_hcd usbcore
Pid: 1997, comm: mingetty Tainted: G        W  2.6.31-rc2 #1
Call Trace:
 [<ffffffff811642f1>] ? tty_ldisc_put+0x81/0x90
 [<ffffffff811642f1>] ? tty_ldisc_put+0x81/0x90
 [<ffffffff81037e74>] ? warn_slowpath_common+0x74/0xd0
 [<ffffffff811642f1>] ? tty_ldisc_put+0x81/0x90
 [<ffffffff81164e20>] ? tty_ldisc_hangup+0x130/0x210
 [<ffffffff8115d1ee>] ? do_tty_hangup+0xde/0x3d0
 [<ffffffff8115d50a>] ? tty_vhangup_self+0x1a/0x30
 [<ffffffff810909be>] ? sys_vhangup+0x1e/0x30
 [<ffffffff8100b3ab>] ? system_call_fastpath+0x16/0x1b
---[ end trace 2068c4982373eb00 ]---
tty_ldisc_deref: no references.
------------[ cut here ]------------
WARNING: at drivers/char/tty_ldisc.c:210 tty_ldisc_put+0x81/0x90()
Hardware name: System Product Name
Modules linked in: sunrpc af_packet snd_hda_intel snd_hda_codec snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss sg snd_pcm sr_mod cdrom 8139too snd_timer mii bitrev crc32 snd soundcore snd_page_alloc floppy ehci_hcd uhci_hcd usbcore
Pid: 1992, comm: login Tainted: G        W  2.6.31-rc2 #1
Call Trace:
 [<ffffffff811642f1>] ? tty_ldisc_put+0x81/0x90
 [<ffffffff811642f1>] ? tty_ldisc_put+0x81/0x90
 [<ffffffff81037e74>] ? warn_slowpath_common+0x74/0xd0
 [<ffffffff811642f1>] ? tty_ldisc_put+0x81/0x90
 [<ffffffff81164e20>] ? tty_ldisc_hangup+0x130/0x210
 [<ffffffff8115d1ee>] ? do_tty_hangup+0xde/0x3d0
 [<ffffffff8115d50a>] ? tty_vhangup_self+0x1a/0x30
 [<ffffffff810909be>] ? sys_vhangup+0x1e/0x30
 [<ffffffff8100b3ab>] ? system_call_fastpath+0x16/0x1b
---[ end trace 2068c4982373eb01 ]---
tty_ldisc_deref: no references.
[drm] Initialized drm 1.1.0 20060810
pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:01:00.0: setting latency timer to 64
[drm] Initialized radeon 1.30.0 20080528 for 0000:01:00.0 on minor 0
mtrr: type mismatch for c0000000,10000000 old: write-back new: write-combining
mtrr: type mismatch for c0000000,10000000 old: write-back new: write-combining
mtrr: type mismatch for c0000000,10000000 old: write-back new: write-combining
mtrr: type mismatch for c0000000,10000000 old: write-back new: write-combining
mtrr: type mismatch for c0000000,10000000 old: write-back new: write-combining
[drm] Setting GART location based on new memory map
[drm] Loading R300 Microcode
[drm] Num pipes: 1
[drm] writeback test succeeded in 1 usecs

/Mikael
