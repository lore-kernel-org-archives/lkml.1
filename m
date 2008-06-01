Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbYFAUiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbYFAUiV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 16:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbYFAUiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 16:38:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40271 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751924AbYFAUiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 16:38:11 -0400
Date: Sun, 1 Jun 2008 13:37:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@suse.cz>
Cc: mtk.manpages@gmail.com, Hugh Dickins <hugh@veritas.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: sync_file_range(SYNC_FILE_RANGE_WRITE) blocks?
Message-Id: <20080601133727.4e62ae55.akpm@linux-foundation.org>
In-Reply-To: <20080601114008.GC16843@elf.ucw.cz>
References: <20080530102619.GA2468@elf.ucw.cz>
	<Pine.LNX.4.64.0805301451020.19914@blonde.site>
	<20080530204307.GA4978@ucw.cz>
	<Pine.LNX.4.64.0805311925190.27293@blonde.site>
	<20080531173950.c4f04028.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0806010752510.24919@blonde.site>
	<20080601011501.199af80c.akpm@linux-foundation.org>
	<20080601114008.GC16843@elf.ucw.cz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jun 2008 13:40:09 +0200 Pavel Machek <pavel@suse.cz> wrote:

> Hi!
> 
> > > > > All I can say so far is that I find the same as you do:
> > > > > SYNC_FILE_RANGE_WRITE (after writing) takes a significant amount of time,
> > > > > more than half as long as when you add in SYNC_FILE_RANGE_WAIT_AFTER too.
> > > > > 
> > > > > Which make the sync_file_range call pretty pointless: your usage seems
> > > > > perfectly reasonable to me, but somehow we've broken its behaviour.
> > > > > I'll be investigating ...
> > > > 
> > > > It will block on disk queue fullness - sysrq-W will tell.
> > > 
> > > Ah, thank you.  What a disappointment, though it's understandable.
> > > Doesn't that very severely limit the usefulness of the system call?
> > 
> > A bit.  The request queue size is runtime tunable though.
> 
> Which /sys is that?

/sys/block/sda/queue/nr_requests

> What happens if I set the queue size to pretty
> much infinity, will memory management die horribly?

In theory, no - it's always caused problems when the VM/VFS/FS layer
has relied upon request-queue exhaustion for throttling.  Hence all
that code is supposed to work OK when there is no request-queue
blocking.  Of course, (theory/practice != 1.0).

> > I expect major users of this system call will be applications which do
> > small-sized overwrites into large files, mainly databases.  That is,
> > once the application developers discover its existence.  I'm still
> > getting expressions of wonder from people who I tell about the
> > five-year-old fadvise().
> 
> Hey, you have one user now, its called s2disk. But for this call to be
> useful, we'd need asynchronous variant... is there such thing?

Well if you're asking the syscall to shove more data into the block
layer than it can concurrently handle, sure, the block layer will
block.  It's tunable...

It can still block in places, of course - we might need to do
synchronous reads to get at metadata and we'll need to allocate memory.

> Okay, I can fork and do the call from another process, but...

I sense a strangeness.  What are you actually trying to do with all of this?

Bear in mind that sync_file_range() doesn't sync metadata (ie: indirect
blocks).  So if they weren't already known to have been written, the
data isn't safe.

> - * range which are not presently under writeback.
> + * range which are not presently under writeback. Notice that even this this
> + *  may and will block if you attempt to write more than request queue size.

um, OK. I'll fix the grammar a bit there.
