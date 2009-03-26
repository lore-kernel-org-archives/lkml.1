Return-Path: <linux-kernel-owner+w=401wt.eu-S1758178AbZCZCqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178AbZCZCqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 22:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751039AbZCZCq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 22:46:29 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:9481 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbZCZCq2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 22:46:28 -0400
MIME-Version: 1.0
In-Reply-To: <f73f7ab80903251944s581166bbk31c26db50750814a@mail.gmail.com>
References: <20090324093245.GA22483@elte.hu>
	 <20090324041249.1133efb6.akpm@linux-foundation.org>
	 <20090325123744.GK23439@duck.suse.cz> <20090325150041.GM32307@mit.edu>
	 <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain>
	 <20090325185824.GO32307@mit.edu> <20090325194851.GA1617@infradead.org>
	 <20090325215016.GP32307@mit.edu>
	 <20090326021034.GA26559@srcf.ucam.org>
	 <f73f7ab80903251944s581166bbk31c26db50750814a@mail.gmail.com>
Date: Wed, 25 Mar 2009 22:46:26 -0400
Message-ID: <f73f7ab80903251946u593216eejb75d77c54fc8bdf@mail.gmail.com>
Subject: Re: Linux 2.6.29
From: Kyle Moffett <kyle@moffetthome.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apologies for the HTML email, resent in ASCII below:

> On Wed, Mar 25, 2009 at 10:10 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>>
>> If fsync() means anything other than "Get
>> my data on disk and then return" then we're breaking guarantees to
>> applications. The problem is that you're insisting that the only way
>> applications can ensure that their requests occur in order is to use
>> fsync(), which will achieve that but also provides guarantees above and
>> beyond what the majority of applications want.
>>
>> I've done some benchmarking now and I'm actually fairly happy with the
>> behaviour of ext4 now - it seems that the real world impact of doing the
>> block allocation at rename time isn't that significant, and if that's
>> the only practical way to ensure ordering guarantees in ext4 then fine.
>> But given that, I don't think there's any reason to try to convince
>> application authors to use fsync() more.
>
> Really, the problem is the filesystem interfaces are incomplete.  There are plenty of ways to specify a "FLUSH CACHE"-type command for an individual file or for the whole filesystem, but there aren't really any ways for programs to specify barriers (either whole-blockdev or per-LBA-range).  An fsync() implies you want to *wait* for the data... there's no way to ask it all to be queued with some ordering constraints.
> Perhaps we ought to add a couple extra open flags, O_BARRIER_BEFORE and O_BARRIER_AFTER, and rename3(), etc functions that take flags arguments?
> Or maybe a new set of syscalls like barrier(file1, file2) and fbarrier(fd1, fd2), which cause all pending changes (perhaps limit to this process?) to the file at fd1 to occur before any successive changes (again limited to this process?) to the file at fd2.
> It seems that rename(oldfile, newfile) with an already-existing newfile should automatically imply barrier(oldfile, newfile) before it occurs, simply because so many programs rely on that.
> In the cross-filesystem case, the fbarrier() might simply fsync(fd1), since that would provide the equivalent guarantee, albeit with possibly significant performance penalties.  I can't think of any easy way to prevent one filesystem from syncing writes to a particular file until another filesystem has finished an asynchronous fsync() call.  Perhaps a half-way solution would be to asynchronously fsync(fd1) and simply block the next write()/ioctl()/etc on fd2 until the async fsync returns.
> Are there other ideas for useful barrier()-generating file APIs?
> Cheers,
> Kyle Moffett
