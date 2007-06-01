Return-Path: <linux-kernel-owner+w=401wt.eu-S1764972AbXFAU6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764972AbXFAU6q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763263AbXFAU6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:58:38 -0400
Received: from styx.suse.cz ([82.119.242.94]:60258 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761443AbXFAU6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:58:37 -0400
Date: Fri, 1 Jun 2007 23:10:36 +0200
From: Jan Kara <jack@suse.cz>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 2/2] Fix possible leakage of blocks in UDF
Message-ID: <20070601211036.GA23975@duck.suse.cz>
References: <20070524165935.GB19709@duck.suse.cz> <20070524170554.GC19709@duck.suse.cz> <20070524203653.GA7693@duck.suse.cz> <465DF0B4.2050203@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465DF0B4.2050203@sandeen.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 30-05-07 16:46:28, Eric Sandeen wrote:
> Jan Kara wrote:
> >   Hello,
> > 
> > On Thu 24-05-07 19:05:54, Jan Kara wrote:
> >>   Hello,
> >>
> >>   attached is a patch that fixes possible leakage of free blocks / use of
> >> free blocks in UDF (which spilled nice assertion failures I've added in my
> >> first round of patches). More details in the changelog. Andrew, please apply.
> >> Both changes have survived some time of fsx and fsstress testing so they
> >> should be reasonably safe.
> >   Sorry for replying to myself but this patch had a minor problem of
> > printing some bogus warnings when directories were deleted (I wonder why
> > fsstress didn't find it). Attached is a new version of the patch without
> > this problem.
> 
> Jan, something seems busted here.  I'm getting lockups when testing udf
> on a single cpu with this last patch in place...
  Hmm, strange, I was also testing on UP and without problems. And I didn't
change any locking...

> I think it's the BKL stumbling on itself.
> 
> for example...
> 
> static int udf_symlink(struct inode * dir, struct dentry * dentry, const
> char * symname)
> {
> ...
>         lock_kernel();
> ...
> out:
>         unlock_kernel();
>         return err;
> 
> out_no_entry:
>         inode_dec_link_count(inode);
>         iput(inode);
>         goto out;
> }
> 
> but iput goes
> iput->iput_final->drop_inode->udf_drop_inode->lock_kernel() again
  As Andrew already wrote, BKL is free to recurse...

> looking for the right way around it but figured I'd ping you early :)
  Thanks for info - I'm now mostly out of email for a few days but I'll
have a look at it as soon as I return.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
