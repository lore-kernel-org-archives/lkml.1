Return-Path: <linux-kernel-owner+w=401wt.eu-S1751690AbXCPM0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbXCPM0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 08:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbXCPM0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 08:26:19 -0400
Received: from smtp.osdl.org ([65.172.181.24]:44021 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbXCPM0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 08:26:17 -0400
Date: Fri, 16 Mar 2007 04:26:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 2/5] revoke: core code
Message-Id: <20070316042600.3e1bd424.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703161331580.21300@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0703111330100.765@sbz-30.cs.Helsinki.FI>
	<20070315173438.efadd514.akpm@linux-foundation.org>
	<84144f020703152344u588da670ge14c1ec5797c2b86@mail.gmail.com>
	<20070316032624.c6db84fc.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0703161331580.21300@sbz-30.cs.Helsinki.FI>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2007 13:44:27 +0200 (EET) Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

> On Fri, 16 Mar 2007, Andrew Morton wrote:
> > I assume that any future callers to sys_read() will reliably do the right
> > thing at this stage, so we are concerned with threads which are presently
> > partway through a read from this inode?
> 
> Yes. We first revoke the file descriptors under tasklist_lock after which 
> any new operations on the revoked inode descriptors fail.

OK.

> On Fri, 16 Mar 2007, Andrew Morton wrote:
> > If it _is_ accurate then hm, tricky.  It all rather depends upon how the
> > relevant filesystem implements reading (and writing?).  Which is why you
> > made it a file_operation, fair enough.
> 
> Yeah, filesystem dependent. Writes are not a problem as do_sync() will 
> wait until the writers are done. For that part, generic_file_revoke() 
> should be fine although suboptimal for most filesystems.

I'm not sure that running do_fsync() will guarantee that all sys_write()
callers will have finished their syscall.  Probably they will have, in
practice.  But there is logic in the sync paths to deliberately bale out
if we're competing with ongoing dirtyings, to avoid livelocking.

> On Fri, 16 Mar 2007, Andrew Morton wrote:
> > But even for ext2 and ext3 (please keep ext4 in sync with ext3 changes,
> > btw), if some process is partway through a big page_cache_readahead()
> > operation then a concurrent invalidate_inode_pages2() call won't worry it
> > at all: the pagecache will be reinstantiated and do_generic_mapping_read()
> > will proceed to copy that pagecache out to the user after the revoke() has
> > returned.  I think.
> 
> That's bad. Can we perhaps wait until readers are done?

Gee.  The only way I can think of guaranteeing this is with a full-on
freeze_processes/thaw_processes, which is the biggest synchronisation
barrier we have, apart from sys_reboot().

Now it just so happens that for ext2/3/4-style filesystems, we re-check
i_size inside the inner loop to handle concurrent truncates (see
i_size_read() calls in do_generic_mapping_read().

Perhaps the revoke() code can hook into there in some fashion to tell the
process-which-is-presently-running-read() that it is now reading crap.

That still doesn't give us a way of making revoke() wait until all
read()ers have finished their reads.

What you're trying to do here is very similar to truncate(), and truncate()
has had a lot of work put into it, and it does work.  So if revoke() were
to

a) grab i_mutex to keep write()s away
b) set i_size to zero
c) run truncate_inode_pages()

then I expect that you'll have the guarantees which you need.  This is
because the read() caller will synchronise against revoke() at each
lock_page(), and the read() caller will check i_size prior to locking each
page.

However, modifying i_size like this might be a problem - the inode could be
dirty and it'll get written to disk!  Perhaps we could change i_size_read()
to cheat and to return zero if there's a revoke in progress.

> On Fri, 16 Mar 2007, Andrew Morton wrote: 
> > I'm afraid I havent paid any attention to this revoke proposal before, I
> > don't understand the usecases nor the implementation details so things
> > which are implicitly-obvious-to-you must be explained to me.  But others
> > will benefit from that explanation too ;)  What, exactly, are we trying to do
> > with the already-opened files and the currently-in-progress syscalls?
> 
> You use revoke() (with chown, for example) to gain exclusive access to 
> an inode that might be in use by other processes. This means that we must 
> mke sure that:
> 
>   - operations on opened file descriptors pointing to that inode fail
>   - there are no shared mappings visible to other processes
>   - in-progress system calls are either completed (writes) or abort 
>     (reads)
> 
> After revoke() system call returns, you are guaranteed to have revoked 
> access to an inode for any processes that had access to it when you 
> started the operation. The caller is responsible for blocking any future 
> open(2) calls that might occur while revoke() takes care of fork(2) and 
> dup(2) during the operation.

<adds that to the changelog>

> On Fri, 16 Mar 2007, Andrew Morton wrote: 
> > (A concurrent direct-io read might be a problem too?)
> 
> Good point. We would need to take down those too.
> 

direct-io caches i_size for the whole operation and sometimes re-reads it. 
It does funky things to handle concurrent reads and writes.  Probably for
the DIO_LOCKING case we're OK, as direct-io has to re-check i_size_read()
after reacquiring i_mutex.  It's complex, but again, our path to success
here will be to piggyback on the existing handling of truncation.


