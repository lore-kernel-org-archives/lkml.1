Return-Path: <linux-kernel-owner+w=401wt.eu-S1760210AbXIZNlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760210AbXIZNlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 09:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756451AbXIZNlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 09:41:11 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:56830 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756340AbXIZNlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 09:41:09 -0400
Date: Wed, 26 Sep 2007 09:40:20 -0400
Message-Id: <200709261340.l8QDeKie025351@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org
Subject: Re: [PATCH 10/25] Unionfs: add un/likely conditionals on copyup ops 
In-reply-to: Your message of "Tue, 25 Sep 2007 21:32:44 PDT."
             <46F9E0EC.3010105@intel.com> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <46F9E0EC.3010105@intel.com>, "Kok, Auke" writes:
> Erez Zadok wrote:
> > Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
> > ---
> >  fs/unionfs/copyup.c |  102 +++++++++++++++++++++++++-------------------------
> >  1 files changed, 51 insertions(+), 51 deletions(-)
> > 
> > diff --git a/fs/unionfs/copyup.c b/fs/unionfs/copyup.c
> > index 23ac4c8..e3c5f15 100644
> > --- a/fs/unionfs/copyup.c
> > +++ b/fs/unionfs/copyup.c
> > @@ -36,14 +36,14 @@ static int copyup_xattrs(struct dentry *old_lower_dentry,
> >  
> >  	/* query the actual size of the xattr list */
> >  	list_size = vfs_listxattr(old_lower_dentry, NULL, 0);
> > -	if (list_size <= 0) {
> > +	if (unlikely(list_size <= 0)) {
> 
> 
> I've been told several times that adding these is almost always bogus - either it
> messes up the CPU branch prediction or the compiler/CPU just does a lot better at
> finding the right way without these hints.
>
> Adding them as a blanket seems rather strange. Have you got any numbers that this
> really improves performance?
> 
> Auke

Auke, that's a good question, but I found it hard to find any info about it.
There's no discussion on it in Documentation/, and very little I could find
elsewhere.  I did see one url explaining what un/likely does precisely, but
no guidelines.  My understanding is that it can improve performance, as long
as it's used carefully (otherwise it may hurt performance).

Background: we used un/likely in Unionfs only sparingly until now.  We
looked at what other filesystems and kernel components do, and it seems that
it varies a lot: some subsystems use it religiously wherever they can, and
some use it just a little here and there.  We looked at what other
filesystems do in particular and tried to follow a similar model under what
cases other filesystems use un/likely.

Recently we've done a full audit of the entire code, and added un/likely
where we felt that the chance of succeeding is 95% or better (e.g., error
conditions that should rarely happen, and such).  So while it looks like
we've added many of those in this series of patches, I can assure you we
didn't just wrap every conditional in an un/likely just for the sake of
using it. :-) There are plenty of conditionals (over 250) left untouched b/c
it didn't make sense to force the branch prediction on them one way or
another.

So my questions are, for everyone, what's the policy on using un/likely?
Any common conventions/wisdom?  I think we need something added to
Documentation/.

Also, Auke, if indeed compilers are [sic] likely to do better than
programmers adding un/likely wrappers, then why do we still support that in
the kernel?  (Working for a company tat produces high-quality compilers, you
may know the answer better.)

Personally I'm not too fond of what those wrappers do the code: they make it
a bit harder to read the code (yet another extra set of parentheses); and
they cause the code to be indented further to the right, which you sometimes
have to split to multiple lines to avoid going over 80 chars.

Cheers,
Erez.
