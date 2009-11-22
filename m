Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbZKVMHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbZKVMHm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 07:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbZKVMHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 07:07:39 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:5697 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbZKVMHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 07:07:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZU+AVD+bDQiYLYNMHLzDeAhhnfEEgQySHfPA2JH2b8q0DMb/fcgwrb4wJ/sqLHUmuj
         uBjdQJY/NLecPb82q2P/VXAvXL70WMVHHzKHrU8gE7MF3eL6NY2qGDeaznWE/5Ck4100
         Fv6JGOT2vygAyfSl60yCXuGlenQYK4KUMR+Ug=
Subject: Re: RFC: Put printk buffer in video ram
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20091122023237.GA6572@nowhere>
References: <1258855506.3153.1.camel@maxim-laptop>
	 <20091122023237.GA6572@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 Nov 2009 14:07:37 +0200
Message-ID: <1258891657.3231.12.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-22 at 03:32 +0100, Frederic Weisbecker wrote: 
> On Sun, Nov 22, 2009 at 04:05:06AM +0200, Maxim Levitsky wrote:
> > After doing some successful debugging by placing printk buffer in video
> > ram, here I publish cleaned version of it.
> > 
> > I discovered that on my system video ram isn't cleared on reboot, and I
> > took advantage of that by placing printk buffer directly there.
> > This allows to capture oopses/panicks almost from everywhere.
> > It is also very simple to setup.
> > 
> > 
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
I more or less agree that printk.c isn't right place for that, but
the way I did it ensures that as soon as messages are printed, they are
in the log buffer. Doing that using early console driver might not
capture all messages. For example, for suspend/resume cycle unless 
no_console_suspend is passed, it would block output to all consoles.
Also, isn't early console only enabled before regular console kicks in?
I think there is a kconfig option to keep it, but I would like to make
this feature permanent independently.

> I would rather see it as an early console (for early printk), beside ttyS,
> vga and usb debug ports.



> 
> Also, instead of creating another debugfs entry, you could just
> trigger the trace to the ftrace ring buffer, using trace_printk()
> for example.
It isn't a bad idea, but this adds yet another requirement, this is user
will need to enable the ftrace, and know how to read this log buffer.
simple 'cat' is easier, but I am not against implementing both.


> 
> Hm?
> 
> I personally would like to see such feature as I have no serial line
> in my laptop, although I'm not sure my graphical card would be happy
> with that...
You can always use 'vesa' Xorg driver. It will only access the
framebuffer. anything beyond that is very likely to be available.

I own an nvidia device, and I patched the 'nv' driver for fixed amount
of memory.

> 
> Thanks.
> 

Best regards,
Maxim Levitsky

