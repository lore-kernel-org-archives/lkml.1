Return-Path: <linux-kernel-owner+w=401wt.eu-S1761644AbYBZAdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761644AbYBZAdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 19:33:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756850AbYBZAdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 19:33:45 -0500
Received: from nebensachen.de ([195.34.83.29]:50773 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757918AbYBZAdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 19:33:45 -0500
X-Hashcash: 1:20:080225:linux-ide@vger.kernel.org::mewcl0Hl/mtAISBn:0000000000000000000000000000000000006pBc
X-Hashcash: 1:20:080225:linux-kernel@vger.kernel.org::y53Rw7A1ANhDhX7t:0000000000000000000000000000000000SOg
X-Hashcash: 1:20:080225:jens.axboe@oracle.com::UYzYKir9gTlsl2ys:00000000000000000000000000000000000000001kPy
From: Elias Oltmanns <eo@nebensachen.de>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: [RFC] Disk shock protection (revisited)
Mail-Copies-To: nobody
Mail-Followup-To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jens Axboe <jens.axboe@oracle.com>
Date: Tue, 26 Feb 2008 00:56:31 +0100
Message-ID: <87skzgd1zk.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

at the moment I'm having another go at trying to make the disk shock
protection patch fit for upstream submission. However, there are still
some fundamental issues I'd like to discuss in order to make sure that
I'm heading in the right direction.

The general idea: A daemon running in user space monitors input data
from an accelerometer. When the daemon detects a critical condition,
i.e., a sudden acceleration (for instance, laptop slides off the desk),
it signals the kernel so the hard disk may be put into a (more) safe
state. To this end, the kernel has to issue an idle immediate command
with unload feature and stop the block layer queue afterwards. Once the
daemon tells us that the imminent danger is over, the most important
task for the kernel is to restart the block layer queue. See below for
more details.

This project is (and I personally am) mainly concerned with laptops
equipped with an accelerometer and an (S)ATA hard drive that supports
the unload feature of the idle immediate command. Jens Axboe, however,
suggested right from the beginning that there might be more general
applications for the block layer queue freezing part of the story. The
question is now to what extent are the requirements for a disk shock
protection facility (specific to ATA devices) and a general block layer
queue freezing facility compatible and in what way should they be
exposed to user space.

Probably, the major problem is that I don't really know what kind of
applications (apart from shock protection) I should be thinking of that
might want to have a queue freezing facility at hand. Still, one thing
seems obvious to me: For disk shock protection, time is of the essence,
whereas in the more general case of simple block layer queue freezing,
the situation is different as far as lower levels are concerned. In
particular, I'm inclined to believe that in the context of such a
general application it would be desirable to be able to freeze the queue
of an ATA device *without* issuing an idle immediate command first.
Obviously, the interface exposed to userspace would have to provide for
these diverging needs.

The disk-protect patch in it's current form [1] got stuck somewhere
between trying to provide a general queue freezing facility and
accommodating the needs of a disk shock protection setup. The sysfs
attributes required to request immediate disk parking from user space
are exported under /sys/block/. This is very convenient from the user's
point of view because the hierarchy is intuitive and you can easily find
the subdirectory associated to your hard disk. Conceptually, though, it
doesn't feel right. That is, for simple queue freezing, it is perfectly
alright, of course, but I don't see why and, indeed, how an ATA specific
feature like immediate disk parking could be controlled from the block
layer in a straight forward way. Besides, Jens, quite understandably,
objects to the introduction of yet another queue hook which is the
current way of telling ATA and non-ATA devices apart. Instead, he
suggests to implement generic block layer notification requests like
REQ_LB_OP_FREEZE of type REQ_TYPE_LINUX_BLOCK and let low level drivers
act upon it as they see fit. But then we would still need a way to
configure the way libata / ide actuaaly does respond to those block
layer messages. As explained above, the user might want to choose
whether or idle immediate is to be issued or simple queue freezing is
enough for his / her purposes. Besides, some drives that actually
support the unload feature of the idle immediate command don't report
that capability in the IDENTIFY data, so userspace needs a way to tell
the driver that the feature is available after all.

So, roughly my questions are these:

1. Who is to be in charge for the shock protection application? Should
   userspace speak to libata / ide directly (through sysfs) and the low
   level drivers will notify block layer to stop the queeue or should
   userspace always talk to the block layer, regardless whether we want
   to park an ATA disk or just freeze the queue? In the latter case we'd
   still need the option to configure the exact behaviour for ATA
   devices.
2. Depending on the answer to the previous question, by what mechanism
   should block layer and lld interact? Special requests, queue hooks or
   something in some way similar to power management functions (once
   suggested by James Bottomley)?
3. What is the preferred way to pass device specific configuration
   options to libata (preferrably at runtime, i.e., after module
   loading)?

Please let me know if you need any further information. Also, I will
certainly have more questions once I try to my hand at any of your
suggestions.

Thanks in advance,

Elias


[1] http://article.gmane.org/gmane.linux.drivers.hdaps.devel/1094
