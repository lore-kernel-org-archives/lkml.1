Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029Ab0A0VZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab0A0VZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 16:25:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610Ab0A0VZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 16:25:19 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57827 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab0A0VZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 16:25:18 -0500
Date: Wed, 27 Jan 2010 16:25:11 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, abelay@mit.edu,
       benh@kernel.crashing.org, drbd-dev@lists.linbit.com, gregkh@suse.de,
       jmoskovc@redhat.com, menage@google.com, mfasheh@suse.com,
       mingo@redhat.com, neilb@suse.de, shemminger@linux-foundation.org,
       spock@gentoo.org, t.sailer@alumni.ethz.ch, takedakn@nttdata.co.jp,
       viro@zeniv.linux.org.uk
Subject: Re: +
 exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather
 -than-0.patch added to -mm tree
Message-ID: <20100127212511.GB15052@hmsreliant.think-freely.org>
References: <201001262354.o0QNsBiM029772@imap1.linux-foundation.org>
 <20100127174706.GA6333@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100127174706.GA6333@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -4.0 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 06:47:06PM +0100, Oleg Nesterov wrote:
> On 01/26, Andrew Morton wrote:
> >
> > From: Neil Horman <nhorman@tuxdriver.com>
> >
> > What I've done is modify the
> > call_usermodehelper() api such that an extra parameter is added, a
> > function pointer which will be called by the user helper task, after it
> > forks, but before it execs the required process.
> 
> Personally I agree, I think this fptr can be useful, not only for coredump.
> 
> > This will give the
> > caller the opportunity to get a callback in the process's context,
> > allowing it to do whatever it needs to to the process in the kernel
> 
> in this case it probably needs "void *data" argument, otherwise the
> usage is very limited.
> 
I'd thought of that, but I wasn't sure what data would be passed that the caller
wouldn't already be able to glean.  Certainly not opposed to adding something of
that nature though.

> Currently only d_coredump() needs this new feature, but please note
> that ____call_usermodehelper() was already "uglified" for the coredumping
> over the pipe.
> 
> If we add sub_info->finit(), then probably we should move the code
> under "if (sub_info->stdin)" from ____call_usermodehelper() to
> core_pipe_setup() ?
> 
> > +/*
> > + * This is used as a helper to set up the task that execs
> > + * our user space core collector application
> > + * Its called in the context of the task thats going to
> > + * exec itself to be the helper, so we can modify current here
> > + */
> 
> very minor nit, perhaps the comment should explain what is the meaning
> of the magical rlim_cur = 1 value? It is not immediately obvious we
> check cprm.limit == 1 below.
> 
Yeah, Andrew asked me to clean up that comment as well, I'll post a follow on
patch after I tinker with the suggestions in this email and your other note as
well for a bit.

> > +void core_pipe_setup(void)
> > +{
> > +	task_lock(current->group_leader);
> > +	current->signal->rlim[RLIMIT_CORE].rlim_cur = 1;
> > +	task_unlock(current->group_leader);
> > +}
> 
> Well, this thread must be the kernel thread and thus it should be
> ->group_leader and I don't think we really need task_lock() her,
> but this is minor and perhaps ->group_leader + task_lock() look
> better even if not needed.
> 
Perhaps, I wasn't sure, I was just following the code used by the core limit
proc write patch series.

Neil

> Oleg.
> 
> 
