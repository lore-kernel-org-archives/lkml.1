Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbXJYScA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbXJYScA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 14:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbXJYSbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 14:31:52 -0400
Received: from [207.173.201.20] ([207.173.201.20]:52086 "EHLO tetsuo.zabbo.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752685AbXJYSbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 14:31:51 -0400
Message-ID: <4720E117.8030805@oracle.com>
Date: Thu, 25 Oct 2007 11:31:51 -0700
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>,
       linux-aio@kvack.org
Subject: Re: [PATCH 5/5] Make wait_on_retry_sync_kiocb killable
References: <11932286982175-git-send-email-matthew@wil.cx> <11932286982021-git-send-email-matthew@wil.cx>
In-Reply-To: <11932286982021-git-send-email-matthew@wil.cx>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Matthew Wilcox wrote:
> Use TASK_KILLABLE to allow wait_on_retry_sync_kiocb to return -EINTR.
> All callers then check the return value and break out of their loops.

This won't work because "sync" kiocbs are a nasty hack that don't follow
the (also nasty) refcounting patterns of the aio core.

-EIOCBRETRY means that aio_{read,write}() has taken on the "IO" kiocb
reference and has ensured that call kick_iocb() will be called in the
future.

Usually kick_iocb() would queue the kiocb to have its ki_retry method
called by the kernel aio threads while holding that reference.  But
"sync" kiocbs are on-stack and aren't reference counted.  kick_iocb() magic:

        /* sync iocbs are easy: they can only ever be executing from a

         * single context. */
        if (is_sync_kiocb(iocb)) {
                kiocbSetKicked(iocb);
                wake_up_process(iocb->ki_obj.tsk);

                return;

        }

So, with this patch, if we catch a signal and return from
wait_on_retry_sync_kiocb() and return from do_sync_{read,write}() then
that on-stack sync kiocb is going to be long gone when kick_iocb() goes
to work with it.

So the first step would be to make sync kiocbs real refcounted
structures so that kick_iocb() could find that the sync submitter has
disappeared.

But then we have to worry about leaving retrying operations in flight
after the sync submitter has returned from their system call.  They
might be VERY SURPRISED to find that a read() implemented with
do_sync_read() is still writing into their userspace pointer after the
syscall was interrupted by a signal.

This leads us to the possibility of working with the ki_cancel method to
stop a pending operation if a signal is caught from a sync submitter.
In practice, nothing sets ki_cancel.

And finally, this code will not be run in a solely mainline kernel.  The
only thing in mainline that returns -EIOCBRETRY is the goofy usb gadget.
 It has both ->{read,write} and ->aio_{read,write} file op methods so
vfs_{read,write}() will never call do_sync_{read,write}().  Sure,
out-of-tree aio providers (SDP?) might get caught up in this.

(Ha ha!  Welcome to fs/aio.c!)

So I'm not sure where to go with this.  It's a mess, but it doesn't seem
like anything is using it.  A significant clean up of the retry and
cancelation support in fs/aio.c is in flight.  Maybe we can revisit this
once that settles down.

- z
