Return-Path: <linux-kernel-owner+w=401wt.eu-S1757817AbYFSKdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817AbYFSKdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 06:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755482AbYFSKdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 06:33:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57238 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462AbYFSKdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 06:33:01 -0400
Date: Thu, 19 Jun 2008 12:32:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] - Increase MAX_APICS for very large x86_64 configs
Message-ID: <20080619103242.GA13213@elte.hu>
References: <20080616170910.GA24930@sgi.com> <20080619101030.GF15228@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080619101030.GF15228@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > The patch has no effect on any 32-bit kernel. It adds ~4k to the 
> > size of 64-bit kernels but only if NR_CPUS > 255.
> > 
> > This is a repost of an earlier patch (4/16) that was implicated in a 
> > random-qa failure. I have not been able to reproduce the failure 
> > using the same boot args & config.  Best guess is that some other 
> > patch caused random data corruption & this patch was a victim.
> 
> i have just re-tested the previously failing config on tip/master:
> 
>   http://redhat.com/~mingo/misc/config-Thu_Apr_17_10_17_14_CEST_2008.bad
>   http://people.redhat.com/mingo/tip.git/README
> 
> and the good news is that it does not crash on bootup anymore. Perhaps 
> one of Mike's fixes/improvements did the trick?

unfortunately it didnt last long, -tip randconfig auto-testing found 
that your patch causes a bootup crash:

[    0.352022] SMP mode deactivated.
[    0.355356] enabled ExtINT on CPU#0
[    0.358861] SMP disabled
[    0.361829] BUG: unable to handle kernel NULL pointer dereference at 00000000000008b0
[    0.364022] IP: [<ffffffff8028127b>] debug_mutex_add_waiter+0x4e/0x61
[    0.364022] PGD 0
[    0.364022] Thread overran stack, or stack corrupted

config, log and bzImage can be found here:

  http://redhat.com/~mingo/misc/config-Thu_Jun_19_12_10_40_CEST_2008.bad
  http://redhat.com/~mingo/misc/crash-Thu_Jun_19_12_10_40_CEST_2008.log
  http://redhat.com/~mingo/misc/bzImage-Thu_Jun_19_12_10_40_CEST_2008.bad

reverting your patch fixes the crash.

if you have trouble reproducing the problem then you should be able to 
stick the bzImage into any 64-bit PC's /etc/grub.conf (no initrd needed) 
and it should just crash straight away during bootup.

NOTE: -tip auto-testing randomizes various commonly used boot parameters 
as well, you can find them in the bootup log:

root=/dev/sda6 console=ttyS0,115200 earlyprintk=serial,ttyS0,115200 
debug initcall_debug apic=verbose sysrq_always_enabled ignore_loglevel 
selinux=0 maxcpus=1 nosmp no_hz=off highres=0 nmi_watchdog=0 noapic 
nolapic_timer hpet=disable idle=mwait idle=poll highmem=512m nopat notsc 
acpi=off pci=nomsi

this might be material to reproducing the crash.

NOTE2: the bzImage above will have the above boot parameters 
auto-appended, no need for you to configure them. But if you build your 
own kernel from tip/master using the above config you might have to add 
these boot parameters to the 'kernel' line of /etc/grub.conf to 
reproduce the crash.

	Ingo
