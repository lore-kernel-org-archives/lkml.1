Return-Path: <linux-kernel-owner+w=401wt.eu-S1757820AbYB1I07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820AbYB1I07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 03:26:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbYB1I0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 03:26:38 -0500
Received: from nebensachen.de ([195.34.83.29]:35021 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679AbYB1I0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 03:26:36 -0500
X-Hashcash: 1:20:080228:alan@lxorguk.ukuu.org.uk::8qlaJiwcXixZ9YOQ:00000000000000000000000000000000000004TIr
X-Hashcash: 1:20:080228:linux-ide@vger.kernel.org::4bSy/qTvIm14szcs:0000000000000000000000000000000000005T7t
X-Hashcash: 1:20:080228:linux-kernel@vger.kernel.org::tz9utXQXeGqdolrF:00000000000000000000000000000000042De
X-Hashcash: 1:20:080228:jens.axboe@oracle.com::kuDTSvht4blK2E46:00000000000000000000000000000000000000000pBQ
From: Elias Oltmanns <eo@nebensachen.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] Disk shock protection (revisited)
References: <87skzgd1zk.fsf@denkblock.local> <20080226123946.75dbe3d2@core>
Mail-Copies-To: nobody
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe
	<jens.axboe@oracle.com>
Date: Thu, 28 Feb 2008 09:24:54 +0100
Message-ID: <87mypl8p49.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> The general idea: A daemon running in user space monitors input data
>> from an accelerometer. When the daemon detects a critical condition,
>
> That sounds like a non starter. What if the box is busy, what if the
> daemon or something you touch needs memory and causes paging ?

The daemon runs mlock'd anyway, so there won't be any need for paging
there. As for responsiveness under heavy load, I'm not quite sure I get
your meaning. On my system, at least, the only way I have managed to
decrease responsiveness noticeably is to cause a lot of I/O operations
on my disk. But even then it's not the overall responsiveness that gets
hurt but just any action that requires further I/O. Since the daemon
stays in memory all the time, it can go ahead and notify the kernel that
the disk heads should be unloaded. The kernel takes care to insert the
idle immediate command at the head of the queue. Am I missing something?

>
> Given the accelerometer data should be very simple doesn't it actually
> make sense in this specific case to put the logic (not thresholds) in
> kernel space.

The simplicity of the input data doesn't necessarily imply that the
evaluation logic is simple as well; but then the daemon is rather simple
in this case. Still, probably due to my lack of experience I don't quite
see what can be gained by putting it into kernel space which cannot be
achieved using the mlock feature or nice levels.

The important thing is this: There will be a dedicated code path for
disk head parking in the kernel. If the actual decision about when head
parking should take place is left to a daemon in user space, it is much
easier for the user to specify which devices should be protected and
which input data the decision should be based upon in case the system
happens to have access to more than one accelerometer. Right now, I don't
feel quite up to the job to write a dedicated kernel module that
replaces the daemon and is designed in a sufficiently generic way to
cope with all sorts of weird system configurations. Since I wouldn't
even know where to start, someone would have to point me in the right
direction first and probably have a lot of patience with me and my
questions in the process.

>
>> state. To this end, the kernel has to issue an idle immediate command
>> with unload feature and stop the block layer queue afterwards. Once the
>
> Yep. Pity the worst case completion time for an IDE I/O is 60 seconds or
> so.

Well, the low level driver would have to make sure that no requests are
accepted after the idle immediate command has been received. The block
layer queue is stopped later merely to stop the request_fn() to be
called for the time that lld won't accept any requests anyway. See
further comments below.

>
>> 1. Who is to be in charge for the shock protection application? Should
>>    userspace speak to libata / ide directly (through sysfs) and the low
>
> I think it has to be kernel side for speed, and because you will need to
> issue idle immediate while a command sequence is active which is
> *extremely* hairy as you have to recover from the mess and restart the
> relevant I/O. Plus you may need controller specific knowledge on issuing
> it (and changes to libata).

As indicated above, I'd appreciate it if you could explain in a bit more
detail why it is not enough to let the kernel take care of just the
actual disk parking. It really is perfectly possible that I miss
something obvious here, so please bare with me.

Let me also make quite clear what exactly I intend to keep in kernel
space and what the daemon is supposed to be doing. When the daemon
decides that we had better stop all I/O to the disk, it writes an
integer to a sysfs attribute specifying the number of seconds it expects
the disk to be kept in the safe mode for. From there on everything is
going to be handled in kernel space, i.e., issuing idle immediate while
making sure that no other command gets issued to the hardware after that
and freezing the block layer queue eventually in order to stop
the request_fn() from being called needlessly. Once the specified time
is up or if the daemon writes 0 to that sysfs attrribute before that
time, it is kernel space code again that takes care that normal
operation is resumed.

>
>> 2. Depending on the answer to the previous question, by what mechanism
>>    should block layer and lld interact? Special requests, queue hooks or
>>    something in some way similar to power management functions (once
>>    suggested by James Bottomley)?
>
> Idle immediate seem to simply fit the queue model, it happens in
> *parallel* to I/O events and is special in all sorts of ways.

Well, this is something we'll have to discuss too since I don't have the
SATA specs and haven't a clue as to how idle immediate behaves in an NCQ
enabled system. However, my question was about something more basic than
that, namely, what should be handled by the block layer and what by the
libata / ide subsystem and how they should interact with each other.
But never mind that now because I have had some ideas since and will
come up with a patch series once the other issues have been settled, so
we can have a more hands on discussion about this particular problem
then.

>
>> 3. What is the preferred way to pass device specific configuration
>>    options to libata (preferrably at runtime, i.e., after module
>>    loading)?
>
> sysfs

Yes, I thought as much. I just haven't quite worked out yet where or how
I am supposed to introduce libata specific sysfs attributes since this
seems to be left to the scsi midlayer so far.

Regards,

Elias
