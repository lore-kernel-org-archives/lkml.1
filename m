Return-Path: <linux-kernel-owner+w=401wt.eu-S1757352AbYCGKef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352AbYCGKef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 05:34:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbYCGKeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 05:34:25 -0500
Received: from www.tglx.de ([62.245.132.106]:47007 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbYCGKeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 05:34:24 -0500
Date: Fri, 7 Mar 2008 11:33:44 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Diego Woitasen <diego@woitasen.com.ar>
cc: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Venkatesch Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: BUG: High resolution timer/dynticks bug
In-Reply-To: <20080306225006.GA2972@motherbox.xtech.com.ar>
Message-ID: <alpine.LFD.1.00.0803071113340.3099@apollo.tec.linutronix.de>
References: <20080303010753.GB3512@motherbox.xtech.com.ar> <20080304110900.GA23227@elf.ucw.cz> <20080304230032.GA2967@motherbox.xtech.com.ar> <20080305082731.GA24004@atrey.karlin.mff.cuni.cz> <20080306225006.GA2972@motherbox.xtech.com.ar>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2008, Diego Woitasen wrote:
> NMI Watchdog detected LOCKUP on CPU 0
> CPU 0 
> Modules linked in: netconsole configfs fan ebtable_broute bridge llc ebtable_nat ebtable_filter ebtables dm_snapshot dm_mirror dm_mod powernow_k8 loop arc4 snd_hda_intel ecb crypto_blkcipher cryptomgr snd_pcm_oss snd_pcm snd_mixer_oss b43 mac80211 cfg80211 crc32 snd_seq_dummy snd_seq_oss firmware_class snd_seq_midi_event ieee80211softmac snd_seq ieee80211 ieee80211_crypt snd_timer snd_seq_device i2c_nforce2 sdhci rng_core ohci1394 snd i2c_core battery ac thermal processor forcedeth mmc_core psmouse ssb ieee1394 button soundcore snd_page_alloc ehci_hcd ohci_hcd usbcore
> Pid: 0, comm: swapper Not tainted 2.6.25-rc3-porti-00081-g7704a8b #18
> RIP: 0010:[<ffffffff80220799>]  [<ffffffff80220799>] hpet_readl+0x9/0x10
> RSP: 0018:ffffffff805e3e00  EFLAGS: 00000086
> RAX: 00000000706c47ea RBX: 000000000002f3f4 RCX: 0000000000000020
> RDX: 00000000ffffffc2 RSI: ffffffff805abcc0 RDI: ffffffffff5fc0f0
> RBP: ffffffff805e3e48 R08: ffffffff805abcc0 R09: 0000000000000000
> R10: 0000000000000000 R11: ffffffff80221010 R12: ffffffff805abcc0
> R13: ffff81001cdf700c R14: 0000000000000004 R15: 0000000000000000
> FS:  00007feeb1b826e0(0000) GS:ffffffff805da000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 00007feeb1b83315 CR3: 00000000155ea000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 0, threadinfo ffffffff805e2000, task ffffffff805a5320)
> Stack:  ffffffff80249c33 ffffffff8021cec0 000000000002f3f4 ffffffff805e3e48
>  ffffffff80247b9b ffffffff805e3e58 0000000000000000 00000039937b9f0c
>  ffffffff80247bdc 0000000047c75913 0000000022adcfd4 0000000000000000
> Call Trace:
>  [<ffffffff80249c33>] ? getnstimeofday+0x33/0xa0
>  [<ffffffff8021cec0>] ? lapic_next_event+0x0/0x10
>  [<ffffffff80247b9b>] ? ktime_get_ts+0x1b/0x50
>  [<ffffffff80247bdc>] ? ktime_get+0xc/0x50
>  [<ffffffff8024cfa5>] ? tick_broadcast_set_event+0x25/0x50
>  [<ffffffff8024d60e>] ? tick_broadcast_oneshot_control+0xfe/0x120
>  [<ffffffff8024cc8d>] ? tick_notify+0x2cd/0x3c0
>  [<ffffffff802486b1>] ? notifier_call_chain+0x51/0x70
>  [<ffffffff8024c698>] ? clockevents_notify+0x18/0xa0
>  [<ffffffff880a2e31>] ? :processor:acpi_idle_enter_bm+0x10f/0x31a

All those traces originate from acpi_idle_enter_bm(). This rings a bell:

We had a similar problem when the tick notification was after the
point where we disabled bus mastering. This is fixed, but I wonder if
there is some relationship.

Can you please provide the output of /proc/acpi/processor/CPU0/power
with and without AC power connected ?

Is the problem reproducible when you add "clocksource=acpi_pm" to the
kernel command line ?

Is the problem reproducible when you add "hpet=disable" to the kernel
command line ?

Thanks,

	tglx
