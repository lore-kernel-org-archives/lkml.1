Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbYHRQ0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbYHRQ0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 12:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbYHRQ0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 12:26:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49299 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbYHRQ0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:26:30 -0400
Subject: Re: [malware-list] scanner interface proposal was: [TALPA]
	Intro	to a linux interface for on access scanning
From: Eric Paris <eparis@redhat.com>
To: tvrtko.ursulin@sophos.com
Cc: Theodore Tso <tytso@mit.edu>, davecb@sun.com, david@lang.hm,
       Adrian Bunk <bunk@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       malware-list@lists.printk.net, Casey Schaufler <casey@schaufler-ca.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20080818153212.6A6FD33687F@pmx1.sophos.com>
References: <20080818153212.6A6FD33687F@pmx1.sophos.com>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 12:15:43 -0400
Message-Id: <1219076143.15566.39.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-18 at 16:31 +0100, tvrtko.ursulin@sophos.com wrote:
> Theodore Tso <tytso@mit.edu> wrote on 18/08/2008 15:25:11:
> 
> > On Mon, Aug 18, 2008 at 02:15:24PM +0100, tvrtko.ursulin@sophos.com 
> wrote:
> > > Then there is still a question of who allows some binary to declare 
> itself 
> > > exempt. If that decision was a mistake, or it gets compromised 
> security 
> > > will be off. A very powerful mechanism which must not be easily 
> > > accessible.  With a good cache your worries go away even without a 
> scheme 
> > > like this.
> > 
> > I have one word for you --- bittorrent.  If you are downloading a very
> > large torrent (say approximately a gigabyte), and it contains many
> > pdf's that are say a few megabytes a piece, and things are coming in
> > tribbles, having either a indexing scanner or an AV scanner wake up
> > and rescan the file from scratch each time a tiny piece of the pdf
> > comes in is going to eat your machine alive....
> 
> Huh? I was never advocating re-scan after each modification and I even 
> explicitly said it does not make sense for AV not only for performance but 
> because it will be useless most of the time. I thought sending out 
> modified notification on close makes sense because it is a natural point, 
> unless someone is trying to subvert which is out of scope. Other have 
> suggested time delay and lumping up.
> 
> Also, just to double-check, you don't think AV scanning would read the 
> whole file on every write?

Make this a userspace problem.  Send a notification on every mtime
update and let userspace do the coallessing, ignoring, delaying, and
perf boosting pre-emptive scans.  If someone designs a crappy
indexer/scanner that can't handle the notifications just blame them, it
should be up to userspace to use this stuff wisely.

Current plans are for read/mmmap to be blocking and require a response.
Close and mtime update and going to be fire and forget async change
notifications.  I'm seriously considering a runtime tunable to allow the
selection of open blocking vs async fire and forget, since I assume most
programs handle open failure much better than read failure.  For the
purposes of an access control systems (AV) open blocking may make the
most sense.  For the purposes of an HSM read blocking makes the most
sense.

Best thing about this is that I have code that already addresses almost
all of this.  If someone else wants to contribute some code I'd be glad
to see it.

But lets talk about a real design and what people want to see.

Userspace program needs to 'register' with a priority.  HSMs would want
a low priority on the blocking calls AV Scanners would want a higher
priority and indexers would want a very high priority.

On async notification we fire a message to everything that registered
'simultaneously.' On blocking we fire a message to everything in
priority order and block until we get a response.  That response should
be of the form ALLOW/DENY and should include "mark result"/"don't mark
result."

If everything responds with ALLOW/"mark result" we will flip a bit IN
CORE so operations on that inode are free from then on.  If any program
responds with DENY/"mark result" we will flip the negative bit IN CORE
so deny operations on the inode are free from then on.

Userspace 'scanners' if intelligent should have set a timespace in a
particular xattr of their choosing to do their own userspace results
caching to speed up things if the inode is evicted from core.  This
means that the 'normal' flow of operations for an inode will look like:

open -> async to userspace -> userspace scans and writes timestamp

read -> blocking to userspace -> userspace checks xattr timestamp and
mtime and responds with ALLOW/"mark result"

read -> we have the ALLOW/mark result bit in core set so just allow.

mtime update -> clear ALLOW/"mark result" bit in core, send async
notification to userspace

close -> send async notification to userspace

If some general xattr namespace is agreed upon for such a thing someday
a patch may be acceptable to clear that namespace on mtime update, but I
don't plan to do that at this time since comparing the timestamp in the
xattr vs mtime should be good enough.

******************************

Great, how to build this interface.  THIS IS WHAT I ACTUALLY CARE ABOUT

The communication with userspace has a very specific need.  The scanning
process needs to get 'something' that will give it access to the
original file/inode/data being worked on.  My previous patch set does
this with a special securityfs file.  Scanners would block on 'read.'
This block was waiting for something to be scanned and when available a
dentry_open() was called in the context of the scanner for the inode in
question.  This means that the fd in the scanner had to be the same data
as the fd in the original process.

If people want me to use something like netlink to send async
notifications to the scanner how do I also get the file/inode/data to
the scanning process?  Can anyone think of a better/cleaner method to
get a file descriptor into the context of the scanner other than having
the scanner block/poll on a special file inside the securityfs?

