Return-Path: <linux-kernel-owner+w=401wt.eu-S1756549AbYJNG4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbYJNG4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 02:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbYJNG4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 02:56:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44855 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbYJNG4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 02:56:22 -0400
Date: Tue, 14 Oct 2008 08:55:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Dmitry Torokhov <dtor@insightbb.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.27-git-a447c093244] BUG: spinlock bad magic on CPU#0,
	setserial/3527
Message-ID: <20081014065541.GA11047@elte.hu>
References: <200810140005.39852.rjw@sisk.pl> <20081013235013.17e3106b@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081013235013.17e3106b@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Tue, 14 Oct 2008 00:05:39 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > Hi,
> > 
> > The Linus' tree from today on Asus L5D:
> > 
> > BUG: spinlock bad magic on CPU#0, setserial/3527
> >  lock: ffffffff80dae020, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
> > Pid: 3527, comm: setserial Not tainted 2.6.27-git #57
> 
> Yep looking at that at the moment. Its a fallout from dropping the 
> NR_IRQ removal changes from the serial tree just before merging I 
> think. Was done to make life simpler for Ingo's code push but appears 
> to have slightly backfired.

i too have triggered it:

[   31.099528] BUG: spinlock bad magic on CPU#1, agetty/2608
[   31.101013]  lock: ffffffff8182b020, .magic: 00000000, .owner: agetty/2608, .owner_cpu: 1
[   31.101013] Pid: 2608, comm: agetty Not tainted 2.6.27-tip-03409-g064a754-dirty #42476
[   31.101013] Call Trace:
[   31.101013]  [<ffffffff8041ee15>] spin_bug+0xa2/0xaa
[   31.101013]  [<ffffffff8041ee3e>] _raw_spin_unlock+0x21/0x8a
[   31.101013]  [<ffffffff8089aac5>] _spin_unlock_irq+0x2b/0x36
[   31.101013]  [<ffffffff804a9a7b>] serial8250_startup+0x3f2/0x5a3
[   31.101013]  [<ffffffff804a5b00>] uart_startup+0xa0/0x14b
[   31.101013]  [<ffffffff804a6a5a>] uart_open+0x1a8/0x3f7
[   31.101013]  [<ffffffff8089aafb>] ? _spin_unlock+0x2b/0x2f
[   31.101013]  [<ffffffff8047ec6a>] tty_open+0x2db/0x41c
[   31.101013]  [<ffffffff802ac383>] chrdev_open+0x130/0x151
[   31.101013]  [<ffffffff8089aafb>] ? _spin_unlock+0x2b/0x2f
[   31.101013]  [<ffffffff802ac253>] ? chrdev_open+0x0/0x151
[   31.101013]  [<ffffffff802a7e38>] __dentry_open+0x178/0x274
[   31.101013]  [<ffffffff802a7f67>] nameidata_to_filp+0x33/0x44
[   31.101013]  [<ffffffff802b43df>] do_filp_open+0x3be/0x753
[   31.101013]  [<ffffffff802beb11>] ? alloc_fd+0x101/0x110
[   31.101013]  [<ffffffff8027d9c9>] ? trace_hardirqs_off+0x1e/0x20
[   31.101013]  [<ffffffff8089aafb>] ? _spin_unlock+0x2b/0x2f
[   31.101013]  [<ffffffff802beb11>] ? alloc_fd+0x101/0x110
[   31.101013]  [<ffffffff802a7bce>] do_sys_open+0x58/0xdf
[   31.101013]  [<ffffffff802a7c88>] sys_open+0x20/0x22
[   31.101013]  [<ffffffff8020c1cb>] system_call_fastpath+0x16/0x1b
[   31.405014] eth1: no IPv6 routers present
[   32.947611] ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18

can test any patch for you if it's not easy to reproduce there.

	Ingo
