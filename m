Return-Path: <linux-kernel-owner+w=401wt.eu-S1758091AbXETRJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091AbXETRJw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 13:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756091AbXETRJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 13:09:43 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:15421 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076AbXETRJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 13:09:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=rndIKgsg2nrDYDmMBp9J/CiX/6VolhzItml/euJaVZLL6iG0qimcBuOkiMamKGQgwnpKmK/mEY5fK7V0AfAE3e7C6K0Y/VcoC1LI6GR32OnCJeWpwv/kwzYSpEhOm2+vV/te0DFL/LgpVXqcy4IHtvckfB5GIdJbJq0/E4oCEE8=
Message-ID: <465080BE.3000201@gmail.com>
Date: Sun, 20 May 2007 19:09:18 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Indan Zupancic <indan@nul.nu>
CC: Paul Mundt <lethal@linux-sh.org>, jeff@garzik.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       garyhade@us.ibm.com
Subject: Re: [PATCH] libata: implement ata_wait_after_reset()
References: <20070510072005.GA27316@linux-sh.org>    <464301D3.5060306@gmail.com> <464307CC.40701@gmail.com>    <20070510124645.GA18534@linux-sh.org> <4643196B.7070806@gmail.com>    <20070511005217.GA23186@li <464B3505.20004@gmail.com>    <1800.81.207.0.53.1179590050.squirrel@secure.samage.net>    <464F409D.9030408@gmail.com>    <2318.81.207.0.53.1179615289.squirrel@secure.samage.net>    <465019E6.2000302@gmail.com> <1678.81.207.0.53.1179667594.squirrel@secure.samage.net>
In-Reply-To: <1678.81.207.0.53.1179667594.squirrel@secure.samage.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Indan Zupancic wrote:
>> The change was made primarily to make libata spin down disks properly on
>> power down and hibernate.  I don't like the added delay either but it's
>> better than shortening the lifespan of harddisks.
> 
> Ah, it fixes that "weird noise on shutdown" problem? Fair enough.

Yeap, finally.

>>  Making resuming
>> asynchronous is planned but we need more infrastructure to do that
>> properly.  The previous implementation worked but it also might try to
>> spin up a lot of disks at once which can't be good for PSU.  I'm not
>> sure yet how to do that properly with sd driving suspend/resume.
> 
> Don't controllers support spread spin up of disks, to avoid the peak load?
> I think I saw something about that in the SiI 3512 spec I downloaded. So
> maybe something like a special spin up method which can be implemented
> by drivers, and if it isn't, the current start stop thing is used?

What they support is allowing drivers to control spin up, and it needs
support from the HDD (many seem to do these days) && BIOS (so that it
doesn't spin up the disks during POST) too.  To do that properly, we
need a repository which distributes spinup tokens such that we can do
parallel, not thundering herd, spinups.

>>> Right. So to me it seems that failed, because the undefined reset time is just
>>> replaced with a fixed ad hoc sleep, which is longer than any undefined reset
>>> mechanism. So where did the advantage go? Better to go back to how it was,
>>> is my impression. Or make that deadline 10 seconds and after that give up,
>>> instead of the other way round. Or just move to async reset.
>> Well, yeah, your case degraded for sure but a lot of hotplug or error
>> handling cases are now much better which often used to take more than 30
>> secs in many cases.  There are just a lot of cases and a lot of weird
>> devices.  Aiming generally acceptable delay on most cases is of higher
>> priority than optimizing specific cases.
> 
> What I meant is that the deadline isn't effective because if it can't be done within
> that time, it's just retried after 10 seconds or whatever, basically rendering the
> deadline useless. But now I understand that the retry is done in the background,
> and that it was just the sd_resume that caused everything to wait on it.

The deadline table sets limits to the maximum time a try can take &&
when the next attempt is made.  So, the initial deadline of 10 secs
means that the first try is allowed to take upto 10secs and no matter
when or why it fails, the next attempt is made after 10sec is passed.  I
would love to bang devices harder but a lot of creepy device are out
there and I'm pretty sure some of them would crap themselves if pushed
too hard.  :-(

Anyways, in your case, the problem was that sata_sil wasted the first
try for no good reason.  I'm not determined whether we need more
aggressive deadlines for early tries for cases like this.  It's
something to think about.

>>>>  It's driven by timing table near the top of libata-eh.c, so
>>>> adjusting the table is easy and maybe we can be a bit more aggressive
>>>> with the first two tries.  But if we solve #1, this shouldn't matter too
>>>> much.
>>> #2 seems totally unrelated to #1, as #1 is about spinup, and #2 about reset.
>>> Only relation is that #2 slows down #1 because #1 needs to wait on #2.
>> Not that easy.  Many drives don't respond to reset while they're
>> spinning up.
> 
> Bugger. So it seems like a good idea to do the reset and spinup async together.

There are a lot of cases.  Depending on various configuration and whims,
some drives spin up when power is reapplied and don't respond to reset
till it's ready.  Some drives don't spin up when power is reapplied but
spin up when PHY is woken up and don't respond to reset till it's ready.
 Yet others just sit quiet and respond to reset nicely but don't spin up
till told to do so.

So, well, I agree that the best strategy is doing it all asynchronously.

>>>>> Maybe a silly question, but why do we wait for the harddisk to show up? Maybe that
>>>>> makes a little bit of sense at bootup, but for resume from ram, where nothing is
>>>>> supposed to have changed, it seems a bit strange. Why not wait when something tries
>>>>> to access the harddisk or something?
>>>> I hope it's explained now.
>>> Almost. Explained is why we wait on the disk, but that's only the sd_resume part.
>>> It's still unclear why resume must wait till the reset is done.
>> Port reset itself is asynchronous.  The wait is solely from sd_resume.
> 
> The whole resetting, or just the retry after 10 seconds? But it becomes clear now that
> you're right that the spinup problem is solved if sd_resume does background spin up.

The whole resetting.  ATA controller/port resume itself is completely
asynchronous.  The resume method just kicks EH thread and tells it to
wake the thing up and returns.  The EH thread asynchronously resets the
port, revalidates all the devices and see if any new ones are attached, etc.

The culprit is that while EH thread is active all commands are deferred,
so the START_STOP command sd_resume() issues waits in the SCSI midlayer
queue till EH is complete.  That's why doing it asynchronously is
tricky.  I'm not sure whether we would be able to do it without
separating libata from SCSI so that libata has its own suspend/resume
functions.  :-(

>> Most ATA drives would spin up immediately when power is reapplied unless
>> configured otherwise and you can configure whether sd_resume issues
>> START_STOP or not by echoing to sysfs node
>> /sys/class/scsi_disk/h:c:i:l/manage_start_stop.  The drawback here is
>> you won't get proper spindown if you turn it off.
> 
> Thanks for the pointer, I'll fiddle with it. What do you mean with "proper" here?
> Not at all, or in a forced way because power goes away?

Well, basically, your drive isn't told that the power is gonna go off.
Power just goes off and your drive has to do emergency head unload which
sometimes causes the funny noise.

> (And what does the 'allow_restart' option do?)

That's for SCSI and doesn't matter for ATA.  ATA drives restart
themselves automatically when media access is needed anyway.

>>  Adding fine-grained
>> control can be useful.  Wanna give it a try?  Shouldn't be too difficult
>> and, as manage_start_stop is just added, I think we can still change its
>> API.
> 
> Well, manage_start_stop could be split up into manage_start and manage_stop,
> but I don't know how useful that is in practice. Maybe it makes more sense to
> check /proc/sys/vm/laptop_mode and then decide whether to start the disk.
> Or just remember the disk state and restore that?
>
> My impression is that these options aren't that useful other than for debugging,
> but that normally the right thing should be done automatically. (Not spinning
> down at reboot, not spinning up at bootup if the disk isn't used, not spinning up
> after resume if the disk wasn't spinning before suspend, etc.)
> 
> Perhaps a silly question, but how can you ever set manage_start_stop to 0 before
> the disk is started at bootup? You can change it before doing suspend, but not at
> bootup. So is this option at the right place?

The problem is sorta complicated because it involves all devices which
use SCSI midlayer.  libata, USB, all the regular SCSI disks, whatnot, so
it's really hard to sell to linux-scsi people if you choose a default
behavior which is specific to libata devices.  What can be done is
adding a configurable option which doesn't change the default behavior
and configure it in the low level driver.  This is how manage_start_stop
is configured.  The default value is zero but libata sets it to one
while registering each device, so the default value for all libata
devices is 1 (this should answer your last question).

-- 
tejun
