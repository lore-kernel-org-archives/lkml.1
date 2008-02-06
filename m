Return-Path: <linux-kernel-owner+w=401wt.eu-S1763367AbYBFXrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763367AbYBFXrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:47:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760412AbYBFXq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:46:59 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48247 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760278AbYBFXq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:46:58 -0500
Date: Wed, 6 Feb 2008 15:46:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] reduce large do_mount stack usage with noinlines
Message-Id: <20080206154617.9bb11169.akpm@linux-foundation.org>
In-Reply-To: <47AA440F.8030403@redhat.com>
References: <47AA3126.8090102@redhat.com>
	<20080206143457.03e8741d.akpm@linux-foundation.org>
	<47AA3EAA.9080204@redhat.com>
	<20080206152239.a2352d6d.akpm@linux-foundation.org>
	<47AA440F.8030403@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Feb 2008 17:34:39 -0600
Eric Sandeen <sandeen@redhat.com> wrote:

> Andrew Morton wrote:
> > On Wed, 06 Feb 2008 17:11:38 -0600
> > Eric Sandeen <sandeen@redhat.com> wrote:
> > 
> >>  /*
> >>   * recursively change the type of the mountpoint.
> >> + * noinline this do_mount helper to save do_mount stack space.
> >>   */
> >> -static int do_change_type(struct nameidata *nd, int flag)
> >> +static noinline int do_change_type(struct nameidata *nd, int flag)
> > 
> > What we could do here is defined a new noinline_because_of_stack_suckiness
> > and use that.  Reasons:
> > 
> > - self-documenting, so we don't need to comment each site
> > 
> > - can be made a no-op for suitable __GNUC__ values if gcc ever fixes this
> > 
> > - our children we can go through and delete them all when nobody is using
> >   the offending gcc versions any more.
> > 
> > what thinkest thou?
> 
> Yes, sounds very good to me.  I'm sure there are more places which could
> use this.
> 
> Or perhaps there are some magic flags to gcc so that it doesn't inline
> so aggressively in situations like this?  IOW is it gcc breakage, or
> design - but maybe with defaults that don't fit well in the limited
> stack... (well, I suppose the "for N mutually exclusive helper functions
> each with stack usage S, use about N*S stack when inlining them all" bit
> probably isn't a feature.)

The auto inlining is OK.  The problem is that when gcc handles this:

static inline foo()
{
	char a[10];
}

static inline bar()
{
	char a[10];
}

zot()
{
	foo();
	bar();
}

it will use 20 bytes of stack instead of using the same 10 bytes for both
"calls".  It doesn't need to do that, and other compilers avoid it, iirc.


Now, it _used_ to be the case that when presented with this:

foo()
{
	{
		char a[10];

		bar(a);
	}
	{
		char a[10];

		bar(a);
	}
}

gcc would also consume 20 bytes of stack.  But I see that this is fixed in
gcc-4.0.3.

These two things are equivalent and hopefully gcc will soon fix the
inlined-functions-use-too-much-stack thing.  Once that happens, we don't
need your patch.


> FWIW the XFS team finally just wrested control from GCC.
> http://oss.sgi.com/archives/xfs/2006-11/msg00195.html
> 

yup.
