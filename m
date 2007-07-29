Return-Path: <linux-kernel-owner+w=401wt.eu-S1765886AbXG2PtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765886AbXG2PtS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763479AbXG2PtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 11:49:08 -0400
Received: from mx.fr.bfs.de ([194.95.226.137]:39611 "EHLO mail.fr.bfs.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763786AbXG2PtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 11:49:06 -0400
Message-ID: <46ACB6EB.40101@bfs.de>
Date: Sun, 29 Jul 2007 17:48:59 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: crash with 2.6.22.1 crash:ll_rw_blk.c blk_remove_plug()
References: <469DD37C.8050200@bfs.de> <20070718103342.GI11657@kernel.dk> <469DF233.5080902@bfs.de> <20070718110724.GN11657@kernel.dk> <469E072E.7080400@bfs.de> <20070718123142.GV11657@kernel.dk> <46A38B1E.3090605@bfs.de> <a781481a0707221020m3c3a397fifa9076aefc63148a@mail.gmail.com> <20070722221717.GV11657@kernel.dk> <a781481a0707241722y5ef33a72qe61d5f4299cff273@mail.gmail.com> <20070725111836.GR3287@kernel.dk>
In-Reply-To: <20070725111836.GR3287@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------050903090904060002070103"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050903090904060002070103
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>>>> On 7/22/07, walter harms <wharms@bfs.de> wrote:
>>>>> hello all,
>>>>> on my asus notebook tm620 there is a crash with 2.6.22 and 2.6.21
>>>> Did this happen when you were resuming from a suspend-to-ram/disk?
>>>> [ I ask because I see swsusp in the trace below, linux-pm added to Cc: ]
>>>>
>>>>> ....
>>>>> Using IPI Shortcut mode
>>>>> WARNING: at block/ll_rw_blk.c:1575 blk_remove_plug()
>>>>>  [<c01ac87e>] blk_remove_plug+0x36/0x5a
>>>>>  [<c01ac8b6>] __generic_unplug_device+0x14/0x1f
>>>>>  [<c01ad587>] __make_request+0x39b/0x49c
>>>>>  [<c01abc8c>] generic_make_request+0x228/0x255
>>>>>  [<c01adb54>] submit_bio+0xa5/0xac
>>>>>  [<c013e233>] mempool_alloc+0x37/0xae
>>>>>  [<c01314dc>] submit+0xc2/0x11d
>>>>>  [<c0131585>] bio_read_page+0x24/0x27
>>>>>  [<c013188b>] swsusp_check+0x4f/0xaf
>>>>>  [<c012f6c2>] software_resume+0x5f/0x108
>>>>>  [<c037867e>] kernel_init+0xb0/0x212
>>>>>  [<c0103a16>] ret_from_fork+0x6/0x1c
>>>>>  [<c03785ce>] kernel_init+0x0/0x212
>>>>>  [<c03785ce>] kernel_init+0x0/0x212
>>>>>  [<c010465b>] kernel_thread_helper+0x7/0x10
>>>>>  =======================
>>>> Surprising, that's a WARN_ON(!irqs_disabled()) but IRQs are disabled
>>>> alright on that codepath. OTOH, __make_request() is heavily goto-driven,
>>>> uses the non-save/restore variants of spin_lock_irq, and does not even
>>>> balance locks / unlocks for some error paths ... gaah.
>>> __make_request() must be called from process context, hence
>>> spin_lock_irq() is perfectly already and the fastest way to go. And of
>>> course the locking is balanced! So please save your 'gaah's for code
>>> you actually took the time to try and understand.
>> You're right, I didn't really look at that code for long (it even 
>> explicitly
>> comments about what's going with the locking in there!) sorry about
>> that.
>>
>> [ Off-topic: BTW does every call to __make_request() end up in
>> blk_remove_plug()? Since you're explicitly making the assumption
>> that it *must* be called from process context (and hence the use of
>> the non-save/restore variants), you could consider putting a
>> WARN_ON(irqs_disabled()) over there, and perhaps a WARN_ON
>> (!spin_is_locked(queue_lock)) in blk_remove_plug() instead, and
>> other such similar functions that currently have the !irqs_disabled
>> check. This way you'd effectively cover _both_ the assertions,
>> and in appropriate places -- just a suggestion. ]
> 
> No, blk_remove_plug() will only be called for sync bios, or where we
> have to wait for request allocation (which will unplug the device).
> 
> __generic_make_request() already does a might_sleep() check, so it
> should catch this already.
> 
>>> But it does look like unbalanced irq disable/enable calls. I'd guess in
>>> the suspend/resume path. Obviously something more esoteric, since this
>>> is the first such report for 2.6.22, so like some not-very-used driver
>>> for instance.
>> Now that I do look at the codepath, it does seem surprising irqs were
>> not disabled there. There are a bunch of calls to _other_ functions
>> between the spin_lock_irq and the blk_remove_plug via
>> __generic_unplug_device that would also have complained about
>> !irqs_disabled.
>>
>> Walter, does this happen reproducibly?
> 
> As I previously wrote, it's like some of the device power up or resume
> routines that botch the irq enable/disable stuff. It'd be interesting to
> start stripping down the config until the warning goes away - or enable
> CONFIG_PM_DEBUG which may help as well.
> 

hi ppl,
here is the output of 2.6.21 with CONFIG_PM_DEBUG. i have disable edd,apm,acpi,smp,resume
whatever i could to make thinks more easy. imho it shows nothing useful.


re,
 wh

--------------050903090904060002070103
Content-Type: application/x-gzip;
 name="2.6.21.PM_DEBUG.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="2.6.21.PM_DEBUG.gz"

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
VeQZ2pVWEkMDft/gUM/qrbX/AbvfmaXkJAAA
--------------050903090904060002070103--
