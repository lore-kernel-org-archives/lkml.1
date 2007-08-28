Return-Path: <linux-kernel-owner+w=401wt.eu-S1761551AbXH1Tub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761551AbXH1Tub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbXH1TuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:50:20 -0400
Received: from pat.uio.no ([129.240.10.15]:47312 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbXH1TuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:50:16 -0400
Subject: Re: [NFS] [PATCH 0/4] add killattr inode operation to allow
	filesystems to interpret ATTR_KILL_S*ID bits
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Layton <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org,
       nfs@lists.sourceforge.net, linux-cifs-client@lists.samba.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070828191114.GA3419@infradead.org>
References: <200708271727.l7RHR36m007248@dantu.rdu.redhat.com>
	 <20070828191114.GA3419@infradead.org>
Content-Type: text/plain
Date: Tue, 28 Aug 2007 15:49:51 -0400
Message-Id: <1188330591.6701.202.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.0, required=12.0, autolearn=disabled, AWL=-0.041)
X-UiO-Scanned: A477F5A091DEB1DC26417DF9C4619480EFC83C5E
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 865 total 3521817 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-28 at 20:11 +0100, Christoph Hellwig wrote:
> Sorry for not replying to the previsious revisions, but I've been out
> for on vacation.
> 
> I can't say I like this version.  Now we've got callouts at two rather close
> levels which is not very nice from the interface POV.

Agreed.

> Maybe preference is for the first scheme where we simply move interpreation
> of the ATTR_KILL_SUID/ATTR_KILL_SGID into the setattr routine and provide
> a nice helper for the normal filesystem to use.
> 
> If people are really concerned about adding two lines of code to the
> handfull of setattr operation there's a variant of this scheme that can
> avoid it:
> 
>  - notify_change is modified to not clear the ATTR_KILL_SUID/ATTR_KILL_SGID
>    but update ia_mode and the ia_valid flag to include ATTR_MODE.
>  - disk filesystems stay unchanged and never look at
>    ATTR_KILL_SUID/ATTR_KILL_SGID, but nfs can check for it and ignore
>    the ATTR_MODE flags and ia_valid in this case and do the right thing
>    on the server side.

Hmm... There has to be an implicit promise here that nobody else will
ever try to set ATTR_KILL_SUID/ATTR_KILL_SGID and ATTR_MODE at the same
time. Currently, that assumption is not there:


> 	if (ia_valid & ATTR_KILL_SGID) {
> 		attr->ia_valid &= ~ ATTR_KILL_SGID;
> 		if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP)) {
> 			if (!(ia_valid & ATTR_MODE)) {
> 				ia_valid = attr->ia_valid |= ATTR_MODE;
> 				attr->ia_mode = inode->i_mode;
> 			}
> 			attr->ia_mode &= ~S_ISGID;
> 		}
> 	}

Should we perhaps just convert the above 'if (!(ia_valid & ATTR_MODE))'
into a 'BUG_ON(ia_valid & ATTR_MODE)'?

Trond

