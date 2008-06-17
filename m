Return-Path: <linux-kernel-owner+w=401wt.eu-S1758137AbYFQVPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137AbYFQVPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 17:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407AbYFQVPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 17:15:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39549 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755012AbYFQVPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 17:15:00 -0400
Date: Tue, 17 Jun 2008 14:14:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rob Mueller <robm@fastmail.fm>, Ingo Molnar <mingo@elte.hu>
Subject: Re: BUG: mmapfile/writev spurious zero bytes (x86_64/not i386,
 bisected, reproducable)
In-Reply-To: <87od5zwzh2.fsf@basil.nowhere.org>
Message-ID: <alpine.LFD.1.10.0806171412470.2907@woody.linux-foundation.org>
References: <1213682410.13174.1258837181@webmail.messagingengine.com> <1213682570.13708.1258839317@webmail.messagingengine.com> <alpine.LFD.1.10.0806170947380.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171041560.25099@woody.linux-foundation.org>
 <alpine.LFD.1.10.0806171309130.2981@woody.linux-foundation.org> <87od5zwzh2.fsf@basil.nowhere.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jun 2008, Andi Kleen wrote:
> 
> The x86-64 copy_*_user functions were always designed to return errors
> both ways (as in both for load and for store).

That's not the problem, Andi.

The problem is that it returns THE WRONG VALUE!

If the fault happened on the second load, but the first load was never 
actually paired up with a store (because of unrolling the loop), then YOU 
MUST NOT CLAIM THAT YOU DID A 8-BYTE COPY! Because you have copied exactly 
_zero_ bytes, even though you _loaded_ 8 bytes successfully!

See?

Claiming that you copied 8 bytes when you didn't do anything at all is 
WRONG. It's so incredibly wrong that it is scary. 

			Linus
