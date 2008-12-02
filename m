Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbYLBMbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbYLBMbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 07:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbYLBMbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 07:31:09 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57255 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbYLBMbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 07:31:08 -0500
Date: Tue, 2 Dec 2008 13:29:39 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Andi Kleen <ak@linux.intel.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: BUG? "Call fasync() functions without the BKL" is racy
Message-ID: <20081202122939.GA3619@redhat.com>
References: <20081128192508.GA21369@redhat.com> <4933CBB0.2060003@linux.intel.com> <20081201191555.GA21385@redhat.com> <20081201123405.51d20d84@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081201123405.51d20d84@bike.lwn.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01, Jonathan Corbet wrote:
>
> On Mon, 1 Dec 2008 20:15:55 +0100
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > > Hmm, about checking for this case and retrying?
> > >
> > > Or put a fasync mutex into files_struct.  
> >
> > Perhaps, we can add O_LOCK_FLAGS, then something like
> >
> > 	--- a/fs/fcntl.c
> > 	+++ b/fs/fcntl.c
> > 	@@ -175,6 +175,15 @@ static int setfl(int fd, struct file * f
> > 		if (error)
> > 			return error;
> >
> > 	+	spin_lock(&current->files->file_lock);
> > 	+	if (!(filp->f_flags & O_LOCK_FLAGS))
> > 	+		filp->f_flags |= O_LOCK_FLAGS;
> > 	+	else
> > 	+		error = -EAGAIN;
> > 	+	spin_unlock(&current->files->file_lock);
> > 	+	if (error) /* pretend ->f_flags was changed after us
> > */
> > 	+		return 0;
> > 	+
>
> This strikes me as overkill.

and doesn't really help. fork() clones files_struct, we can't rely
on ->file_lock. And we have fd passing.

> What we really want to do is to protect
> against concurrent access to f_flags - something which could come about
> in a couple of other situations (nfsd/vfs.c tweaks it, for example).
> We *could* just extend files_lock to cover f_flags too, but that comes
> at the cost of making ->fasync() atomic when it never has been before -
> doesn't seem like a good idea.
>
> Perhaps we just need a single f_flags_mutex?  For code changing
> f_flags only (it woudn't be needed to query the flags)? Then
> ioctl_fionbio() and ioctl_fioasync() could use it too. It's hard to
> imagine that there's enough contention to warrant any more than that,
> especially given that it all (except ioctl_fionbio()) has been under
> the BKL until now.

A bit ugly to use the global mutex to protect all ->f_flags, but yes,
I agree. Imho this is 2.6.28 material, we need the simple fix or the
user can crash the kernel.

Still I'd like to see the better fix for the long term, the only (afaics)
flag with the "side effect" is FASYNC, perhaps we can move it to (say)
->f_mode, but this is ugly of course and still need serialization for the
pathes which play with FASYNC.

Otherwise, any code which changes ->f_flags can clear FASYNC if we race
with sys_fcntl(F_SETFL, FASYNC).

If we introduce the new lock, we should change for example tty_io.c:fionbio(),
tty has the ->fasync() method. Currently tty_io.c relies on lock_kernel().

Oleg.

