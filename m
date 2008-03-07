Return-Path: <linux-kernel-owner+w=401wt.eu-S1760393AbYCGSVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760393AbYCGSVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 13:21:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754998AbYCGSVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 13:21:20 -0500
Received: from nebensachen.de ([195.34.83.29]:40420 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbYCGSVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 13:21:18 -0500
From: Elias Oltmanns <eo@nebensachen.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] Disk shock protection (revisited)
Date: Fri, 07 Mar 2008 19:03:36 +0100
Message-ID: <87bq5qfm2v.fsf@denkblock.local>
References: <87skzgd1zk.fsf@denkblock.local> <20080226123946.75dbe3d2@core>
	<87mypl8p49.fsf@denkblock.local> <20080228111349.6831925c@core>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
X-Hashcash: 1:20:080307:alan@lxorguk.ukuu.org.uk::VSGc3/qcxkreJ0cz:00000000000000000000000000000000000000ryh
X-Hashcash: 1:20:080307:linux-ide@vger.kernel.org::fcz+pogNccJDSr7+:0000000000000000000000000000000000004SMu
X-Hashcash: 1:20:080307:linux-kernel@vger.kernel.org::RJtFrnYFKNRenS38:000000000000000000000000000000000GW++
X-Hashcash: 1:20:080307:jens.axboe@oracle.com::yFkkbvgl/6AiNaco:000000000000000000000000000000000000000001DT
Mail-Copies-To: nobody
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe
	<jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
[...]
>> there. As for responsiveness under heavy load, I'm not quite sure I get
>> your meaning. On my system, at least, the only way I have managed to
>> decrease responsiveness noticeably is to cause a lot of I/O operations
>
> It depends a lot on hardware but you can certainly get user space delays
> in seconds as an extreme worst case.
>
>> stays in memory all the time, it can go ahead and notify the kernel that
>> the disk heads should be unloaded. The kernel takes care to insert the
>> idle immediate command at the head of the queue. Am I missing something?
>
> Yes - the fact we may well have bounced off the floor already.

Well, with or without shock protection it can't get any worse by then,
can it? But in all those cases where the system manages to get the heads
of the platter in time, the owner may be greatful for this feature.

>
>> happens to have access to more than one accelerometer. Right now, I don't
>> feel quite up to the job to write a dedicated kernel module that
>> replaces the daemon and is designed in a sufficiently generic way to
>
> Thats fine - nothing says a user space daemon isn't a good starting point.

A starting point it is then.

>
>> > Yep. Pity the worst case completion time for an IDE I/O is 60 seconds or
>> > so.
>> 
>> Well, the low level driver would have to make sure that no requests are
>> accepted after the idle immediate command has been received. The block
>
> No doesn't work like that. The command currently being processed on IDE
> can take up to 60 seconds to complete. Idle immediate (on the devices it
> works for - it hangs some) is very special in that it can be used in some
> cases to interrupt a running command sequence. It requires a significant
> amount of work in the driver layer to then clean up and requeue the
> partial command and to know if it is possible to do so.

This business of aborting commands is exactly what I haven't a clue
about. At first I thought I could do something similar to
ata_do_link_abort but I obviously want to avoid the need for a soft
reset before issuing idle immediate. How am I to go about it?

>
>> and freezing the block layer queue eventually in order to stop
>> the request_fn() from being called needlessly. Once the specified time
>> is up or if the daemon writes 0 to that sysfs attrribute before that
>> time, it is kernel space code again that takes care that normal
>> operation is resumed.
>
> I think we have three things here
>
> 1.	A general queue freeze scheme from user space
> 2.	A general implementation of a queue freeze that stops further
> command issuing while the queue is blocked
> 3.	The ability for devices to provide a function to be called
> when a queue freeze is done (ie idle immediate and the like)
>
> The fine details of how you abort an ATA command don't actually matter
> for an initial implementation and can be written once the core stuff is
> right.
>
[...]
>> Yes, I thought as much. I just haven't quite worked out yet where or how
>> I am supposed to introduce libata specific sysfs attributes since this
>> seems to be left to the scsi midlayer so far.
>
> The scsi midlayer is the main manager of queues so that seems sane - and
> if you've got the basic queue freeze logic right then one assumes it will
> work for scsi too.

Basic queue freezing certainly will. But we'll need attributes specific
to ATA so the user can determine whether
1. idle immediate should be issued (if supported) on queue freeze
   events;
2. idle immediate is supported on this particular device even though
   dev->id doesn't say so;
3. idle immediate is malfunctioning and should be avoided even though
   dev->id reports support for that feature;
4. (perhaps we should drop that): use standby immediate if idle
   immediate isn't supported for some reason.

I'm going to send a first draft of a patch series in reply to this
email. It is a stripped down version intended to get the general idea
across. The first of these four patches will eventually need to be
modified to actually abort in flight commands and clear up the mess
afterwards. However, first and foremost I'd like to draw your attention
to the use of REQ_TYPE_LINUX_BLOCK requests as demonstrated in the other
three patches. The question is whether the underlying concept is right.
Although the question how to handle REQ_TYPE_LINUX_BLOCK requests in the
scsi subsystem has been raised on the linux-scsi ml, it has never been
answered really because this request type was deemed unsuitable for the
application in question. See, for instance, the thread starting at [1].
My patch approach has been partly inspired by the patch discussed there.
Before I raise this issue yet again, I'd like to know whether
REQ_TYPE_LINUX_BLOCK is the right choice for my application in your
opinion or whether another mechanism might be more suitable as James
suggested a while ago (see [2]).

Regards,

Elias

[1] http://permalink.gmane.org/gmane.linux.scsi/30049
[2] http://permalink.gmane.org/gmane.linux.scsi/37951
