Return-Path: <linux-kernel-owner+w=401wt.eu-S1753227AbZA1DRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbZA1DRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 22:17:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbZA1DRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 22:17:17 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44922 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbZA1DRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 22:17:16 -0500
Date: Wed, 28 Jan 2009 04:14:39 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, hch@infradead.org, corbet@lwn.net,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       linux-api@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH, RFC] Remove fasync() BKL usage, take 3325
Message-ID: <20090128031439.GA11025@redhat.com>
References: <20090115153211.663df310@bike.lwn.net> <20090122065104.2787df2d.akpm@linux-foundation.org> <20090122203248.GA20159@infradead.org> <20090123045646.GK15750@one.firstfloor.org> <20090127165504.53ed7a2d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090127165504.53ed7a2d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27, Andrew Morton wrote:
>
> On Fri, 23 Jan 2009 05:56:46 +0100
> Andi Kleen <andi@firstfloor.org> wrote:
>
> > On Thu, Jan 22, 2009 at 03:32:49PM -0500, Christoph Hellwig wrote:
> > > On Thu, Jan 22, 2009 at 06:51:04AM -0800, Andrew Morton wrote:
> > > > OK, replacing a lock_kernel() with a spin_lock(&global_lock) is pretty
> > > > straightforwad.  But it's really really sad.  It basically leaves a great
> > > > big FIXME in there.  It'd be better to fix it.
> > >
> > >
> > > Umm, we've been discussiong this in and out a guestimated million times.
> > >
> > > Let's go forward with Jon's patch which is on obvious improvement and
> > > if it shows problems later on we can revisit it.
> >
> > The point was that we already have a better patch from Oleg.
> >
>
> Where is this patch?

I didn't send the actual patch. The idea is,

	can't we use O_LOCK_FLAGS bit? I agree, it is a bit ugly,
	and I won't insist if you don't like is.

		static inline int try_lock_f_flags(struct file *file)
		{
			return !test_and_set_bit(O_LOCK_FLAGS, file->f_flags);
		}

		static inline set_f_flags(struct file *file, unsigned int flags)
		{
			file->f_flags = flags & ~O_LOCK_FLAGS;
		}

	Now, nobody should change ->f_flags directly (except create/open
	pathes. For example, ioctl_fionbio() should be changed:

			if (try_lock_f_flags(filp)) {
				if (on)
					set_f_flags(filp, filp->f_flags | flag);
				else
					set_f_flags(filp, filp->f_flags & ~flag);
			}

	If try_lock_f_flags() fails we do nothing, as if the current owner of
	O_LOCK_FLAGS changes ->f_flags after us.

and, from another message,

	No need to disable preemption, we never spin waiting for the
	lock bit. If it is locked - somebody else updates ->f_flags,
	we can pretend it does this after us. This can confuse F_GETFL
	after F_SETFL (if F_SETFL "fails"), but I think in that case
	user-space is wrong anyway, it must not do F_GETFL in parallel.

I'll try to make the patch tomorrow, but the problem is that I am not
sure this is not too ugly. At least Jonathan dislikes this approach,
and I do understand him ;)

Oleg.

