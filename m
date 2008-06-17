Return-Path: <linux-kernel-owner+w=401wt.eu-S1758799AbYFQV1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799AbYFQV1D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 17:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbYFQV0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 17:26:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39506 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbYFQV0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 17:26:53 -0400
Message-ID: <48582C18.4090900@firstfloor.org>
Date: Tue, 17 Jun 2008 23:26:48 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rob Mueller <robm@fastmail.fm>, Ingo Molnar <mingo@elte.hu>
Subject: Re: BUG: mmapfile/writev spurious zero bytes (x86_64/not i386, bisected,
 reproducable)
References: <1213682410.13174.1258837181@webmail.messagingengine.com> <1213682570.13708.1258839317@webmail.messagingengine.com> <alpine.LFD.1.10.0806170947380.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171041560.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171309130.2981@woody.linux-foundation.org> <87od5zwzh2.fsf@basil.nowhere.org> <alpine.LFD.1.10.0806171412470.2907@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806171412470.2907@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 17 Jun 2008, Andi Kleen wrote:
>> The x86-64 copy_*_user functions were always designed to return errors
>> both ways (as in both for load and for store).
> 
> That's not the problem, Andi.
> 
> The problem is that it returns THE WRONG VALUE!
> 
> If the fault happened on the second load, 

Loads are not supposed to fault in copy_to_user(). Only stores are.

The way it works is that it assumes that either loads fault (when used
as copy_from_user) or stores (copy_to_user), but never both.

> but the first load was never 
> actually paired up with a store (because of unrolling the loop), then YOU 
> MUST NOT CLAIM THAT YOU DID A 8-BYTE COPY! Because you have copied exactly 
> _zero_ bytes, even though you _loaded_ 8 bytes successfully!
> 
> See?
> 
> Claiming that you copied 8 bytes when you didn't do anything at all is 
> WRONG. It's so incredibly wrong that it is scary. 

If your patch fixes something then the main wrong thing is the caller
who passes a faulting source address.

And again it always breaks the other case.

-Andi


