Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbYLCNDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbYLCNDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 08:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbYLCNDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 08:03:05 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58098 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbYLCNDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 08:03:02 -0500
Date: Wed, 3 Dec 2008 08:03:01 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 3/6] integrity: IMA as an integrity service provider
Message-ID: <20081203130301.GA9681@infradead.org>
References: <cover.1228253618.git.zohar@linux.vnet.ibm.com> <5bea2422d059b97475d735feb9feb78b57ec8eca.1228253619.git.zohar@linux.vnet.ibm.com> <1228260925.2971.240.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228260925.2971.240.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2008 at 03:35:25PM -0800, Dave Hansen wrote:
> If you're looking for another way to split your patch out, you could
> just stick use inode->integrity for the first patch, then introduce your
> radix-tree in a subsequent patch.  It would be functionally fine, and
> more clearly separate out the ideas.

This was done earlier and is a really bad thing for review.  Just as the
breakout happening in this round.

Folks, breaking out logical changes is good, but splitting new code for
the sake of it is just a bloody stupid idea.  It makes reviewing things
much harder and makes the submitter to stupid work.  If a single new
driver really is large splitting the patch doesn't help.

> > +	if (!ima_used_chip)
> > +		ima_info("No TPM chip found(rc = %d), activating TPM-bypass!\n",
> > +			 rc);
> 
> For the record, I think this is the kind of place that it's worth going
> over 80 chars.

Or just don't bother printing the useless and ugly rc value and you're
under it immediately..

> > +	if ((file->f_mode & FMODE_WRITE) &&
> > +	    (atomic_read(&inode->i_writecount) == 1)) {
> > +		rcu_read_lock();
> > +		iint = ima_iint_lookup(inode);
> > +		if (!iint) {
> > +			rcu_read_unlock();
> > +			return;
> > +		}
> > +		kref_get(&iint->refcount);
> > +		rcu_read_unlock();
> > +
> > +		mutex_lock(&iint->mutex);
> > +		if (iint->version != inode->i_version)
> > +			iint->flags &= ~IMA_MEASURED;
> > +		mutex_unlock(&iint->mutex);
> > +		kref_put(&iint->refcount, iint_free);
> > +	}
> > +}
> 
> I'm also wondering if there's a way to wrap up the mutex operations
> since this seems to be done the exact same way every time.  Dunno, maybe
> it is too much locking obfuscation for just a few lines saved.

Biggest problem here is the i_version checks.  i_version is only updated
for directories unless you're on ext4 and use an undocumented mount
option..

> > +
> > +	/* Invalidate PCR, if a measured file is already open for read */
> > +	if ((mdata.mask & (MAY_WRITE | MAY_READ)) == MAY_WRITE) {
> 
> It would warm my heart to see something like this:
> 
> int mdata_is_write_only(struct ima_measure_data *mdata)
> {
> 	if (mdata.mask & MAY_READ)
> 		return 0;
> 	return mdata.mask & MAY_WRITE;

Umm, no.  The above is a perfectly fine idiom for testing flags in C.
The helper would just obsfucated it.

> I have memories of talking about this bit.  I was confused and you
> explained it to me, but it still isn't explained in the code. :(  Again,
> I'm not convinced that this works.  Can the code convince me, or should
> I go digging in my inbox?

I also haven't seen a good explanation for it yet.

> Please take a really, really hard look at these patches, all 3000 lines
> of it, and try to rework them.  Find common bits of code that are
> duplicated or copy-n-pasted around.  Find functions that have gotten too
> long and break them up.  I bet you can knock a couple hundred lines of
> code off this sucker, easy.

*nod*  And change all the places that pass a pointer to a structure as
a void pointer instead of a few normal paramters.  That part really
drives me nuts.

