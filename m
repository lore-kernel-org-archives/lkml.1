Return-Path: <linux-kernel-owner+w=401wt.eu-S1759297AbZGGQjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297AbZGGQjG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:39:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757441AbZGGQiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:38:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44751 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631AbZGGQiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:38:54 -0400
Date: Tue, 7 Jul 2009 18:35:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       earl_chew@agilent.com, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org
Subject: Re: [PATCH 3/3] exec: Allow do_coredump to wait for user space
	pipe readers to complete (v8)
Message-ID: <20090707163516.GA17935@redhat.com>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090703104447.GA19371@hmsreliant.think-freely.org> <20090703105233.GD19371@hmsreliant.think-freely.org> <20090707161933.GF28326@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090707161933.GF28326@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07, Neil Horman wrote:
>
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
> > +	while ((pipe->readers > 1) && (!signal_pending(current))) {
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
> > +
> > +
> >  void do_coredump(long signr, int exit_code, struct pt_regs *regs)
> >  {
> >  	struct core_state core_state;
> > @@ -1862,6 +1886,8 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
> >  		current->signal->group_exit_code |= 0x80;
> >
> >  close_fail:
> > +	if (ispipe && core_pipe_limit)
> > +		wait_for_dump_helpers(file);

Looks good to me.


As for "&& core_pipe_limit" here, I agree this is subjective and I see
your point.

Oleg.

