Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808AbZKVMPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbZKVMPE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 07:15:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbZKVMPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 07:15:03 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:29635 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbZKVMPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 07:15:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=xC2mkQWVabqbV+oAIDrVXLFfA0kueJ48xDzhwgJw25ijW6uz59GtK42PQJvXrD5cDg
         95UkubeTCjt6AUfKsyHCK4fBmOX414OI9mhBBJGXXaBnG7Uo6RiXiLtyxGGetIh17nkf
         nx8XuC0JhjsrocKz1uFgVOmlNY7rqVCFP5RrU=
Subject: Re: RFC: Put printk buffer in video ram
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Dave Jones <davej@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20091122082511.GC24558@elte.hu>
References: <1258855506.3153.1.camel@maxim-laptop>
	 <20091122023237.GA6572@nowhere>  <20091122082511.GC24558@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 Nov 2009 14:15:01 +0200
Message-ID: <1258892101.3231.20.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-22 at 09:25 +0100, Ingo Molnar wrote: 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Sun, Nov 22, 2009 at 04:05:06AM +0200, Maxim Levitsky wrote:
> > > After doing some successful debugging by placing printk buffer in video
> > > ram, here I publish cleaned version of it.
> > > 
> > > I discovered that on my system video ram isn't cleared on reboot, and I
> > > took advantage of that by placing printk buffer directly there.
> > > This allows to capture oopses/panicks almost from everywhere.
> > > It is also very simple to setup.
> 
> The idea is very, very nice!
> 
> If implemented cleanly and with a few more usability fixes this could be 
> a killer feature for laptop debugging. Persistent storage across reboots 
> - that's really nice.
> 
> ( It wont help us debug crashes that require a power cycle - so it
>   probably will not help with s2ram failure debugging - but still it 
>   widens the scope of printk based logging to critical crash scenarios: 
>   early bootup crashes can be debugged via it and panics can be debugged 
>   via it as well - as long as panic_timeout still works. )
> 
> > > Best regards,
> > > Maxim Levitsky
> > > 
> > > ---
> > > 
> > > >From 77e0f4ffc531417d54ce928ade8481d82192b012 Mon Sep 17 00:00:00 2001
> > > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > > Date: Sun, 22 Nov 2009 03:49:04 +0200
> > > Subject: [PATCH] printk: Allow to store log buffer into video memory
> > > 
> > > This patch adds new kernel parameter printk_address=
> > > that will allow it to store the printk buffer in arbitary
> > > (I/O) memory address.
> > > 
> > > If you own a system that has discrete video ram, and it
> > > isn't cleared automatically by BIOS on reboot, you
> > > can use this as a black box recorder of crashes.
> > > 
> > > If debugfs is enabled, log of last boot is copied into
> > > system ram, and can be accessed via debugfs, for example
> > > cat /sys/kernel/debug/printk/crash_dmesg
> > > 
> > > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> > > ---
> > >  kernel/printk.c   |  102 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  lib/Kconfig.debug |   31 ++++++++++++++++
> > >  2 files changed, 133 insertions(+), 0 deletions(-)
> > 
> > 
> > 
> > kernel/printk.c does not seem to be the right place to do that
> > but rather in a specific console driver.
> > I would rather see it as an early console (for early printk), beside ttyS,
> > vga and usb debug ports.
> > 
> > Also, instead of creating another debugfs entry, you could just
> > trigger the trace to the ftrace ring buffer, using trace_printk()
> > for example.
> > 
> > Hm?
> > 
> > I personally would like to see such feature as I have no serial line
> > in my laptop, although I'm not sure my graphical card would be happy
> > with that...
> 
> I'd like to make it easy for distros to pipe regular printk's into this 
> buffer as well - and not tie it to some hassle-to-set-up early printk 
> mechanism. (early printk should tie into it too, to make it easier to 
> debug early crashes. User first boots into a kernel that crashes - then 
> can 'recover' the crashlog on a known-good kernel.)
> 
> But i agree with your observation that the hw dependent bits should not 
> go into kernel/printk.c - but this could be done cleanly at the console 
> driver level and be added to the VGA driver.
Same question, will this always work?
I would like the kernel buffer always to go into the video ram, but
there is a chance that console driver won't be called (during
suspend/resume for example) 
How to do that?

> 
> It should probably also tie into KMS/GEM to make sure it does not stomp 
> over video RAM that the GX driver might be using.

I have here an nvidia card.
Hooking this feature into kms would be really nice, but currently is
only useful for AMD users. I haven't yet tried nouveau driver, but I
think it isn't yet stable enough to be used.


> 
> Furthermore, the printk_address=xyz boot parameter is way too difficult 
> for users to get right. This should be done as automatically as possible 
> - and the 'previous' printk buffer should be dumped into the 'next' 
> printk buffer during bootup. (preserving it for the regular syslog in a 
> compatible way and for kerneloops, etc.)
This isn't a bad idea at all, I add that feature.


> 
> Creating a new /sys output channel just delays the adoption of such a 
> feature forever. It should be part of the printk infrastructure, 
> enable-able via a .config option but automatic otherwise.
Agree.


Best regards,
Maxim Levitsky

