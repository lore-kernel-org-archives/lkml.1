Return-Path: <linux-kernel-owner+w=401wt.eu-S933687AbXJQTRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933687AbXJQTRb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbXJQTRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:17:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59714 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757678AbXJQTRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:17:08 -0400
Date: Wed, 17 Oct 2007 12:16:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [RESEND] file operations: release can race with read/write?
Message-Id: <20071017121656.484646a5.akpm@linux-foundation.org>
In-Reply-To: <adaodexh9uz.fsf@cisco.com>
References: <adave96ki0x.fsf@cisco.com>
	<adaodexh9uz.fsf@cisco.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007 11:30:44 -0700 Roland Dreier <rdreier@cisco.com> wrote:

> [Resending, directly to a couple likely suspects this time, in the
> hope of getting a reply... thanks]
> 
> I have a question about the synchronization of file_operations: is it
> intended that the .release method of a file can be called while a
> .read or .write method is still running for that file?
> 
> The reason I ask is that I've seen a crash in practice that appears to
> be caused by this race, and I'm wondering whether the correct fix is
> to add synchronization between .read/.write and .release to the
> driver's methods (this is a character device), or whether the core
> kernel is supposed to provide this synchronization.
> 
> I've written a quick test case that seems to show this happen in
> practice, and reading the code in fs/open.c and fs/read_write.c I see
> no reason why this race can't happen: sys_read() and sys_write() just
> do fget_light(), which will not increment the file's reference count
> on the fast path, so a racing sys_close() from another thread could do
> the final fput() that ends up calling the file's .release method
> before the read or write has finished.

After pthread_create()'s clone() you should have files->count==2, so
fget_light() will do the full atomic_inc_not_zero() thing?

> I think the actual file data structure is OK, because it is freed with
> RCU, so it won't be freed too soon.  But a .release method may free
> other driver-internal state that is still in use because of this race.
> 
> It seems that we wouldn't want to give up the fget_light()
> optimization in read/write, so probably the right place to handle this
> is in the driver.  But on the other hand, this is kind of a subtle
> booby trap that has been laid, and maybe there is a clever way to
> handle this.  So I would appreciate guidance from smarter people.
> 
> Thanks,
>   Roland
> 
> 
> BTW, here's the test case -- it seems pretty conclusive to me, but
> maybe I'm all wet and misunderstanding things.  There's a kernel
> module that just prints "Write raced with close?" if it sees the race,
> and a userspace driver that just spawns two threads, one that does
> open/close in a loop and one that does write in a loop.  Running this
> on my machine, I see several race messages get printed.
> 

That seems pretty conclusive.  I haven't actually thought about this yet -
I just wanted to clarify that fget_light() thing.

