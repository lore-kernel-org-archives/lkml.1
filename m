Return-Path: <linux-kernel-owner+w=401wt.eu-S964888AbXCPLoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964888AbXCPLoj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 07:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964873AbXCPLoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 07:44:39 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42133 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964802AbXCPLoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 07:44:38 -0400
Date: Fri, 16 Mar 2007 13:44:27 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, hch@infradead.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 2/5] revoke: core code
In-Reply-To: <20070316032624.c6db84fc.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703161331580.21300@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0703111330100.765@sbz-30.cs.Helsinki.FI>
 <20070315173438.efadd514.akpm@linux-foundation.org>
 <84144f020703152344u588da670ge14c1ec5797c2b86@mail.gmail.com>
 <20070316032624.c6db84fc.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2007, Andrew Morton wrote:
> I assume that any future callers to sys_read() will reliably do the right
> thing at this stage, so we are concerned with threads which are presently
> partway through a read from this inode?

Yes. We first revoke the file descriptors under tasklist_lock after which 
any new operations on the revoked inode descriptors fail.

On Fri, 16 Mar 2007, Andrew Morton wrote:
> If it _is_ accurate then hm, tricky.  It all rather depends upon how the
> relevant filesystem implements reading (and writing?).  Which is why you
> made it a file_operation, fair enough.

Yeah, filesystem dependent. Writes are not a problem as do_sync() will 
wait until the writers are done. For that part, generic_file_revoke() 
should be fine although suboptimal for most filesystems.

On Fri, 16 Mar 2007, Andrew Morton wrote:
> But even for ext2 and ext3 (please keep ext4 in sync with ext3 changes,
> btw), if some process is partway through a big page_cache_readahead()
> operation then a concurrent invalidate_inode_pages2() call won't worry it
> at all: the pagecache will be reinstantiated and do_generic_mapping_read()
> will proceed to copy that pagecache out to the user after the revoke() has
> returned.  I think.

That's bad. Can we perhaps wait until readers are done?

On Fri, 16 Mar 2007, Andrew Morton wrote: 
> I'm afraid I havent paid any attention to this revoke proposal before, I
> don't understand the usecases nor the implementation details so things
> which are implicitly-obvious-to-you must be explained to me.  But others
> will benefit from that explanation too ;)  What, exactly, are we trying to do
> with the already-opened files and the currently-in-progress syscalls?

You use revoke() (with chown, for example) to gain exclusive access to 
an inode that might be in use by other processes. This means that we must 
mke sure that:

  - operations on opened file descriptors pointing to that inode fail
  - there are no shared mappings visible to other processes
  - in-progress system calls are either completed (writes) or abort 
    (reads)

After revoke() system call returns, you are guaranteed to have revoked 
access to an inode for any processes that had access to it when you 
started the operation. The caller is responsible for blocking any future 
open(2) calls that might occur while revoke() takes care of fork(2) and 
dup(2) during the operation.

On Fri, 16 Mar 2007, Andrew Morton wrote: 
> (A concurrent direct-io read might be a problem too?)

Good point. We would need to take down those too.

			Pekka
