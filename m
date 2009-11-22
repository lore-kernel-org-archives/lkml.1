Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbZKVIZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbZKVIZV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 03:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbZKVIZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 03:25:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60860 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446AbZKVIZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 03:25:20 -0500
Date: Sun, 22 Nov 2009 09:25:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Dave Jones <davej@redhat.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RFC: Put printk buffer in video ram
Message-ID: <20091122082511.GC24558@elte.hu>
References: <1258855506.3153.1.camel@maxim-laptop>
 <20091122023237.GA6572@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091122023237.GA6572@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Sun, Nov 22, 2009 at 04:05:06AM +0200, Maxim Levitsky wrote:
> > After doing some successful debugging by placing printk buffer in video
> > ram, here I publish cleaned version of it.
> > 
> > I discovered that on my system video ram isn't cleared on reboot, and I
> > took advantage of that by placing printk buffer directly there.
> > This allows to capture oopses/panicks almost from everywhere.
> > It is also very simple to setup.

The idea is very, very nice!

If implemented cleanly and with a few more usability fixes this could be 
a killer feature for laptop debugging. Persistent storage across reboots 
- that's really nice.

( It wont help us debug crashes that require a power cycle - so it
  probably will not help with s2ram failure debugging - but still it 
  widens the scope of printk based logging to critical crash scenarios: 
  early bootup crashes can be debugged via it and panics can be debugged 
  via it as well - as long as panic_timeout still works. )

> > Best regards,
> > Maxim Levitsky
> > 
> > ---
> > 
> > >From 77e0f4ffc531417d54ce928ade8481d82192b012 Mon Sep 17 00:00:00 2001
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > Date: Sun, 22 Nov 2009 03:49:04 +0200
> > Subject: [PATCH] printk: Allow to store log buffer into video memory
> > 
> > This patch adds new kernel parameter printk_address=
> > that will allow it to store the printk buffer in arbitary
> > (I/O) memory address.
> > 
> > If you own a system that has discrete video ram, and it
> > isn't cleared automatically by BIOS on reboot, you
> > can use this as a black box recorder of crashes.
> > 
> > If debugfs is enabled, log of last boot is copied into
> > system ram, and can be accessed via debugfs, for example
> > cat /sys/kernel/debug/printk/crash_dmesg
> > 
> > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> > ---
> >  kernel/printk.c   |  102 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  lib/Kconfig.debug |   31 ++++++++++++++++
> >  2 files changed, 133 insertions(+), 0 deletions(-)
> 
> 
> 
> kernel/printk.c does not seem to be the right place to do that
> but rather in a specific console driver.
> I would rather see it as an early console (for early printk), beside ttyS,
> vga and usb debug ports.
> 
> Also, instead of creating another debugfs entry, you could just
> trigger the trace to the ftrace ring buffer, using trace_printk()
> for example.
> 
> Hm?
> 
> I personally would like to see such feature as I have no serial line
> in my laptop, although I'm not sure my graphical card would be happy
> with that...

I'd like to make it easy for distros to pipe regular printk's into this 
buffer as well - and not tie it to some hassle-to-set-up early printk 
mechanism. (early printk should tie into it too, to make it easier to 
debug early crashes. User first boots into a kernel that crashes - then 
can 'recover' the crashlog on a known-good kernel.)

But i agree with your observation that the hw dependent bits should not 
go into kernel/printk.c - but this could be done cleanly at the console 
driver level and be added to the VGA driver.

It should probably also tie into KMS/GEM to make sure it does not stomp 
over video RAM that the GX driver might be using.

Furthermore, the printk_address=xyz boot parameter is way too difficult 
for users to get right. This should be done as automatically as possible 
- and the 'previous' printk buffer should be dumped into the 'next' 
printk buffer during bootup. (preserving it for the regular syslog in a 
compatible way and for kerneloops, etc.)

Creating a new /sys output channel just delays the adoption of such a 
feature forever. It should be part of the printk infrastructure, 
enable-able via a .config option but automatic otherwise.

	Ingo
