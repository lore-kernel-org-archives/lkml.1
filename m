Return-Path: <linux-kernel-owner+w=401wt.eu-S1752868AbYHLT1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbYHLT1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 15:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbYHLT1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 15:27:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37828 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbYHLT1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 15:27:42 -0400
Date: Tue, 12 Aug 2008 15:27:41 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Mimi Zohar <zohar@us.ibm.com>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com,
       Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/4] integrity: Linux Integrity Module(LIM)
Message-ID: <20080812192741.GB18034@infradead.org>
References: <20080808184349.999902616@linux.vnet.ibm.com> <1218221761.4444.13.camel@localhost.localdomain> <20080809185340.GC22905@infradead.org> <OF0AEBDCA2.1E27B823-ON852574A1.000FEE48-852574A1.004C3185@us.ibm.com> <20080811170255.GA2662@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811170255.GA2662@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 12:02:55PM -0500, Serge E. Hallyn wrote:
> > > Sorry, but I don't think we can bloat the inode even further for this.
> > 
> > The original version of IMA was LSM based, using i_security. Based
> > on discussions on the LSM mailing list, it was decided that the LSM hooks
> > were meant only for access control.  During the same time frame, there 
> > was a lot of work done in stacking LSM modules and i_security, but that
> > approach was dropped. It was suggested that we define a separate set of
> > hooks for integrity, which this patch set provides. Caching integrity 
> > results is an important aspect. Any suggestions in lieu of defining 
> > i_integrity?
> 
> The i_integrity is only bloating the inode if LIM is enabled.  Surely
> that beats having LIM define its own hash table and locking to track
> integrity labels on inodes?  Do you have another suggestion?
> 
> Or is the concern about having more #ifdefs in the struct inode
> definition?

No, the concern is over bloating the inode for a rather academic fringe
feature.  As this comes from IBM I'm pretty sure someone will pressure
the big distro to turn it on.  And inode growth is a concern for
fileserving or other inode heavy workload.  Mimi mentioned this is just
a cache of information, so consider using something like XFS's mru cache
which is used for something similar where the xfs_inode was kept small
despite a very niche feature needing a cache attached to the inode:

	fs/xfs/xfs_mru_cache.c
