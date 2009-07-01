Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbZGAOMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbZGAOMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 10:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbZGAOMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 10:12:33 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33670 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbZGAOMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 10:12:33 -0400
Date: Wed, 1 Jul 2009 10:12:20 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       earl_chew@agilent.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 3/3] exec: Allow do_coredump to wait for user space
	pipe readers to complete (v4)
Message-ID: <20090701141220.GC29601@hmsreliant.think-freely.org>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090630173836.GA15612@hmsreliant.think-freely.org> <20090630174634.GD15612@hmsreliant.think-freely.org> <20090701055151.GB26877@redhat.com> <20090701103109.GA29601@hmsreliant.think-freely.org> <20090701122533.GA11411@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701122533.GA11411@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 02:25:33PM +0200, Oleg Nesterov wrote:
> On 07/01, Neil Horman wrote:
> >
> > On Wed, Jul 01, 2009 at 07:52:57AM +0200, Oleg Nesterov wrote:
> > > > This extra count is reclaimed in
> > > > +		 * wait_for_dump_helpers
> > > > +		 */
> > > > +		pipe = file->f_path.dentry->d_inode->i_pipe;
> > > > +		pipe_lock(pipe);
> > > > +		pipe->readers++;
> > > > +		pipe_unlock(pipe);
> > >
> > > why should we inc ->readers in advance?
> > >
> > Read the comment immediately above it and look at the filp_close path.  We inc
> > ->readers in advance so as to prevent pipe_inode_info getting freed between the
> > time we write out the core file and the time we wait on the pipe.
> 
> Can't understand.
> 
> call_usermodehelper_stdinpipe() creates 2 files, both share the same
> inode/pipe_inode_info (->f_path actually).
> 
> Until we close the file returned by call_usermodehelper_pipe(),
> pipe_inode_info can't go away.
> 
> > If the
> > userspace helper exits in between those points we inode->i_pipe will be null by
> > the time we get to wait_for_dump_helpers.
> 
> See above. Can't understand how this can happen.
> 
Yes, I apologize, in reviewing that code, I don't see how it could happen
either.  I think that I must have changed to things at once and gotten erroneous
results in my testing (most likely I did the wait_for_dump_helpers after the
filp_close and that cause the race).  I'm reworking the patch now.

> > > > +	wait_for_dump_helpers(file);
> > >
> > > why do we call it unconditionally and then check ISFIFO? We only need to wait
> > > when ispipe = T, and in that case we know that this file is pipe.
> > >
> > Cosmetic, I can call it unconditionally here and then check if its a fifo in the
> > function, so that in do_coredump I don't have to do the following:
> > if (is_pipe)
> > 	wait_for_dump_helpers(file);
> 
> I think the above is better. More straightforward and clean.
> 
> > This is exactly the sort of crap your cleanups to do_coredump attemtped to
> > remove.  I thought it best not to undo that work :)
> 
> Well. I tried to remove unnecessary "if (ispipe)" checks, yes. But in that
> case we can't avoid this check. And your patch still does this check, but
> instead of simple "ispipe == T" we check
> S_ISFIFO(file->f_path.dentry->d_inode->i_mode), doesn't look as a cleanup ;)
> 
Ok, whatever, I'm not interested in debating what looks prettier, so I'll just
use the ispipe test and be done with it.

I'm testing version 5 and will post the set shortly.
Neil

