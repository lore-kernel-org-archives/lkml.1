Return-Path: <linux-kernel-owner+w=401wt.eu-S1752786AbXLFRfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbXLFRfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 12:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbXLFRf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 12:35:29 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35001 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751216AbXLFRf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 12:35:28 -0500
Date: Thu, 6 Dec 2007 09:34:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Daniel Phillips <phillips@phunq.net>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC] [PATCH] A clean approach to writeout throttling
Message-Id: <20071206093432.096213fe.akpm@linux-foundation.org>
In-Reply-To: <20071206105242.3e289a21@cuia.boston.redhat.com>
References: <200712051603.02183.phillips@phunq.net>
	<200712052221.45409.phillips@phunq.net>
	<20071205233152.c567fa57.akpm@linux-foundation.org>
	<200712060148.53805.phillips@phunq.net>
	<20071206035511.83bef995.akpm@linux-foundation.org>
	<20071206105242.3e289a21@cuia.boston.redhat.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Dec 2007 10:52:42 -0500 Rik van Riel <riel@redhat.com> wrote:

> On Thu, 6 Dec 2007 03:55:11 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > - We a-priori decide to limit a particular stack's peak memory usage to
> >   1MB
> > 
> > - We empirically discover that the maximum amount of memory which is
> >   allocated by that stack on behalf of a single BIO is 16kb.  (ie: that's
> >   the most it has ever used for a single BIO).
> > 
> > - Now, we refuse to feed any more BIOs into the stack when its
> >   instantaneous memory usage exceeds (1MB - 16kb).
> > 
> > Of course, the _average_ memory-per-BIO is much less than 16kb.  So there
> > are a lot of BIOs in flight - probably hundreds, but a minimum of 63.
> 
> There is only one problem I can see with this.  With network block
> IO, some memory will be consumed upon IO completion.  We need to
> make sure we reserve (number of in flight BIOs * maximum amount of
> memory consumed upon IO completion) memory, in addition to the
> memory you're accounting in your example above.
> 

hm, yeah, drat.

What we could do is

- in do_IRQ(): set up a per-cpu pointer to some counter which
  corresponds to this IRQ.

- in the page allocator, if in_irq(), retrieve that per-cpu pointer and
  increment the counter.

- in the network block-io stack we can now look at the number of
  interrupts, number of packets, size of packets and amount of memory
  allocated and work out the max amount of memory which needs to be
  allocated for each frame.

That's all rather handwavy and misses a lot of details and might be
inaccurate too.  Probably sufficient to just work out by hand the amount of
memory which the network stack will need to allocate.  I expect it'll be
two pages..
