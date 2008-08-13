Return-Path: <linux-kernel-owner+w=401wt.eu-S1755688AbYHMSWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688AbYHMSWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 14:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750987AbYHMSWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 14:22:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:41981 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbYHMSWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 14:22:02 -0400
Date: Wed, 13 Aug 2008 11:21:49 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, andi@firstfloor.org, riel@redhat.com,
       greg@kroah.com, viro@ZenIV.linux.org.uk, alan@lxorguk.ukuu.org.uk,
       peterz@infradead.org, hch@infradead.org
Subject: Re: TALPA - a threat model?  well sorta.
Message-ID: <20080813112149.2fda0fa4@infradead.org>
In-Reply-To: <20080813181549.GH8232@mit.edu>
References: <1218645375.3540.71.camel@localhost.localdomain>
	<20080813103951.1e3e5827@infradead.org>
	<20080813181549.GH8232@mit.edu>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008 14:15:49 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Wed, Aug 13, 2008 at 10:39:51AM -0700, Arjan van de Ven wrote:
> > for the "dirty" case it gets muddy. You clearly want to scan "some
> > time" after the write, from the principle of getting rid of malware
> > that's on the disk, but it's unclear if this HAS to be synchronous.
> > (obviously, synchronous behavior hurts performance bigtime so lets
> > do as little as we can of that without hurting the protection).
> 
> Something else to think about is what happens if the file is naturally
> written in pieces.  For example, I've been playing with bittorrent
> recently, and it appears that trackerd will do something... not very
> intelligent in that it will repeatedly try to index a file which is
> being written in pieces, and in some cases, it will do things like
> call pdftext that aren't exactly cheap.  A timeout *can* help (i.e.,
> don't try to scan/index this file until 15 minutes after the last
> write), but it won't help if the torrent is very large, or the
> download bitrate is very slow.  One very simple workaround is to
> disable trackerd altogether while you are downloading the file, but
> that's not very pleasant solution; it's horribly manual.
> 
> Most of this may end up being outside of the kernel (i.e.,some kind of
> interface where a bittorrent client can say, "look this file is still
> being downloaded, so it's don't bother scanning it unless some process
> *other* than the bittorrent client tries to access the file".  And
> maybe there should be some other more complex policies, such as the
> bittorrent client explicitly telling the indexer/scanner that the file
> is has been completely downloaded, so it's safe to index it now.
> 

> verification --- is very much a policy question where different system
> administrators will come down on different sides about what should and
> shouldn't be allowed --- and therefore this kind of policy decision
> should ****NOT**** be in the kernel.

exactly. Even more, since this is async work, the scheduling of the
order of work also is a policy.. and userland is again the right place
for that.

> 
> > For efficiency the kernel ought to keep track of which files have
> > been declared clean, and it needs to track of a 'generation' of the
> > scan with which it has been found clean (so that if you update your
> > virus definitions, you can invalidate all previous scanning just by
> > bumping the 'generation' number in whatever format we use).
> 
> We have an i_version support for NFSv4, so we have that already as far
> as the version of the file.  We can have a single bit which means
> "block on open" that is stored on a file, and some kind of policy
> which dictates whether or not any modification to the file contens
> should automatically set the bit.
> 
> However, questions of which version of virus database was used to scan
> a particular file should be stored outside of the filesystem, since

well I was assuming we only store this in memory (say in the inode) and
just rescan the file if we destroy the in memory inode.
I don't see the need for this to be persistent data; in fact I assume
(Eric, please confirm) that this data is not *supposed* to be
persistent.


> each product will have its own version namespace, and the questions of
> what happens if a user switches from one version checker to another is

yes that's a hard question; what if you have 2 virus scanners active.

(they could register a version of the database with the kernel, and the
in kernel version-cookie could be a hash of all registered versions I
suppose.. if anything changes ever we just rehash and scan as if we
have to do that)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
