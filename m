Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbYHNPuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbYHNPuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 11:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYHNPul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 11:50:41 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:47512 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751368AbYHNPul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 11:50:41 -0400
Date: Thu, 14 Aug 2008 11:50:28 -0400
From: Theodore Tso <tytso@mit.edu>
To: Eric Paris <eparis@redhat.com>
Cc: tvrtko.ursulin@sophos.com, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org,
       Arjan van de Ven <arjan@infradead.org>, hch@infradead.org,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       malware-list-bounces@dmesg.printk.net, peterz@infradead.org,
       viro@ZenIV.linux.org.uk
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
Message-ID: <20080814155028.GB8256@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Eric Paris <eparis@redhat.com>, tvrtko.ursulin@sophos.com,
	alan@lxorguk.ukuu.org.uk, andi@firstfloor.org,
	Arjan van de Ven <arjan@infradead.org>, hch@infradead.org,
	linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
	malware-list-bounces@dmesg.printk.net, peterz@infradead.org,
	viro@ZenIV.linux.org.uk
References: <20080813192922.GI8232@mit.edu> <20080814093103.6CD102FE8B4@pmx1.sophos.com> <20080814132455.GE6469@mit.edu> <1218721713.3540.125.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218721713.3540.125.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 09:48:33AM -0400, Eric Paris wrote:
> 
> There needs to be a way to say that an inode in cache needs to be
> rescanned.  3 states this flag can be.  Clean, Dirty, Infected.  The
> current talpa solution involves a global monotomically increasing
> counter every time you change virus defs or make some "interesting"
> change.  If global == inode flag we are clean.  If global == negative
> inode flag we are infected.  if global > inode flag we are dirty and
> need a scan.

"Infected" just means to instantly return an error when the file is
opened or if an already opened file descriptor is read or mmap'ed,
right?  If file is already mmaped(), what's the plan?  Send a kill -9
to the process, even if it ends up kill off an emacs or openoffice
process?

> > That seems fair; if it turns out there is an AV product that wants to
> > optimize this a bit further, as long as we provide a persistent inode
> > version/generation number, they can always do their own persistent
> > database in userspace.
> 
> exporting i_version might be useful for better userspace caching,
> although I've yet to see any reasonable description of how a userspace
> database can map between data on disk and what they have in userspace.
> How can a userspace process, given 2 file descriptors know they are
> actually the same thing on disk?
> 

If a userspace database knows that inode X, i_version Y was checked a
day ago, and inode X still has i_version Y, even if that inode has
been evicted from memory, the contents will be the same absent root
messing about with direct access to the block device.  If there was an
intervening boot, the someone could remove the disk, edit the disk
block directly -- but that person could also add a backdoor to the
kernel while they were at it.

If your threat model is, "we do file scanning; that's it", then having
an external database which uses the inode number and i_version as a
tuple makes a lot of sense --- for filesystems where i_version is
getting bumped on every disk write, which is needed to support NFSv4
cache support, anyway.  

							- Ted

