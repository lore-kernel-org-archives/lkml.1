Return-Path: <linux-kernel-owner+w=401wt.eu-S1763004AbXJRBTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763004AbXJRBTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 21:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754438AbXJRBTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 21:19:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40226
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754358AbXJRBTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 21:19:09 -0400
Date: Wed, 17 Oct 2007 18:19:07 -0700 (PDT)
Message-Id: <20071017.181907.63126798.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.0.999.0710171801000.26902@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0710171342550.26902@woody.linux-foundation.org>
	<20071018080048O.fujita.tomonori@lab.ntt.co.jp>
	<alpine.LFD.0.999.0710171801000.26902@woody.linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 17 Oct 2007 18:07:19 -0700 (PDT)

> sg_next() - as it stands now - never actually looks at the SG that its 
> argument points to: it explicitly *only* looks at the next one.
> 
> That's the bug. If sg_next() looked at the actual *current* sg entry, we 
> wouldn't have any issues to begin with, and that's what I'm arguing we 
> should do in the longer run (where "longer run" is defined as "when Jens 
> does it asap").

What the thing really wants is some kind of indication of state,
without having to bloat up the scatterlist structure.

I believe that we have enough of a limited set of accessors to
sg->page that we can more aggressively encode things in the lower
bits.

I'm thinking of encoding the low two bits of sg->page as
follows:

1) bits == 0

   then the SG list is linear and sg_next() is sg++

2) bits == 1

   the nest SG is an indirect chunk, sg_next() is
   therefore something like:

	next = *((struct scatterlist **)(sg + 1));

3) bits == 2

   this is the last entry in the scatterlist, sg_next() is NULL

So for the cases of ARCH_HAS_SG_CHAIN not being set (ie. back
compatible), we can do no bit encoding in page->flags and just do
sg_next() == sg++, as is done now.

When doing SG chaining, in each non-linear chunk we have to allocate
one more pointer past the end of the scatterlist array (instead of a
full extra scatterlist entry for the indirect pointer encode).  Next,
all sg->page accesses have to be guarded to clear the state bits
out first.

I don't know, maybe it would work, and would make the loop termination
issues easier to handle properly.
