Return-Path: <linux-kernel-owner+w=401wt.eu-S1764913AbXEYSrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764913AbXEYSrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 14:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763898AbXEYSrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 14:47:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:36902 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1763416AbXEYSrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 14:47:40 -0400
X-Authenticated: #8359428
X-Provags-ID: V01U2FsdGVkX1+EkDMMMe+EgE+mmdyvoik0CNb9EsmO4pe7eGMmBW
	jAczURv0d0Ctty
From: Uwe Bugla <uwe.bugla@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
Date: Fri, 25 May 2007 20:42:17 +0200
User-Agent: KMail/1.9.5
References: <20070524195616.234280@gmx.net> <200705251652.19911.mb@bu3sch.de> <20070525095618.1cd86672.akpm@linux-foundation.org>
In-Reply-To: <20070525095618.1cd86672.akpm@linux-foundation.org>
Cc: Michael Buesch <mb@bu3sch.de>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705252042.17680.uwe.bugla@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 25. Mai 2007 18:56 schrieben Sie:
> On Fri, 25 May 2007 16:52:19 +0200 Michael Buesch <mb@bu3sch.de> wrote:
> > I bet your bug is _not_ caused by ssb, but by some other breakage
> > in another subsystem. Maybe ACPI or APIC is broken? Try to boot
> > the machine without ACPI and/or APIC.
>
> It wouldn't be the first time.
>
> Uwe, please generate the `dmesg -s 1000000' output for 2.6.22-rc2 and for
> 2.6.22-rc2-mm1, feed them through `diff -u' and see if you can spot any
> interesting-looking differences in the PCI/ACPI/IRQ area.  Send both the
> files to me and I'll stick them on a server and then I'll see if we can
> hunt down the perpetrator.
>
> Thanks.

Hi everybody,

unfortunately Andrew's path can be proven to be wrong:
There is no bug in the ACPI area at all.

I reverted the following modules in 2.6.22-rc2-mm1:

--- linux-2.6.22-rc2/drivers/net/b44.c	2007-05-19 02:24:07.000000000 -0700
+++ devel/drivers/net/b44.c	2007-05-22 21:55:36.000000000 -0700

AND:

--- linux-2.6.22-rc2/drivers/net/b44.h	2007-04-25 23:42:17.000000000 -0700
+++ devel/drivers/net/b44.h	2007-05-22 21:55:36.000000000 -0700

AND:

--- linux-2.6.22-rc2/drivers/usb/host/ohci-hcd.c	2007-05-19 
02:24:07.000000000 -0700
+++ devel/drivers/usb/host/ohci-hcd.c	2007-05-22 21:55:36.000000000 -0700

AND:

--- /dev/null	2007-05-07 19:14:32.301975000 -0700
+++ devel/drivers/usb/host/ohci-ssb.c	2007-05-22 21:55:36.000000000 -0700


RESULT:

Broadcom 4401 is working purrfectly! YUP!

Apart from that the kernel configuration menu of 2.6.22-rc2-mm1 is highly 
confusing:

Kernel Config differences:

In kernel 2.6.21.2 you are bound to go:

EISA, VLB, PCI and onboard controllers Y

Broadcom 4400 ethernet support m


Whereas in Kernel 2.6.22-rc2-mm1 is completely confusing:

1. There is a menu called Sonics Silicon Backplane, which does not
exist in 2.6.21.2.

2. In Section Network device support Y
Ethernet (10 or 100Mbit) Y

you got 2 confusing choices:

Option A:
EISA, VLB, PCI and onboard controllers Y

Broadcom 4400 ethernet support m

Broadcom 4400 PCI device support y

This enables "Sonic Silicon Backplane support m"

OR, and this is in fact confusing:

Option B:

Leave OUT (!!!) EISA, VLB, PCI and onboard controllers Y

Simply: Broadcom 4400 ethernet support m

This enables "Sonic Silicon Backplane support m"

Option B is proved to be working with the patch against the b44.c module
reverted  in 2.6.22-rc2-mm1.

If it is NOT reverted, Option B fails, but the confusion stays:

You do not get the idea whether

"Support for SSB on PCI bus host m" is necessary or not!

And above that, THIS ONE:

"Broadcom 4400 ethernet support m"

should never appear when THIS one:

"EISA, VLB, PCI and onboard controllers Y"

is DESELECTED, should it??

And that's it exactly what I meant when I mentioned that the ATTACHMENT of ssb 
to b44 is highly buggy!

I hope, Michael, that you believe that now.

If you need lspci -v or / and dmesg to prove that I am right and you are 
wrong:

Pleasure for me, just ask please!

Cheers

Uwe

P. S.: In clear words:

I higly suspect that simply the kernel config bindings are highly buggy and 
chaotic.
