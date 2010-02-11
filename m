Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab0BKPBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 10:01:50 -0500
Received: from kroah.org ([198.145.64.141]:51472 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755837Ab0BKPBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 10:01:48 -0500
Date: Thu, 11 Feb 2010 07:01:00 -0800
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Valdis.Kletnieks@vt.edu, Len Brown <lenb@kernel.org>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: mmotm 2010-02-10 - lockdep whinge in ACPI code
Message-ID: <20100211150100.GA23984@kroah.com>
References: <201002110043.o1B0hKxW008835@imap1.linux-foundation.org> <5114.1265865104@localhost> <20100210212655.7784dc5b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100210212655.7784dc5b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 10, 2010 at 09:26:55PM -0800, Andrew Morton wrote:
> On Thu, 11 Feb 2010 00:11:44 -0500 Valdis.Kletnieks@vt.edu wrote:
> 
> > On Wed, 10 Feb 2010 16:17:41 PST, akpm@linux-foundation.org said:
> > > The mm-of-the-moment snapshot 2010-02-10-16-17 has been uploaded to
> > > 
> > >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > Seen at boot:
> > 
> > [    0.207242] ACPI: (supports S0 S5)
> > [    0.207257] ACPI: Using IOAPIC for interrupt routing
> > [    0.335315] 
> > [    0.335316] =============================================
> > [    0.335483] [ INFO: possible recursive locking detected ]
> > [    0.335572] 2.6.33-rc7-mmotm0210 #1
> > [    0.335658] ---------------------------------------------
> > [    0.335746] swapper/1 is trying to acquire lock:
> > [    0.335834]  (&dev->mutex){+.+...}, at: [<ffffffff812eb521>] __driver_attach+0x47/0x80
> > [    0.335999] 
> > [    0.335999] but task is already holding lock:
> > [    0.335999]  (&dev->mutex){+.+...}, at: [<ffffffff812eb513>] __driver_attach+0x39/0x80
> > [    0.335999] 
> > [    0.335999] other info that might help us debug this:
> > [    0.335999] 1 lock held by swapper/1:
> > [    0.335999]  #0:  (&dev->mutex){+.+...}, at: [<ffffffff812eb513>] __driver_attach+0x39/0x80
> > [    0.335999] 
> > [    0.335999] stack backtrace:
> > [    0.335999] Pid: 1, comm: swapper Not tainted 2.6.33-rc7-mmotm0210 #1
> > [    0.335999] Call Trace:
> > [    0.335999]  [<ffffffff81063b47>] __lock_acquire+0xc77/0xcee
> > [    0.335999]  [<ffffffff81061fad>] ? mark_lock+0x2d/0x22c
> > [    0.335999]  [<ffffffff812eb521>] ? __driver_attach+0x47/0x80
> > [    0.335999]  [<ffffffff81063c89>] lock_acquire+0xcb/0xe8
> > [    0.335999]  [<ffffffff812eb521>] ? __driver_attach+0x47/0x80
> > [    0.335999]  [<ffffffff810621fe>] ? mark_held_locks+0x52/0x70
> > [    0.335999]  [<ffffffff81568c9d>] __mutex_lock_common+0x5c/0x5aa
> > [    0.335999]  [<ffffffff812eb521>] ? __driver_attach+0x47/0x80
> > [    0.335999]  [<ffffffff815583f8>] ? klist_next+0x24/0xd7
> > [    0.335999]  [<ffffffff812eb521>] ? __driver_attach+0x47/0x80
> > [    0.335999]  [<ffffffff812eb4da>] ? __driver_attach+0x0/0x80
> > [    0.335999]  [<ffffffff81569291>] mutex_lock_nested+0x34/0x39
> > [    0.335999]  [<ffffffff812eb521>] __driver_attach+0x47/0x80
> > [    0.335999]  [<ffffffff812eb4da>] ? __driver_attach+0x0/0x80
> > [    0.335999]  [<ffffffff812eb4da>] ? __driver_attach+0x0/0x80
> > [    0.335999]  [<ffffffff812eaa43>] bus_for_each_dev+0x54/0x89
> > [    0.335999]  [<ffffffff812eb28a>] driver_attach+0x19/0x1b
> > [    0.335999]  [<ffffffff812eaed5>] bus_add_driver+0xb4/0x203
> > [    0.335999]  [<ffffffff812eb833>] driver_register+0xb8/0x129
> > [    0.335999]  [<ffffffff81231604>] acpi_bus_register_driver+0x3e/0x40
> > [    0.335999]  [<ffffffff81b45094>] acpi_ec_init+0x37/0x55
> > [    0.335999]  [<ffffffff81b44ef1>] acpi_init+0x115/0x12a
> > [    0.335999]  [<ffffffff81b44ddc>] ? acpi_init+0x0/0x12a
> > [    0.335999]  [<ffffffff810001ef>] do_one_initcall+0x59/0x14e
> > [    0.335999]  [<ffffffff81b26655>] kernel_init+0x14d/0x1a3
> > [    0.335999]  [<ffffffff81003354>] kernel_thread_helper+0x4/0x10
> > [    0.335999]  [<ffffffff8156b0c0>] ? restore_args+0x0/0x30
> > [    0.335999]  [<ffffffff81b26508>] ? kernel_init+0x0/0x1a3
> > [    0.335999]  [<ffffffff81003350>] ? kernel_thread_helper+0x0/0x10
> > [    0.340036] ACPI: EC: GPE = 0x11, I/O: command/status = 0x934, data = 0x930
> > 
> 
> driver_attach() got converted from sem to mutex in linux-next.  So this
> is probably an old bug which just got exposed.

Odds are it is not a bug, I need to revert that patch as it does not
work well (i.e. at all) with lockdep.

thanks,

greg k-h
