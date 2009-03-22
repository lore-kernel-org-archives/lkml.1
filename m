Return-Path: <linux-kernel-owner+w=401wt.eu-S1754620AbZCVLoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbZCVLoi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 07:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbZCVLo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 07:44:28 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:48902 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045AbZCVLo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 07:44:28 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18886.9364.699476.946164@cargo.ozlabs.ibm.com>
Date: Sun, 22 Mar 2009 22:44:20 +1100
From: Paul Mackerras <paulus@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] perfcounters: record time running and time enabled
 for each counter
In-Reply-To: <20090322015559.818961b6.akpm@linux-foundation.org>
References: <18884.55232.197620.696687@cargo.ozlabs.ibm.com>
	<20090321055252.eb0673ea.akpm@linux-foundation.org>
	<18885.29855.433194.463455@cargo.ozlabs.ibm.com>
	<20090322015559.818961b6.akpm@linux-foundation.org>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:

> > > > -	return put_user(cntval, (u64 __user *) buf) ? -EFAULT : sizeof(cntval);
> > > > +	if (count != n * sizeof(u64))
> > > > +		return -EINVAL;
> > > > +
> > > > +	if (!access_ok(VERIFY_WRITE, buf, count))
> > > > +		return -EFAULT;
> > > > +	
> > > 
> > > <panics>
> > > 
> > > Oh.
> > > 
> > > It would be a lot more reassuring to verify `uptr', rather than `buf' here.
> 
> This?
> 
> > > The patch adds new trailing whitespace.  checkpatch helps.
> > > 
> > > > +	for (i = 0; i < n; ++i)
> > > > +		if (__put_user(values[i], uptr + i))
> > > > +			return -EFAULT;
> > > 
> > > And here we iterate across `n', whereas we verified `count'.
> > 
> > And the fact that we just verified count == n * 8, four lines above,
> > doesn't give you any comfort?
> 
> 	access_ok(..., uptr, n * sizeof(*uptr))
> 
> might be most robust.

I'm not sure quite what you're getting at.  Are you saying

(a) you think there is an actual security problem in that code
(b) you can't tell if there is a problem in that code, or
(c) you think there isn't a problem but you had to spend too much
    brain power working that out, or
(d) you think there isn't a problem but there might be in future if
    someone changed the code?

> Or fix up the types (if needed) and copy the whole thing with copy_to_user()
> 
> Is it really so performance-sensitive that we can't use plain old put_user()?

The sort of people that use performance-monitoring tools tend to be
sensitive to performance issues in their tools, for some reason. :)

Is copy_to_user on 8 bytes practically as fast as put_user, these
days?

Paul.
