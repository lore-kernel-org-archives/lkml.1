Return-Path: <linux-kernel-owner+w=401wt.eu-S1752615AbZJ2Mca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbZJ2Mca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 08:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbZJ2Mc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 08:32:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170AbZJ2Mc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 08:32:29 -0400
Date: Thu, 29 Oct 2009 08:31:54 -0400
From: Josef Bacik <josef@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Hommey <mh@glandium.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>,
       "Theodore Ts'o" <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
       Josef Bacik <jbacik@redhat.com>, Mark Fasheh <mfasheh@suse.com>
Subject: Re: [PATCH] Fix generic_block_fiemap for files bigger than 4GB
Message-ID: <20091029123153.GA7436@localhost.localdomain>
References: <1256577868-30484-1-git-send-email-mh@glandium.org> <20091028230022.e15b1e9c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091028230022.e15b1e9c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 11:00:22PM -0700, Andrew Morton wrote:
> On Mon, 26 Oct 2009 18:24:28 +0100 Mike Hommey <mh@glandium.org> wrote:
> 
> > Because of an integer overflow on start_blk, various kind of wrong results
> > would be returned by the generic_block_fiemap handler, such as no extents
> > when there is a 4GB+ hole at the beginning of the file, or wrong fe_logical
> > when an extent starts after the first 4GB.
> > 
> > Signed-off-by: Mike Hommey <mh@glandium.org>
> > ---
> >  fs/ioctl.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/ioctl.c b/fs/ioctl.c
> > index 7b17a14..6c75110 100644
> > --- a/fs/ioctl.c
> > +++ b/fs/ioctl.c
> > @@ -254,7 +254,7 @@ int __generic_block_fiemap(struct inode *inode,
> >  			   u64 len, get_block_t *get_block)
> >  {
> >  	struct buffer_head tmp;
> > -	unsigned int start_blk;
> > +	unsigned long long start_blk;
> >  	long long length = 0, map_len = 0;
> >  	u64 logical = 0, phys = 0, size = 0;
> >  	u32 flags = FIEMAP_EXTENT_MERGED;
> 
> Well.  Should it be unsigned long long, or u64 or sector_t?  Or even loff_t.
> 
> The code's a bit confused about types in there.  And it's made much
> more confusing by the moronic and wholly unnecessary use of macros for
> blk_to_logical() and logical_to_blk().
> 
> It's also unhelpful that the `u64 start' argument forgot to get itself
> documented in the kerneldoc comment.  Sigh.
> 
> Ah, generic_block_fiemap() has it:
> 
>  * @start: The initial block to map
> 
> I guess u64 was logical there as it comes in from userspace.  But at
> some boundary we should start talking kernel types so I suspect the
> correct thing to do here is to use sector_t?
> 

Hmm this is strange, I had sent a patch a few months ago after you chewed me out
the first time for this to change all the types and such and make the macro's
inlined functions.  I will see if I can find it and resend it.  Thanks,

Josef
