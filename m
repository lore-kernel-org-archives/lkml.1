Return-Path: <linux-kernel-owner+w=401wt.eu-S1762113AbXH1UKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762113AbXH1UKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 16:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbXH1UKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 16:10:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387AbXH1UKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 16:10:20 -0400
Date: Tue, 28 Aug 2007 16:09:51 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       nfs@lists.sourceforge.net, linux-cifs-client@lists.samba.org,
       linux-kernel@vger.kernel.org
Subject: Re: [NFS] [PATCH 0/4] add killattr inode operation to allow
 filesystems to interpret ATTR_KILL_S*ID bits
Message-Id: <20070828160951.1a7d84fa.jlayton@redhat.com>
In-Reply-To: <1188330591.6701.202.camel@heimdal.trondhjem.org>
References: <200708271727.l7RHR36m007248@dantu.rdu.redhat.com>
	<20070828191114.GA3419@infradead.org>
	<1188330591.6701.202.camel@heimdal.trondhjem.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Aug 2007 15:49:51 -0400
Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> On Tue, 2007-08-28 at 20:11 +0100, Christoph Hellwig wrote:
> > Sorry for not replying to the previsious revisions, but I've been out
> > for on vacation.
> > 
> > I can't say I like this version.  Now we've got callouts at two rather close
> > levels which is not very nice from the interface POV.
> 
> Agreed.
> 
> > Maybe preference is for the first scheme where we simply move interpreation
> > of the ATTR_KILL_SUID/ATTR_KILL_SGID into the setattr routine and provide
> > a nice helper for the normal filesystem to use.
> > 
> > If people are really concerned about adding two lines of code to the
> > handfull of setattr operation there's a variant of this scheme that can
> > avoid it:
> > 
> >  - notify_change is modified to not clear the ATTR_KILL_SUID/ATTR_KILL_SGID
> >    but update ia_mode and the ia_valid flag to include ATTR_MODE.
> >  - disk filesystems stay unchanged and never look at
> >    ATTR_KILL_SUID/ATTR_KILL_SGID, but nfs can check for it and ignore
> >    the ATTR_MODE flags and ia_valid in this case and do the right thing
> >    on the server side.
> 
> Hmm... There has to be an implicit promise here that nobody else will
> ever try to set ATTR_KILL_SUID/ATTR_KILL_SGID and ATTR_MODE at the same
> time. Currently, that assumption is not there:
> 

That was my concern with this scheme as well...

> 
> > 	if (ia_valid & ATTR_KILL_SGID) {
> > 		attr->ia_valid &= ~ ATTR_KILL_SGID;
> > 		if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP)) {
> > 			if (!(ia_valid & ATTR_MODE)) {
> > 				ia_valid = attr->ia_valid |= ATTR_MODE;
> > 				attr->ia_mode = inode->i_mode;
> > 			}
> > 			attr->ia_mode &= ~S_ISGID;
> > 		}
> > 	}
> 
> Should we perhaps just convert the above 'if (!(ia_valid & ATTR_MODE))'
> into a 'BUG_ON(ia_valid & ATTR_MODE)'?
> 

Sounds reasonable. I'll also throw in a comment that explains this
reasoning...

-- 
Jeff Layton <jlayton@redhat.com>
