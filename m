Return-Path: <linux-kernel-owner+w=401wt.eu-S1752766AbYKNEww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbYKNEww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 23:52:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbYKNEwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 23:52:41 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:48803 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbYKNEwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 23:52:40 -0500
Date: Fri, 14 Nov 2008 10:21:35 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, jkenisto@us.ibm.com,
       davem@davemloft.net, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org, systemtap@sources.redhat.com
Subject: Re: [PATCH 4/7] kprobes: Support probing module __exit function
Message-ID: <20081114045135.GA3141@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <4919F19A.9050904@redhat.com> <20081113162739.5e871fab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081113162739.5e871fab.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 04:27:39PM -0800, Andrew Morton wrote:
> On Tue, 11 Nov 2008 15:56:58 -0500
> Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
> > @@ -69,9 +69,6 @@ struct kprobe {
> >  	/* list of kprobes for multi-handler support */
> >  	struct list_head list;
> > 
> > -	/* Indicates that the corresponding module has been ref counted */
> > -	unsigned int mod_refcounted;
> > -
> >  	/*count the number of times this probe was temporarily disarmed */
> >  	unsigned long nmissed;
> > 
> > @@ -103,8 +100,19 @@ struct kprobe {
> > 
> >  	/* copy of the original instruction */
> >  	struct arch_specific_insn ainsn;
> > +
> > +	/* Indicates various status flags */
> > +	u32 flags;
> >  };
> > 
> > +/* Kprobe status flags */
> > +#define KPROBE_FLAG_GONE	1 /* breakpoint has already gone */
> > +
> > +static inline int kprobe_gone(struct kprobe *p)
> > +{
> > +	return p->flags & KPROBE_FLAG_GONE;
> > +}
> 
> If we're not going to use atomic bitops on kprobe.flags then
> modifications to that member will require that the caller hold a lock. 
> The comment above that member should describe its locking protocol.  It
> seems that it is kprobe_mutex, so...
> 
> --- a/include/linux/kprobes.h~kprobes-support-probing-module-__exit-function-fix
> +++ a/include/linux/kprobes.h
> @@ -101,7 +101,7 @@ struct kprobe {
>  	/* copy of the original instruction */
>  	struct arch_specific_insn ainsn;
> 
> -	/* Indicates various status flags */
> +	/* Indicates various status flags.  Protected by kprobe_mutex. */
>  	u32 flags;
>  };
> 
> _
> 
> 
> yes?

Right, setting and resetting is done under the kprobe_mutex.

Ananth
