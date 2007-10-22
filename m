Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbXJVSIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbXJVSIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 14:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbXJVSIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 14:08:40 -0400
Received: from mail.fieldses.org ([66.93.2.214]:50501 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbXJVSIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 14:08:39 -0400
Date: Mon, 22 Oct 2007 14:08:35 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, viro@ftp.linux.org.uk
Subject: Re: [PATCH] dcache: don't expose uninitialized memory in
	/proc/<pid>/fd/<fd>
Message-ID: <20071022180835.GI583@fieldses.org>
References: <20071016193230.GA8650@fieldses.org> <20071016193557.GB8650@fieldses.org> <20071017153201.d4e0679b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017153201.d4e0679b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delayed response:

On Wed, Oct 17, 2007 at 03:32:01PM -0700, Andrew Morton wrote:
> On Tue, 16 Oct 2007 15:35:57 -0400
> "J. Bruce Fields" <bfields@fieldses.org> wrote:
> 
> > From: J. Bruce Fields <bfields@citi.umich.edu>
> > 
> > Well, it's not especially important that target->d_iname get the
> > contents of dentry->d_iname, but it's important that it get initialized
> > with *something*, otherwise we're just exposing some random piece of
> > memory to anyone who reads the link at /proc/<pid>/fd/<fd> for the
> > deleted file, when it's still held open by someone.
> > 
> 
> hm, that was tricky.
> 
> > ---
> >  fs/dcache.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > (Am I missing something?  I've also run a test program that copies a
> > short (<36 character) name ontop of a long (>=36 character) name and see
> > that the first time I run it, without this patch, I get unpredicatable
> > results out of /proc/<pid>/fd/<fd>.)
> > 
> > diff --git a/fs/dcache.c b/fs/dcache.c
> > index 5663a31..24252fc 100644
> > --- a/fs/dcache.c
> > +++ b/fs/dcache.c
> > @@ -1483,6 +1483,8 @@ static void switch_names(struct dentry *dentry, struct dentry *target)
> >  			 * dentry:internal, target:external.  Steal target's
> >  			 * storage and make target internal.
> >  			 */
> > +			memcpy(target->d_iname, dentry->d_name.name,
> > +					dentry->d_name.len + 1);
> >  			dentry->d_name.name = target->d_name.name;
> >  			target->d_name.name = target->d_iname;
> >  		}
> 
> Or we could just stick a \0 in there.

The memcpy() makes the behavior agree with the code comments, and with
what the kernel normally otherwise does.  But, yeah, just making it a
null string would probably be reasonable too.

> Or perhaps we should set it to "(deleted file)"?

Looks like __d_path already adds a (deleted) for us, so that'de be
redundant.

--b.
