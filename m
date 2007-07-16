Return-Path: <linux-kernel-owner+w=401wt.eu-S1762750AbXGPVr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762750AbXGPVr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 17:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757376AbXGPVrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 17:47:51 -0400
Received: from DELFT.AURA.CS.CMU.EDU ([128.2.206.88]:46023 "EHLO
	delft.aura.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbXGPVrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 17:47:51 -0400
Date: Mon, 16 Jul 2007 17:47:45 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: wrong order of arguments of ->readdir()
Message-ID: <20070716214745.GA22534@delft.aura.cs.cmu.edu>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200707152359.l6FNx3oN023117@hera.kernel.org> <20070716134424.0cd870b4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716134424.0cd870b4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Jan Harkes <jaharkes@cs.cmu.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2007 at 01:44:24PM -0700, Andrew Morton wrote:
> On Sun, 15 Jul 2007 23:59:03 GMT
> Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
> > 
> >     wrong order of arguments of ->readdir()
> >     
> >     Shows how many people are testing coda - the bug had been there for 5 years
> >     and results of stepping on it are not subtle.
> >     
> >     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> >     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > ---
> >  fs/coda/dir.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/coda/dir.c b/fs/coda/dir.c
> > index 9ddf5ed..898a86d 100644
> > --- a/fs/coda/dir.c
> > +++ b/fs/coda/dir.c
> > @@ -470,7 +470,7 @@ int coda_readdir(struct file *coda_file, void *dirent, filldir_t filldir)
> >  
> >  		ret = -ENOENT;
> >  		if (!IS_DEADDIR(host_inode)) {
> > -			ret = host_file->f_op->readdir(host_file, filldir, dirent);
> > +			ret = host_file->f_op->readdir(host_file, dirent, filldir);
> >  			file_accessed(host_file);
> >  		}
> >  	}
> 
> Today is not being a good day.
> 
> This bug was already fixed.   The following mistakes were made:

This bug never affected Coda clients, the relevant code path was used by
'potemkin' which was an extremely stripped down client that was used to
test the kernel module during it's initial development. It simply
exported an existing directory tree under the /coda namespace.

I noticed the bug when I moved the place where we lock the container
file which was triggering the lockdep warning and corrected the code. It
isn't a code path that our userspace uses, and considering how long the
bug has been present nobody else used either so I actually didn't even
remember fixing that bug when I was cherry picking patches out of my
development tree to pass upstream.

> a) Jan's patch was misleadingly titled "coda: avoid lockdep warning in
>    coda_readdir"
> 
> b) Jan's patch had no changelog
> 
> c) Jen's patch was not cc'ed to any mailing list
>
> d) Al's patch was not sent to the maintainer.  Nor to me.  Nor was it
>    staged in any tree which I can get at so that I could inform people of
>    the upcoming conflict/duplication/etc.

I didn't realize that as the maintainer for Coda and only touching code
within fs/coda, I was expected to CC' the mailing lists. Especially
surprising since there have been quite a few patches to fs/coda on which
I haven't even been CC'd and which were never sent any mailing list
either. I see them only after they appear in the main kernel during the
merge window, which means I pretty much don't get a chance to update and
retest my development work before the window is closed again.

My patches weren't written last week, several of them have been around
since at least June 2005 and are probably even older than that,

http://www.coda.cs.cmu.edu/cgi-bin/gitweb.cgi?p=linux-coda.git;a=shortlog

Yes that is an externally built Coda kernel module, which most Coda
users who have a problem with the in-kernel one switch to. Even with
some of the known bugs, the in-kernel version works fine for most use
cases.

So this time I cherrypicked a limited subset of fixes and cleanups that
I think should go upstream. The cherry picks were for the most part
rewrites by looking at diffs between 2.6.22-rc and the external module
code that I maintain (which is why I didn't have nice changelogs).

> Guys (and I mean all guys): things are really shit at present.  Please try
> to do better.

You can check with git how many patches went into fs/coda that I have
not been CC'd on, this problem has been ongoing for a while. I don't
mind it too much, clearly the patches were mostly minor changes which
did not break Coda.

Jan

