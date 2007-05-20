Return-Path: <linux-kernel-owner+w=401wt.eu-S1758523AbXETN0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523AbXETN0u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 09:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756017AbXETN0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 09:26:41 -0400
Received: from neon.samage.net ([85.17.153.66]:46209 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755926AbXETN0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 09:26:39 -0400
Message-ID: <1678.81.207.0.53.1179667594.squirrel@secure.samage.net>
In-Reply-To: <465019E6.2000302@gmail.com>
References: <20070510072005.GA27316@linux-sh.org>
    <464301D3.5060306@gmail.com> <464307CC.40701@gmail.com>
    <20070510124645.GA18534@linux-sh.org> <4643196B.7070806@gmail.com>
    <20070511005217.GA23186@li <464B3505.20004@gmail.com>
    <1800.81.207.0.53.1179590050.squirrel@secure.samage.net>
    <464F409D.9030408@gmail.com>
    <2318.81.207.0.53.1179615289.squirrel@secure.samage.net>
    <465019E6.2000302@gmail.com>
Date: Sun, 20 May 2007 15:26:34 +0200 (CEST)
Subject: Re: [PATCH] libata: implement ata_wait_after_reset()
From: "Indan Zupancic" <indan@nul.nu>
To: "Tejun Heo" <htejun@gmail.com>
Cc: "Paul Mundt" <lethal@linux-sh.org>, jeff@garzik.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       garyhade@us.ibm.com
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 118046538f1968b7a7bc35ac7f8c9032
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tejun,

Thanks for your answers.

On Sun, May 20, 2007 11:50, Tejun Heo wrote:
> Indan Zupancic wrote:
>>> 1. We dropped libata specific suspend/resume implementation in favor of
>>> sd driven one.  Unfortunately, the new implementation currently can't do
>>> background spinup, so that's probably why you can feel the delay.  We
>>> need to figure out how to do background spinup with the new implementation.
>>
>> What are the advantages of that, except slower resume? ;-)
>
> The change was made primarily to make libata spin down disks properly on
> power down and hibernate.  I don't like the added delay either but it's
> better than shortening the lifespan of harddisks.

Ah, it fixes that "weird noise on shutdown" problem? Fair enough.


>  Making resuming
> asynchronous is planned but we need more infrastructure to do that
> properly.  The previous implementation worked but it also might try to
> spin up a lot of disks at once which can't be good for PSU.  I'm not
> sure yet how to do that properly with sd driving suspend/resume.

Don't controllers support spread spin up of disks, to avoid the peak load?
I think I saw something about that in the SiI 3512 spec I downloaded. So
maybe something like a special spin up method which can be implemented
by drivers, and if it isn't, the current start stop thing is used?


>>> 2. To make reset finish in defined time, each reset try now has defined
>>> deadlines.  I was trying to be conservative so I chose 10sec for the
>>> first try.
>>
>> Right. So to me it seems that failed, because the undefined reset time is just
>> replaced with a fixed ad hoc sleep, which is longer than any undefined reset
>> mechanism. So where did the advantage go? Better to go back to how it was,
>> is my impression. Or make that deadline 10 seconds and after that give up,
>> instead of the other way round. Or just move to async reset.
>
> Well, yeah, your case degraded for sure but a lot of hotplug or error
> handling cases are now much better which often used to take more than 30
> secs in many cases.  There are just a lot of cases and a lot of weird
> devices.  Aiming generally acceptable delay on most cases is of higher
> priority than optimizing specific cases.

What I meant is that the deadline isn't effective because if it can't be done within
that time, it's just retried after 10 seconds or whatever, basically rendering the
deadline useless. But now I understand that the retry is done in the background,
and that it was just the sd_resume that caused everything to wait on it.


> That said, the 10 sec delayed
> retry you're seeing is primarily caused by incorrect interpretation of
> 0xff status on sata_sil, so with that fixed, it shouldn't be too much of
> a problem.

True.

>>>  It's driven by timing table near the top of libata-eh.c, so
>>> adjusting the table is easy and maybe we can be a bit more aggressive
>>> with the first two tries.  But if we solve #1, this shouldn't matter too
>>> much.
>>
>> #2 seems totally unrelated to #1, as #1 is about spinup, and #2 about reset.
>> Only relation is that #2 slows down #1 because #1 needs to wait on #2.
>
> Not that easy.  Many drives don't respond to reset while they're
> spinning up.

Bugger. So it seems like a good idea to do the reset and spinup async together.


>>>> Maybe a silly question, but why do we wait for the harddisk to show up? Maybe that
>>>> makes a little bit of sense at bootup, but for resume from ram, where nothing is
>>>> supposed to have changed, it seems a bit strange. Why not wait when something tries
>>>> to access the harddisk or something?
>>> I hope it's explained now.
>>
>> Almost. Explained is why we wait on the disk, but that's only the sd_resume part.
>> It's still unclear why resume must wait till the reset is done.
>
> Port reset itself is asynchronous.  The wait is solely from sd_resume.

The whole resetting, or just the retry after 10 seconds? But it becomes clear now that
you're right that the spinup problem is solved if sd_resume does background spin up.


>>>> I wonder if sil_pci_device_resume() and sd_resume() know about each other...
>>>> I'll disable sd_resume() and see how that goes.
>>> Yeap, that should work.  In most configurations, devices spin up
>>> immediately after power is restored.  sd_resume() just waits for the
>>> device to be revalidated in such cases.
>>
>> And it kicks the disk into action. Why? Only thing it does is sending a START_STOP
>> command. I assume that causes the disk to spin up. But for e.g. laptopmode I can
>> imagine that's quite annoying. I think sd_resume() is totally unnecessary and can
>> be removed, because it seems wrong to always force the harddisk to spin up,
>> background spin up or not.
>
> Most ATA drives would spin up immediately when power is reapplied unless
> configured otherwise and you can configure whether sd_resume issues
> START_STOP or not by echoing to sysfs node
> /sys/class/scsi_disk/h:c:i:l/manage_start_stop.  The drawback here is
> you won't get proper spindown if you turn it off.

Thanks for the pointer, I'll fiddle with it. What do you mean with "proper" here?
Not at all, or in a forced way because power goes away?

(And what does the 'allow_restart' option do?)

>  Adding fine-grained
> control can be useful.  Wanna give it a try?  Shouldn't be too difficult
> and, as manage_start_stop is just added, I think we can still change its
> API.

Well, manage_start_stop could be split up into manage_start and manage_stop,
but I don't know how useful that is in practice. Maybe it makes more sense to
check /proc/sys/vm/laptop_mode and then decide whether to start the disk.
Or just remember the disk state and restore that?

My impression is that these options aren't that useful other than for debugging,
but that normally the right thing should be done automatically. (Not spinning
down at reboot, not spinning up at bootup if the disk isn't used, not spinning up
after resume if the disk wasn't spinning before suspend, etc.)

Perhaps a silly question, but how can you ever set manage_start_stop to 0 before
the disk is started at bootup? You can change it before doing suspend, but not at
bootup. So is this option at the right place?

Greetings,

Indan


