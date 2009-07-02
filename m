Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbZGBK3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbZGBK3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 06:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbZGBK3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 06:29:42 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59961 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbZGBK3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 06:29:41 -0400
Date: Thu, 2 Jul 2009 06:29:36 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       andi@firstfloor.org, akpm@linux-foundation.org, earl_chew@agilent.com,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 3/3] exec: Allow do_coredump to wait for user space
	pipe readers to complete (v6)
Message-ID: <20090702102936.GA8028@hmsreliant.think-freely.org>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090701182834.GC31414@hmsreliant.think-freely.org> <20090701183707.GF31414@hmsreliant.think-freely.org> <20090702082854.GA15003@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090702082854.GA15003@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02, 2009 at 10:29:14AM +0200, Oleg Nesterov wrote:
> (add Roland)
> 
> Neil, I guess we both are tired of this thread, but I still have questions ;)
> 
> On 07/01, Neil Horman wrote:
> >
> > +static void wait_for_dump_helpers(struct file *file)
> > +{
> > +	struct pipe_inode_info *pipe;
> > +
> > +	pipe = file->f_path.dentry->d_inode->i_pipe;
> > +
> > +	pipe_lock(pipe);
> > +	pipe->readers++;
> > +	pipe->writers--;
> > +
> > +	while (pipe->readers > 1) {
> > +		wake_up_interruptible_sync(&pipe->wait);
> > +		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
> > +		pipe_wait(pipe);
> > +	}
> > +
> > +	pipe->readers--;
> > +	pipe->writers++;
> > +	pipe_unlock(pipe);
> > +
> > +}
> 
> OK, I think this is simple enough and should work.
> 
> This is not exactly correct wrt signals, if we get TIF_SIGPENDING this
> becomes a busy-wait loop.
> 
> I'd suggest to do while (->readers && !signal_pending()), this is not
> exactly right too because we have other problems with signals, but
> this is another story.
> 
> >  void do_coredump(long signr, int exit_code, struct pt_regs *regs)
> >  {
> >  	struct core_state core_state;
> > @@ -1862,6 +1886,8 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
> >  		current->signal->group_exit_code |= 0x80;
> >
> >  close_fail:
> > +	if (ispipe && core_pipe_limit)
> > +		wait_for_dump_helpers(file);
> 
> Oh. I thought I misread the first version, but now I see I got it right.
> And now I confused again.
> 
> So, we only wait if core_pipe_limit != 0. Why?
> 
> The previous version, v4, called wait_for_dump_helpers() unconditionally.
> And this looks more right to me. Once again, even without wait_for_dump()
> the coredumping process can't be reaped until core_pattern app reads all
> data from the pipe.
> 
> I won't insist. However, anybody else please take a look?
> 
> core_pipe_limit != 0 limits the number of coredump-via-pipe in flight, OK.
> 
> But, should wait_for_dump_helpers() depend on core_limit_pipe != 0?
> 
I messed this up in v4 and am fixing it here.  If you read the documentation I
added in patch 2, you can see that my intent with the core_pipe_limit sysctl was
to designate 0 as a special value allowing unlimited parallel core_dumps in
which we do not wait for any user space process completion (so that current
system behavior can be maintained, which I think is desireable for those user
space helpers who don't need access to a crashing processes meta data via proc.
If you look above in the second patch where we do an atomic_inc_return, you'll
see that we only honor the core_pipe_limit value if its non-zero.  This addional
check restores the behavior I documented in that patch.

Neil

> Oleg.
> 
> 
