Return-Path: <linux-kernel-owner+w=401wt.eu-S1757501AbZFVVVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501AbZFVVVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 17:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbZFVVU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 17:20:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751228AbZFVVU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 17:20:59 -0400
Date: Mon, 22 Jun 2009 14:20:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jon Masters <jonathan@jonmasters.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       rostedt@goodmis.org
Subject: Re: [PATCH 1/1] hwlat_detector: A system hardware latency detector
Message-Id: <20090622142014.2a1e675b.akpm@linux-foundation.org>
In-Reply-To: <1245704283.15044.28.camel@localhost.localdomain>
References: <20090611045829.714510042@jonmasters.org>
	<20090611045939.103213179@jonmasters.org>
	<20090622121736.588ae743.akpm@linux-foundation.org>
	<1245704283.15044.28.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009 16:58:03 -0400
Jon Masters <jonathan@jonmasters.org> wrote:

> 
> > We seem to be forward-declaring functions which didn't need forward
> > declarations.  This adds duplication and noise - personally I think
> > it's better to just get the functions in the correct order and only use
> > forward-decls where circularities are present.
> > 
> > A couple of struct are needlessly forward-decalred too.  etc.
> 
> Well, call me pedantic but I was always taught to do it this way for
> completeness. If that's not how we want to do it in-kernel, I'm happy
> but I'd like to know where this is spelled out (if it is) so I can go
> add that to my to-read list and get this sorted out in my head. And
> conversely, if it's not documented then I should also be fixing it.

It's not a major issue by any means.  It's just a little unusual for
kernel code.

> > > +	char buf[U64STR_SIZE];
> > > +	int csize = min(cnt, sizeof(buf));
> > > +	u64 val = 0;
> > > +	int err = 0;
> > > +
> > > +	memset(buf, '\0', sizeof(buf));
> > 
> > This is unneeded.
> 
> I disagree. I always like to explicitly initialize everything to known
> values, even if it might be done for me. In this case, I want to ensure
> there is no way the copy_from_user will give me a non-terminated buffer
> (I add an explicit NULL later too) and that it is zeroed before use. If
> this were some hot-path that mattered, it would be different, but it's a
> trivial function that's already dealing with a copy_from_user. I'm not
> fussy about changing, but just so you understand my pedantic logic.


Well.  The kernel prefers "fast, risky and well tested" over
"super-defensive".

	copy_from_user(buf, ubuf, csize)

will reliably write to buf[0] .. buf[csize-1].


But what you want here is to toss all this code out and call the
not-yet-written u64_from_user().  I think I hinted at someone about
this a few days ago..

> > > +			goto unlock;
> > > +		enabled = 1;
> > > +		__reset_stats();
> > > +		if (start_kthread())
> > > +			return -EFAULT;
> > 
> > -EFAULT seems inappropriate.
> 
> If you're unable to kick off the kernel thread, what should you return?

Propagate the kthread_run() return error code back up.

> 
> So...I'll post another update (thanks again). Am I certainly too late
> for this merge window? That's ok too.

We're generally pretty relaxed about merging updates to just-added
subsystems.  There's not much point in releasing them in a
known-to-be-unfinished form.  And if a late fix _does_ break the
driver, that still isn't strictly a regression against the previous
kernel release.

