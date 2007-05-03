Return-Path: <linux-kernel-owner+w=401wt.eu-S2992420AbXECUcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992420AbXECUcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 16:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031286AbXECUcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 16:32:31 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:59982 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031206AbXECUca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 16:32:30 -0400
Date: Thu, 3 May 2007 23:32:28 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] revoke: change revoke_table to fileset and revoke_details
In-Reply-To: <20070503132253.7b6fe5fe.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705032329220.14781@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0705031752440.6505@sbz-30.cs.Helsinki.FI>
 <20070503132253.7b6fe5fe.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007, Andrew Morton wrote:
> > +/**
> > + * fileset - an array of file pointers.
> > + * @files:    the array of file pointers
> > + * @nr:               number of elements in the array
> > + * @end:      index to next unused file pointer
> > + */
> > +struct fileset {
> > +	struct file	**files;
> > +	unsigned long	nr;
> > +	unsigned long	end;
> > +};
> 
> What's the locking protocol for all this?

What do you mean? There is no concurrent access going on here.

On Thu, 3 May 2007, Andrew Morton wrote:
> > +static void free_fset(struct fileset *fset)
> > +{
> > +      int i;
> > +
> > +      for (i = fset->end; i < fset->nr; i++)
> > +              fput(fset->files[i]);
> > +
> > +      kfree(fset->files);
> > +      kfree(fset);
> > +}
> 
> Confused.  Shouldn't it be
> 
> 	for (i = 0; i < fset->end; i++)

No. The fset->end is an index to the first _unused_ file pointer. All 
entries before that are in use by revoked file descriptors so we don't 
want to fput() them.

			Pekka
