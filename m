Return-Path: <linux-kernel-owner+w=401wt.eu-S1758644AbXLSPbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644AbXLSPbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 10:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754721AbXLSPbC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 10:31:02 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:41227 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141AbXLSPbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 10:31:00 -0500
Date: Wed, 19 Dec 2007 09:30:56 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: serge@hallyn.com, alan@redhat.com, viro@zeniv.linux.org.uk,
       hch@infradead.org, peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC/PATCH 2/8] revoke: inode revoke lock V7
Message-ID: <20071219153056.GA7574@sergelap.austin.ibm.com>
References: <Pine.LNX.4.64.0712141715440.28689@sbz-30.cs.Helsinki.FI> <20071217222850.GA10076@vino.hallyn.com> <Pine.LNX.4.64.0712180923450.32179@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712180923450.32179@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pekka J Enberg (penberg@cs.helsinki.fi):
> Hi Serge,
> 
> (Thanks for looking at this. I appreciate the review!)
> 
> On Mon, 17 Dec 2007, serge@hallyn.com wrote:
> > >  	struct vfsmount *mnt = nd->mnt;
> > > -	struct dentry *dentry = __d_lookup(nd->dentry, name);
> > > +	struct dentry *dentry;
> > >  
> > > +again:
> > > +	dentry  = __d_lookup(nd->dentry, name);
> > >  	if (!dentry)
> > >  		goto need_lookup;
> > > +
> > > +	if (dentry->d_inode && IS_REVOKE_LOCKED(dentry->d_inode)) {
> > 
> > not sure whether this is a problem or not, but dentry->d_inode isn't
> > locked here, right?  So nothing is keeping do_lookup() returning
> > with an inode which gets revoked between here and the return 0
> > a few lines down?
> 
> I assume you mean S_REVOKE_LOCK and not ->i_mutex, right?

No I did mean the i_mutex since you take the i_mutex when you set
S_REVOKE_LOCK.  So between that and the comment above do_lookup(),
I assumed you were trying to lock out concurrent do_lookups() returning
an inode whose revoke is starting at the same time.

But based on your next paragraph it sounds like I misunderstand your
locking.

> The caller is supposed to block open(2) with chmod(2)/chattr(2) so while 
> revoke is in progress, you can get references to the _revoked inode_, 
> which is fine (operations on it will fail with EBADFS). The 
> ->i_revoke_wait bits are there to make sure that while we revoke, you 
> can't get a _new reference_ to the inode until we're done.

And a new reference means through iget(), so if revoke starts
between the IS_REVOKE_LOCKED() check in do_lookup and its return,
it's ok bc we'll get a reference later on?

I'm a little confused but i'll keep looking.

thanks,
-serge
