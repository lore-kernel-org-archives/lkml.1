Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758732Ab0BYBcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 20:32:25 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:32789 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758591Ab0BYBcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 20:32:24 -0500
Date: Wed, 24 Feb 2010 20:32:10 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: oleg@redhat.com, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] supress uid comparison test if core output files are
 pipes
Message-ID: <20100225013210.GA10527@localhost.localdomain>
References: <20100222200851.GD3344@hmsreliant.think-freely.org>
 <20100224135053.e75800c1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100224135053.e75800c1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -4.1 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 01:50:53PM -0800, Andrew Morton wrote:
> On Mon, 22 Feb 2010 15:44:29 -0500 Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> > Modify uid check in do_coredump so as to not apply it in the case of pipes
> > 
> > So this just got noticed in testing.  The end of do_coredump validates the uid
> > of the inode for the created file against the uid of the crashing process to
> > ensure that no one can pre-create a core file with different ownership and grab
> > the information contained in the core when they shouldn' tbe able to.  This
> > causes failures when using pipes for a core dumps if the crashing process is not
> > root, which is the uid of the pipe when it is created.
> > 
> > The fix is simple.  Since the check for matching uid's isn't relevant for pipes
> > (a process can't create a pipe that the uermodehelper code will open anyway), we
> > can just just skip it in the event ispipe is non-zero
> > 
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > 
> > 
> >  exec.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/exec.c b/fs/exec.c
> > index 6303d18..6af2214 100644
> > --- a/fs/exec.c
> > +++ b/fs/exec.c
> > @@ -1987,8 +1987,9 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
> >  	/*
> >  	 * Dont allow local users get cute and trick others to coredump
> >  	 * into their pre-created files:
> > +	 * Note, this is not relevant for pipes
> >  	 */
> > -	if (inode->i_uid != current_fsuid())
> > +	if (!ispipe && (inode->i_uid != current_fsuid()))
> >  		goto close_fail;
> >  	if (!cprm.file->f_op)
> >  		goto close_fail;
> 
> hm, this actually appears to fix a regression, added by:
> 
In a sense yes.  Previously though, Ingos check was both useless for pipes
(since you can't have a user create a pipe that will map to what the coredump
path creates anyway, making this check useless), but it worked anyway, since the
crashing process created the pipe, so the uid check always matched.  With the
refactoring andi and I did, thats no longer true, so the check could fail.  This
patch just fixes it up by recongnizing that the check isn't needed at all for
pipes

Regards
Neil

> 
> 
> commit c46f739dd39db3b07ab5deb4e3ec81e1c04a91af
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Wed Nov 28 13:59:18 2007 +0100
> Commit:     Linus Torvalds <torvalds@woody.linux-foundation.org>
> CommitDate: Wed Nov 28 10:58:01 2007 -0800
> 
>     vfs: coredumping fix
>     
>     fix: http://bugzilla.kernel.org/show_bug.cgi?id=3043
>     
>     only allow coredumping to the same uid that the coredumping
>     task runs under.
>     
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>     Acked-by: Alan Cox <alan@redhat.com>
>     Acked-by: Christoph Hellwig <hch@lst.de>
>     Acked-by: Al Viro <viro@ftp.linux.org.uk>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index 4ccaaa4..282240a 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1780,6 +1780,12 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
>  	   but keep the previous behaviour for now. */
>  	if (!ispipe && !S_ISREG(inode->i_mode))
>  		goto close_fail;
> +	/*
> +	 * Dont allow local users get cute and trick others to coredump
> +	 * into their pre-created files:
> +	 */
> +	if (inode->i_uid != current->fsuid)
> +		goto close_fail;
>  	if (!file->f_op)
>  		goto close_fail;
>  	if (!file->f_op->write)
> 
> 
