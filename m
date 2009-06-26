Return-Path: <linux-kernel-owner+w=401wt.eu-S1756953AbZFZUSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953AbZFZUSQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 16:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbZFZUSC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 16:18:02 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55714 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbZFZUSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 16:18:01 -0400
Date: Fri, 26 Jun 2009 16:17:53 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, earl_chew@agilent.com, oleg@redhat.com,
       alan@lxorguk.ukuu.org.uk, andi@firstfloor.org
Subject: Re: [PATCH 1/2] exec: Make do_coredump more robust and safer when
	using pipes in core_pattern: recursive dump detection
Message-ID: <20090626201753.GF7337@hmsreliant.think-freely.org>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090625163050.d6a71a13.akpm@linux-foundation.org> <20090626180222.GD7337@hmsreliant.think-freely.org> <20090626123723.9b6f88c2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090626123723.9b6f88c2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 12:37:23PM -0700, Andrew Morton wrote:
> On Fri, 26 Jun 2009 14:02:22 -0400
> Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> > 
> > core_pattern: Change how we detect recursive dumps with core_pattern pipes
> > 
> > Change how we detect recursive dumps.  Currently we have a mechanism by which
> > we try to compare pathnames of the crashing process to the core_pattern path.
> > This is broken for a dozen reasons, and just doesn't work in any sort of robust
> > way.  I'm replacing it with the use of a 0 RLIMIT_CORE value.  Since helper
> > apps set RLIMIT_CORE to zero, we don't write out core files for any process with
> > that particular limit set.  It the core_pattern is a pipe, any non-zero limit is
> > translated to RLIM_INFINITY.  This allows complete dumps to be captured, but
> > prevents infinite recursion in the event that the core_pattern process itself
> > crashes.
> > 
> 
> The patch appears to be against 2.6.30 or something.  I get rejects due
> to some other patch in exec.c which was added three weeks ago.  Please
> don't do that :(
> 

No, this patch is against a branch I made from the 2.6.28-rc2 tag, to which I
cleanly applied your -mm patch that I got from kernel.org.

> > 
> > 
> > exec.c |   32 +++++++++++++++++++-------------
> > 1 file changed, 19 insertions(+), 13 deletions(-)
> > 
> > diff --git a/fs/exec.c b/fs/exec.c
> > index ebe359f..163cfa7 100644
> > --- a/fs/exec.c
> > +++ b/fs/exec.c
> > @@ -1802,22 +1802,28 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
> >  		goto fail_unlock;
> >  
> >   	if (ispipe) {
> > -		helper_argv = argv_split(GFP_KERNEL, corename+1, &helper_argc);
> > -		/* Terminate the string before the first option */
> > -		delimit = strchr(corename, ' ');
> > -		if (delimit)
> > -			*delimit = '\0';
> > -		delimit = strrchr(helper_argv[0], '/');
> > -		if (delimit)
> > -			delimit++;
> > -		else
> > -			delimit = helper_argv[0];
> > -		if (!strcmp(delimit, current->comm)) {
> > -			printk(KERN_NOTICE "Recursive core dump detected, "
> > -					"aborting\n");
> > +		if (core_limit == 0) {
> > +			 /*
> > +			 * Normally core limits are irrelevant to pipes, since
> > +			 * we're not writing to the file system, but we use
> > +			 * core_limit of 0 here as a speacial value. Any
> > +			 * non-zero limit gets set to RLIM_INFINITY below, but
> > +			 * a limit of 0 skips the dump.  This is a consistent
> > +			 * way to catch recursive crashes.  We can still crash
> > +			 * if the core_pattern binary sets RLIM_CORE =  !0
> > +			 * but it runs as root, and can do lots of stupid things
> > +			 * Note that we use task_tgid_vnr here to grab the pid of the
> > +			 * process group leader.  That way we get the right pid if a thread
> > +			 * in a multi-threaded core_pattern process dies.
> > +			 */
> > +			printk(KERN_WARNING "Process %d(%s) has RLIMIT_CORE set to 0\n",
> > +			       task_tgid_vnr(current), current->comm);
> > +			printk(KERN_WARNING "Aborting core\n");
> >  			goto fail_unlock;
> >  		}
> 
> A few cosmetic things:
> 
> - The asterisks don't line up in the comment block.  Normally we'll do
> 
> 	/*
> 	 *
> 	 *
> 
>   rather than
> 
> 	/*
> 	*
> 	*
> 
I'll fix that

> - The comment overflows 80 columns and makes a mess.
> 
> - Would it not be neater to do this check in a separate function? 
>   Then the comment block can go above the function rather than being
>   all scrunched to the right and do_coredump() (which is already >150
>   lines) just gets
> 
> 	if (ispipe) {
> +		if (core_limit_is_zero())
> +			goto fail_unlock;
Yeah, I can do that.
Neil

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
