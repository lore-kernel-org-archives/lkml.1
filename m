Return-Path: <linux-kernel-owner+w=401wt.eu-S1756162AbZCZDvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbZCZDvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 23:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbZCZDvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 23:51:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42707 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754100AbZCZDvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 23:51:21 -0400
Date: Wed, 25 Mar 2009 20:40:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Kyle Moffett <kyle@moffetthome.net>
cc: Jeff Garzik <jeff@garzik.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <f73f7ab80903252003j248b416ewe52b613c5b53066c@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0903252017100.3032@localhost.localdomain>
References: <20090324093245.GA22483@elte.hu> <20090325150041.GM32307@mit.edu>  <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain>  <20090325185824.GO32307@mit.edu> <20090325194851.GA1617@infradead.org>  <20090325215016.GP32307@mit.edu> 
 <20090326021034.GA26559@srcf.ucam.org>  <f73f7ab80903251944s581166bbk31c26db50750814a@mail.gmail.com>  <f73f7ab80903251946u593216eejb75d77c54fc8bdf@mail.gmail.com>  <49CAEDA7.1080902@garzik.org>
 <f73f7ab80903252003j248b416ewe52b613c5b53066c@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Mar 2009, Kyle Moffett wrote:
> 
> Well, I think the goal is not to *replace* the POSIX API or even
> provide "transactional" guarantees.  The performance penalty for
> atomic transactions is pretty high, and most programs (like GIT) don't
> really give a damn, as they provide that on a higher level.

Speaking with my 'git' hat on, I can tell that

 - git was designed to have almost minimal requirements from the 
   filesystem, and to not do anything even half-way clever.

 - despite that, we've hit an absolute metric sh*tload of filesystem bugs 
   and misfeatures. Some very much in Linux. And some I bet git was the 
   first to ever notice, exactly because git tries to be really anal, in 
   ways that I can pretty much guarantee no normal program _ever_ is.

For example, the latest one came from git actually checking the error code 
from 'close()'. Tell me the last time you saw anybody do that in a real 
program. Hint: it's just not done. EVER. Git does it (and even then, git 
does it only for the core git object files that we care about so much), 
and we found a real data-loss CIFS bug thanks to that. Afaik, the bug has 
been there for a year and half. Don't tell me nobody uses cifs.

Before that, we had cross-directory rename bugs. Or the inexplicable 
"pread() doesn't work correctly on HP-UX". Or the "readdir() returns the 
same entry multiple times" bug. And all of this without ever doing 
anything even _remotely_ odd. No file locking, no rewriting of old files, 
no lseek()ing in directories, no nothing.

Anybody who wants more complex and subtle filesystem interfaces is just 
crazy. Not only will they never get used, they'll definitely not be 
stable.

> To be honest I think we could provide much better data consistency
> guarantees and remove a lot of fsync() calls with just a basic
> per-filesystem barrier() call.

The problem is not that we have a lot of fsync() calls. Quite the reverse. 
fsync() is really really rare. So is being careful in general. The number 
of applications that do even the _minimal_ safety-net of "create new file, 
rename it atomically over an old one" is basically zero. Almost everybody 
ends up rewriting files with something like

	open(name, O_CREAT | O_TRUNC, 0666)
	write();
	close();

where there isn't an fsync in sight, nor any "create temp file", nor 
likely even any real error checking on the write(), much less the 
close().

And if we have a Linux-specific magic system call or sync action, it's 
going to be even more rarely used than fsync(). Do you think anybody 
really uses the OS X FSYNC_FULL ioctl? Nope. Outside of a few databases, 
it is almost certainly not going to be used, and fsync() will not be 
reliable in general.

So rather than come up with new barriers that nobody will use, filesystem 
people should aim to make "badly written" code "just work" unless people 
are really really unlucky. Because like it or not, that's what 99% of all 
code is.

The undeniable FACT that people don't tend to check errors from close() 
should, for example, mean that delayed allocation must still track disk 
full conditions, for example. If your filesystem returns ENOSPC at close() 
rather than at write(), you just lost error coverage for disk full cases 
from 90% of all apps. It's that simple.

Crying that it's an application bug is like crying over the speed of 
light: you should deal with *reality*, not what you wish reality was. Same 
goes for any complaints that "people should write a temp-file, fsync it, 
and rename it over the original". You may wish that was what they did, but 
reality is that "open(filename, O_TRUNC | O_CREAT, 0666)" thing.

Harsh, I know. And in the end, even the _good_ applications will decide 
that it's not worth the performance penalty of doing an fsync(). In git, 
for example, where we generally try to be very very very careful, 
'fsync()' on the object files is turned off by default.

Why? Because turning it on results in unacceptable behavior on ext3. Now, 
admittedly, the git design means that a lost new DB file isn't deadly, 
just potentially very very annoying and confusing - you may have to roll 
back and re-do your operation by hand, and you have to know enough to be 
able to do it in the first place.

The point here? Sometimes those filesystem people who say "you must use 
fsync() to get well-defined semantics" are the same people who SCREWED IT 
UP SO DAMN BADLY THAT FSYNC ISN'T ACTUALLY REALISTICALLY USEABLE!

Theory and practice sometimes clash. And when that happens, theory loses. 
Every single time. 

		Linus
