Return-Path: <linux-kernel-owner+w=401wt.eu-S1755146AbYLCSYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbYLCSYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 13:24:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbYLCSYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 13:24:34 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:53718 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990AbYLCSYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 13:24:32 -0500
Subject: Re: [PATCH 3/6] integrity: IMA as an integrity service provider
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <20081203130301.GA9681@infradead.org>
References: <cover.1228253618.git.zohar@linux.vnet.ibm.com>
	 <5bea2422d059b97475d735feb9feb78b57ec8eca.1228253619.git.zohar@linux.vnet.ibm.com>
	 <1228260925.2971.240.camel@nimitz>  <20081203130301.GA9681@infradead.org>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 13:24:14 -0500
Message-Id: <1228328654.2821.35.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-03 at 08:03 -0500, Christoph Hellwig wrote: 
> On Tue, Dec 02, 2008 at 03:35:25PM -0800, Dave Hansen wrote:
> > If you're looking for another way to split your patch out, you could
> > just stick use inode->integrity for the first patch, then introduce your
> > radix-tree in a subsequent patch.  It would be functionally fine, and
> > more clearly separate out the ideas.
> 
> This was done earlier and is a really bad thing for review.  Just as the
> breakout happening in this round.
> 
> Folks, breaking out logical changes is good, but splitting new code for
> the sake of it is just a bloody stupid idea.  It makes reviewing things
> much harder and makes the submitter to stupid work.  If a single new
> driver really is large splitting the patch doesn't help.

I'm not disagreeing, just letting you know that in this case, the first
IMA patch builds cleanly and works, with each of the subsequent patches
adding new functionality.

> > > +	if ((file->f_mode & FMODE_WRITE) &&
> > > +	    (atomic_read(&inode->i_writecount) == 1)) {
> > > +		rcu_read_lock();
> > > +		iint = ima_iint_lookup(inode);
> > > +		if (!iint) {
> > > +			rcu_read_unlock();
> > > +			return;
> > > +		}
> > > +		kref_get(&iint->refcount);
> > > +		rcu_read_unlock();
> > > +
> > > +		mutex_lock(&iint->mutex);
> > > +		if (iint->version != inode->i_version)
> > > +			iint->flags &= ~IMA_MEASURED;
> > > +		mutex_unlock(&iint->mutex);
> > > +		kref_put(&iint->refcount, iint_free);
> > > +	}
> > > +}
> > 
> > I'm also wondering if there's a way to wrap up the mutex operations
> > since this seems to be done the exact same way every time.  Dunno, maybe
> > it is too much locking obfuscation for just a few lines saved.
> 
> Biggest problem here is the i_version checks.  i_version is only updated
> for directories unless you're on ext4 and use an undocumented mount
> option..

hm, i_version seems to be working properly for regular files on ext3.

> 
> > I have memories of talking about this bit.  I was confused and you
> > explained it to me, but it still isn't explained in the code. :(  Again,
> > I'm not convinced that this works.  Can the code convince me, or should
> > I go digging in my inbox?
> 
> I also haven't seen a good explanation for it yet.

Previous posting:
"The OS protects against an executable file, already open for write,
from being executed; and an executable file, open for execute, from
being modified.  In the same vein, we want to know that the file
measured is the same file read, that it hasn't been modified.  So, if a
file already open for read is then opened for write, we log it with a
"Time of Measure, Time of Use" error (ToMToU) and invalidate the
PCR.....

This is important when measuring configuration files, shell scripts (not
measured in brpm_check_integrity which are protected by the OS), and
files imported/included by scripts."

Another posting:
"From an integrity perspective, a file measurement might be invalidated
unnecessarily, but it is safe. For any file when opened for write, while
having an existing reader, will cause the file measurement to be
invalidated."

I'm just not seeing a problem. Perhaps because only regular files are
being measured, and of them, only those defined by the policy, which
most likely would not include pseudo filesystems (i.e. sysfs, procfs,
tmpfs, securityfs).

> > Please take a really, really hard look at these patches, all 3000 lines
> > of it, and try to rework them.  Find common bits of code that are
> > duplicated or copy-n-pasted around.  Find functions that have gotten too
> > long and break them up.  I bet you can knock a couple hundred lines of
> > code off this sucker, easy.
> 
> *nod*  And change all the places that pass a pointer to a structure as
> a void pointer instead of a few normal paramters.  That part really
> drives me nuts.

The parameters to the integrity API calls (collect, measure, store, etc)
need to be generic (void *), as different templates measure different
types of data, requiring different parameters.

As Dave Hansen, pointed out, the casting of void pointers is
unnecessary.  This will be cleaned up in the next patch set.

Mimi

