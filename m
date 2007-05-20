Return-Path: <linux-kernel-owner+w=401wt.eu-S1757682AbXETTf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682AbXETTf2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 15:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755929AbXETTfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 15:35:14 -0400
Received: from neon.samage.net ([85.17.153.66]:46679 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755678AbXETTfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 15:35:11 -0400
Message-ID: <3891.81.207.0.53.1179689704.squirrel@secure.samage.net>
In-Reply-To: <465080BE.3000201@gmail.com>
References: <20070510072005.GA27316@linux-sh.org>
    <464301D3.5060306@gmail.com> <464307CC.40701@gmail.com>
    <20070510124645.GA18534@linux-sh.org> <4643196B.7070806@gmail.com>
    <20070511005217.GA23186@li <464B3505.20004@gmail.com>
    <1800.81.207.0.53.1179590050.squirrel@secure.samage.net>
    <464F409D.9030408@gmail.com>
    <2318.81.207.0.53.1179615289.squirrel@secure.samage.net>
    <465019E6.2000302@gmail.com>
    <1678.81.207.0.53.1179667594.squirrel@secure.samage.net>
    <465080BE.3000201@gmail.com>
Date: Sun, 20 May 2007 21:35:04 +0200 (CEST)
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
X-Scan-Signature: d2b65465fd2235632e6f1ea95c39dbf6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tejun,

On Sun, May 20, 2007 19:09, Tejun Heo wrote:
> Indan Zupancic wrote:
>> Don't controllers support spread spin up of disks, to avoid the peak load?
>> I think I saw something about that in the SiI 3512 spec I downloaded. So
>> maybe something like a special spin up method which can be implemented
>> by drivers, and if it isn't, the current start stop thing is used?
>
> What they support is allowing drivers to control spin up, and it needs
> support from the HDD (many seem to do these days) && BIOS (so that it
> doesn't spin up the disks during POST) too.  To do that properly, we
> need a repository which distributes spinup tokens such that we can do
> parallel, not thundering herd, spinups.

More and more do I get the impression that with full hardware control for Linux,
from BIOS to firmware, great things could be done. Alas.


> The deadline table sets limits to the maximum time a try can take &&
> when the next attempt is made.  So, the initial deadline of 10 secs
> means that the first try is allowed to take upto 10secs and no matter
> when or why it fails, the next attempt is made after 10sec is passed.  I
> would love to bang devices harder but a lot of creepy device are out
> there and I'm pretty sure some of them would crap themselves if pushed
> too hard.  :-(

Well, if it's going to be retried later on, then it's not really a deadline, is it?
Perhaps it's better to give up after the deadline, and only try again after an
interrupt is received from the controller?


> Anyways, in your case, the problem was that sata_sil wasted the first
> try for no good reason.  I'm not determined whether we need more
> aggressive deadlines for early tries for cases like this.  It's
> something to think about.

The annoying part is that all this seems to depend on the harddisk, and not
really on the controller (or the combination of the two).


>> Bugger. So it seems like a good idea to do the reset and spinup async together.
>
> There are a lot of cases.  Depending on various configuration and whims,
> some drives spin up when power is reapplied and don't respond to reset
> till it's ready.  Some drives don't spin up when power is reapplied but
> spin up when PHY is woken up and don't respond to reset till it's ready.
>  Yet others just sit quiet and respond to reset nicely but don't spin up
> till told to do so.
>
> So, well, I agree that the best strategy is doing it all asynchronously.

Another one would be to do it interrupt driven instead of doing polling,
if the controller supports it well.


>> The whole resetting, or just the retry after 10 seconds? But it becomes clear now that
>> you're right that the spinup problem is solved if sd_resume does background spin up.
>
> The whole resetting.  ATA controller/port resume itself is completely
> asynchronous.  The resume method just kicks EH thread and tells it to
> wake the thing up and returns.  The EH thread asynchronously resets the
> port, revalidates all the devices and see if any new ones are attached, etc.
>
> The culprit is that while EH thread is active all commands are deferred,
> so the START_STOP command sd_resume() issues waits in the SCSI midlayer
> queue till EH is complete.

Are you saying that right now there is only one EH thread? In that case an
improvent would be to have one EH thread per controller/device, so that at
least independent scsi devices can't block each other.

>  That's why doing it asynchronously is
> tricky.  I'm not sure whether we would be able to do it without
> separating libata from SCSI so that libata has its own suspend/resume
> functions.  :-(

Well, it seems you just moved the other direction, with leaning on sd_resume.


>> Thanks for the pointer, I'll fiddle with it. What do you mean with "proper" here?
>> Not at all, or in a forced way because power goes away?
>
> Well, basically, your drive isn't told that the power is gonna go off.
> Power just goes off and your drive has to do emergency head unload which
> sometimes causes the funny noise.

Hm, I suspected something like that. Though the shutdown sound of my HD
seems to sound the same as usual. Perhaps the BIOS gives it a sign as part of the
suspend? (Or to the controller, which delegates it.)


>> Perhaps a silly question, but how can you ever set manage_start_stop to 0 before
>> the disk is started at bootup? You can change it before doing suspend, but not at
>> bootup. So is this option at the right place?
>
> The problem is sorta complicated because it involves all devices which
> use SCSI midlayer.  libata, USB, all the regular SCSI disks, whatnot, so
> it's really hard to sell to linux-scsi people if you choose a default
> behavior which is specific to libata devices.  What can be done is
> adding a configurable option which doesn't change the default behavior
> and configure it in the low level driver.  This is how manage_start_stop
> is configured.  The default value is zero but libata sets it to one
> while registering each device, so the default value for all libata
> devices is 1 (this should answer your last question).

The "problem" here is that the option only shows up after the device is detected,
in which case the default is already executed, rendering the 'start' part useless
for people who don't use s2ram. So the interface does seem to be a bit hampered,
or at least not fully effective. On the other hand, as you said disks are spin up by
the BIOS already, so it's more a theoretical problem than a real one I suppose.

Thanks for your explanations,

Indan


