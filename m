Return-Path: <linux-kernel-owner+w=401wt.eu-S1764605AbYFKREU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764605AbYFKREU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 13:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761866AbYFKREN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 13:04:13 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3915 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbYFKREM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 13:04:12 -0400
Date: Wed, 11 Jun 2008 13:03:21 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] shm: Remove silly double assignment
Message-ID: <20080611170321.GA23507@hmsreliant.think-freely.org>
References: <20080610125338.GB3165@hmsreliant.think-freely.org> <20080611034506.05ad07ae.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080611034506.05ad07ae.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2008 at 03:45:06AM -0700, Andrew Morton wrote:
> On Tue, 10 Jun 2008 08:53:39 -0400 Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> >     Found a silly double assignment of err is do_shmat.  Silly, but good to clean up
> >     the useless code.
> >     
> >     Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > 
> > diff --git a/ipc/shm.c b/ipc/shm.c
> > index 554429a..d05f6b5 100644
> > --- a/ipc/shm.c
> > +++ b/ipc/shm.c
> > @@ -894,8 +894,6 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr)
> >  	if (!sfd)
> >  		goto out_put_dentry;
> >  
> > -	err = -ENOMEM;
> > -
> >  	file = alloc_file(path.mnt, path.dentry, f_mode, &shm_file_operations);
> >  	if (!file)
> >  		goto out_free;
> 
> Not silly, really.  Look:
> 
> 	err = -ENOMEM;
> 	if (expr1)
> 		goto out;
> 
> 	err = -ENOMEM;
> 	if (expr2)
> 		goto out;
> 
> each of these two units is a separate, self-contained clause.  Removing
> the second assignment to `err' breaks that separation and will make one
> clause undesirably dependent upon the other.
yes, I see that keeping the second assignment lets you insert code in the middle
without having up to update afterwards.  I just don't think the redundant
assignment is worth keeping just for that purpose.


> 
> Example: if someone later comes up and does
> 
> 	err = -ENOMEM;
> 	if (expr1)
> 		goto out;
> 
> +	er = -EINVAL;
> +	if (expr3)
> +		goto out;
> 
> 	if (expr2)
> 		goto out;
> 
> then whoops, it broke.
> 
Yes, but that would be the fault of the subsequent patch, and if they couldn't
see that problem, I fear that a double assignment isn't going to help them much.

> The compiler should optimise away the second assignment anyway.
Agreed, its really not a big deal.  If its not worth it, its fine with me.  I
was just being janitorial, and thought this looked rather redundant.

Best
Neil

-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
