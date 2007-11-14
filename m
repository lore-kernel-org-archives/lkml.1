Return-Path: <linux-kernel-owner+w=401wt.eu-S1758360AbXKNRQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360AbXKNRQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 12:16:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbXKNRQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 12:16:24 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44310 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753788AbXKNRQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 12:16:23 -0500
Date: Wed, 14 Nov 2007 09:14:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: Rik van Riel <riel@redhat.com>, arjan@infradead.org, jens.axboe@oracle.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [patch] Give kjournald a IOPRIO_CLASS_RT io priority
Message-Id: <20071114091451.d4b110db.akpm@linux-foundation.org>
In-Reply-To: <473B18BA.5000709@hp.com>
References: <20071015104647.14e60bc5@laptopd505.fenrus.org>
	<20071015114738.6b5a25c7.akpm@linux-foundation.org>
	<20071015161315.4fe18e07@bree.surriel.com>
	<20071015141236.62b075c6.akpm@linux-foundation.org>
	<473B18BA.5000709@hp.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(cc lkml restored, with permission)

On Wed, 14 Nov 2007 10:48:10 -0500 "Alan D. Brunelle" <Alan.Brunelle@hp.com> wrote:

> Andrew Morton wrote:
> > On Mon, 15 Oct 2007 16:13:15 -0400
> > Rik van Riel <riel@redhat.com> wrote:
> >
> >   
> >> Since you have been involved a lot with ext3 development,
> >> which kinds of workloads do you think will show a performance
> >> degradation with Arjan's patch?   What should I test?
> >>     
> >
> > Gee.  Expect the unexpected ;)
> >
> > One problem might be when kjournald is doing its ordered-mode data
> > writeback at the start of commit.  That writeout will now be
> > higher-priority and might impact other tasks which are doing synchronous
> > file overwrites (ie: no commits) or O_DIRECT reads or writes or just plain
> > old reads.
> >
> > If the aggregate number of seeks over the long term is the same as before
> > then of course the overall throughput should be the same, in which case the
> > impact might only be upon latency.  However if for some reason the total
> > number of seeks is increased then there will be throughput impacts as well.
> >
> > So as a starting point I guess one could set up a
> > copy-a-kernel-tree-in-a-loop running in the background and then see what
> > impact that has upon a large-linear-read, upon a
> > read-a-different-kernel-tree and upon some database-style multithreaded
> > O_DIRECT reader/overwriter.
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >   
> Hi folks -
> 
> I noticed this thread recently (sorry, month late and a dollar short), 
> but it was very interesting to me, and as I had some cycles yesterday I 
> did a quick run of what Andrew suggested here (using 2.6.24-rc2 w/out 
> and then w/ Ajran's patch). After doing the runs last night I'm not 
> overly happy with the test setup, but before redoing that, I thought I'd 
> ask to make sure that this patch was still being considered?

I'd consider its status to be "might be a good idea, more performance
testing needed".

> And, btw, the results from the first pass were rather mixed -

ooh, more performance testing.  Thanks

>     * The overwriter task (on an 8GiB file), average over 10 runs:
>           o 2.6.24 - 300.88226 seconds
>           o 2.6.24 + Arjan's patch - 403.85505 seconds
> 
>     * The read-a-different-kernel-tree task, average over 10 runs:
>           o 2.6.24 - 46.8145945549 seconds
>           o 2.6.24 + Arjan's patch - 39.6430601119 seconds
> 
>     * The large-linear-read task (on an 8GiB file), average over 10 runs:
>           o 2.6.24 - 290.32522 seconds
>           o 2.6.24 + Arjan's patch - 386.34860 seconds

These are *large* differences, making this a very signifcant patch.  Much
care is needed now.

Could you expand a bit on what you're testing here?  I think that in one
process you're doing a continuous copy-a-kernel-tree and in the other
process you're the above three things, yes?

I guess the other things we should look at are the impact on the
continuously-copy-a-kernel-tree process and also the overall IO throughput.
 These things will of course be related.  If the overall system-wide IO
throughput increases with the patch then we probably have a no-brainer.  If
(as I suspect) the overall IO throughput is decreased then this will be a
difficult call.

> This was performed on a 4-way IA64 w/ 4GiB RAM w/ a FC disk containing 
> an Ext3 (4KiB block) FS. The reason I woke up this morning and wasn't 
> too happy with the benchmarking harness is that a kernel source tree is 
> less than 1GiB and size, and thus the back ground task of reading it 
> might all fit in the page cache. To do this right, I'd use another tree 
> that has >4GiB of data stored in it. (And likewise, I'd change the 
> read-a-different-kernel-tree task to use a larger tree as well.)

hm, yes.  Back in the days when I used to do useful things I'd do most
testing of this sort on 256MB, 128MB or even 64MB machines.  So that data
would get tossed out of cache quickly so that I could use smaller working
sets so that the tests could be executed faster.

> But before I do that, I want to make sure that the path is still being 
> considered.

Sure, it hasn't been ruled out.  Especially as those time deltas you're
measuring are so large.  We haven't seen changes in IO throughput like that
in years.  We just need to work out if they're net-positive or net-negative ;)

This will end up being a pretty large hunk of work I expect.
