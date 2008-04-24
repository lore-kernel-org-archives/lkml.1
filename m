Return-Path: <linux-kernel-owner+w=401wt.eu-S1757927AbYDXSa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927AbYDXSa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 14:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbYDXSaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 14:30:18 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42305 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753320AbYDXSaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 14:30:16 -0400
Message-Id: <1209061814.16243.1249700961@webmail.messagingengine.com>
X-Sasl-Enc: ZRZZYs2HYdRDDT2a9ANmrk/Nlf0ToVdyww7m2uhqhHmv 1209061814
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Chris Mason" <chris.mason@oracle.com>,
       "Christoph Hellwig" <hch@infradead.org>
Cc: "Arjan van de Ven" <arjan@infradead.org>, "T David Chinner" <dgc@sgi.com>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       Th@pimp.vs19.net
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <200804181737.m3IHbabI010051@hera.kernel.org>
   <20080423174516.0982a325@laptopd505.fenrus.org>
   <20080424095215.GA13088@infradead.org>
   <200804241141.31198.chris.mason@oracle.com>
Subject: Re: x86: 4kstacks default
In-Reply-To: <200804241141.31198.chris.mason@oracle.com>
Date: Thu, 24 Apr 2008 20:30:14 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2008 11:41:30 -0400, "Chris Mason"
<chris.mason@oracle.com> said:
> On Thursday 24 April 2008, Christoph Hellwig wrote:
> > On Wed, Apr 23, 2008 at 05:45:16PM -0700, Arjan van de Ven wrote:
> > > THe good news is that direct reclaim is.. rare. And I also doubt
> > > XFS is unique here; imagine the whole stacking thing on x86-64
> > > just the same ...
> >
> > It's bad news actually.  Beause it means the stack overflow happens
> > totally random and hard to reproduce.   And no, XFS is not unique
> > there, any filesystem with a complex enough writeback path (aka
> > extents + delalloc + smart allocator) will have to use quite a lot
> > here.  I'll be my 2 cent that ext4 one finished up will run into
> > this just as likely.
> >
> > > I wonder if the direct reclaim path should avoid direct reclaim if
> > > the stack has only X bytes left. (where the value of X is... well
> > > we can figure that one out later)
> >
> > Actually direct reclaim should be totally avoided for complex
> > filesystems.  It's horrible for the stack and for the filesystem
> > writeout policy and ondisk allocation strategies.
>
> Just as a data point, XFS isn't alone.  I run through once or twice a
> month and try to get rid of any new btrfs stack pigs, but keeping
> under the 4k  stack barrier is a constant challenge.
>
> My storage configuration is fairly simple, if we spin the wheel of
> stacked IO devices...it won't be pretty.
>
> Does it make more sense to kill off some brain cells on finding ways
> to dynamically increase the stack as we run out?  Or even give the
> robust stack users like xfs/btrfs a way to say: I'm pretty sure this
> call path is going to hurt, please make my stack bigger now.

Hi,

(Rookie warning goes here.) To me, growing the stack at more or less
random places in the kernel seems to be quite a complicated thing to do
and it will be quite a maintainance burden to find the right spots to
insert stack usage checks. So I'ld say: lose the dynamic aspect.

How about unconditionally switching stacks at some defined points within
the core code of the kernel, just before calling into any driver code,
for example? The 4k-option has separate irq stacks already, why not have
driver stacks too?

I think the most important consideration to keep the stack size small
was that non-order-0 allocations are unreliable under/after memory
pressure due to fragmentation and that this allocation has to be done
for each thread. It is therefore preferable not to do any higher-order
allocations at all, unless there is a fall-back mechanism if the
allocation fails. For higher-order stacks there isn't such a fallback...
Can the system get by (without deadlocks at least in practice) with a
limited number of preallocated but 'large' stacks (in addition to a
small per-thread stack)?

It was discussed that stack space is needed for any sleeping process.
Could it be arranged that this waiting happens on the smallish stack, at
least for the most common cases, while non-waiting activity can use the
big stacks?

Greetings,
    Alexander

> We have relatively few entry points between the rest of the kernel and
> the FS, there should be some ways to compromise here.
>
> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> kernel" in the body of a message to majordomo@vger.kernel.org More
> majordomo info at  http://vger.kernel.org/majordomo-info.html Please
> read the FAQ at  http://www.tux.org/lkml/
>
>
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - A fast, anti-spam email service.

