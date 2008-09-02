Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbYIBVEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbYIBVEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 17:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbYIBVEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 17:04:23 -0400
Received: from mail.xtech.com.ar ([216.75.63.130]:48899 "EHLO
	mail.xtech.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbYIBVEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 17:04:22 -0400
X-Greylist: delayed 1399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Sep 2008 17:04:21 EDT
Date: Tue, 2 Sep 2008 17:40:58 -0300
From: Diego Woitasen <diego@woitasen.com.ar>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       herton@mandriva.com.br, linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc5 doesn't boot on a Pavilion laptop
Message-ID: <20080902204058.GB17488@motherbox.xtech.com.ar>
References: <20080902163532.436f8fbd@doriath.conectiva> <alpine.LFD.1.10.0809022208320.3243@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809022208320.3243@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2008 at 10:18:25PM +0200, Thomas Gleixner wrote:
> Luiz,
> 
> On Tue, 2 Sep 2008, Luiz Fernando N. Capitulino wrote:
> > 
> >  I have a HP Pavilion dv6000 laptop here which doesn't boot with
> > latest Linus tree (2.6.27-rc5).
> > 
> >  The last lines I see on the screen are:
> > 
> > """
> > hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
> > hpet0: 3 32-bit timers, 25 000000 Hz
> > """
> 
> Sigh. I'm getting sick of that :)
>  
> 
> >  Then I bisected and git says that the culprit is:
> > 
> > """
> > commit aa276e1cafb3ce9d01d1e837bcd67e92616013ac
> > Author: Thomas Gleixner <tglx@linutronix.de>
> > Date:   Mon Jun 9 19:15:00 2008 +0200
> > 
> >     x86, clockevents: add C1E aware idle function
> 
> Not surprising :)
> 
> >  Now, what puzzles me though is that if you do:
> > 
> > $ git checkout -b bla aa276e1cafb3ce9d01d1e837bcd67e92616013ac
> > 
> >  and edit the Makefile you will see that it is a 2.6.26-rc4
> > kernel! When I saw this I thought 'wth? git bisect went backwards?'
> > (I specified 2.6.26 as good and 2.6.27-rc1 as bad).
> 
> That's because the commit happened in the x86 git tree after
> 2.6.26-rc4. In fact you checked out the branch of the x86 git tree
> where the commit happened.
> 
> >  I don't know if this is known (it should be) but it seems that you
> > have changed the Makefile during the merge of that commit... But
> > I'm quite sure that this commit has been introduced in 2.6.27-rc1.
> 
> Yes, it was merged into Linus tree after 2.6.26 and before
> 2.6.27-rc1. That's how git works. It keeps track from which point a
> particular commit descended. If you look at the git tree with gitk,
> then you will see the various points where a particular branch was
> split off from Linus tree and when it was merged back.
> 
> Nothing to worry about.
>  
> >  I would try to revert it from current Linus' tree to see if it
> > really fix the problem but turns out that it will take some time
> > to work on the conflicts.
> 
> Don't do that. We really need to find out what the root cause of this
> HPET wreckage on those AMD machine is. The commit in question _IS_ the
> alleged culprit, but the root cause is something different.
> 
> >  I'm attaching the 2.6.26.3 (Mandriva kernel) and 2.6.27-rc5 (with
> > hpet=disable) dmesg files.
> > 
> >  Also, this _seems_ to be the same as reported in:
> > 
> > http://bugzilla.kernel.org/show_bug.cgi?id=11191
> 
> Yup.
>  
> >  But I'm still compiling the kernel with the appropriate config
> > options to confirm this.
> > 
> >  Please, let me know if there's anything else I can do to
> > help you debug this.
> 
> Can you please disable CONFIG_HPET ?
> 
> Thanks,
> 
> 	tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

I'm not sure if it's related, but I have similar problems with
CONFIG_NO_HZ and CONFIG_HIGH_RES_TIMERS. With the second one, the kernel
shoot a kernel panic during the boot and with both enabled or with
CONFIG_NO_HZ only crash after a while.

I have this bug from 2.5.25 and works if I boot with hpet=disable. If I
have some time this week will try a bisect.

Crash attached. I've got it with netconsole (with both optiones
enabled):

BUG: NMI Watchdog detected LOCKUP on CPU0, ip ffffffff8024af62, registers:
CPU 0 
Modules linked in: netconsole nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs dm_mod loop arc4 ecb crypto_blkcipher cryptomgr b43 rng_core mac80211 cfg80211 crc32 led_class bitrev snd_hda_intel snd_pcm_oss snd_pcm snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_timer snd_seq_device ohci1394 ohci_hcd ehci_hcd k8temp ieee1394 snd soundcore snd_page_alloc usbcore pcspkr i2c_nforce2 i2c_core psmouse ssb evdev
Pid: 0, comm: swapper Not tainted 2.6.27-rc5-porti-00016-gcc08102-dirty #9
RIP: 0010:[<ffffffff8024af62>]  [<ffffffff8024af62>] getnstimeofday+0x52/0xc0
RSP: 0018:ffffffff80659e08  EFLAGS: 00000086
RAX: ffffffff8061e800 RBX: 000000000011a78c RCX: 000000007f176538
RDX: 00000000ffffffc2 RSI: 000000007f176570 RDI: ffffffff80659e48
RBP: ffffffff80659e48 R08: ffffffff8061e780 R09: 00000000ffffffff
R10: 0000000000000000 R11: ffffffff8021db70 R12: ffffffff8061e780
R13: ffff88001b82700c R14: 0000000000000004 R15: 0000000000000000
FS:  000000004128b950(0000) GS:ffffffff80650e80(0000) knlGS:00000000f7471720
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00007f7bf13a8000 CR3: 000000000fc40000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff80658000, task ffffffff80615360)
Stack:  ffffffff8021b490 000000000011a78c ffffffff80659e48 ffffffff80249270
 ffffffff80659e58 0000000000000000 000000dbd2b6d6b8 ffffffff802492ac
 0000000048bae65f 0000000032e10398 0000000000000046 ffffffff8024e85d
Call Trace:
 [<ffffffff8021b490>] ? lapic_next_event+0x0/0x10
 [<ffffffff80249270>] ? ktime_get_ts+0x30/0x60
 [<ffffffff802492ac>] ? ktime_get+0xc/0x50
 [<ffffffff8024e85d>] ? tick_broadcast_set_event+0x4d/0x60
 [<ffffffff8024ea92>] ? tick_broadcast_oneshot_control+0x102/0x130
 [<ffffffff8024e31d>] ? tick_notify+0x2ed/0x400
 [<ffffffff80249e07>] ? notifier_call_chain+0x37/0x70
 [<ffffffff8024dc55>] ? clockevents_notify+0x25/0xa0
 [<ffffffff803fa8d7>] ? acpi_idle_enter_bm+0x138/0x386
 [<ffffffff8048e4b8>] ? cpuidle_idle_call+0xd8/0x130
 [<ffffffff8020a859>] ? cpu_idle+0x49/0xa0

00 48 f1 00 89 45 8b ee e6 48 45 8b 05 47 ff 50 48 48 8b e6 <48> 70 60 30 23 8b 48 0f f2 ee ---[ end trace 47710009e5854d1c ]---
Kernel panic - not syncing: Attempted to kill the idle task!

--------------
Diego Woitasen
--------------
