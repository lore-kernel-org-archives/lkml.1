Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab0BOJ3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 04:29:16 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49179 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab0BOJ3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 04:29:14 -0500
Subject: Re: Why is PERF_FORMAT_GROUP incompatible with inherited events?
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, Dave Wootton <dwootton@us.ibm.com>
In-Reply-To: <20100215045644.GK13769@brick.ozlabs.ibm.com>
References: <20100212030205.GE13769@brick.ozlabs.ibm.com>
	 <1266142337.5273.417.camel@laptop>
	 <20100214113314.GG13769@brick.ozlabs.ibm.com>
	 <1266151107.5273.629.camel@laptop>
	 <20100215045644.GK13769@brick.ozlabs.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Feb 2010 10:29:06 +0100
Message-ID: <1266226146.5273.743.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-15 at 15:56 +1100, Paul Mackerras wrote:
> On Sun, Feb 14, 2010 at 01:38:27PM +0100, Peter Zijlstra wrote:
> > On Sun, 2010-02-14 at 22:33 +1100, Paul Mackerras wrote:
> > > 
> > > But we don't go and collect the count delta from children without
> > > PERF_FORMAT_GROUP, so why would we with it? 
> > 
> > Yes we do, see perf_event_read_value().
> 
> Ah, true, I should have read the code more carefully.
> 
> > But now that I look at it we don't seem to do so in
> > perf_output_read_one()... I guess we should fix that.
> 
> I suppose it should give the same value as read() would, but the
> possibly unbounded interrupt latency is a bit of a worry.  I can't
> think of a way to avoid it, though (other than not using
> PERF_SAMPLE_READ with inherited sampling events :).
> 
> > There is of course the lock inversion in the .read() code reported by
> > stephane, but other than that is seems to actually support inherited &&
> > group just fine.
> > 
> > So I think if we fix that lock inversion and make the PERF_SAMPLE_READ
> > code look like the .read() code it should all work out.

I now realize that this is going to be very complicated because it
involves sending IPIs from NMI context, which is rather involved.

So I might have meant:
  attr->inherit && (attr->sample_format & PERF_SAMPLE_READ)

to be mutually exclusive.

