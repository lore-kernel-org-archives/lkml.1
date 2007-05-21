Return-Path: <linux-kernel-owner+w=401wt.eu-S1758066AbXEUEui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066AbXEUEui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 00:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754860AbXEUEua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 00:50:30 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49821 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754297AbXEUEu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 00:50:29 -0400
Date: Sun, 20 May 2007 21:46:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Gerd Hoffmann" <kraxel@redhat.com>, "Andi Kleen" <ak@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]serial: make early_uart to use early_prarm instead of
 console_initcall
Message-Id: <20070520214657.fcf5e9ce.akpm@linux-foundation.org>
In-Reply-To: <86802c440705202129o6fe9fb89l47aef78e973c36c5@mail.gmail.com>
References: <200705181900.17101.yinghai.lu@sun.com>
	<20070520202332.145d93a6.akpm@linux-foundation.org>
	<86802c440705202129o6fe9fb89l47aef78e973c36c5@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2007 21:29:20 -0700 "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:

> On 5/20/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > I'll queue this up for some testing, but I'd be a bit reluctant to send it
> > into Linus due to my poor understanding of what it actually does.  What
> > _is_ an early console, and how does it differ from a non-early one?
> >
> > Someone help, please.
> >
> > Coudl you please provide a patch against
> > Documentation/kernel-parameters.txt as well?
> >
> the story:
> Bjorn refer to andi's early_printk to create one early_uart. it took
> console=uart,io,0x3f8,9600n8
> or console=uart,mem,0xfxxx,115200n8.
> and it is called via console_init. --- it is not really early uart for
> platform other than ia64.
> ia64 call early_serial_console_init explicitly, so it is some early.
> but it needs to late_initcall to do console switch.
> 
> Gerd's patch  (console handover) was merged into mainline. it will
> switch from early_printk to normal console in register_console via
> CON_BOOT flags.. ===> only for x86
> 
> I produced one patch to change early_uart calling from console_init to
> early_param. So to make early_uart to real early_uart for all other
> platform in addition to ia64.
> it will take
> earlycon=uart,io,0x3f8,9600n8 console=ttyS0,9600n8
> 
> but Bjorn said that don't let the customer to key two times about
> console command line.
> Then come this patch. will take
> earlycon=uart,io,0x3f8,9600n8
> and it will switch to console ttyS0 automatically. ---- by calling
> add_preferred_console.
> 
> Still need Bjorn to:
> 1. remove early_serial_console_init call in ia64 setup_arch.
> 2. verify mem io 8250 compatiable card.
> 
> for 2, in x86 platform we need to use fix_to_virt and fix map to give
> it one fixed virtual address. == like Eric did for usb debug port
> console.
> 
> I will send out another in email about updated early dbgp console with
> current tree.

hm, OK.  I hope you guys have it under control ;)


With http://userweb.kernel.org/~akpm/config-vmm.txt I get

drivers/built-in.o:(.data+0x5790): undefined reference to `serial8250_find_port_for_earlycon'

