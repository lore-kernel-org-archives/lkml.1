Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbYFAV7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbYFAV7h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 17:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbYFAV73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 17:59:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56493 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbYFAV73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 17:59:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: sync_file_range(SYNC_FILE_RANGE_WRITE) blocks?
Date: Mon, 2 Jun 2008 00:00:07 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@suse.cz>, mtk.manpages@gmail.com,
       Hugh Dickins <hugh@veritas.com>,
       kernel list <linux-kernel@vger.kernel.org>
References: <20080530102619.GA2468@elf.ucw.cz> <20080601114008.GC16843@elf.ucw.cz> <20080601133727.4e62ae55.akpm@linux-foundation.org>
In-Reply-To: <20080601133727.4e62ae55.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806020000.07708.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 1 of June 2008, Andrew Morton wrote:
> On Sun, 1 Jun 2008 13:40:09 +0200 Pavel Machek <pavel@suse.cz> wrote:
> 
> > Hi!
> > 
> > > > > > All I can say so far is that I find the same as you do:
> > > > > > SYNC_FILE_RANGE_WRITE (after writing) takes a significant amount of time,
> > > > > > more than half as long as when you add in SYNC_FILE_RANGE_WAIT_AFTER too.
> > > > > > 
> > > > > > Which make the sync_file_range call pretty pointless: your usage seems
> > > > > > perfectly reasonable to me, but somehow we've broken its behaviour.
> > > > > > I'll be investigating ...
> > > > > 
> > > > > It will block on disk queue fullness - sysrq-W will tell.
> > > > 
> > > > Ah, thank you.  What a disappointment, though it's understandable.
> > > > Doesn't that very severely limit the usefulness of the system call?
> > > 
> > > A bit.  The request queue size is runtime tunable though.
> > 
> > Which /sys is that?
> 
> /sys/block/sda/queue/nr_requests
> 
> > What happens if I set the queue size to pretty
> > much infinity, will memory management die horribly?
> 
> In theory, no - it's always caused problems when the VM/VFS/FS layer
> has relied upon request-queue exhaustion for throttling.  Hence all
> that code is supposed to work OK when there is no request-queue
> blocking.  Of course, (theory/practice != 1.0).
> 
> > > I expect major users of this system call will be applications which do
> > > small-sized overwrites into large files, mainly databases.  That is,
> > > once the application developers discover its existence.  I'm still
> > > getting expressions of wonder from people who I tell about the
> > > five-year-old fadvise().
> > 
> > Hey, you have one user now, its called s2disk. But for this call to be
> > useful, we'd need asynchronous variant... is there such thing?
> 
> Well if you're asking the syscall to shove more data into the block
> layer than it can concurrently handle, sure, the block layer will
> block.  It's tunable...
> 
> It can still block in places, of course - we might need to do
> synchronous reads to get at metadata and we'll need to allocate memory.
> 
> > Okay, I can fork and do the call from another process, but...
> 
> I sense a strangeness.  What are you actually trying to do with all of this?

Pavel is trying to avoid me doing multithreaded s2disk, more or less. ;-)

However, I have some numbers showing that multithreaded image saving actually
helps a lot in case the image is compressed and encrypted.

Thanks,
Rafael
