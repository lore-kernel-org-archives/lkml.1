Return-Path: <linux-kernel-owner+w=401wt.eu-S1758429AbYHNRaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758429AbYHNRaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 13:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbYHNRaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 13:30:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbYHNRaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 13:30:12 -0400
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
From: Eric Paris <eparis@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Cc: tvrtko.ursulin@sophos.com, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org,
       Arjan van de Ven <arjan@infradead.org>, hch@infradead.org,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       malware-list-bounces@dmesg.printk.net, peterz@infradead.org,
       viro@ZenIV.linux.org.uk
In-Reply-To: <20080814155028.GB8256@mit.edu>
References: <20080813192922.GI8232@mit.edu>
	 <20080814093103.6CD102FE8B4@pmx1.sophos.com>
	 <20080814132455.GE6469@mit.edu>
	 <1218721713.3540.125.camel@localhost.localdomain>
	 <20080814155028.GB8256@mit.edu>
Content-Type: text/plain
Date: Thu, 14 Aug 2008 13:29:45 -0400
Message-Id: <1218734985.9375.5.camel@paris.rdu.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-08-14 at 11:50 -0400, Theodore Tso wrote:
> On Thu, Aug 14, 2008 at 09:48:33AM -0400, Eric Paris wrote:
> > 
> > There needs to be a way to say that an inode in cache needs to be
> > rescanned.  3 states this flag can be.  Clean, Dirty, Infected.  The
> > current talpa solution involves a global monotomically increasing
> > counter every time you change virus defs or make some "interesting"
> > change.  If global == inode flag we are clean.  If global == negative
> > inode flag we are infected.  if global > inode flag we are dirty and
> > need a scan.
> 
> "Infected" just means to instantly return an error when the file is
> opened or if an already opened file descriptor is read or mmap'ed,
> right?  If file is already mmaped(), what's the plan?  Send a kill -9
> to the process, even if it ends up kill off an emacs or openoffice
> process?

We don't have a revocation mechanism in linux and this isn't about
adding one.  Your trying to turn this into something it isn't.  If you
have it opened and mmap'd you've got that file for as long as you want.
I've already said that given Arjan's belief that we can move it
read/write instead of open/close we are moving the open->read race to a
mmap->fault race.  It isn't perfect at stopping bad data flow, but its
darn sure a lot better than nothing.
> 
> > > That seems fair; if it turns out there is an AV product that wants to
> > > optimize this a bit further, as long as we provide a persistent inode
> > > version/generation number, they can always do their own persistent
> > > database in userspace.
> > 
> > exporting i_version might be useful for better userspace caching,
> > although I've yet to see any reasonable description of how a userspace
> > database can map between data on disk and what they have in userspace.
> > How can a userspace process, given 2 file descriptors know they are
> > actually the same thing on disk?
> > 
> 
> If a userspace database knows that inode X, i_version Y was checked a
> day ago, and inode X still has i_version Y, even if that inode has
> been evicted from memory, the contents will be the same absent root
> messing about with direct access to the block device.  If there was an
> intervening boot, the someone could remove the disk, edit the disk
> block directly -- but that person could also add a backdoor to the
> kernel while they were at it.

is i_version an on disk think?  didn't realize that and just assumed it
was in in core thing.  I wouldn't have an issue sending i_version to the
userspace scanner for them to use as they like.

-Eric

