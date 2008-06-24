Return-Path: <linux-kernel-owner+w=401wt.eu-S1759037AbYFXHCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759037AbYFXHCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 03:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755356AbYFXHCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 03:02:30 -0400
Received: from nebensachen.de ([195.34.83.29]:48294 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbYFXHC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 03:02:26 -0400
X-Hashcash: 1:20:080624:alan@lxorguk.ukuu.org.uk::PpI5+k/KUStgb7Er:00000000000000000000000000000000000001Vvc
X-Hashcash: 1:20:080624:bzolnier@gmail.com::sqDsuiZ6rG07V3TC:00000000000000000000000000000000000000000002vDR
X-Hashcash: 1:20:080624:linux-ide@vger.kernel.org::kjLZ5hY8bApHb0eO:0000000000000000000000000000000000002vuV
X-Hashcash: 1:20:080624:linux-kernel@vger.kernel.org::SYflHjsLmpND/wz3:0000000000000000000000000000000002sGL
X-Hashcash: 1:20:080624:randy.dunlap@oracle.com::UYyMtT9odxhCAyHh:00000000000000000000000000000000000000BdLI
From: Elias Oltmanns <eo@nebensachen.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] IDE: Fix HDIO_DRIVE_RESET handling
References: <87k5gmz596.fsf@denkblock.local>
	<200806192247.25063.bzolnier@gmail.com>
	<87wskhuk98.fsf@denkblock.local> <87r6apuk16.fsf@denkblock.local>
	<20080623101600.391e5245@lxorguk.ukuu.org.uk>
Date: Tue, 24 Jun 2008 09:02:09 +0200
Message-ID: <873an3tixa.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> in various ways.  Most importantly, it is treated as an out of band
>> request in an illegal way which may very likely lead to system lock ups.
>> Use the drive's request queue to avoid this problem (and fix a locking
>> issue for free along the way).
>
> It was always designed to be, and used out of band. One of the important
> uses of the ioctl is to abort a running command when an interface has
> jammed up. If you end up queueing it behind that command you've lost most
> of the reason for the ioctl anyway (and you might as well just remove it
> really given SG_IO exists).

Well, I can see your point. In fact, there really doesn't seem to be an
alternative to the out of band approach for the purposes you described.
Now, I even think that I could perhaps fix the request aborting properly
and restore the original behaviour. Moreover, I may very likely live to
regret having removed ide_abort() and friends when implementing disk
shock protection in the IDE layer. Maybe I should try to send an
alternative patch for discussion. On the other hand I don't see the
equivalent for HDIO_DRIVE_RESET in libata which makes me wonder whether
this ioctl has actually been used in real life for the purposes you
described.

>
> Other than the command aborting bit, it looks a good idea - that code
>has
> always been racy and raced against timer handlers, irq handlers and if
> neither of them got it then a speed changedown raced the lot 8(

My idea to solve this would be roughly this: Change ide_set_handler to
leave the ->handler and ->expiry members alone if they have been set on
entry. If a request is being processed by the time a HDIO_DRIVE_RESET
ioctl is received, these callbacks will be changed so the reset sequence
will be started on the next interrupt, timeout, or when the ->busy flag
is cleared. I'm not quite sure yet whether things will work out the way
I want them to and I don't know whether HDIO_DRIVE_RESET actually
justifies the effort since I don't knowof an equivalent in libata
anyway. But as I said, it might come in handy for other purposes.

Comments?

Elias
