Return-Path: <linux-kernel-owner+w=401wt.eu-S1757294AbYEGBVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294AbYEGBVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 21:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbYEGBUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 21:20:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37745 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753307AbYEGBUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 21:20:51 -0400
Date: Tue, 6 May 2008 18:20:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: benh@kernel.crashing.org
Cc: David Miller <davem@davemloft.net>, tony@bakeyournoodle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Silence 'ignoring return value' warnings in
 drivers/video/aty/radeon_base.c
Message-Id: <20080506182006.4b4a3968.akpm@linux-foundation.org>
In-Reply-To: <1210121683.21644.194.camel@pasglop>
References: <20080424043400.GS20457@bakeyournoodle.com>
	<20080506143936.6357e578.akpm@linux-foundation.org>
	<20080506.144301.233784820.davem@davemloft.net>
	<1210121683.21644.194.camel@pasglop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 May 2008 10:54:43 +1000 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> 
> On Tue, 2008-05-06 at 14:43 -0700, David Miller wrote:
> > > So I rewrote the title to "drivers/video/aty/radeon_base.c: notify
> > user if
> > > sysfs_create_bin_file() failed".
> > > 
> > > And your fix looks appropriate - if sysfs_create_bin_file() fails we
> > will now get
> > > reports of this and we can find out what kernel bug caused this to
> > happen.
> > 
> > The last time someone "fixed" this warning in the radeon driver,
> > people lost their consoles.
> > 
> > Just giving a heads up...
> 
> I asked Tony to only warn. I still don't like it tho. As I (and paulus)
> have explained several times in the past, but I'm not going to veto the
> patch because I'm tired of that argument.
>  
> We have something like 99% of users of sysfs_create_file not supposed to
> fail right ?
> 
> So what we are effectively doing is adding -hundreds- of printk's all
> over the place (bloat bloat bloat) while instead we could have warned
> inside sysfs_create_file itself, and provided a __sysfs_create_file or
> sysfs_create_file_nowarn, or whatever you want to call it for the
> handful of users that actually want to explicitely deal with failures.
> 
> And it's the same for a whole bunch of those must check things. We are
> just adding bloat often for nothing useful.

You said "not useful".  But you're just wrong.

Look at the history of this.  A couple of years ago we were seeing a huge
number of mysterious crashes and warnings in and around sysfs and driver
code and we just didn't have a clue what was causing it, because those
crashes were happening long, long after the buggy code had done its work.

So I went in there and found a tremendous amount of code in driver core,
sysfs and in callers of both which was just ignoring error returns and
blundering on.

It was a comnplete undebuggable unmaintainable mess.  And the reason why it
was undebuggable was because the code was failing to detect errors *when
they occurred*.  So we (me, Cornelia, Greg, others) set about fixing all of
that.  And to support that effort we marked all the things which should be
checked with __must_check.

Now you come along and cherrypick a few callsites where you'd rather not
bother checking and assert that the entire effort was wrong-headed.  Well
sorry, no, it wasn't.  Sure, there's a little bit of undesirable fallout
but the whole thing had.  to.  be.  done.

> In some case, even harmful
> as we prevent entire modules from initializing due to what is often just
> a minor failure.

There is no such thing as a "minor failure".  Code either works as
designed or it doesn't.  If it doesn't work as designed then we cannot
state how serious the problem is until we've understood its causes.

If you have sysfs files which aren't needed then remove the damn things. 
If they _are_ needed then they should be available to all users of the
driver.
