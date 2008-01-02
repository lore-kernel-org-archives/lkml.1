Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784AbYABTTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbYABTTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 14:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbYABTTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 14:19:42 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60646 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751408AbYABTTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 14:19:41 -0500
Date: Wed, 2 Jan 2008 11:19:14 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
In-Reply-To: <1199292381.3258.32.camel@localhost.localdomain>
Message-ID: <alpine.LFD.1.00.0801021113150.32517@woody.linux-foundation.org>
References: <20080102162534.GA4041@elte.hu> <1199292381.3258.32.camel@localhost.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Jan 2008, James Bottomley wrote:
> 
> I disagree with this.  We only have one reporter of a problem and it
> appears to be some type of obscure interaction with pktdvd which no-one
> can track down (although it's not really helped by the reporter not
> being very responsive).

It's totally immaterial if we have one reporter or many. The fact is, that 
thing has been outstanding for almost two months now. The root cause is 
almost certainly known (and Matthew is apparently even aware of it), but 
it has been dicked-around-with by having totally weak excuses ("is it an 
ide-scsi thing?")

> The correct thing to do is root cause the problem and fix it at source,
> since it's very likely that this is a pre-existing bug that was simply
> uncovered by the patch you're recommending we revert.

No, the correct thing would have been to fix it a month ago.

By now, it needs to either have a patch, or to be reverted. It's too late 
to make excuses.

And no, it doesn't really need any more reporters or ways to reproduce it, 
all it needs is looking at the patch and seeing what the differences are 
AT A SOURCE level. And quite frankly, I see one huge honking difference, 
which is that new test for 

	if (cmd->request->cmd_type != REQ_TYPE_BLOCK_PC) 

which will disable all the crud that sd_done() does.

And guess what? Look at what sd_done() does: it checks whether the request 
was partially filled, and tries to handle that end-of-medium case nicely. 
Which is *exactly* what seems  to have broken.

So I think you are making totally idiotic excuses. I may not know the SCSI 
layer all that intimately, and maybe I'm wrong and there is some other 
cause for this, but quite frankly, I doubt it. And I can look at just the 
patch and have a damn good idea of why something is broken, but I can't 
actually fix it myself because I don't know how to look up a a 
"scsi_driver" from a "scsi_cmnd" sanely.

But almost two months after the fact, we should have had a patch that does 
that, or we should revert it.

NO MORE BOGUS EXCUSES!

			Linus
