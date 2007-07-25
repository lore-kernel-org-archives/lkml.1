Return-Path: <linux-kernel-owner+w=401wt.eu-S1765040AbXGYMTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765040AbXGYMTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 08:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622AbXGYMT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 08:19:28 -0400
Received: from mx.fr.bfs.de ([194.95.226.137]:36639 "EHLO mail.fr.bfs.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752312AbXGYMT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 08:19:27 -0400
Message-ID: <46A73FC7.9000801@bfs.de>
Date: Wed, 25 Jul 2007 14:19:19 +0200
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Jens Axboe wrote:
> On Wed, Jul 25 2007, Satyam Sharma wrote:
>> On 7/23/07, Jens Axboe <jens.axboe@oracle.com> wrote:
>>> On Sun, Jul 22 2007, Satyam Sharma wrote:
>>>> Hi Walter,
>>>>
>>>> Thanks for reporting this.
>>>>
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

i will give CONFIG_PM_DEBUG a try,
do not expect results before WE.

re,
 wh
