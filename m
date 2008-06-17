Return-Path: <linux-kernel-owner+w=401wt.eu-S1759571AbYFQVrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759571AbYFQVrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 17:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756166AbYFQVrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 17:47:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753391AbYFQVrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 17:47:46 -0400
Date: Tue, 17 Jun 2008 14:46:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rob Mueller <robm@fastmail.fm>, Ingo Molnar <mingo@elte.hu>
Subject: Re: BUG: mmapfile/writev spurious zero bytes (x86_64/not i386,
 bisected, reproducable)
In-Reply-To: <48582E03.1040404@firstfloor.org>
Message-ID: <alpine.LFD.1.10.0806171442210.2907@woody.linux-foundation.org>
References: <1213682410.13174.1258837181@webmail.messagingengine.com> <1213682570.13708.1258839317@webmail.messagingengine.com> <alpine.LFD.1.10.0806170947380.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171041560.25099@woody.linux-foundation.org>
 <alpine.LFD.1.10.0806171309130.2981@woody.linux-foundation.org> <87od5zwzh2.fsf@basil.nowhere.org> <alpine.LFD.1.10.0806171412470.2907@woody.linux-foundation.org> <48582C18.4090900@firstfloor.org> <alpine.LFD.1.10.0806171429010.2907@woody.linux-foundation.org>
 <48582E03.1040404@firstfloor.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jun 2008, Andi Kleen wrote:
> 
> The patch is wrong because it'll break the other case (in this case
> copy_from_user)

Ok, I'm now putting you in my idiots filter.

No, it will not break the other case. You're an idiot. Loading a value 
without using it will not break anything, quite the reverse. What the 
patch does is to _fix_ copy_from_user(), because if the second load traps, 
then the fact that we did the first load IS IMMATERIAL, because its result 
was never stored!

So the patch _fixes_ copy_from_user(), exactly because it says that even 
if you've loaded 24 bytes, but you faulted on the fourth load, you've 
still _copied_ exactly zero bytes, because you didn't actually store the 
24 bytes you loaded.

And it is a no-op for copy_to_user, since copy_to_user will never fault on 
the load (not the first one, not the second one, not _any_ load), so the 
exception table entries for the loads are unusued.

IOW: 
 - the patch fixes a bug
 - you refuse to acknowledge this
 - I'll put you in my "flamers" filter that goes into another mailbox, 
   because it's not worth my time even arguing with you any more.

Sorry for ever adding you to the cc. I thought it might be a good idea, 
since you were the author of the code. But clearly the bug was not because 
you made a mistake, but because you simply don't seem to understand what 
the function is supposed to return, and you're not even interested in 
learning.

			Linus
