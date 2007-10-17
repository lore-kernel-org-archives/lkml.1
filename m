Return-Path: <linux-kernel-owner+w=401wt.eu-S1758876AbXJQSCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758876AbXJQSCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 14:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753599AbXJQSCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 14:02:25 -0400
Received: from brick.kernel.dk ([87.55.233.238]:24527 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502AbXJQSCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 14:02:24 -0400
Date: Wed, 17 Oct 2007 20:02:19 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] block subsystem related crash with latest -git
Message-ID: <20071017180218.GQ15552@kernel.dk>
References: <20071017154655.GA13394@elte.hu> <alpine.LFD.0.999.0710170929270.26902@woody.linux-foundation.org> <20071017165949.GF15552@kernel.dk> <20071017170804.GG15552@kernel.dk> <20071017172158.GH15552@kernel.dk> <20071017172932.GI15552@kernel.dk> <alpine.LFD.0.999.0710171053180.26902@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710171053180.26902@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17 2007, Linus Torvalds wrote:
> 
> 
> On Wed, 17 Oct 2007, Jens Axboe wrote:
> > 
> > OK, it is fine, as long as the sglist is cleared initially. And I don't
> > think there's anyway around that, clearly I didn't think long enough
> > before including the memset() removal from Tomo.
> 
> Ok, I think that one-liner fixes the real bug.
> 
> But I think the rest of your changes are simply bad.
> 
> The fix to block/ll_rw_block.c should likely be something like the 
> appended instead:
> 
>  - remove the "memset()" you had added earlier. It's bogus. It cannot be 
>    the right thing. If the sg list wasn't initialized correctly much 
>    earlier, trying to initialize it late is pointless - it contains crap.

It's required to clear output members (like dma_len and so on), since
some of the IOMU code really wants that initialized.

>  - the old code was fine, but let's initialize "sg" to NULL to make it 
>    clear that the initial value of sg is pointless, and only "next_sg" 
>    matters (since sg had better be assigned from that).

If you prefer the old next_sg approach to my alternative, that is fine
with me. But we do need the memset().

-- 
Jens Axboe

