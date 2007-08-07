Return-Path: <linux-kernel-owner+w=401wt.eu-S934941AbXHGPMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934941AbXHGPMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 11:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758464AbXHGPMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 11:12:13 -0400
Received: from smtp121.sbc.mail.re3.yahoo.com ([66.196.96.94]:25483 "HELO
	smtp121.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757680AbXHGPMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 11:12:12 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Aug 2007 11:12:11 EDT
X-YMail-OSG: o5UckrcVM1kJbQXnxcNDAEH7Pd3Uw8__x7b1N.puZMQbZUZiVIoG7JoI_FK6aQH_iXilwa47UqaWiLc6waDk.pfSM6BxVi_h433VxQp92blBQ1wLYuX5gmbZcw0lNBwWD6GEa4hwtRi9orM-
Date: Tue, 7 Aug 2007 10:05:29 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ifdef struct task_struct::security
Message-ID: <20070807150529.GA22447@vino.hallyn.com>
References: <20070806185514.GA5842@martell.zuzino.mipt.ru> <20070806203112.GA12726@vino.hallyn.com> <20070806220833.4040f861.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070806220833.4040f861.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morton (akpm@linux-foundation.org):
> On Mon, 6 Aug 2007 15:31:12 -0500 "Serge E. Hallyn" <serge@hallyn.com> wrote:
> 
> > Quoting Alexey Dobriyan (adobriyan@gmail.com):
> > > For those who don't care about CONFIG_SECURITY.
> > 
> > I'm quite sure we started that way, but the ifdefs were considered
> > too much of an eyesore.
> 
> argh, y'all stop top-posting at me.

(Hmm, I'm replying at the point in the email I'm replying to.  Is what
I'm doing in this current email ok - i.e the one you replied to looked
like pure top-posting - or do you actually want pure bottom posting?)

> > If this is now acceptable, then the same thing might be considered
> > for inode->i_security, kern_ipc_perm.security, etc.  Getting rid of
> > just the task->security seems overly half-hearted.
> > 
> > -serge
> > 
> > > Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> > > ---
> > > 
> > >  include/linux/sched.h |    3 ++-
> > >  kernel/fork.c         |    2 ++
> > >  2 files changed, 4 insertions(+), 1 deletion(-)
> > > 
> > > --- a/include/linux/sched.h
> > > +++ b/include/linux/sched.h
> > > @@ -1086,8 +1086,9 @@ struct task_struct {
> > >  	int (*notifier)(void *priv);
> > >  	void *notifier_data;
> > >  	sigset_t *notifier_mask;
> > > -	
> > > +#ifdef CONFIG_SECURITY
> > >  	void *security;
> > > +#endif
> > >  	struct audit_context *audit_context;
> > >  	seccomp_t seccomp;
> > >  
> > > --- a/kernel/fork.c
> > > +++ b/kernel/fork.c
> > > @@ -1066,7 +1066,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
> > >  	do_posix_clock_monotonic_gettime(&p->start_time);
> > >  	p->real_start_time = p->start_time;
> > >  	monotonic_to_bootbased(&p->real_start_time);
> > > +#ifdef CONFIG_SECURITY
> > >  	p->security = NULL;
> > > +#endif
> > >  	p->io_context = NULL;
> > >  	p->io_wait = NULL;
> > >  	p->audit_context = NULL;
> > > 
> 
> I think it's OK.  Removing 4 or 8 bytes from the task_struct is a decent win,
> and an ifdef at the definition site (unavoidable) and at a single
> initialisation site where there are lots of other similar ifdefs is pretty
> minimal hurt.

Then how about making it depend on CONFIG_SECURITY_SELINUX?  It's the
only LSM actually using that field right now.  (As more come along, we
can use a hidden CONFIG_SECURITY_ATTRS or somesuch bool select'ed by
LSMs which need it)

Using CONFIG_SECURITY means that if you compile with SECURITY=n, you get
the capability module but no task->security.  If you compile with
SECURITY=y but no modules, you get the dummy module and a
task->security field!

> In fact, looking through all those "= 0" and "= NULL" statements in
> copy_process() makes one wonder whether we should be memsetting that guy to
> zero then selectively copying things out of current, rather than the
> present vice-versa.
> 
> A possibly-neat way of doing this would be to move all the task_struct fields which
> are zeroed in copy_process() into a separate anonymous struct in
> task_struct, then wipe only that in copy_process().  One would need to be
> careful about the hand-arranged grouping which has been done in the
> task_struct however.

thanks,
-serge
