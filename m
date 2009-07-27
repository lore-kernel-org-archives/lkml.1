Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbZG0VYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbZG0VYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 17:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbZG0VYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 17:24:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60177 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbZG0VY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 17:24:29 -0400
Date: Mon, 27 Jul 2009 17:24:29 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Robert Richter <robert.richter@amd.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at kernel/trace/ring_buffer.c:2289
 rb_advance_reader+0x2e/0xc5()
In-Reply-To: <20090727195058.GA25478@erda.amd.com>
Message-ID: <alpine.DEB.2.00.0907271601210.30108@gandalf.stny.rr.com>
References: <20090727195058.GA25478@erda.amd.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Robert,


On Mon, 27 Jul 2009, Robert Richter wrote:

> Steven,
> 
> I have workloads for oprofile that trigger warnings like this:
> 
> ------------[ cut here ]------------
> WARNING: at /dev/shm/.source/linux/kernel/trace/ring_buffer.c:2289 rb_advance_reader+0x2e/0xc5()

So this is this code:

        reader = rb_get_reader_page(cpu_buffer);

        /* This function should not be called when buffer is empty */
        if (RB_WARN_ON(cpu_buffer, !reader))
                return;


> Hardware name: Anaheim
> Modules linked in:
> Pid: 29, comm: events/2 Tainted: G        W  2.6.31-rc3-oprofile-x86_64-standard-00059-g5050dc2 #1
> Call Trace:
> [<ffffffff8106776f>] ? rb_advance_reader+0x2e/0xc5
> [<ffffffff81039ffe>] warn_slowpath_common+0x77/0x8f
> [<ffffffff8103a025>] warn_slowpath_null+0xf/0x11
> [<ffffffff8106776f>] rb_advance_reader+0x2e/0xc5
> [<ffffffff81068bda>] ring_buffer_consume+0xa0/0xd2
> [<ffffffff81326933>] op_cpu_buffer_read_entry+0x21/0x9e
> [<ffffffff810be3af>] ? __find_get_block+0x4b/0x165
> [<ffffffff8132749b>] sync_buffer+0xa5/0x401
> [<ffffffff810be3af>] ? __find_get_block+0x4b/0x165
> [<ffffffff81326c1b>] ? wq_sync_buffer+0x0/0x78
> [<ffffffff81326c76>] wq_sync_buffer+0x5b/0x78
> [<ffffffff8104aa30>] worker_thread+0x113/0x1ac
> [<ffffffff8104dd95>] ? autoremove_wake_function+0x0/0x38
> [<ffffffff8104a91d>] ? worker_thread+0x0/0x1ac
> [<ffffffff8104dc9a>] kthread+0x88/0x92
> [<ffffffff8100bdba>] child_rip+0xa/0x20
> [<ffffffff8104dc12>] ? kthread+0x0/0x92
> [<ffffffff8100bdb0>] ? child_rip+0x0/0x20
> ---[ end trace f561c0a58fcc89bd ]---
> 
> I am wondering when this may happen. It seems the following code in
> rb_get_reader_page() triggers this:
> 
>         /* check if we caught up to the tail */
>         reader = NULL;
>         if (cpu_buffer->commit_page == cpu_buffer->reader_page)
>                 goto out;

So you see that rb_advance_reader is called while the commit_page is the 
same as the reader page? Which means that there's nothing left in the 
buffer. This is interesting? Because in ring_buffer_consume we have:

        event = rb_buffer_peek(buffer, cpu, ts);
        if (!event)
                goto out_unlock;

        rb_advance_reader(cpu_buffer);

Where rb_buffer_peak checks to see if there's anything in the buffer, if 
there is, it returns an event, but does not increment the pointer. What 
you see is that we got an event, but then the event went away? Is there 
something else that could have read this buffer? You are not reading this 
from an NMI or something?

Or do you see any other WARN ONs happening? This would cause the locks to 
not be taken for reads.


> 
> It is very hard to find out the conditions for equal commit and reader
> pages.
> 
> Maybe you have any idea or could shortly explain the use of head,
> tail, commit and reader page pointers? When an overrun happens?
> (... or point me to some documentation.)

OK, I'll do it here, but there is documentation already posted, but I'm 
too lazy to search for it (writing it is easier ;-)

The ring buffer is made up of 3 pointers. New writes go to the tail 
pointer, and new reads, read from the head pointer.

To prevent races with the writer over writing the reader as the reader is 
reading the buffer, the reader is given a separate page. When a read wants 
to read the buffer, it swaps a blank page with the "head" page of the 
buffer. If there is less then a page worth of data in the ring buffer, the 
writer will also be on this page. When the write goes to the next page, it 
simply moves back into the ring buffer because the next pointer of the 
reader page points back into the ring buffer.

Since the write side is mosly lockless (and is totally lockless for the 32 
queue), when a writer wants data it must first reserve space in the ring 
buffer. Then the writer may copy directly into the ring buffer, and then 
it "commits" it. This is where the commit pointer comes from. The 
reserving of space from the ring buffer moves the tail. But the commit 
pointer points to the last committed entry is. That is, data that the 
reader can read. We can not allow a reader to read part of the ring buffer 
that the writer has yet to write to.

When the writer is done and commits the changes, the commit pointer goes 
to the end of that entry. This allows interrupts to preempt another 
writer, but it will not overwrite the data of the preempted writer. A 
write that interrupted another write will reserve data at the tail after 
the data that was already reserved.

The head, tail and commit pointers are made up in two. There is a page and 
index pointer. The page pointer points to the page and the index points to 
the index in that page. A commit page pointer points to the page that 
holds the commit and the commit index pointer points to the index in that 
page.

To make things easier, if the writer wraps the ring buffer and comes back 
to the head page, it will move the entire page.

The code you pointed out that shows the the reader == commit page, means 
that there was less than a page worth of data when the reader swapped the 
page from the buffer and the writer (or at least the commit page) was on 
the page that was swapped. Thus the commit page is the same as the reader 
page.

The conditions before hand checked to see if there was data left on the 
page to read. If there was, then it would return the reader page, but when 
the reader index == the commit index it means that there is no more data 
left to read on that page and returns NULL.

This is strange because it is the same code that the peak uses, but the 
previous call found something?

-- Steve

