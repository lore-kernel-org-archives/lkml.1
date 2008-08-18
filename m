Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbYHRRs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbYHRRs1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 13:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbYHRRsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 13:48:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49144 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753763AbYHRRsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 13:48:17 -0400
Subject: Re: [malware-list] scanner interface proposal was:
	[TALPA]	Intro	to a linux interface for on access scanning
From: Eric Paris <eparis@redhat.com>
To: david@lang.hm
Cc: tvrtko.ursulin@sophos.com, Theodore Tso <tytso@mit.edu>, davecb@sun.com,
       Adrian Bunk <bunk@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       malware-list@lists.printk.net, Casey Schaufler <casey@schaufler-ca.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <alpine.DEB.1.10.0808181015070.15109@asgard.lang.hm>
References: <20080818153212.6A6FD33687F@pmx1.sophos.com>
	 <1219076143.15566.39.camel@localhost.localdomain>
	 <alpine.DEB.1.10.0808181015070.15109@asgard.lang.hm>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 13:39:14 -0400
Message-Id: <1219081154.15566.73.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-18 at 10:29 -0700, david@lang.hm wrote:
> On Mon, 18 Aug 2008, Eric Paris wrote:
> 
> > But lets talk about a real design and what people want to see.
> >
> > Userspace program needs to 'register' with a priority.  HSMs would want
> > a low priority on the blocking calls AV Scanners would want a higher
> > priority and indexers would want a very high priority.
> 
> why do you need to introduce a priority mechanism for notifying scanners? 
> just notify them all and let them take action at their own rate for async 
> notifications. if you are waiting for their result you need to invoke them 
> directly, but whether you do it in order or in parallel will depend on the 
> config. this is an optmization problem that the kernel should not be 
> trying to figure out becouse the right answer is policy dependant (if they 
> all need to bless the file for it to be accepted then fire them off in 
> parallel (system resources allowing), if one accepting it is good enough 
> you may want to just run that one and see if you get lucky rather then 
> eating up resources of all the others)

You have some pretty serious reading comprehension problems with my
message.  Try reading it all over again keeping in mind (although not
stated it was I thought understood) that the priority was only of value
during blocking calls.

> > On async notification we fire a message to everything that registered
> > 'simultaneously.' On blocking we fire a message to everything in
> > priority order and block until we get a response.  That response should
> > be of the form ALLOW/DENY and should include "mark result"/"don't mark
> > result."
> 
> why in the world would you block for an _async_ notification mechanism?

try reading it again.

> 
> > If everything responds with ALLOW/"mark result" we will flip a bit IN
> > CORE so operations on that inode are free from then on.  If any program
> > responds with DENY/"mark result" we will flip the negative bit IN CORE
> > so deny operations on the inode are free from then on.
> 
> this requires syncronous scanning by all scanners.

yup.

> > Userspace 'scanners' if intelligent should have set a timespace in a
> > particular xattr of their choosing to do their own userspace results
> > caching to speed up things if the inode is evicted from core.  This
> > means that the 'normal' flow of operations for an inode will look like:
> >
> > open -> async to userspace -> userspace scans and writes timestamp
> >
> > read -> blocking to userspace -> userspace checks xattr timestamp and
> > mtime and responds with ALLOW/"mark result"
> 
> you can't trust timestamps, they go forwareds and backwords. they need to 
> have some sort of 'generation id' but don't try to define meaning for it, 
> leave that to the scanner. have everything else treat it as a simple "it 
> matches" or "it doesn't match"

Not my problem.  Userspace needs to make their own determination and
cache their own results from async scans.  Kernel fires and forgets on
async.  Its up to userspace to make those notifications useful if they
can help with the blocking read (open?) calls.

> > read -> we have the ALLOW/mark result bit in core set so just allow.
> >
> > mtime update -> clear ALLOW/"mark result" bit in core, send async
> > notification to userspace
> 
> you keep planning to do this with a single allow mark. it may not be that 
> simple.
> 
> > close -> send async notification to userspace
> 
> as several others have noted, alerting on close is not good enough, we 
> need to alert on the scanned->dirty transition (by the way, this 
> contridicts the part of your message I snipped where you were advocating 
> notification on every write)

Is it really that hard to understand what I'm saying?  We notified on
mtime update and cleared the "mark result".  Why shouldn't we notify on
close?

> > If some general xattr namespace is agreed upon for such a thing someday
> > a patch may be acceptable to clear that namespace on mtime update, but I
> > don't plan to do that at this time since comparing the timestamp in the
> > xattr vs mtime should be good enough.
> 
> if you are already accessing xattrs, why not just use the value rather 
> then trying to make it into a time?

I'm not accessing anything.  I'm leaving xattrs as an exercise of
efficiency for people who want to write a userspace scanner.  Not my
problem.

> > ******************************
> >
> > Great, how to build this interface.  THIS IS WHAT I ACTUALLY CARE ABOUT
> >
> > The communication with userspace has a very specific need.  The scanning
> > process needs to get 'something' that will give it access to the
> > original file/inode/data being worked on.  My previous patch set does
> > this with a special securityfs file.  Scanners would block on 'read.'
> > This block was waiting for something to be scanned and when available a
> > dentry_open() was called in the context of the scanner for the inode in
> > question.  This means that the fd in the scanner had to be the same data
> > as the fd in the original process.
> 
> having scanners access a file blocking on read won't work for multiple 
> scanners (unless you are going to create multiple files for them to read)

WHAT?

> > If people want me to use something like netlink to send async
> > notifications to the scanner how do I also get the file/inode/data to
> > the scanning process?  Can anyone think of a better/cleaner method to
> > get a file descriptor into the context of the scanner other than having
> > the scanner block/poll on a special file inside the securityfs?
> 
> this is easy, the userspace library (libmalware or glibc) intercepts the 
> open and is invoking the scanners if the checks tell it to. they can send 
> the file descripter over a unix socket on the machine to a scanner daemon, 
> or they can invoke the scanner in the existing user context.

But, I have code for my solution that addresses just about every problem
mentioned on list so far except for multi priority blockers.  Where is
your code?

-Eric

