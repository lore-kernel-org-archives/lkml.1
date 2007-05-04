Return-Path: <linux-kernel-owner+w=401wt.eu-S1422625AbXEDAEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422625AbXEDAEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 20:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422626AbXEDAEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 20:04:54 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49193 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422625AbXEDAEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 20:04:53 -0400
Date: Thu, 3 May 2007 17:04:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] revoke: change revoke_table to fileset and
 revoke_details
Message-Id: <20070503170447.8520da9c.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705032329220.14781@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0705031752440.6505@sbz-30.cs.Helsinki.FI>
	<20070503132253.7b6fe5fe.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705032329220.14781@sbz-30.cs.Helsinki.FI>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007 23:32:28 +0300 (EEST)
Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

> On Thu, 3 May 2007, Andrew Morton wrote:
> > > +/**
> > > + * fileset - an array of file pointers.
> > > + * @files:    the array of file pointers
> > > + * @nr:               number of elements in the array
> > > + * @end:      index to next unused file pointer
> > > + */
> > > +struct fileset {
> > > +	struct file	**files;
> > > +	unsigned long	nr;
> > > +	unsigned long	end;
> > > +};
> > 
> > What's the locking protocol for all this?
> 
> What do you mean? There is no concurrent access going on here.

Well that's the "locking" protocol then: each instance of this structure is
only ever touched by a single thread, yes?

> On Thu, 3 May 2007, Andrew Morton wrote:
> > > +static void free_fset(struct fileset *fset)
> > > +{
> > > +      int i;
> > > +
> > > +      for (i = fset->end; i < fset->nr; i++)
> > > +              fput(fset->files[i]);
> > > +
> > > +      kfree(fset->files);
> > > +      kfree(fset);
> > > +}
> > 
> > Confused.  Shouldn't it be
> > 
> > 	for (i = 0; i < fset->end; i++)
> 
> No. The fset->end is an index to the first _unused_ file pointer. All 
> entries before that are in use by revoked file descriptors so we don't 
> want to fput() them.
> 

OK.
