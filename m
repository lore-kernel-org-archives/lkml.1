Return-Path: <linux-kernel-owner+w=401wt.eu-S1754567AbYATQHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbYATQHG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 11:07:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbYATQGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 11:06:55 -0500
Received: from brick.kernel.dk ([87.55.233.238]:10691 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416AbYATQGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 11:06:55 -0500
Date: Sun, 20 Jan 2008 17:06:51 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrea Righi <righiandr@users.sourceforge.net>
Cc: Naveen Gupta <ngupta@google.com>, Paul Menage <menage@google.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cgroup: limit block I/O bandwidth
Message-ID: <20080120160651.GU6258@kernel.dk>
References: <2846be6b0801181439o55dcff09ted2b8f817e7ba682@mail.gmail.com> <4791DC2C.9090405@users.sourceforge.net> <4793507B.6040706@users.sourceforge.net> <20080120143239.GS6258@kernel.dk> <47936BC1.9060805@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47936BC1.9060805@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20 2008, Andrea Righi wrote:
> Jens Axboe wrote:
> > Your approach is totally flawed, imho. For instance, you don't want a
> > process to be able to dirty memory at foo mb/sec but only actually
> > write them out at bar mb/sec.
> 
> Right. Actually my problem here is that the processes that write out
> blocks are different respect to the processes that write bytes in
> memory, and I would be able to add limits on those processes that are
> dirtying memory.

That's another reason why you cannot do this on a per-process or group
basis, because you have no way of mapping back from the io queue path
which process originally dirtied this memory.

> > The noop-iosched changes are also very buggy. The queue back pointer
> > breaks reference counting and the task pointer storage assumes the task
> > will also always be around. That's of course not the case.
> 
> Yes, this really need a lot of fixes. I simply posted the patch to know
> if such approach (in general) could have sense or not.

It doesn't need fixes, it needs to be redesigned :-). No amount of
fixing will make the patch you posted correct, since the approach is
simply not feasible.

> > IOW, you are doing this at the wrong level.
> > 
> > What problem are you trying to solve?
> 
> Limiting block I/O bandwidth for tasks that belong to a generic cgroup,
> in order to provide a sort of a QoS on block I/O.
> 
> Anyway, I'm quite new in the wonderful land of the I/O scheduling, so
> any help is appreciated.

For starters, you want to throttle when queuing IO, not dispatching it.
If you need to modify IO schedulers, then you are already at the wrong
level. That doesn't solve the write problem, but reads can be done.

If you want to solve for both read/write(2), then move the code to that
level. That wont work for eg mmap, though...

And as Balbir notes, the openvz group have been looking at some of these
problems as well. As has lots of other people btw, you probably want to
search around a bit and acquaint yourself with some of that work.

-- 
Jens Axboe

