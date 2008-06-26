Return-Path: <linux-kernel-owner+w=401wt.eu-S1752810AbYFZMVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbYFZMVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYFZMVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:21:16 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:55876 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750830AbYFZMVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:21:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmIDAMwmY0h5LG+uZWdsb2JhbACSYBICHp9T
X-IronPort-AV: E=Sophos;i="4.27,708,1204464600"; 
   d="scan'208";a="135838271"
Date: Thu, 26 Jun 2008 22:21:12 +1000
From: Dave Chinner <david@fromorbit.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] Extend completions to provide XFS object flush
	requirements
Message-ID: <20080626122112.GL11558@disturbed>
Mail-Followup-To: Matthew Wilcox <matthew@wil.cx>, xfs@oss.sgi.com,
	linux-kernel@vger.kernel.org
References: <1214455277-6387-1-git-send-email-david@fromorbit.com> <1214455277-6387-2-git-send-email-david@fromorbit.com> <20080626112612.GW4392@parisc-linux.org> <20080626113209.GK11558@disturbed> <20080626114242.GX4392@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080626114242.GX4392@parisc-linux.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 05:42:42AM -0600, Matthew Wilcox wrote:
> On Thu, Jun 26, 2008 at 09:32:09PM +1000, Dave Chinner wrote:
> > On Thu, Jun 26, 2008 at 05:26:12AM -0600, Matthew Wilcox wrote:
> > > On Thu, Jun 26, 2008 at 02:41:12PM +1000, Dave Chinner wrote:
> > > > XFS object flushing doesn't quite match existing completion semantics.  It
> > > > mixed exclusive access with completion. That is, we need to mark an object as
> > > > being flushed before flushing it to disk, and then block any other attempt to
> > > > flush it until the completion occurs.
> > > 
> > > This sounds like mutex semantics.  Why are the existing mutexes not
> > > appropriate for your needs?
> > 
> > Different threads doing wait and complete.
> 
> Then let's leave it as a semaphore.  You can get rid of the sema_t if
> you like, but I don't think that turning completions into semaphores is
> a good idea (because it's confusing).

So remind me what the point of the semaphore removal tree is again?

As Christoph suggested, I can put this under another API that
is implemented using completions. If I have to do that in XFS,
so be it....

The main reason for this that we've just uncovered the fact that the
way XFS uses semaphores is completely unsafe [*] on x86/x86_64 for
kernels prior to the new generic semaphores.

[*] 2.6.20 panics in up() because of this race when I/O completion
(the up call) races with a simultaneous down() (iowaiter):

	T1		T2
	up()		down()
			kmem_free()

When the down() call completes, the up() call can still be
referencing the semaphore, and hence if we free the structure after
the down call then the up() will reference freed memory.  This is
probably the cause of many unexplained log replay or unmount panics
that we've been hitting for years with buffers that been freed while
apparently still in use....

Hence I'd prefer just to move completely away from semaphores for
this flush interface.  I'd like to start with getting the upstream
code fixed in a sane manner so all the backports to older kernels
start from the same series of commits.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
