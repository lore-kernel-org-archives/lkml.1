Return-Path: <linux-kernel-owner+w=401wt.eu-S1759390AbXFABAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759390AbXFABAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 21:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754665AbXFAA7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 20:59:55 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:19922 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbXFAA7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 20:59:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=U7OqQSMF7D9eMJNyaiv6SsfZ1uZvPZn8amu3EfCgybxuMW4GSwc1jwud67WkkNZzo9yzmANC6tjQYyZQjWtdZO4oVpAlovhQYye1bAlslaKcukFeCbWx1E/tbvFURUfxGWSn46C30CH0xoP5s8rMbDfv2Emy+eTvF50NXB9sGK4=
Message-ID: <465F6F48.8080804@gmail.com>
Date: Fri, 01 Jun 2007 09:58:48 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Gregor Jasny <gjasny@googlemail.com>, Jeff Garzik <jgarzik@pobox.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux v2.6.22-rc3
References: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org>  <9d2cd630705270801m2826be60p3f802c502b26c531@mail.gmail.com>  <46599E6B.1000209@pobox.com>  <9d2cd630705270907y4722653cpf79f073fa8f12f08@mail.gmail.com>  <alpine.LFD.0.98.0705270922030.26602@woody.linux-foundation.org>  <9d2cd630705271315x7030c91ew2f175c921c022880@mail.gmail.com>  <465AA536.6080608@gmail.com> <9d2cd630705280707h4921900fxc93a07a87f0bdf66@mail.gmail.com> <465BF244.5080200@gmail.com> <alpine.LFD.0.98.0705290924350.26602@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705290924350.26602@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.  Sorry about late response.  I'm still recovering from jet
lag.

Linus Torvalds wrote:
> On Tue, 29 May 2007, Tejun Heo wrote:
>> Aieee, so the drive doesn't like the new SRST sequence.
> 
> It would appear that the old code largely ignored the SRST error entirely, 
> no?

Yes, we used to ignore some error conditions, which sometimes led to
very long timeout sequence after hotplugging under certain circumstances
- a few 30sec timeouts for the reset and another 30sec for the following
IDENTIFY (because reset didn't fail after the timeouts).

> If we *used* to do (in ata_bus_post_reset()):
> 
> 	if (dev0)
> 		ata_busy_sleep(ap, ATA_TMOUT_BOOT_QUICK, ATA_TMOUT_BOOT);
> 
> and you changed that to actually care about the return value:
> 
> 	if (dev0) {
> 		rc = ata_wait_ready(ap, deadline);
> 		if (rc && rc != -ENODEV)
> 			return rc;
> 	}
> 
> (in _two_ places). That change also changed the same "post_reset" handling 
> in a totally _different_ way: it used to do ata_busy_sleep() twice, now it 
> still does it twice, but it does it with the same "timeout" value, so if 
> the first one times out, then the second one won't be given any timeout AT 
> ALL!
> 
> And to make matters worse: the first timeout seems to be for ANOTHER PORT 
> ENTIRELY! So you seem to break port 1 even if the timeout happened on port 
> 0, as far as I can read that sequence. 

Yes, the whole operation uses single timeout.  If the given time runs
out, it fails for both devices on the channel.  This is because reset
timeout is channel wide.  After SRST, both devices are required to
respond in certain time (30secs max per spec).  If anyone of the device
doesn't respond, it isn't clear what we can or can't do with the bus -
reset protocol itself requires responding master, cable detection needs
both devices working, etc...

> So I think your ata_bus_post_reset() changes are rather suspect. The fact 
> that you don't change the timeout, and use the same deadline for two 
> different ports (and for multiple commands to the same port, afaik), seems 
> rather suspect. The old code also didn't care about failures in certain 
> phases of the reset sequence, and it appears that it did so for good 
> reason.

Gregor's cdrom has broken SRST support which is extremely rare and
broken.  The reason why it works flawlessly with the ide driver is
because the ide driver doesn't issue SRST during probing and libata
worked after 30sec timeout before reset-seq change because libata didn't
use to check reset failures in some cases and the device just worked
when issued commands even when it didn't report ready status after reset.

I'll try to add some code in the reset path and see where the device
fails reset protocol.  Hopefully, we can work around it.  If it doesn't,
maybe we'll need to issue IDENTIFY and see whether that works after
reset timeout.  :-(

Thanks.

-- 
tejun
