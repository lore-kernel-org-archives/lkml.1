Return-Path: <linux-kernel-owner+w=401wt.eu-S1757233AbZFTSxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233AbZFTSxx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 14:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755063AbZFTSxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 14:53:45 -0400
Received: from [212.98.175.89] ([212.98.175.89]:53639 "EHLO localdomain.by"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753305AbZFTSxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 14:53:44 -0400
Date: Sat, 20 Jun 2009 21:54:52 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Rabin Vincent <rabin@rab.in>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: BUG: scheduling while atomic
Message-ID: <20090620185452.GD3138@localdomain.by>
References: <20090619181529.GA3593@localdomain.by>
 <20090620174320.GA6791@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090620174320.GA6791@debian>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (06/20/09 23:13), Rabin Vincent wrote:
> On Fri, Jun 19, 2009 at 09:15:29PM +0300, Sergey Senozhatsky wrote:
> > Hello.
> > I see lots of "BUG: scheduling while atomic" with current kernels (started with 2.6.30-git1, 2.6.30 is ok).
> > For example (2.6.30-git14):
> 
> Looks like the net softirq (via ppp) ends up calling tty_throttle(), and
> this causes problems because of the mutex_lock() added there by
> 38db8979.  I've cc'd the tty maintainer.
>

Hello. I've tried to contact Alan Cox - alan@linux.intel.com, alan@redhat.com. 
unfortunately messages were blocked by spam filters (my fault).

-----------------------------------------------------------------
original message:
(06/13/09 01:18) BUG: scheduling while atomic: pptpgw (with attachment)
-----------------------------------------------------------------
Hello Alan.

As I can see you've patched tty recently.
---
commit c9b3976e3fec266be25c5001a70aa0a890b6c476
Author: Alan Cox <alan@redhat.com>
Date:   Fri Jan 2 13:44:56 2009 +0000

    tty: Fix PPP hang under load

    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---

I have some problems in tty + ppp.
Part of syslog (the rest is in attach):

[ 8506.042498] BUG: scheduling while atomic: pptpgw/3167/0x00000400
[ 8506.042504] Modules linked in: ppp_deflate zlib_deflate ppp_async crc_ccitt ppp_generic slhc ipv6 fuse sbp2 loop snd_hda_codec_si3054 snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd soundcore pcspkr i2c_i801 rng_core snd_page_alloc psmouse asus_laptop
serio_raw evdev led_class usbhid hid sg sd_mod sr_mod cdrom ata_generic pata_acpi ata_piix ide_pci_generic ohci1394 ieee1394 r8169 mii uhci_hcd ehci_hcd usbcore
[ 8506.042563]
[ 8506.042568] Pid: 3167, comm: pptpgw Tainted: G        W  (2.6.30-nv-git3 #7) F3JC
[ 8506.042572] EIP: 0060:[<c13e4386>] EFLAGS: 00200246 CPU: 0
[ 8506.042580] EIP is at _spin_unlock_irqrestore+0x16/0x30
[ 8506.042583] EAX: c1660040 EBX: 00200246 ECX: 00000000 EDX: 00200246
[ 8506.042586] ESI: f66b97e0 EDI: 00000001 EBP: f22ebe5c ESP: f22ebe58
[ 8506.042590]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 8506.042593] CR0: 8005003b CR2: b753c000 CR3: 36a91000 CR4: 000006d0
[ 8506.042596] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 8506.042599] DR6: ffff0ff0 DR7: 00000400
[ 8506.042601] Call Trace:
[ 8506.042609]  [<c12b92cb>] tty_ldisc_deref+0x5b/0x90
[ 8506.042615]  [<c12b2699>] tty_wakeup+0x79/0x90
[ 8506.042620]  [<c12baa23>] pty_unthrottle+0x23/0x50
[ 8506.042624]  [<c12b75f0>] tty_unthrottle+0x40/0x70
[ 8506.042628]  [<c12b571f>] n_tty_read+0x47f/0x720
[ 8506.042636]  [<c103a020>] ? default_wake_function+0x0/0x40
[ 8506.042640]  [<c12b0a28>] tty_read+0x98/0xe0
[ 8506.042644]  [<c12b52a0>] ? n_tty_read+0x0/0x720
[ 8506.042651]  [<c10e5dfb>] vfs_read+0xbb/0x1c0
[ 8506.042655]  [<c12b0990>] ? tty_read+0x0/0xe0
[ 8506.042659]  [<c10e6008>] sys_read+0x58/0xa0
[ 8506.042665]  [<c100320b>] sysenter_do_call+0x12/0x22

-----------------------------------------------------------------



> > 
> > kernel: [27404.945372] BUG: scheduling while atomic: pptpgw/4637/0x00000400
> > kernel: [27404.945378] INFO: lockdep is turned off.
> > kernel: [27404.945383] Modules linked in: ppp_deflate zlib_deflate ppp_async crc_ccitt ppp_generic slhc ipv6 fuse sbp2 loop snd_hda_codec_si3054 snd_hda_codec_realtek
> > snd_hda_intel snd_hda_codec snd_pcm snd_seq_mi
> > di snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device pcspkr snd i2c_i801 psmouse serio_raw rng_core soundcore snd_page_alloc asus_laptop evdev usbhid hid sg sr_mod
> > cdrom sd_mod sdhci_pci sdhci mmc_co
> > re ohci1394 ata_generic pata_acpi ricoh_mmc uhci_hcd led_class ata_piix ieee1394 ide_pci_generic ehci_hcd usbcore r8169 mii
> > kernel: [27404.945532] 
> > kernel: [27404.945540] Pid: 4637, comm: pptpgw Not tainted (2.6.30-dbgnv-git14 #4) F3JC                
> > kernel: [27404.945549] EIP: 0060:[<c104a3d5>] EFLAGS: 00200246 CPU: 0
> > kernel: [27404.945559] EIP is at __tasklet_schedule+0x65/0xb0
> > kernel: [27404.945566] EAX: 00000000 EBX: f6077c6c ECX: 00000000 EDX: 00000000
> > kernel: [27404.945573] ESI: 00200246 EDI: 00000001 EBP: e2807e60 ESP: e2807e54
> > kernel: [27404.945581]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> > kernel: [27404.945589] CR0: 8005003b CR2: b5f027ac CR3: 35993000 CR4: 000006d0
> > kernel: [27404.945596] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> > kernel: [27404.945603] DR6: ffff0ff0 DR7: 00000400
> > kernel: [27404.945609] Call Trace:
> > kernel: [27404.945621]  [<f90be38b>] ppp_asynctty_wakeup+0x6b/0x80 [ppp_async]
> > kernel: [27404.945632]  [<c12de902>] tty_wakeup+0x72/0x90
> > kernel: [27404.945643]  [<c12e70d3>] pty_unthrottle+0x23/0x50
> > kernel: [27404.945653]  [<c12e3b22>] tty_unthrottle+0x42/0x70
> > kernel: [27404.945663]  [<c12e1c2f>] n_tty_read+0x48f/0x730
> > kernel: [27404.945676]  [<c103e150>] ? default_wake_function+0x0/0x40
> > kernel: [27404.945688]  [<c12dcc20>] tty_read+0xa0/0xe0
> > kernel: [27404.945698]  [<c12e17a0>] ? n_tty_read+0x0/0x730
> > kernel: [27404.945709]  [<c10faf2b>] vfs_read+0xbb/0x1c0
> > kernel: [27404.945720]  [<c12dcb80>] ? tty_read+0x0/0xe0
> > kernel: [27404.945730]  [<c10fb138>] sys_read+0x58/0xa0
> > kernel: [27404.945741]  [<c100325b>] sysenter_do_call+0x12/0x32
> > 
> > /USR/SBIN/CRON[10140]: CMD (fetchmail -sk -m '/usr/bin/procmail' > /dev/null 2>&1)
> > 
> > kernel: [27729.047046] BUG: spinlock lockup on CPU#1, pppd/4636, f5928dc0
> > kernel: [27729.047060] Pid: 4636, comm: pppd Not tainted 2.6.30-dbgnv-git14 #4
> > kernel: [27729.047067] Call Trace:
> > kernel: [27729.047084]  [<c141786b>] ? printk+0x23/0x36
> > kernel: [27729.047099]  [<c125da29>] _raw_spin_lock+0x159/0x170
> > kernel: [27729.047111]  [<c141b7f2>] _spin_lock_bh+0x62/0x90
> > kernel: [27729.047130]  [<f90aabe7>] ? ppp_channel_push+0x27/0xd0 [ppp_generic]
> > kernel: [27729.047145]  [<f90aabe7>] ppp_channel_push+0x27/0xd0 [ppp_generic]
> > kernel: [27729.047159]  [<f90aad67>] ppp_write+0xd7/0xe0 [ppp_generic]
> > kernel: [27729.047172]  [<c10fac1e>] vfs_write+0xbe/0x1c0
> > kernel: [27729.047186]  [<f90aac90>] ? ppp_write+0x0/0xe0 [ppp_generic]
> > kernel: [27729.047197]  [<c10fae28>] sys_write+0x58/0xa0
> > kernel: [27729.047209]  [<c100325b>] sysenter_do_call+0x12/0x32
> > kernel: [27787.880283] SysRq : Keyboard mode set to system default
> > 
> > //Truncated. See attachment for details.
> > 
> > Hardware: ASUS F3Jc
> > 
> > Reported: http://bugzilla.kernel.org/show_bug.cgi?id=13522
> > 
> > 
> > Thanks,
> > 	Sergey
> 

//attachment has been truncated.


	Sergey
