Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334AbZGAKb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbZGAKb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 06:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbZGAKbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 06:31:20 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47599 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbZGAKbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 06:31:19 -0400
Date: Wed, 1 Jul 2009 06:31:09 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       earl_chew@agilent.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 3/3] exec: Allow do_coredump to wait for user space
	pipe readers to complete (v4)
Message-ID: <20090701103109.GA29601@hmsreliant.think-freely.org>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090630173836.GA15612@hmsreliant.think-freely.org> <20090630174634.GD15612@hmsreliant.think-freely.org> <20090701055151.GB26877@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701055151.GB26877@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 07:52:57AM +0200, Oleg Nesterov wrote:
> On 06/30, Neil Horman wrote:
> >
> >  void do_coredump(long signr, int exit_code, struct pt_regs *regs)
> >  {
> >  	struct core_state core_state;
> >  	char corename[CORENAME_MAX_SIZE + 1];
> >  	struct mm_struct *mm = current->mm;
> >  	struct linux_binfmt * binfmt;
> > -	struct inode * inode;
> > -	struct file * file;
> > +	struct inode * inode = NULL;
> > +	struct file * file = NULL;
> 
> why this change?
> 
Its part of a cosmetic change, see below.

> > @@ -1824,6 +1860,17 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
> >  			       corename);
> >   			goto fail_dropcount;
> >   		}
> > +
> > +		/*
> > +		 * This lets us wait on a pipe after we close the writing
> > +		 * end.  The extra reader count prevents the pipe_inode_info
> > +		 * from getting freed.
> 
> but it can't be freed until we close file?
> 
Damn, leftover comment from a previous version, needs to be removed.

> > This extra count is reclaimed in
> > +		 * wait_for_dump_helpers
> > +		 */
> > +		pipe = file->f_path.dentry->d_inode->i_pipe;
> > +		pipe_lock(pipe);
> > +		pipe->readers++;
> > +		pipe_unlock(pipe);
> 
> why should we inc ->readers in advance?
> 
Read the comment immediately above it and look at the filp_close path.  We inc
->readers in advance so as to prevent pipe_inode_info getting freed between the
time we write out the core file and the time we wait on the pipe.  If the
userspace helper exits in between those points we inode->i_pipe will be null by
the time we get to wait_for_dump_helpers.  And a simple null check isn't
sufficient in wait_for_dump_helpers, since that still creates a window between
the check and the alternative increment of readers inside the loop, leading to a
use after free/corruption case.

> > +	wait_for_dump_helpers(file);
> 
> why do we call it unconditionally and then check ISFIFO? We only need to wait
> when ispipe = T, and in that case we know that this file is pipe.
> 
Cosmetic, I can call it unconditionally here and then check if its a fifo in the
function, so that in do_coredump I don't have to do the following:
if (is_pipe)
	wait_for_dump_helpers(file);
out_unlock:
	filp_close(...)
if (is_pipe)
	atomic_dec(&core_dump_count);
This is exactly the sort of crap your cleanups to do_coredump attemtped to
remove.  I thought it best not to undo that work :)

I also do a NULL check in wait_for_dump_helpers, so that if the helper fails to
start properly, its a fall through case.

> IOW, could you explain why the (much simpler) patch I sent doesn't work ?
> 
In short, because the much simpler patch that you sent is broken.  I in fact
tried it as is, and ran across the exact race that I described above, in which
the user space helepr exited before we waited on it, resulting in an oops when
we tried to manipulate the i_pipe pointer, which had become NULL;

> 
> Hmm. And in fact that pipe->readers++ above doesn't look right. What if
> the core_patter task exits? Since we incremented ->readers we can't notice
> the fact there are no readers, and f_op->write() will hang forever.
> 
But if we don't we can loose the inode->i_pipe pointer.  I suppose what we need
to do is increment writers immediately, then decrement writers and increment
readers after the return from ->core_dump

Neil
