Return-Path: <linux-kernel-owner+w=401wt.eu-S966394AbXEHMk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966394AbXEHMk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 08:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934367AbXEHMk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 08:40:57 -0400
Received: from mail.screens.ru ([213.234.233.54]:35785 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934206AbXEHMk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 08:40:56 -0400
Date: Tue, 8 May 2007 16:40:47 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-mm1 hwsusp: BUG at workqueue.c:106
Message-ID: <20070508124047.GA995@tv-sign.ru>
References: <20070508105528.GA86@tv-sign.ru> <20070508121232.GE1772@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508121232.GE1772@ff.dom.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08, Jarek Poplawski wrote:
>
> On 08-05-2007 12:55, Oleg Nesterov wrote:
> > On 05/08, Andrew Morton wrote:
> >> On Tue, 08 May 2007 10:57:35 +0200 Jiri Slaby <jirislaby@gmail.com> wrote:
> >>
> >>> this occured in dmesg during resuming from hwsusp in 2.6.21-mm1 (captured
> >>> through netconsole). Perfectly reproducible, it simply happens each time I
> >>> try it.
> >> Let's cc Oleg.
> >>
> >>> usb_endpoint usbdev5.1_ep00: PM: resume from 0, parent usb5 still 2
> >>> ------------[ cut here ]------------
> >>> kernel BUG at /home/l/latest/xxx/kernel/workqueue.c:106!
> >>> invalid opcode: 0000 [#1]
> >>> SMP
> >>> Modules linked in: ipv6 floppy ohci1394 ieee1394 parport_pc parport usbhid
> >>> ehci_hcd pata_acpi ff_memless sr_mod cdrom
> ...
> > queue_delayed_work().
> > 
> > Probably, cancel_delayed_work(&delayed_work->work) was called with the ->timer
> > pending. This is wrong, cancel_delayed_work() clears _PENDING unconditionally,
> 
> Maybe I miss your point, but clearing is conditional: on timer delete...
> 
> I think more suspicious is calling cancel_work_sync() for a delayed work
> (with timer pending). Or maybe some race profits from _PENDING cleared
> without locking?

Yes, of course, I meant cancel_work_sync(), sorry for the confusion.

Thanks!

So, once again, cancel_work_sync(&dwork->work) is wrong unless the timer
was stopped.

Before make-cancel_rearming_delayed_work-reliable.patch

	it requires that the @work can't be re-queued.

After
	works, but waits for the timer expiration in a busy-wait loop.

Oleg.

