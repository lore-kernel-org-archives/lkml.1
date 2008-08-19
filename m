Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbYHSJlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbYHSJlq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 05:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbYHSJli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 05:41:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38372 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751260AbYHSJlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 05:41:37 -0400
Date: Tue, 19 Aug 2008 02:41:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATH -mm] Fix a race condtion of oops_in_progress
Message-Id: <20080819024129.e0c48ff8.akpm@linux-foundation.org>
In-Reply-To: <20080818224643.865da7a3.akpm@linux-foundation.org>
References: <1219025007.5663.22.camel@yhuang-dev.sh.intel.com>
	<20080818210657.c7f3cd87.akpm@linux-foundation.org>
	<1219124280.5663.88.camel@yhuang-dev.sh.intel.com>
	<20080818224643.865da7a3.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2008 22:46:43 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 19 Aug 2008 13:38:00 +0800 Huang Ying <ying.huang@intel.com> wrote:
> 
> > On Mon, 2008-08-18 at 21:06 -0700, Andrew Morton wrote:
> > > On Mon, 18 Aug 2008 10:03:27 +0800 Huang Ying <ying.huang@intel.com> wrote:
> > > 
> > > > This patch fix a race condition of oops_in_progress. Which may be
> > > > changed on multiple CPU simultaneously, but it is changed via
> > > > non-atomic operation ++/--. This patch changes the definition of
> > > > oops_in_process from int to atomic_t, and accessing method to atomic
> > > > operations.
> > > 
> > > 
> > > > extern atomic_t oops_in_progress;
> > > 
> > > In file included from include/asm/system.h:10,
> > >                  from include/asm/processor.h:17,
> > >                  from include/asm/atomic_32.h:5,
> > >                  from include/asm/atomic.h:2,
> > >                  from include/linux/crypto.h:20,
> > >                  from arch/x86/kernel/asm-offsets_32.c:7,
> > >                  from arch/x86/kernel/asm-offsets.c:2:
> > > include/linux/kernel.h:236: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'oops_in_progress'
> > > make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
> > > make: *** [prepare0] Error 2
> > > 
> > > we can't inlude asm/atomic.h from linux/kernel.h because asm/atomic.h
> > > includes linux/kernel.h via the above route.
> > > 
> > > And we cannot forward-declare atomic_t by hand because it's a typedef.
> > > 
> > > Not sure what to do, really.  Find a different header file in which to
> > > declare oops_in_progress?
> > 
> > It seems that asm/atomic.h is used for both atomic_t declaration and
> > implementation, how about separate them? That it, add a new file
> > asm/atomic_def.h, put typedef there, and include asm/atomic_def.h in
> > kernel.h?
> 
> yup, that sounds sensible.

otoh, it means altering every architectures's atomic.h.

Finding a different header file for the oops_in_progress declaration
might be more practical.

Or we could just do nothing.  How realistic is this race?


umm, how about making it a function?

static atomic_t oops_in_progress = ATOMIC_INIT(0);

int oops_is_in_progress(void)
{
	return atomic_read(&oops_in_progress);
}

int oops_in_progress_inc(void)
{
	atomic_inc(&oops_in_progress);
}

then just open-code the atomic_inc and atomic_dec in
lib/bust_spinlocks.c and call oops_in_progress_inc() from
debug_locks_off().

Or whatever.  Doing it via a function call API means that we don't need
to declare that atomic_t globally.
