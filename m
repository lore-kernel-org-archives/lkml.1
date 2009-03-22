Return-Path: <linux-kernel-owner+w=401wt.eu-S1754306AbZCVJDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbZCVJDc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 05:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbZCVJDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 05:03:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50632 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752677AbZCVJDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 05:03:21 -0400
Date: Sun, 22 Mar 2009 01:55:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] perfcounters: record time running and time enabled
 for each counter
Message-Id: <20090322015559.818961b6.akpm@linux-foundation.org>
In-Reply-To: <18885.29855.433194.463455@cargo.ozlabs.ibm.com>
References: <18884.55232.197620.696687@cargo.ozlabs.ibm.com>
	<20090321055252.eb0673ea.akpm@linux-foundation.org>
	<18885.29855.433194.463455@cargo.ozlabs.ibm.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Mar 2009 10:13:35 +1100 Paul Mackerras <paulus@samba.org> wrote:

> Andrew Morton writes:
> 
> > Perhaps one of the reasons why this code is confusing is the blurring
> > between the "time" at which an event occured and the "time" between the
> > occurrence of two events.  A weakness in English, I guess.  Using the term
> > "interval" in the latter case will help a lot.
> 
> Except that we aren't measuring an "interval", we're measuring the
> combined length of a whole series of intervals.  What's a good word
> for that?

foo_total_time?

It doesn't matter so much if the thing has a comment at the definition site.

> > > +	atomic64_t			child_time_enabled;
> > > +	atomic64_t			child_time_running;
> > 
> > These read like booleans, but why are they atomic64_t's?
> 
> OK so this file could use more comments, but I did answer that
> question in the patch description.
> 
> > > -	return put_user(cntval, (u64 __user *) buf) ? -EFAULT : sizeof(cntval);
> > > +	if (count != n * sizeof(u64))
> > > +		return -EINVAL;
> > > +
> > > +	if (!access_ok(VERIFY_WRITE, buf, count))
> > > +		return -EFAULT;
> > > +	
> > 
> > <panics>
> > 
> > Oh.
> > 
> > It would be a lot more reassuring to verify `uptr', rather than `buf' here.

This?

> > The patch adds new trailing whitespace.  checkpatch helps.
> > 
> > > +	for (i = 0; i < n; ++i)
> > > +		if (__put_user(values[i], uptr + i))
> > > +			return -EFAULT;
> > 
> > And here we iterate across `n', whereas we verified `count'.
> 
> And the fact that we just verified count == n * 8, four lines above,
> doesn't give you any comfort?

	access_ok(..., uptr, n * sizeof(*uptr))

might be most robust.

Or fix up the types (if needed) and copy the whole thing with copy_to_user()

Is it really so performance-sensitive that we can't use plain old put_user()?
