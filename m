Return-Path: <linux-kernel-owner+w=401wt.eu-S1758129AbXFDPyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbXFDPyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 11:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757567AbXFDPyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 11:54:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:22658 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882AbXFDPyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 11:54:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=LhNgeiAx8uWkYVIB3cSFEHmzuMHgyA3W6U5GgJZ+fkVRVcHBGZjc5fmBBP8dCJJNdjepyiQPPzjiofsH/K25FW+UFnC8UK9zZIkmS13wdBJfosborv4xnnWj/3QKob//zCPf7lWNS9EcsksoKqNsxEqnfGgDMLpbPbfyDZeE0Ro=
Date: Mon, 4 Jun 2007 19:53:16 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Eric Sandeen <sandeen@sandeen.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 2/2] Fix possible leakage of blocks in UDF
Message-ID: <20070604155316.GA10438@cvg>
References: <20070524165935.GB19709@duck.suse.cz> <20070524170554.GC19709@duck.suse.cz> <20070524203653.GA7693@duck.suse.cz> <465DF0B4.2050203@sandeen.net> <20070601211036.GA23975@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601211036.GA23975@duck.suse.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Jan Kara - Fri, Jun 01, 2007 at 11:10:36PM +0200]
| On Wed 30-05-07 16:46:28, Eric Sandeen wrote:
| > Jan Kara wrote:
| > >   Hello,
| > > 
| > > On Thu 24-05-07 19:05:54, Jan Kara wrote:
| > >>   Hello,
| > >>
| > >>   attached is a patch that fixes possible leakage of free blocks / use of
| > >> free blocks in UDF (which spilled nice assertion failures I've added in my
| > >> first round of patches). More details in the changelog. Andrew, please apply.
| > >> Both changes have survived some time of fsx and fsstress testing so they
| > >> should be reasonably safe.
| > >   Sorry for replying to myself but this patch had a minor problem of
| > > printing some bogus warnings when directories were deleted (I wonder why
| > > fsstress didn't find it). Attached is a new version of the patch without
| > > this problem.
| > 
| > Jan, something seems busted here.  I'm getting lockups when testing udf
| > on a single cpu with this last patch in place...
|   Hmm, strange, I was also testing on UP and without problems. And I didn't
| change any locking...
| 
| > I think it's the BKL stumbling on itself.
| > 
| > for example...
| > 
| > static int udf_symlink(struct inode * dir, struct dentry * dentry, const
| > char * symname)
| > {
| > ...
| >         lock_kernel();
| > ...
| > out:
| >         unlock_kernel();
| >         return err;
| > 
| > out_no_entry:
| >         inode_dec_link_count(inode);
| >         iput(inode);
| >         goto out;
| > }
| > 
| > but iput goes
| > iput->iput_final->drop_inode->udf_drop_inode->lock_kernel() again
|   As Andrew already wrote, BKL is free to recurse...
| 
| > looking for the right way around it but figured I'd ping you early :)
|   Thanks for info - I'm now mostly out of email for a few days but I'll
| have a look at it as soon as I return.
| 
| 								Honza
| -- 
| Jan Kara <jack@suse.cz>
| SuSE CR Labs
| 

Hi Jan,

why can't we combine udf_delete_inode() with udf_drop_inode()?
It'll avoid deadlock.

		Cyrill

