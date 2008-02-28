Return-Path: <linux-kernel-owner+w=401wt.eu-S1758660AbYB1LZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660AbYB1LZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 06:25:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755999AbYB1LZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 06:25:16 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56203 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754622AbYB1LZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 06:25:14 -0500
Date: Thu, 28 Feb 2008 11:13:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] Disk shock protection (revisited)
Message-ID: <20080228111349.6831925c@core>
In-Reply-To: <87mypl8p49.fsf@denkblock.local>
References: <87skzgd1zk.fsf@denkblock.local>
	<20080226123946.75dbe3d2@core>
	<87mypl8p49.fsf@denkblock.local>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > That sounds like a non starter. What if the box is busy, what if the
> > daemon or something you touch needs memory and causes paging ?
> 
> The daemon runs mlock'd anyway, so there won't be any need for paging

mlock does not guarantee anything of that form. A syscall by an mlocked
process which causes a memory allocation can cause paging of another
process on the system.

> there. As for responsiveness under heavy load, I'm not quite sure I get
> your meaning. On my system, at least, the only way I have managed to
> decrease responsiveness noticeably is to cause a lot of I/O operations

It depends a lot on hardware but you can certainly get user space delays
in seconds as an extreme worst case.

> stays in memory all the time, it can go ahead and notify the kernel that
> the disk heads should be unloaded. The kernel takes care to insert the
> idle immediate command at the head of the queue. Am I missing something?

Yes - the fact we may well have bounced off the floor already.

> happens to have access to more than one accelerometer. Right now, I don't
> feel quite up to the job to write a dedicated kernel module that
> replaces the daemon and is designed in a sufficiently generic way to

Thats fine - nothing says a user space daemon isn't a good starting point.

> > Yep. Pity the worst case completion time for an IDE I/O is 60 seconds or
> > so.
> 
> Well, the low level driver would have to make sure that no requests are
> accepted after the idle immediate command has been received. The block

No doesn't work like that. The command currently being processed on IDE
can take up to 60 seconds to complete. Idle immediate (on the devices it
works for - it hangs some) is very special in that it can be used in some
cases to interrupt a running command sequence. It requires a significant
amount of work in the driver layer to then clean up and requeue the
partial command and to know if it is possible to do so.

> and freezing the block layer queue eventually in order to stop
> the request_fn() from being called needlessly. Once the specified time
> is up or if the daemon writes 0 to that sysfs attrribute before that
> time, it is kernel space code again that takes care that normal
> operation is resumed.

I think we have three things here

1.	A general queue freeze scheme from user space
2.	A general implementation of a queue freeze that stops further
command issuing while the queue is blocked
3.	The ability for devices to provide a function to be called
when a queue freeze is done (ie idle immediate and the like)

The fine details of how you abort an ATA command don't actually matter
for an initial implementation and can be written once the core stuff is
right.

> Well, this is something we'll have to discuss too since I don't have the
> SATA specs and haven't a clue as to how idle immediate behaves in an NCQ
> enabled system. However, my question was about something more basic than

I have the specs, and I don't understand it or even if it is valid to do
so. Some research (as in trying it and seeing) may be needed.

> Yes, I thought as much. I just haven't quite worked out yet where or how
> I am supposed to introduce libata specific sysfs attributes since this
> seems to be left to the scsi midlayer so far.

The scsi midlayer is the main manager of queues so that seems sane - and
if you've got the basic queue freeze logic right then one assumes it will
work for scsi too.

