Return-Path: <linux-kernel-owner+w=401wt.eu-S1756672AbYHMREQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbYHMREQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 13:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbYHMRD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 13:03:58 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:57241 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbYHMRD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 13:03:57 -0400
Subject: Re: [PATCH 3/4] integrity: Linux Integrity Module(LIM)
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mimi Zohar <zohar@us.ibm.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com
In-Reply-To: <20080812211919.GA29721@us.ibm.com>
References: <20080808184349.999902616@linux.vnet.ibm.com>
	 <1218221761.4444.13.camel@localhost.localdomain>
	 <20080809185340.GC22905@infradead.org>
	 <OF0AEBDCA2.1E27B823-ON852574A1.000FEE48-852574A1.004C3185@us.ibm.com>
	 <20080811170255.GA2662@us.ibm.com> <20080812192741.GB18034@infradead.org>
	 <20080812211919.GA29721@us.ibm.com>
Content-Type: text/plain
Date: Wed, 13 Aug 2008 13:03:23 -0400
Message-Id: <1218647003.2987.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-12 at 16:19 -0500, Serge E. Hallyn wrote: 
> Quoting Christoph Hellwig (hch@infradead.org):
> > On Mon, Aug 11, 2008 at 12:02:55PM -0500, Serge E. Hallyn wrote:
> > > > > Sorry, but I don't think we can bloat the inode even further for this.
> > > > 
> > > > The original version of IMA was LSM based, using i_security. Based
> > > > on discussions on the LSM mailing list, it was decided that the LSM hooks
> > > > were meant only for access control.  During the same time frame, there 
> > > > was a lot of work done in stacking LSM modules and i_security, but that
> > > > approach was dropped. It was suggested that we define a separate set of
> > > > hooks for integrity, which this patch set provides. Caching integrity 
> > > > results is an important aspect. Any suggestions in lieu of defining 
> > > > i_integrity?
> > > 
> > > The i_integrity is only bloating the inode if LIM is enabled.  Surely
> > > that beats having LIM define its own hash table and locking to track
> > > integrity labels on inodes?  Do you have another suggestion?
> > > 
> > > Or is the concern about having more #ifdefs in the struct inode
> > > definition?
> > 
> > No, the concern is over bloating the inode for a rather academic fringe
> > feature.  As this comes from IBM I'm pretty sure someone will pressure
> > the big distro to turn it on.
> 
> By default??  I should hope not...
> 
> Note that these are all not loadable modules.  So presumably either it's
> in the kernel and enforcing, or it's not there.
> 
> > And inode growth is a concern for
> > fileserving or other inode heavy workload.  Mimi mentioned this is just
> > a cache of information, so consider using something like XFS's mru cache
> > which is used for something similar where the xfs_inode was kept small
> > despite a very niche feature needing a cache attached to the inode:
> > 
> > 	fs/xfs/xfs_mru_cache.c
> 
> ok, so basically as I said above
> 
> > > ... having LIM define its own hash table and locking to track
> > > integrity labels on inodes?
> 
> :)
> 
> But then that is in fact the better way to go if there can be a lot
> of inodes with i_integrity=NULL.  It looks like IMA always allocates
> something, but if I understand the idea behind templates correctly,
> that isn't necessarily always the case.
> 
> thanks,
> -serge

IMA has a two stage initialization, one at security_initcall() and 
another at late_initcall(), when the tpm is available, to make sure 
that all inode's i_integrity are allocated.  

Multiple templates can register themselves with LIM, but only one
integrity provider, such as IMA, can register itself at a time. So
hypothetically, other integrity providers could be implemented 
without a need for i_integrity.

Mimi

