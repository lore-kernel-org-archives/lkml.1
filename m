Return-Path: <linux-kernel-owner+w=401wt.eu-S1765646AbXGVWRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765646AbXGVWRS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 18:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757586AbXGVWRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 18:17:10 -0400
Received: from brick.kernel.dk ([80.160.20.94]:20640 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757932AbXGVWRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 18:17:09 -0400
Date: Mon, 23 Jul 2007 00:17:18 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: wharms@bfs.de, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: crash with 2.6.22.1 crash:ll_rw_blk.c blk_remove_plug()
Message-ID: <20070722221717.GV11657@kernel.dk>
References: <469DD37C.8050200@bfs.de> <20070718103342.GI11657@kernel.dk> <469DF233.5080902@bfs.de> <20070718110724.GN11657@kernel.dk> <469E072E.7080400@bfs.de> <20070718123142.GV11657@kernel.dk> <46A38B1E.3090605@bfs.de> <a781481a0707221020m3c3a397fifa9076aefc63148a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0707221020m3c3a397fifa9076aefc63148a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22 2007, Satyam Sharma wrote:
> Hi Walter,
>
> Thanks for reporting this.
>
> On 7/22/07, walter harms <wharms@bfs.de> wrote:
>> hello all,
>> on my asus notebook tm620 there is a crash with 2.6.22 and 2.6.21
>
> Did this happen when you were resuming from a suspend-to-ram/disk?
> [ I ask because I see swsusp in the trace below, linux-pm added to Cc: ]
>
>> ....
>> Using IPI Shortcut mode
>> WARNING: at block/ll_rw_blk.c:1575 blk_remove_plug()
>>  [<c01ac87e>] blk_remove_plug+0x36/0x5a
>>  [<c01ac8b6>] __generic_unplug_device+0x14/0x1f
>>  [<c01ad587>] __make_request+0x39b/0x49c
>>  [<c01abc8c>] generic_make_request+0x228/0x255
>>  [<c01adb54>] submit_bio+0xa5/0xac
>>  [<c013e233>] mempool_alloc+0x37/0xae
>>  [<c01314dc>] submit+0xc2/0x11d
>>  [<c0131585>] bio_read_page+0x24/0x27
>>  [<c013188b>] swsusp_check+0x4f/0xaf
>>  [<c012f6c2>] software_resume+0x5f/0x108
>>  [<c037867e>] kernel_init+0xb0/0x212
>>  [<c0103a16>] ret_from_fork+0x6/0x1c
>>  [<c03785ce>] kernel_init+0x0/0x212
>>  [<c03785ce>] kernel_init+0x0/0x212
>>  [<c010465b>] kernel_thread_helper+0x7/0x10
>>  =======================
>
> Surprising, that's a WARN_ON(!irqs_disabled()) but IRQs are disabled
> alright on that codepath. OTOH, __make_request() is heavily goto-driven,
> uses the non-save/restore variants of spin_lock_irq, and does not even
> balance locks / unlocks for some error paths ... gaah.

__make_request() must be called from process context, hence
spin_lock_irq() is perfectly already and the fastest way to go. And of
course the locking is balanced! So please save your 'gaah's for code
you actually took the time to try and understand.

But it does look like unbalanced irq disable/enable calls. I'd guess in
the suspend/resume path. Obviously something more esoteric, since this
is the first such report for 2.6.22, so like some not-very-used driver
for instance.

-- 
Jens Axboe

