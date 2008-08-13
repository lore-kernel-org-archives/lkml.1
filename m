Return-Path: <linux-kernel-owner+w=401wt.eu-S1756377AbYHMSQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377AbYHMSQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 14:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbYHMSQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 14:16:05 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:42195 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751780AbYHMSQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 14:16:02 -0400
Date: Wed, 13 Aug 2008 14:15:49 -0400
From: Theodore Tso <tytso@mit.edu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, andi@firstfloor.org, riel@redhat.com,
       greg@kroah.com, viro@ZenIV.linux.org.uk, alan@lxorguk.ukuu.org.uk,
       peterz@infradead.org, hch@infradead.org
Subject: Re: TALPA - a threat model?  well sorta.
Message-ID: <20080813181549.GH8232@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Arjan van de Ven <arjan@infradead.org>,
	Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
	malware-list@lists.printk.net, andi@firstfloor.org, riel@redhat.com,
	greg@kroah.com, viro@ZenIV.linux.org.uk, alan@lxorguk.ukuu.org.uk,
	peterz@infradead.org, hch@infradead.org
References: <1218645375.3540.71.camel@localhost.localdomain> <20080813103951.1e3e5827@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080813103951.1e3e5827@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 10:39:51AM -0700, Arjan van de Ven wrote:
> for the "dirty" case it gets muddy. You clearly want to scan "some
> time" after the write, from the principle of getting rid of malware
> that's on the disk, but it's unclear if this HAS to be synchronous.
> (obviously, synchronous behavior hurts performance bigtime so lets do
> as little as we can of that without hurting the protection).

Something else to think about is what happens if the file is naturally
written in pieces.  For example, I've been playing with bittorrent
recently, and it appears that trackerd will do something... not very
intelligent in that it will repeatedly try to index a file which is
being written in pieces, and in some cases, it will do things like
call pdftext that aren't exactly cheap.  A timeout *can* help (i.e.,
don't try to scan/index this file until 15 minutes after the last
write), but it won't help if the torrent is very large, or the
download bitrate is very slow.  One very simple workaround is to
disable trackerd altogether while you are downloading the file, but
that's not very pleasant solution; it's horribly manual.

Most of this may end up being outside of the kernel (i.e.,some kind of
interface where a bittorrent client can say, "look this file is still
being downloaded, so it's don't bother scanning it unless some process
*other* than the bittorrent client tries to access the file".  And
maybe there should be some other more complex policies, such as the
bittorrent client explicitly telling the indexer/scanner that the file
is has been completely downloaded, so it's safe to index it now.

But what this points out is that if you want a good solution, (a) it
probably shouldn't all be in the kernel, since trying to get all of
this complexity into the kernel will be painful, and (b) the policy
about whether or not a bittorrent client should be allowed to say,
"it's OK not to check the file until it's completely downloaded, even
if I am handing out pieces to other people over the network --- after
all the entire file has its own SHA checksum for data integrity
verification --- is very much a policy question where different system
administrators will come down on different sides about what should and
shouldn't be allowed --- and therefore this kind of policy decision
should ****NOT**** be in the kernel.

> For efficiency the kernel ought to keep track of which files have been
> declared clean, and it needs to track of a 'generation' of the scan
> with which it has been found clean (so that if you update your virus
> definitions, you can invalidate all previous scanning just by bumping
> the 'generation' number in whatever format we use).

We have an i_version support for NFSv4, so we have that already as far
as the version of the file.  We can have a single bit which means
"block on open" that is stored on a file, and some kind of policy
which dictates whether or not any modification to the file contens
should automatically set the bit.

However, questions of which version of virus database was used to scan
a particular file should be stored outside of the filesystem, since
each product will have its own version namespace, and the questions of
what happens if a user switches from one version checker to another is
going to be messy.  So better that this be done in userspace, and that
this information be stored in some on-disk database.

						- Ted
