Return-Path: <linux-kernel-owner+w=401wt.eu-S1753617AbXLGAEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617AbXLGAEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 19:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbXLGAEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 19:04:48 -0500
Received: from phunq.net ([64.81.85.152]:41538 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751549AbXLGAEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 19:04:47 -0500
From: Daniel Phillips <phillips@phunq.net>
To: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [RFC] [PATCH] A clean approach to writeout throttling
Date: Thu, 6 Dec 2007 16:04:41 -0800
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
References: <200712051603.02183.phillips@phunq.net> <200712052221.45409.phillips@phunq.net> <47586F59.5090507@tmr.com>
In-Reply-To: <47586F59.5090507@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712061604.41490.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 December 2007 13:53, Bill Davidsen wrote:
> Daniel Phillips wrote:
> The problem is that you (a) may or may not know just how bad a worst
> case can be, and (b) may block unnecessarily by being pessimistic.

True, but after a quick introspect I realized that that issue (it's 
really a single issue) is not any worse than the way I planned to wave 
my hands at the issue of programmers constructing their metrics wrongly 
and thereby breaking the throttling assumptions.

Which is to say that I am now entirely convince by Andrew's argument and 
am prepardc to reroll the patch along the lines he suggests.  The 
result will be somewhat bigger.  Only a minor change is required to the 
main mechanism: we will now account things entirely in units of pages 
instead of abstract units, eliminating a whole class of things to go 
wrong.  I like that.  Accounting variables get shifted to a new home, 
maybe.  Must try a few ideas and see what works.

Anyway, the key idea is that task struct will gain a field pointing at a 
handle for the "block device stack", whatever that is (this is sure to 
evolve over time) and alloc_pages will know how to account pages to 
that object.  The submit_bio and bio->endio bits change hardly at all.

The runner up key idea is that we will gain a notion of "block device 
stack" (or block stack for short, so that we may implement block 
stackers) which for the time being will simply be Device Mapper's 
notion of device stack, however many warts that may have.  It's there 
now and we use it for ddsnap.

The other player in this is Peterz's swap over network use case, which 
does not involve a device mapper device.  Maybe it should?  Otherwise 
we will need a variant notion of block device stack, and the two 
threads of work should merge eventually.  There is little harm in 
starting this effort in two different places, quite the contrary.

In the meantime we do have a strategy that works, posted at the head of 
this thread, for anybody who needs it now.

> The dummy transaction would be nice, but it would be perfect if you
> could send the real transaction down with a max memory limit and a
> flag, have each level check and decrement the max by what's actually
> needed, and then return some pass/fail status for that particular
> transaction. Clearly every level in the stack would have to know how
> to do that. It would seem that once excess memory use was detected
> the transaction could be failed without deadlock.

The function of the dummy transaction will be to establish roughly what 
kind of footprint for a single transaction we see on that block IO 
path.  Then we will make the reservation _hugely_ greater than that, to 
accommodate 1000 or so of those.  A transaction blocks if it actually 
tries to use more than that.  We close the "many partial submissions 
all deadlock together" hole by ... <insert handwaving here>.  Can't go 
wrong, right?

Agreed that drivers should pay special attention to our dummy 
transaction and try to use the maximum possible resources when they see 
one.  More handwaving, but this is progress.

Regards,

Daniel
