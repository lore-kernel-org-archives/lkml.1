Return-Path: <linux-kernel-owner+w=401wt.eu-S1753410AbZCZCyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbZCZCyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 22:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751039AbZCZCyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 22:54:10 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:60041 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbZCZCyJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 22:54:09 -0400
MIME-Version: 1.0
In-Reply-To: <20090326024753.GA27299@srcf.ucam.org>
References: <20090324103111.GA26691@elte.hu>
	 <20090325123744.GK23439@duck.suse.cz> <20090325150041.GM32307@mit.edu>
	 <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain>
	 <20090325185824.GO32307@mit.edu> <20090325194851.GA1617@infradead.org>
	 <20090325215016.GP32307@mit.edu>
	 <20090326021034.GA26559@srcf.ucam.org>
	 <f73f7ab80903251944s581166bbk31c26db50750814a@mail.gmail.com>
	 <20090326024753.GA27299@srcf.ucam.org>
Date: Wed, 25 Mar 2009 22:54:05 -0400
Message-ID: <f73f7ab80903251954t48b72c92x535e6698fef4749d@mail.gmail.com>
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

On Wed, Mar 25, 2009 at 10:47 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Wed, Mar 25, 2009 at 10:44:44PM -0400, Kyle Moffett wrote:
>
>>    Perhaps we ought to add a couple extra open flags, O_BARRIER_BEFORE and
>>    O_BARRIER_AFTER, and rename3(), etc functions that take flags arguments?
>>    Or maybe a new set of syscalls like barrier(file1, file2) and
>>    fbarrier(fd1, fd2), which cause all pending changes (perhaps limit to this
>>    process?) to the file at fd1 to occur before any successive changes (again
>>    limited to this process?) to the file at fd2.
>
> That's an option, but what would benefit? If rename is expected to
> preserve ordering (which I think it has to, in order to avoid breaking
> existing code) then are there any other interesting use cases?

The use cases would be programs like GIT (or any other kind of
database) where you want to ensure that your new pulled packfile has
fully hit disk before the ref update does.  If that ordering
constraint is applied, then we don't really care when we crash,
because either we have a partial packfile update (and we have to pull
again) or we have the whole thing.  The rename() barrier would ensure
that we either have the old ref or the new ref, but it would not check
to ensure that the whole packfile is on disk yet.

I would imagine that databases like MySQL could also use such support
to help speed up their database transaction support, instead of having
to run a bunch of threads which fsync() and buffer data internally.

Cheers,
Kyle Moffett
