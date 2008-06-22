Return-Path: <linux-kernel-owner+w=401wt.eu-S1756732AbYFVXX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbYFVXX7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 19:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755664AbYFVXXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 19:23:48 -0400
Received: from nebensachen.de ([195.34.83.29]:57670 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353AbYFVXXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 19:23:46 -0400
X-Hashcash: 1:20:080622:bzolnier@gmail.com::kZ7N5KXc0K6OqKoD:00000000000000000000000000000000000000000001LTd
X-Hashcash: 1:20:080622:linux-ide@vger.kernel.org::OEBu4Xcg0dRrtnsH:000000000000000000000000000000000000AgSZ
X-Hashcash: 1:20:080622:linux-kernel@vger.kernel.org::kafO0+td8W+i8qmT:00000000000000000000000000000000002ld
X-Hashcash: 1:20:080622:randy.dunlap@oracle.com::ruPdICA9b85sKSjm:000000000000000000000000000000000000000fnP
From: Elias Oltmanns <eo@nebensachen.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] IDE: Fix HDIO_DRIVE_RESET handling
References: <87k5gmz596.fsf@denkblock.local>
	<200806192247.25063.bzolnier@gmail.com>
Date: Mon, 23 Jun 2008 01:23:31 +0200
Message-ID: <87wskhuk98.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> Hi,
>
> On Thursday 19 June 2008, Elias Oltmanns wrote:
>> Hi Bart,
>> 
>> currently, the code path executing an HDIO_DRIVE_RESET ioctl is broken
>> in various ways.  Firstly, ide_abort() is called with the ide_lock held
>> and may call ide_end_request() further down the line which will try to
>> grab the same lock again.  More importantly though, the whole concept of
>> aborting an inflight request is flawed -- at least as far as ide_abort()
>> is concerned.
>> 
>> The patch below tries to address these issues by handling the
>> HDIO_DRIVE_RESET ioctl in-band.
[...]
> One more thing, ide-2.6 is for syncing with Linus _only_ (it seems I'm to
> blame for the confusion), please rebase your work on top of pata-2.6 quilt
> tree (some comments which should ease the transition below):
>
> 	http://kernel.org/pub/linux/kernel/people/bart/pata-2.6/
>
> [ This tree is pulled into linux-next so you may prefer to just use the
>   latest -next snapshost instead. ]

Indeed, the following patch series is based on nex-20080620.  Just to be
absolutely clear though, this is actually a bug fix since a

# hdparm -w /dev/hda

currently freezes the system if there happens to be any I/O operation in
progress.  Not sure whether this is serious enough for -rc or, indeed,
-stable trees, but I thought I'd mention it.

[...]
>> +	rq->cmd[0] = REQ_DRIVE_RESET;
>> +	rq->cmd_type = REQ_TYPE_SPECIAL;
>> +	rq->cmd_flags |= REQ_SOFTBARRIER;
>> +	ide_do_drive_cmd(drive, rq, ide_end);
>
> ide_do_drive_cmd() now handles only ide_preempt + it seems that previously
> the ioctl would wait till the reset is complete so probably this needs to
> use blk_execute_rq() instead

There is some uncertainty here: Previously, the code didn't actually
wait for the reset to complete before returning but did so right after
the reset sequence had been initiated.  It might be desirable to wait
for completion before returning though and that's the way I've
implemented it in the new patch (first in the series).  This has the
advantage that user space could be informed when anything should have
gone wrong (like a timeout).  This would obviously mean a functional
change visible from user space but then fixing the bug in the first
place is a change visible in user space.  See the fourth patch in the
series for what I've had in mind.

>
> [...]
>
> Oh, and now that you've fixed HDIO_DRIVE_RESET you get the following bonus:
> ide_abort(), __ide_abort() and ide_driver_t.abort all can be removed in the
> incremental patch! ;)

Done.  It's the second in the series.

So here is the summary of the patch series to come:

1. Fixes the buggy implementation of HDIO_DRIVE_RESET handling.
2. Removes all code that has been made superfluous by the previous
   change.
3. Documents the way HDIO_DRIVE_RESET is handled accurately.
4. Adds some more error reporting facilities and documents them as well.

Please be particularly alert when reviewing the last patch.  I merely
did what seemed to be the right and obvious thing to do but I ironed out
some irregularities along the way which (for all improbability) may have
been there for some reason or other.  It beats me, for instance, why
->polling but not ->resetting should be reset to 0 when
sil_sata_reset_poll() returns non zero.  So, I now both are 0 once any
of the poll functions returns ide_stopped.

Regards,

Elias
