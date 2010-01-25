Return-Path: <linux-kernel-owner+w=401wt.eu-S1753123Ab0AYJ0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab0AYJ0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 04:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085Ab0AYJ0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 04:26:42 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33084 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab0AYJ0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 04:26:41 -0500
Subject: Re: futex() on vdso makes process unkillable
From: Peter Zijlstra <peterz@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mark Seaborn <mrs@mythic-beasts.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Darren Hart <dvhltc@us.ibm.com>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>
In-Reply-To: <20100125162733.BDB8.A69D9226@jp.fujitsu.com>
References: <20100124.000458.506212773266927716.mrs@deli>
	 <20100125120459.4944.A69D9226@jp.fujitsu.com>
	 <20100125162733.BDB8.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jan 2010 10:26:14 +0100
Message-ID: <1264411574.4283.1632.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-25 at 16:27 +0900, KOSAKI Motohiro wrote:
> Hi
> 
> > CC to futex folks.
> > 
> > > I was experimenting with futexes and was a little surprised to
> > > discover that futex() works on read-only pages.  This creates quite a
> > > high bandwidth side channel that allows two processes to communicate
> > > if, for example, they share a library.  (Mind you, this is not much
> > > different from file locks, which also work on read-only file
> > > descriptors.)
> > > 
> > > I also found a couple of differences between 2.6.24 (from Ubuntu
> > > hardy) and 2.6.31 (from Ubuntu karmic).  The first is a definite bug
> > > in 2.6.31:
> > > 
> > > 1) On 2.6.31 i686, using futex() on the vdso causes the process to get
> > > stuck, consuming CPU in an unkillable state.  Both FUTEX_WAIT and
> > > FUTEX_WAKE cause the problem.  The problem doesn't occur on 2.6.24.
> > > (BTW, I was testing to see whether futex() on the vdso allows any two
> > > processes to communicate.  This appears not to be the case on 2.6.24.)
> > > 
> > > A test program is below.
> > > 
> > > 
> > > 2) Suppose a file is mapped into two processes with MAP_PRIVATE.  Can
> > > the resulting mappings be used to communicate via futex()?  i.e. Does
> > > futex() consider the mappings to be the same?
> > > 
> > > On 2.6.24, the futex wakeup is not transferred; pages must be mapped
> > > with MAP_SHARED for futex to work.  On 2.6.31, the futex wakeup *is*
> > > transferred; futex works with either MAP_SHARED or MAP_PRIVATE.
> > > 
> > > 2.6.24's behaviour seems more correct, because the mappings are
> > > logically different, even if the underlying memory pages are the same
> > > before copy-on-write is triggered.  Is 2.6.31's behaviour a
> > > regression, or is the kernel's behaviour here supposed to be
> > > undefined?
> 
> Futex should work both file anon anon. however I personally think 
> vdso is not file nor anon. it is special mappings. nobody defined
> futex spec on special mappings. (yes, undefined).
> 
> Personally, I think EINVAL or EFAULT are best result of vdso futexing, like as
> futexing againt kernel address. but I guess another person have another thinking.
> 
> I'd like to hear futex folks's opinion.

Well, my opinion is we should remove the vdso, its ugly as hell :-)

But I think it would make most sense to extend its definition in the
direction of it being a file (for all intents and purposes its a special
DSO -- which unfortunately isn't present in any filesystem).

[ For all intents and purposes processes can already communicate through
futexes on the libc space, so being able to do so through the vsdo
really doesn't add anything ]

So the problem is that the VDSO pages do not have a page->mapping
because they lack the actual filesystem part of files, so even if (with
the recent zero-page patch from Kosaki-san) you make private COWs of the
VDSO, you'll get stuck in that loop.

So the prettiest solution is to simply place the vdso in an actual
filesystem and slowly migrate towards letting userspace map it as a
regular DSO -- /sys/lib{32,64}/libkernel.so like.

[ that has the bonus of getting rid of install_special_mapping() ]

The ugly solution is special casing the vdso in get_futex_key().

