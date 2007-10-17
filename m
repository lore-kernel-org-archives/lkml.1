Return-Path: <linux-kernel-owner+w=401wt.eu-S1760804AbXJQTbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760804AbXJQTbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbXJQTbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:31:32 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55383 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751063AbXJQTbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:31:31 -0400
Date: Wed, 17 Oct 2007 12:28:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [bug] ata subsystem related crash with latest -git
In-Reply-To: <20071017190901.GA13780@elte.hu>
Message-ID: <alpine.LFD.0.999.0710171217160.26902@woody.linux-foundation.org>
References: <20071017154655.GA13394@elte.hu>
 <alpine.LFD.0.999.0710170929270.26902@woody.linux-foundation.org>
 <20071017165949.GF15552@kernel.dk> <20071017170804.GG15552@kernel.dk>
 <20071017172158.GH15552@kernel.dk> <20071017172932.GI15552@kernel.dk>
 <20071017173408.GA1960@elte.hu> <20071017174503.GA4622@elte.hu>
 <20071017175337.GN15552@kernel.dk> <20071017183716.GU15552@kernel.dk>
 <20071017190901.GA13780@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Oct 2007, Ingo Molnar wrote:
> 
> nope, this did not help. First bootup went fine, second bootup crashed 
> again (see below), without hitting the BUG_ON().

I think you'll always hit it if you have a scatter-gather list that is 
exactly filled up.

Why? Because those things do "sg_next()" on the last entry, and as 
mentioned, that ends up actually accessing one past the end - even if the 
end result is not actually ever *used* (because we just effectively 
incremented it to past the last entry when the code was done with the SG 
list).

So I think the sg_next() interface is fundamentally mis-designed. It 
should do the scatter-gather link following on *starting* to use the SG 
entry, not after finishing with it.

Put another way: I suspect pretty much every single sg_next() out there is 
likely to hit this issue. The way that blk_rq_map_sg() fixed its problem 
was exactly to move the "sg_next()" to *before* the use of the SG (and 
even that one is somewhat bogus, in that it just blindly assumes that the 
first entry is not a link entry).

I suspect the "the next entry is a link" bit should be in the *previous* 
entry, and then sg_next() could look like

	if (next_is_link(sg))
		sg = sg_chain_ptr(sg+1);
	else
		sg++;
	return sg;

and that would work. 

The alternative is to always make sure to allocate one more SG entry than 
required, so that the last entry is always either the link, or an unused 
entry!

		Linus
