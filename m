Return-Path: <linux-kernel-owner+w=401wt.eu-S933433AbXLRHbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933433AbXLRHbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 02:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758079AbXLRHbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 02:31:07 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43444 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759910AbXLRHbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 02:31:06 -0500
Date: Tue, 18 Dec 2007 09:31:03 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: serge@hallyn.com
cc: alan@redhat.com, viro@zeniv.linux.org.uk, hch@infradead.org,
       peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC/PATCH 2/8] revoke: inode revoke lock V7
In-Reply-To: <20071217222850.GA10076@vino.hallyn.com>
Message-ID: <Pine.LNX.4.64.0712180923450.32179@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0712141715440.28689@sbz-30.cs.Helsinki.FI>
 <20071217222850.GA10076@vino.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Serge,

(Thanks for looking at this. I appreciate the review!)

On Mon, 17 Dec 2007, serge@hallyn.com wrote:
> >  	struct vfsmount *mnt = nd->mnt;
> > -	struct dentry *dentry = __d_lookup(nd->dentry, name);
> > +	struct dentry *dentry;
> >  
> > +again:
> > +	dentry  = __d_lookup(nd->dentry, name);
> >  	if (!dentry)
> >  		goto need_lookup;
> > +
> > +	if (dentry->d_inode && IS_REVOKE_LOCKED(dentry->d_inode)) {
> 
> not sure whether this is a problem or not, but dentry->d_inode isn't
> locked here, right?  So nothing is keeping do_lookup() returning
> with an inode which gets revoked between here and the return 0
> a few lines down?

I assume you mean S_REVOKE_LOCK and not ->i_mutex, right?

The caller is supposed to block open(2) with chmod(2)/chattr(2) so while 
revoke is in progress, you can get references to the _revoked inode_, 
which is fine (operations on it will fail with EBADFS). The 
->i_revoke_wait bits are there to make sure that while we revoke, you 
can't get a _new reference_ to the inode until we're done.

			Pekka
