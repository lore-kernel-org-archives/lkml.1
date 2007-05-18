Return-Path: <linux-kernel-owner+w=401wt.eu-S1757712AbXERLBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712AbXERLBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 07:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754955AbXERLBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 07:01:30 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:34720 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518AbXERLB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 07:01:29 -0400
Date: Fri, 18 May 2007 16:35:58 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH  8/14] Union-mount lookup
Message-ID: <20070518110558.GB4869@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070514093722.GB4139@in.ibm.com> <20070514094218.GJ4139@in.ibm.com> <1179237645.6464.22.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179237645.6464.22.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2007 at 10:00:45AM -0400, Trond Myklebust wrote:
> On Mon, 2007-05-14 at 15:12 +0530, Bharata B Rao wrote:
> > From: Jan Blunck <j.blunck@tu-harburg.de>
> > Subject: Union-mount lookup
> > 
> > Modifies the vfs lookup routines to work with union mounted directories.
> > 
> > The existing lookup routines generally lookup for a pathname only in the
> > topmost or given directory. The changed versions of the lookup routines
> > search for the pathname in the entire union mounted stack. Also they have been
> > modified to setup the union stack during lookup from dcache cache and from
> > real_lookup().
> > 
> > Signed-off-by: Jan Blunck <j.blunck@tu-harburg.de>
> > Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> > ---
> >  fs/dcache.c            |   16 +
> >  fs/namei.c             |   78 +++++-
> >  fs/namespace.c         |   35 ++
> >  fs/union.c             |  598 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/dcache.h |   17 +
> >  include/linux/namei.h  |    4 
> >  include/linux/union.h  |   49 ++++
> >  7 files changed, 786 insertions(+), 11 deletions(-)
> > 
> > --- a/fs/dcache.c
> > +++ b/fs/dcache.c
> > @@ -1286,7 +1286,7 @@ struct dentry * d_lookup(struct dentry *
> >  	return dentry;
> >  }
> >  
> > -struct dentry * __d_lookup(struct dentry * parent, struct qstr * name)
> > +struct dentry * __d_lookup_single(struct dentry *parent, struct qstr *name)
> >  {
> >  	unsigned int len = name->len;
> >  	unsigned int hash = name->hash;
> > @@ -1371,6 +1371,20 @@ out:
> >  	return dentry;
> >  }
> >  
> > +struct dentry * d_lookup_single(struct dentry *parent, struct qstr *name)
> > +{
> > +	struct dentry *dentry;
> > +	unsigned long seq;
> > +
> > +        do {
> > +                seq = read_seqbegin(&rename_lock);
> > +                dentry = __d_lookup_single(parent, name);
> > +                if (dentry)
> > +			break;
> > +	} while (read_seqretry(&rename_lock, seq));
> > +	return dentry;
> > +}
> > +
> >  /**
> >   * d_validate - verify dentry provided from insecure source
> >   * @dentry: The dentry alleged to be valid child of @dparent
> > --- a/fs/namei.c
> > +++ b/fs/namei.c
> > @@ -374,6 +374,33 @@ void release_open_intent(struct nameidat
> >  }
> >  
> >  static inline struct dentry *
> > +do_revalidate_single(struct dentry *dentry, struct nameidata *nd)
> > +{
> > +	int status = dentry->d_op->d_revalidate(dentry, nd);
> > +	if (unlikely(status <= 0)) {
> 
> d_revalidate() returns a 0 or 1 result, not an error.

Doesn't look like (see the comment below) because this is copied
as-is from do_revalidate().

> 
> > +		/*
> > +		 * The dentry failed validation.
> > +		 * If d_revalidate returned 0 attempt to invalidate
> > +		 * the dentry otherwise d_revalidate is asking us
> > +		 * to return a fail status.
> > +		 */
> > +		if (!status) {
> > +			if (!d_invalidate(dentry)) {
> > +				__dput_single(dentry);
> > +				dentry = NULL;
> > +			}
> > +		} else {
> > +			__dput_single(dentry);
> > +			dentry = ERR_PTR(status);

Regards,
Bharata.
