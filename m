Return-Path: <linux-kernel-owner+w=401wt.eu-S1758424AbYJVTTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424AbYJVTTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 15:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbYJVTTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 15:19:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34301 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbYJVTTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 15:19:44 -0400
Subject: Re: [PATCH 1/2] Allow rwlocks to re-enable interrupts
From: Peter Zijlstra <peterz@infradead.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Petr Tesarik <ptesarik@suse.cz>, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, tee@sgi.com, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20081022190510.GH26094@parisc-linux.org>
References: <1224664414.4430.33.camel@elijah.suse.cz>
	 <1224664476.4430.38.camel@elijah.suse.cz> <1224665128.15448.4.camel@twins>
	 <1224665899.4430.48.camel@elijah.suse.cz> <1224696271.20069.8.camel@twins>
	 <20081022190510.GH26094@parisc-linux.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 22 Oct 2008 21:19:43 +0200
Message-Id: <1224703183.20069.55.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-22 at 13:05 -0600, Matthew Wilcox wrote:
> On Wed, Oct 22, 2008 at 07:24:31PM +0200, Peter Zijlstra wrote:
> > > No problem. I could then also use it for _spin_lock_irqsave, if the
> > > answer to the above question is use CONFIG_LOCK_STAT there as well.
> > 
> > If you create LOCK_CONTEDED_FLAGS() the whole issue goes away nicely.

Gah, I looked at it again, and that #ifdef isn't only to select between
LOCK_CONTENDED and not, but we can't actually have the re-enable for
anything lockdep.

So I was wrong.

> Should it also be used for _spin_lock_irq()?  I'm puzzled why it's only
> used for _irqsave().

Right, not sure how this maze is done.

The thing is, with spin_lock_irq() you know the irq state and can do the
enable unconditionally - then again, with ticket locks we cannot do it
at all.

The _flags() version needs the flags to see if irqs was enabled before
we entered the op, if it wasn't we cannot go around enabling them.

> (should _spin_lock_bh() re-enable BHs while waiting?  Is it just not big
> enough of a deal?)

Doubt it.. dunno.. personally I'd rather see softirqs die sooner rather
than later.
