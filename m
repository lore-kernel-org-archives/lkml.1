Return-Path: <linux-kernel-owner+w=401wt.eu-S1765751AbXJTTFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765751AbXJTTFQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 15:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758464AbXJTTFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 15:05:04 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:51403 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758450AbXJTTFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 15:05:02 -0400
Date: Sat, 20 Oct 2007 15:04:39 -0400
Message-Id: <200710201904.l9KJ4d4Z019993@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, bfields@fieldses.org,
       nfs@lists.sourceforge.net, neilb@suse.de, linux-kernel@vger.kernel.org
Subject: Re: nfsv2 ref leak in 2.6.24? 
In-reply-to: Your message of "Sat, 20 Oct 2007 13:12:31 EDT."
             <1192900351.7440.6.camel@heimdal.trondhjem.org> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1192900351.7440.6.camel@heimdal.trondhjem.org>, Trond Myklebust writes:
> 
> On Fri, 2007-10-19 at 22:33 -0400, Erez Zadok wrote:
> > Trond, good news.  I was able to narrow down the problem to purely the
> > client-side, probably dcache/readdir related, and I have a shell script that
> > deterministically triggers the problem each time for me (this is a FC6 image
> > under Vmware 6.0.1).  Here's a short shell script which reliably triggers
> > the "lost files" problem -- I create a file via nfs2 on the client side, and
> > sometimes it doesn't show up in readdir, but it is there if you stat it
> > directly.
> 
> Ah... I got confused as to what you were measuring and where.

Yeah, I wasn't sure myself until I narrowed it down to a small test case.

> Looking at
> nfs_proc_create(), there is indeed a missing call to
> nfs_mark_for_revalidate(). The reason why you need such a call being the
> usual one: NFSv2 doesn't provide post-op attributes for the directory.
> 
> The patch below ought to fix the problem.

It fixes some, but breaks others.  The test script I sent yesterday indeed
passes.  And more of my unionfs-on-nfs2 tests pass, but not all.  Three of
my unionfs tests (create w/ copyup, unlink open files, and unlink with a
whiteout) fail b/c they detect leftover silly-renamed files.  Worse, now the
same three tests also fail when I use unionfs on top of nfs3/nfs4: before
the one line fix below, unionfs-on-nfsv3/4 worked fine.

Was there any significant semantic change in the behaviour of silly-renamed
files in nfs in 2.6.24?  If so, then I may have to change how unionfs
handles refcounts and such.

I'll try to dig deeper and see if I can come up with a small test case that
doesn't involve unionfs.

Thanks,
Erez.

> Cheers
>   Trond
> ---------------------- CUT HERE -----------------------
> From: Trond Myklebust <Trond.Myklebust@netapp.com>
> Date: Sat, 20 Oct 2007 13:07:21 -0400
> NFSv2: Ensure that the directory metadata gets revalidated on file create
> 
> Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> ---
> 
>  fs/nfs/proc.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/nfs/proc.c b/fs/nfs/proc.c
> index 97669ed..4f80d88 100644
> --- a/fs/nfs/proc.c
> +++ b/fs/nfs/proc.c
> @@ -211,6 +211,7 @@ nfs_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
>  	nfs_fattr_init(&fattr);
>  	dprintk("NFS call  create %s\n", dentry->d_name.name);
>  	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
> +	nfs_mark_for_revalidate(dir);
>  	if (status == 0)
>  		status = nfs_instantiate(dentry, &fhandle, &fattr);
>  	dprintk("NFS reply create: %d\n", status);

Erez.
