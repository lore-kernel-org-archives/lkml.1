Return-Path: <linux-kernel-owner+w=401wt.eu-S1762483AbZDABKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762483AbZDABKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 21:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbZDABKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 21:10:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36646 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751204AbZDABKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 21:10:04 -0400
Date: Tue, 31 Mar 2009 18:07:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] writeback: guard against jiffies wraparound on
 inode->dirtied_when checks (try #2)
Message-Id: <20090331180730.049d42e7.akpm@linux-foundation.org>
In-Reply-To: <20090331205018.228ea5f8@tleilax.poochiereds.net>
References: <1238544239-31882-1-git-send-email-jlayton@redhat.com>
	<20090331172031.b2971f1e.akpm@linux-foundation.org>
	<20090331205018.228ea5f8@tleilax.poochiereds.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 20:50:18 -0400 Jeff Layton <jlayton@redhat.com> wrote:

> On Tue, 31 Mar 2009 17:20:31 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Tue, 31 Mar 2009 20:03:59 -0400
> > Jeff Layton <jlayton@redhat.com> wrote:
> > 
> > > +		 * It's not sufficient to just do a time_after() check on
> > > +		 * dirtied_when. That assumes that dirtied_when will always
> > > +		 * change within a period of jiffies that encompasses half the
> > > +		 * machine word size (2^31 jiffies on 32-bit arch). That's not
> > > +		 * necessarily the case if an inode is being constantly
> > > +		 * redirtied. Since dirtied_when can never be in the future,
> > > +		 * we can assume that if it appears to be so then it is
> > > +		 * actually in the distant past.
> > 
> > so this really is a 32-bit-only thing.
> > 
> > I guess that isn't worth optimising for though.
> > 
> 
> Yeah, it's pretty much impossible to hit this on a 64-bit machine.
> 
> > otoh, given that all three comparisons are the same:
> > 
> > +			time_after(inode->dirtied_when, *older_than_this) &&
> > +			time_before_eq(inode->dirtied_when, jiffies))
> > 
> > (although one is inverted (i think?)), it might end up nicer if this was all done
> > in a little helper function?
> > 
> > That way we only need to comment what's going on at a single site, and
> > we could omit the additional test if !CONFIG_64BIT.
> 
> Ok, that seems reasonable.
> 
> At one point I had a macro similar to time_in_range(), but dropped it
> primarily because time_after_but_before_eq() wasn't easy on the eyes.
> Thoughts on better names?

I was thinking

	bool inode_dirtied_after(...);

and just leave the innards using time_after() and time_before_eq()?
