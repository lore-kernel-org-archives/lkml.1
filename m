Return-Path: <linux-kernel-owner+w=401wt.eu-S1761690AbZCYSKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761690AbZCYSKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 14:10:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbZCYSJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 14:09:56 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:42342 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbZCYSJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 14:09:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=A4MN0FPsj+NQfcggyXh0+Ru/xYqexoUvX5xIZ3NCc9gLyddJYlsLyzq+2lKjlT28B9
         wSlF3LlIpdH7It3uVdtXqrhbXdH4WN9ZWEb7Zxn0vt06CkedJwH+klOODQ1b7h4oKGAo
         NBHBr1QaxHl20BIVtdsOdvn6SFzNLDkd9D9ZY=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>
	 <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>
	 <20090324091545.758d00f5@lxorguk.ukuu.org.uk>
	 <20090324093245.GA22483@elte.hu>
	 <20090324101011.6555a0b9@lxorguk.ukuu.org.uk>
	 <20090324103111.GA26691@elte.hu>
	 <20090324041249.1133efb6.akpm@linux-foundation.org>
	 <20090325123744.GK23439@duck.suse.cz> <20090325150041.GM32307@mit.edu>
	 <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain>
Date: Wed, 25 Mar 2009 11:09:52 -0700
Message-ID: <72dbd3150903251109x75aa5d8ke8277247c2f292f9@mail.gmail.com>
Subject: Re: Linux 2.6.29
From: David Rees <drees76@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 10:29 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, 25 Mar 2009, Theodore Tso wrote:
>> I still think the fsync() problem is the much bigger deal, and solving
>> the contention problem isn't going to solve the fsync() latency problem
>> with ext3 data=ordered mode.
>
> The fsync() problem is really annoying, but what is doubly annoying is
> that sometimes one process doing fsync() (or sync) seems to cause other
> processes to hickup too.
>
> Now, I personally solved that problem by moving to (good) SSD's on my
> desktop, and I think that's indeed the long-term solution. But it would be
> good to try to figure out a solution in the short term for people who
> don't have new hardware thrown at them from random companies too.

Throwing SSDs at it only increases the limit before which it becomes
an issue.  They hide the underlying issue and are only a workaround.
Create enough dirty data and you'll get the same latencies, it's just
that that limit is now a lot higher.  Your Intel SSD will write
streaming data 2-4 times faster than your typical disk - and can be an
order of magnitude faster when it comes to small, random writes.

> I suspect it's a combination of filesystem transaction locking, together
> with the VM wanting to write out some unrelated blocks or inodes due to
> the system just being close to the dirty limits. Which is why the
> system-wide hickups then happen especially when writing big files.
>
> The VM _tries_ to do writes in the background, but if the writepage() path
> hits a filesystem-level blocking lock, that background write suddenly
> becomes largely synchronous.
>
> I suspect there is also some possibility of confusion with inter-file
> (false) metadata dependencies. If a filesystem were to think that the file
> size is metadata that should be journaled (in a single journal), and the
> journaling code then decides that it needs to do those meta-data updates
> in the correct order (ie the big file write _before_ the file write that
> wants to be fsync'ed), then the fsync() will be delayed by a totally
> irrelevant large file having to have its data written out (due to
> data=ordered or whatever).

It certainly "feels" like that is the case from the workloads I have
that generate high latencies.

-Dave
