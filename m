Return-Path: <linux-kernel-owner+w=401wt.eu-S1752419AbYHLVTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbYHLVTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 17:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbYHLVTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 17:19:20 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54389 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbYHLVTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 17:19:19 -0400
Date: Tue, 12 Aug 2008 16:19:19 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Mimi Zohar <zohar@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com,
       Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/4] integrity: Linux Integrity Module(LIM)
Message-ID: <20080812211919.GA29721@us.ibm.com>
References: <20080808184349.999902616@linux.vnet.ibm.com> <1218221761.4444.13.camel@localhost.localdomain> <20080809185340.GC22905@infradead.org> <OF0AEBDCA2.1E27B823-ON852574A1.000FEE48-852574A1.004C3185@us.ibm.com> <20080811170255.GA2662@us.ibm.com> <20080812192741.GB18034@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080812192741.GB18034@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Christoph Hellwig (hch@infradead.org):
> On Mon, Aug 11, 2008 at 12:02:55PM -0500, Serge E. Hallyn wrote:
> > > > Sorry, but I don't think we can bloat the inode even further for this.
> > > 
> > > The original version of IMA was LSM based, using i_security. Based
> > > on discussions on the LSM mailing list, it was decided that the LSM hooks
> > > were meant only for access control.  During the same time frame, there 
> > > was a lot of work done in stacking LSM modules and i_security, but that
> > > approach was dropped. It was suggested that we define a separate set of
> > > hooks for integrity, which this patch set provides. Caching integrity 
> > > results is an important aspect. Any suggestions in lieu of defining 
> > > i_integrity?
> > 
> > The i_integrity is only bloating the inode if LIM is enabled.  Surely
> > that beats having LIM define its own hash table and locking to track
> > integrity labels on inodes?  Do you have another suggestion?
> > 
> > Or is the concern about having more #ifdefs in the struct inode
> > definition?
> 
> No, the concern is over bloating the inode for a rather academic fringe
> feature.  As this comes from IBM I'm pretty sure someone will pressure
> the big distro to turn it on.

By default??  I should hope not...

Note that these are all not loadable modules.  So presumably either it's
in the kernel and enforcing, or it's not there.

> And inode growth is a concern for
> fileserving or other inode heavy workload.  Mimi mentioned this is just
> a cache of information, so consider using something like XFS's mru cache
> which is used for something similar where the xfs_inode was kept small
> despite a very niche feature needing a cache attached to the inode:
> 
> 	fs/xfs/xfs_mru_cache.c

ok, so basically as I said above

> > ... having LIM define its own hash table and locking to track
> > integrity labels on inodes?

:)

But then that is in fact the better way to go if there can be a lot
of inodes with i_integrity=NULL.  It looks like IMA always allocates
something, but if I understand the idea behind templates correctly,
that isn't necessarily always the case.

thanks,
-serge
