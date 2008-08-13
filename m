Return-Path: <linux-kernel-owner+w=401wt.eu-S1756068AbYHMTDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068AbYHMTDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 15:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbYHMTDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 15:03:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbYHMTDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 15:03:02 -0400
Subject: Re: TALPA - a threat model?  well sorta.
From: Eric Paris <eparis@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, andi@firstfloor.org, riel@redhat.com,
       greg@kroah.com, viro@ZenIV.linux.org.uk, alan@lxorguk.ukuu.org.uk,
       peterz@infradead.org, hch@infradead.org
In-Reply-To: <20080813181549.GH8232@mit.edu>
References: <1218645375.3540.71.camel@localhost.localdomain>
	 <20080813103951.1e3e5827@infradead.org>  <20080813181549.GH8232@mit.edu>
Content-Type: text/plain
Date: Wed, 13 Aug 2008 15:02:48 -0400
Message-Id: <1218654168.3540.115.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-13 at 14:15 -0400, Theodore Tso wrote:
> On Wed, Aug 13, 2008 at 10:39:51AM -0700, Arjan van de Ven wrote:
> > for the "dirty" case it gets muddy. You clearly want to scan "some
> > time" after the write, from the principle of getting rid of malware
> > that's on the disk, but it's unclear if this HAS to be synchronous.
> > (obviously, synchronous behavior hurts performance bigtime so lets do
> > as little as we can of that without hurting the protection).
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
> But what this points out is that if you want a good solution, (a) it
> probably shouldn't all be in the kernel, since trying to get all of
> this complexity into the kernel will be painful, and (b) the policy
> about whether or not a bittorrent client should be allowed to say,
> "it's OK not to check the file until it's completely downloaded, even
> if I am handing out pieces to other people over the network --- after
> all the entire file has its own SHA checksum for data integrity
> verification --- is very much a policy question where different system
> administrators will come down on different sides about what should and
> shouldn't be allowed --- and therefore this kind of policy decision
> should ****NOT**** be in the kernel.

I never suggested putting a scanner in kernel.  Sound like you want the
"allow don't cache" response from your userspace scanner while this is
going on.  The kernel doesn't need to be making decisions about when to
send events, nor should userspace tell the kernel not to send events.
Its up to whatever the scanner is to agree not to actually do any
scanning...

> However, questions of which version of virus database was used to scan
> a particular file should be stored outside of the filesystem, since
> each product will have its own version namespace, and the questions of
> what happens if a user switches from one version checker to another is
> going to be messy.  So better that this be done in userspace, and that
> this information be stored in some on-disk database.

No.  How in the heck can some out of kernel database store information
about what inodes have been scanned in any even slightly sane way?  And
people think the race between open and read is too large and you suggest
moving clean/dirty marking to a userspace database?  I MUCH prefer my
(and it sounds like arjan agrees) clean/dirty versioned flag in inode.

-Eris

