Return-Path: <linux-kernel-owner+w=401wt.eu-S1765031AbYEOURK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765031AbYEOURK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756584AbYEOUQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:16:51 -0400
Received: from nebensachen.de ([195.34.83.29]:52586 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755519AbYEOUQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:16:49 -0400
X-Hashcash: 1:20:080515:james.bottomley@hansenpartnership.com::BMo8m1Mcx9d8bE2f:0000000000000000000000000hne
X-Hashcash: 1:20:080515:jens.axboe@oracle.com::LfMqfAYcdM8WLCIf:00000000000000000000000000000000000000001Ym1
X-Hashcash: 1:20:080515:linux-scsi@vger.kernel.org::t4wqT9tJpye1phDr:000000000000000000000000000000000004VFa
X-Hashcash: 1:20:080515:linux-kernel@vger.kernel.org::MxSSpaS7AEiBMT2D:0000000000000000000000000000000001S/Z
From: Elias Oltmanns <eo@nebensachen.de>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Linux specific scsi CDBs vs REQ_TYPE_LINUX_BLOCK requests
References: <87r6ccadzd.fsf@denkblock.local>
	<20080509115520.GS16217@kernel.dk> <87ej83ygtm.fsf@denkblock.local>
Date: Thu, 15 May 2008 22:17:25 +0200
Message-ID: <87ej839vai.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elias Oltmanns <eo@nebensachen.de> wrote:
> Jens Axboe <jens.axboe@oracle.com> wrote:
[...]
>> It still makes sense to use the queue as the transport for the command
>> though, using an ioctl is both ugly from a design POV and (more
>> importantly) has serialization issues since it's an out-of-band
>> signalling mechanism. If you pass down a request as the park request,
>> then you need only deal with the device specific details of parking
>> the head.
>
> Well, the request queue is certainly the most obvious and preferable way
> to solve these serialisation issues -- the only drawback being that
> other paths might involve less memory allocations, thus reducing
> potential issues with paging in when time is of the essence. The
> question remains, however, who should be responsible for enqueueing such
> a request? And if it is going to be a REQ_TYPE_LINUX_BLOCK request, how
> am I supposed to get it past scsi midlayer to the LLDD? But I'll discuss
> that particular issue in a seperate mail.

Right, this is something for the scsi people and probably James in
particular to comment on. Earlier this year, I sent a patch [1] to
implement REQ_TYPE_LINUX_BLOCK in the scsi subsystem. Maybe, an
alternative approach would be to set aside a linux specific scsi opcode
(courtesy of Boaz's variable length cdb support) in order to attach
LINUX_BLOCK requests to this cdb and hand them down to LLDDs. However,
I'm not quite sure whether this is feasible or, indeed, desirable in the
long run.

And finally, here is yet another, but I'm afraid just as hackish
possibility to get shock protection working for both libata and ide: We
define linux specific opcodes for the park and resume commands in
addition to the REQ_TYPE_LINUX_BLOCK opcodes. This way, we have to
options:

1. The block layer provides the interface to request immediate disk head
   unloading and enqueues appropriate LINUX_BLOCK requests accordingly.
   ide is modified to handle these requests directly, whereas scsi ULD
   or midlayer translates them to the corresponding linux specific cdb.
2. The subsystem (i.e., ide / libata) exposes the interface to request
   head unloading and queues up a park or resume request as directed.
   ide would enqueue a LINUX_BLOCK request, whereas libata could stick
   to BLOCK_PC requests by means of the linux specific cdbs for that
   purpose.

So, which way am I to turn here?

[...]
> So, I'd like to export an interface to user space which is specifically
> dedicated to disk shock protection, i.e., only available for ATA / IDE
> devices. On the other hand, it would be desirable to make this interface
> transparent, so user space doesn't have to differentiate between devices
> driven by the libata or the ide subsystem. A sysfs attribute
> /sys/block/.../queue/protect or even just /sys/block/.../protect would
> be very convenient from a user's point of view. However, this would
> require something like a blk_register_protect_attr() /
> blk_unregister_protect_attr() interface so that libata and ide can
> export this attribute for disks after calling blk_init_queue(). Would
> that be alright with you? Otherwise, I'd have to implement this
> interface directly in the subsystems and *thats* where ioctls seem to be
> the easiest way to make this interface as transparent as possible to
> user space. In this case a park request of some sort would be fed to the
> request queue internally.

Alternatively, we could have similar scsi_register_protect_attr() and
scsi_unregister_protect_attr() functions to be called from libata's
->slave_configure() callback. Not sure whether that's any better.

Regards,

Elias

[1] http://lkml.org/lkml/2008/3/7/253
