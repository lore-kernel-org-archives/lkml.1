Return-Path: <linux-kernel-owner+w=401wt.eu-S1761254AbYJMNd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761254AbYJMNd0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 09:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757592AbYJMNdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 09:33:17 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:45848 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756014AbYJMNdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 09:33:16 -0400
Date: Mon, 13 Oct 2008 15:33:18 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Anders Blomdell <anders.blomdell@control.lth.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make ATNGW100 serial ports configurable
Message-ID: <20081013153318.7ed8e8d8@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <48F3473E.6070305@control.lth.se>
References: <48EF6762.2080205@control.lth.se>
	<20081010165814.1c62eabf@hskinnemo-gx745.norway.atmel.com>
	<48EF7949.4010108@control.lth.se>
	<20081013122727.7298bd4a@hskinnemo-gx745.norway.atmel.com>
	<48F32899.5000006@control.lth.se>
	<20081013143447.5e0519b3@hskinnemo-gx745.norway.atmel.com>
	<48F3473E.6070305@control.lth.se>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 13 Oct 2008 13:33:01.0460 (UTC) FILETIME=[369F5540:01C92D38]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anders Blomdell <anders.blomdell@control.lth.se> wrote:
> Haavard Skinnemoen wrote:
> > Adding EXPORT_SYMBOLs purely for use by out-of-tree modules is
> > generally frowned upon. 
> If I'm not mistaken, you need EXPORT_SYMBOL for any loadable module, be it in-
> or out-of-tree.

Yes, but no in-kernel modules need those symbols exported.

> >And patching in an additional file to the build is just about the easiest
> >thing you can do.
> Next to config options and loadable modules out-of-tree :-)

Really? I personally think out-of-tree modules is a real hassle causing
extra work each time I need to update the kernel, whether it's on my
embedded target or my PC.

On the other hand, a trivial patch adding support for an expansion
board can just stay in your tree while you do a 'git pull' to grab the
most up-to-date kernel.

Even better, if you send your trivial patch upstream, it will just be
there the next time you update your kernel. No need to do anything
extra at all.

A Kconfig option is admittedly just as easy, but with the added
downside that it makes the board code less readable, and there will
never be enough of them to support every board mod that people make.

> >>> What _I_ think would be a nicer way to do it is to implement support
> >>> for flattened device trees and get rid of the board code entirely. Or
> >>> almost entirely; it depends on how complete we can make the device tree.
> >> I don't understand the above paragraph, could you please elaborate?
> > 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/powerpc/booting-without-of.txt;h=de4063cb4fdc0ad6abea29d766cae78616837311;hb=HEAD
> OK, essentially compile all drivers into the kernel and let the boot-loader tell
> us what to activate. Gives a small kernel bloat (which I can live with), but
> what if two conflicting drivers (e.g. same I/O pin) are selected by the
> flattened tree?

That's how it works today, except that it's the board code which
specifies what to activate instead of the boot loader (or a device tree
blob in flash.) So there won't be any additional bloat unless you
go and select lots of drivers you don't need.

On the other hand, these functions are currently __init, so if we
export them for use by modules, it will definitely bloat the kernel.

> But I take your replies that you are adamantly against kernel options for the
> atngw100, so I'll drop the subject for now (letting everyone figure out their
> favorite way to configure modified boards).

I'm not fundamentally against kernel options for the atngw100. I just
don't like cluttering up the board code.

If you add support for an expansion board, you'll definitely need a
config option to select it as well. But that option is only used to
select the implementation file for that board; it won't add any
additional mess to the core NGW100 code.

Have a look at the EVKLCD10x code that was just applied for an example
of how to add support for an expansion board:

http://git.kernel.org/?p=linux/kernel/git/hskinnemoen/avr32-2.6.git;a=commitdiff;h=a3bee42f058c2f9fe281df942eff397924630a12

Most of it is LCD-related, so if you only need to add a USART, you'll
only need a fraction of the code.

Also note that it shows a huge problem with the Kconfig approach: Most
devices need additional board-specific data. And even though the USART
doesn't currently need any of that, it may in the future when we add
support for RS485, hardware flow control, etc. How will you deal with
that through Kconfig?

Haavard
