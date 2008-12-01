Return-Path: <linux-kernel-owner+w=401wt.eu-S1753813AbYLATeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbYLATeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 14:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbYLATeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 14:34:09 -0500
Received: from vena.lwn.net ([206.168.112.25]:57998 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364AbYLATeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 14:34:08 -0500
Date: Mon, 1 Dec 2008 12:34:05 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: BUG? "Call fasync() functions without the BKL" is racy
Message-ID: <20081201123405.51d20d84@bike.lwn.net>
In-Reply-To: <20081201191555.GA21385@redhat.com>
References: <20081128192508.GA21369@redhat.com>
	<4933CBB0.2060003@linux.intel.com>
	<20081201191555.GA21385@redhat.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2008 20:15:55 +0100
Oleg Nesterov <oleg@redhat.com> wrote:

> > Hmm, about checking for this case and retrying?
> >
> > Or put a fasync mutex into files_struct.  
> 
> Perhaps, we can add O_LOCK_FLAGS, then something like
> 
> 	--- a/fs/fcntl.c
> 	+++ b/fs/fcntl.c
> 	@@ -175,6 +175,15 @@ static int setfl(int fd, struct file * f
> 		if (error)
> 			return error;
> 	 
> 	+	spin_lock(&current->files->file_lock);
> 	+	if (!(filp->f_flags & O_LOCK_FLAGS))
> 	+		filp->f_flags |= O_LOCK_FLAGS;
> 	+	else
> 	+		error = -EAGAIN;
> 	+	spin_unlock(&current->files->file_lock);
> 	+	if (error) /* pretend ->f_flags was changed after us
> */
> 	+		return 0;
> 	+

This strikes me as overkill.  What we really want to do is to protect
against concurrent access to f_flags - something which could come about
in a couple of other situations (nfsd/vfs.c tweaks it, for example).
We *could* just extend files_lock to cover f_flags too, but that comes
at the cost of making ->fasync() atomic when it never has been before -
doesn't seem like a good idea.

Perhaps we just need a single f_flags_mutex?  For code changing
f_flags only (it woudn't be needed to query the flags)? Then
ioctl_fionbio() and ioctl_fioasync() could use it too. It's hard to
imagine that there's enough contention to warrant any more than that,
especially given that it all (except ioctl_fionbio()) has been under
the BKL until now.

jon
