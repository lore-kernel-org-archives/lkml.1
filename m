Return-Path: <linux-kernel-owner+w=401wt.eu-S1161049AbXB0Iuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161049AbXB0Iuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 03:50:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161051AbXB0Iuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 03:50:35 -0500
Received: from mail.suse.de ([195.135.220.2]:59424 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161037AbXB0Iud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 03:50:33 -0500
Date: Tue, 27 Feb 2007 09:50:25 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Airlie <airlied@gmail.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [patch 0/6] fault vs truncate/invalidate race fix
Message-ID: <20070227085025.GA2710@wotan.suse.de>
References: <20070221023656.6306.246.sendpatchset@linux.site> <21d7e9970702262036h3575229ex3bf3cd4474a57068@mail.gmail.com> <20070226213204.14f8b584.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070226213204.14f8b584.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 26, 2007 at 09:32:04PM -0800, Andrew Morton wrote:
> > On Tue, 27 Feb 2007 15:36:03 +1100 "Dave Airlie" <airlied@gmail.com> wrote:
> > >
> > > I've also got rid of the horrible populate API, and integrated nonlinear pages
> > > properly with the page fault path.
> > >
> > > Downside is that this adds one more vector through which the buffered write
> > > deadlock can occur. However this is just a very tiny one (pte being unmapped
> > > for reclaim), compared to all the other ways that deadlock can occur (unmap,
> > > reclaim, truncate, invalidate). I doubt it will be noticable. At any rate, it
> > > is better than data corruption.
> > >
> > > I hope these can get merged (at least into -mm) soon.
> > 
> > Have these been put into mm?
> 
> Not yet - I need to get back on the correct continent, review the code,
> stuff like that.  It still hurts that this work makes the write() deadlock
> harder to hit,

s/harder/easier of course...

I think there is good reason to assume the buffered write page lock
deadlocks would not occur in "normal" programs (or very very few),
because it would require writing from the same page you are writing to,
or 2 processes writing from the page the other is writing to. If any
innocent users do hit this, at least it is not data corrupting, and is
relatively easy to trace back to the kernel.

In the case of local DoS exploits, the deadlocks already present in the
buffered write path are already trivial to exploit...  locking the page
in the fault path doesn't make the deadlock exploit any more possible.

So the downside to merging is that we _may_ get some additional deadlocks.

What is being fixed is silent data corruption that has been reported by
several different users of the SLES kernel (because we have assertions
there to catch it), and can be triggered by DIO or NFS, or anything using
vmtruncate_range or invalidate_inode_pages2 on regular files. Or even a
regular truncate with nonlinear pages. These are known problems on
production workloads.

That's my argument for merging these. I think it's reasonable, but I'm
open to debate.

I did get some page fault performance numbers at one stage. Nothing
really exciting seemed to happen IIRC, but I can do another set of tests
if you want?

> and we haven't worked out how to fix that.

To be fair, I have 2 ways to fix it. Unfortunately one is slow and the
other requires cooperation from filesystem developers. perform_write() is
still on track, but it is going to take a reasonable amount of time and
effort to convert filesystems. I just can't see any gain in holding these
patches back until that all happens.

Thanks,
Nick
