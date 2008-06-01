Return-Path: <linux-kernel-owner+w=401wt.eu-S1754147AbYFAWsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbYFAWsr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 18:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbYFAWsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 18:48:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751961AbYFAWsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 18:48:36 -0400
Date: Sun, 1 Jun 2008 15:47:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@suse.cz>
Cc: mtk.manpages@gmail.com, Hugh Dickins <hugh@veritas.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: sync_file_range(SYNC_FILE_RANGE_WRITE) blocks?
Message-Id: <20080601154736.2e9f5905.akpm@linux-foundation.org>
In-Reply-To: <20080601222202.GA2255@elf.ucw.cz>
References: <20080530102619.GA2468@elf.ucw.cz>
	<Pine.LNX.4.64.0805301451020.19914@blonde.site>
	<20080530204307.GA4978@ucw.cz>
	<Pine.LNX.4.64.0805311925190.27293@blonde.site>
	<20080531173950.c4f04028.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0806010752510.24919@blonde.site>
	<20080601011501.199af80c.akpm@linux-foundation.org>
	<20080601114008.GC16843@elf.ucw.cz>
	<20080601133727.4e62ae55.akpm@linux-foundation.org>
	<20080601222202.GA2255@elf.ucw.cz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2008 00:22:02 +0200 Pavel Machek <pavel@suse.cz> wrote:

> Hi!
> 
> > > > I expect major users of this system call will be applications which do
> > > > small-sized overwrites into large files, mainly databases.  That is,
> > > > once the application developers discover its existence.  I'm still
> > > > getting expressions of wonder from people who I tell about the
> > > > five-year-old fadvise().
> > > 
> > > Hey, you have one user now, its called s2disk. But for this call to be
> > > useful, we'd need asynchronous variant... is there such thing?
> > 
> > Well if you're asking the syscall to shove more data into the block
> > layer than it can concurrently handle, sure, the block layer will
> > block.  It's tunable...
> 
> No, no, I don't want to overload block layer. All I want is ...
> 
> > > Okay, I can fork and do the call from another process, but...
> > 
> > I sense a strangeness.  What are you actually trying to do with all of this?
> 
> Okay, so I have around 400MB of data, I want it compressed, optionally
> encrypted and written to partition.
> 
> Now, if I do it "naturally", I do writes, followed by fsync.
> 
> That's bad, because kernel does not start write out immediately, and
> we waste time with idle disk. (If data compress really well, or
> encryption is off, this is significant).
> 
> So we improve on this, by doing sync_file_range(SYNC_FILE_RANGE_WRITE)
> periodically. That keeps the disk busy, but occassionaly blocks the
> cpu... wasting time (which mostly hurts in compression+encryption
> case).

yep.  That's another use of sync_file_range(): to allow smart userspace
to optimise the kernel's IO scheduling decisions.

> So... how can I keep _both_ cpu and disk busy?

pthread_create() ;)

How about this:

- Add a new SYNC_FILE_RANGE_NON_BLOCKING

- If userspace set that flag, turn on writeback_control.nonblocking
  in __filemap_fdatawrite_range().

- test it a lot.

It will be userspace's responsibility to avoid burning huge amounts of
CPU repeatedly calling sync_file_range() and having it not actually write
anything.


