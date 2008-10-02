Return-Path: <linux-kernel-owner+w=401wt.eu-S1753845AbYJBGzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbYJBGzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 02:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYJBGzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 02:55:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752199AbYJBGzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 02:55:23 -0400
Date: Wed, 1 Oct 2008 23:55:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-Id: <20081001235501.2b7f50fe.akpm@linux-foundation.org>
In-Reply-To: <20081002062736.GR19428@kernel.dk>
References: <20081001200034.65eb67d6@infradead.org>
	<20081001215638.3a65134c.akpm@linux-foundation.org>
	<20081002062736.GR19428@kernel.dk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008 08:27:37 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:

> On Wed, Oct 01 2008, Andrew Morton wrote:
> > On Wed, 1 Oct 2008 20:00:34 -0700 Arjan van de Ven <arjan@infradead.org> wrote:
> > 
> > > Subject: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
> > 
> > You proposed this a while back and it didn't happen and I forget
> > why and the changelog doesn't mention any of that?
> 
> I think you called for benchmark results, which I don't think happened.
> The patch definitely makes sense, so we should just make sure that we
> don't regress elsewhere. Honestly, I'd be surprised if we did...

Now I think about it, didn't the earlier patch tweak CPU priority and
not IO priority?  I forget.  <kicks the changelog again>

> How about I just toss it into the 2.6.28 testing mix, plenty of time for
> testing and such?

Many performance regressions don't get noticed for six or twelve
months, by which time everyone is suffering from them (see
kernel/sched.c).

kjournald does huge amounts of not-terribly-important writeback.  One
obvious risk is that by making all that bulk writeback high-priority,
read-latency-sensitive applications might suffer latency spikes.



Now, kjournald is _supposed_ to be mostly asynchronous wrt foreground
operations.  And once upon a time (seven years ago) it mostly was.  But
there was some horrid race which I ended up fixing by introducing one
point where synchronous userspace actions had to block behind kjournald
activity.  I spent quite some time on it but couldn't come up with
anything better.  It had fairly bad effects on some workloads.

I've forgotten where that code is now, but I don't think it was ever
revisited.  It should be.

So.  Where are these atime updaters getting blocked?
