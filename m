Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab0BANQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 08:16:43 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60570 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab0BANQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 08:16:42 -0500
Date: Mon, 1 Feb 2010 08:16:27 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jmoskovc@redhat.com, mingo@redhat.com, drbd-dev@lists.linbit.com,
       benh@kernel.crashing.org, t.sailer@alumni.ethz.ch, abelay@mit.edu,
       gregkh@suse.de, spock@gentoo.org, viro@zeniv.linux.org.uk,
       neilb@suse.de, mfasheh@suse.com, menage@google.com,
       shemminger@linux-foundation.org, takedakn@nttdata.co.jp
Subject: Re: [PATCH 2/2] exec: allow core_pipe recursion check to look for a
 value of 1 rather than 0 (v2)
Message-ID: <20100201131627.GE25094@hmsreliant.think-freely.org>
References: <20100121200806.GA29801@shamino.rdu.redhat.com>
 <20100129151024.GA19249@hmsreliant.think-freely.org>
 <20100129151458.GC19249@hmsreliant.think-freely.org>
 <20100131155000.GB13402@redhat.com>
 <20100131160030.GB1950@localhost.localdomain>
 <20100201102936.GA31611@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100201102936.GA31611@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -4.1 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 11:29:36AM +0100, Oleg Nesterov wrote:
> On 01/31, Neil Horman wrote:
> >
> > On Sun, Jan 31, 2010 at 04:50:01PM +0100, Oleg Nesterov wrote:
> > > On 01/29, Neil Horman wrote:
> > > >
> > > >  void do_coredump(long signr, int exit_code, struct pt_regs *regs)
> > > >  {
> > > > ...
> > > > -		if (call_usermodehelper_pipe(helper_argv[0], helper_argv, NULL,
> > > > -				&cprm.file)) {
> > > > +		cprm.file = NULL;
> > >
> > > it is already NULL,
> > >
> > Are we sure, it was declared on the stack.
> 
> it must be NULL, or compiler is buggy. it was declared as "= { ... }".
> 
> > I think its safer to ensure that its
> > NULL.
> 
> OK, agreed. I mentioned this just in case.
> 
> > > > +		if (call_usermodehelper_fns(helper_argv[0], helper_argv, NULL,
> > > > +					    UMH_WAIT_EXEC, umh_pipe_setup,
> > > > +					    NULL, &cprm)) {
> > > > +			if (cprm.file)
> > > > +				filp_close(cprm.file, NULL);
> > >
> > > Hmm. Looks like this change fixes the bug by accident.
> > >
> > > Before this patch, I think we leak info->stdin if kernel_thread() fails
> > > in __call_usermodehelper() pathes.
> > >
> > I think we did that in call_usermodehelper_pipe.
> 
> Afaics, no. Well yes, call_usermodehelper_pipe() closes write_pipe,
> but I meant nobody closes read_pipe, info->stdin, if we fail before
> ____call_usermodehelper() is called.
> 
> > > Completely off-topic, but I think __call_usermodehelper(UMH_NO_WAIT) is
> > > buggy. if kernel_thread() failes it should do call_usermodehelper_freeinfo().
> > > Also, UMH_WAIT_EXEC should set ->retval in this case.
> > >
> > I went down that path last time I changed this code, Andrew and I decided that
> > yes it was buggy, but someone (can't recall how) smacked me around a bit and
> > explained how it worked (some odd artifact behavior of the scheduler).  Its in
> > the lkml archives if you want to get the whole story.
> 
> Hmm. I strongly believe this is buggy, and the scheduler can't help in any
> way. Fortunately, kernel_thread() must "never" fail...
> 
> Oh. And in theory, it is better to change wait_for_helper(). It should
> do allow_signal(SIGCHLD) after kernel_thread(). Otherwise, kernel_thread()
> can fail if user-space sends SIGCHLD to the forking thread.
> 

Commit 95e0d86badc410d525ea7218fd32df7bfbf9c837 has the discussion from the
previous time that I messed with this code.  Not sure how closely it relates,
but...

Neil

> 
