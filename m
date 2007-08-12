Return-Path: <linux-kernel-owner+w=401wt.eu-S934450AbXHLKt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934450AbXHLKt7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 06:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755431AbXHLKtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 06:49:51 -0400
Received: from mailgw.cvut.cz ([147.32.3.235]:41311 "EHLO mailgw.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754358AbXHLKtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 06:49:50 -0400
Message-ID: <46BEE427.3020904@vandrovec.name>
Date: Sun, 12 Aug 2007 03:42:47 -0700
From: Petr Vandrovec <petr@vandrovec.name>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.6) Gecko/20070802 Iceape/1.1.4 (Debian-1.1.4-1)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: discuss@x86-64.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Please remove ab144f5ec64c42218a555ec1dbde6b60cf2982d6 was Re:
 [discuss] [PATCH] Fix triplefault on x86-64 bootup
References: <20070812081252.GA23309@vana.vc.cvut.cz> <200708121209.40995.ak@suse.de>
In-Reply-To: <200708121209.40995.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Sunday 12 August 2007 10:12, Petr Vandrovec wrote:
>> Hello,
>>   after I upgraded kernel on my box to current git, only thing it did
>> was rebooting in a loop.  After some digging I found that it is silly
>> to apply alternative to memcpy by using that every same memcpy...
>> Sorry if it is known bug, I do not see it reported in my LKML mailbox...
> 
> Ok Linus already applied your patch. Even though it's a really 
> bad fragile hack, not better than the old bug.
> 
> Petr are you double sure you really tested with
> ab144f5ec64c42218a555ec1dbde6b60cf2982d6
> already applied? I bet not -- it is the symptom exactly fixed by this patch

I'm quite sure that this patch is in my tree, as I have that "u8 *instr 
= a->instr;" in apply_alternatives, and it seems that this one was added 
by checkin you mention...  My tree was synced up to:

Commit: 3dab307e527f2a9bbb4f9d00240374bb93d1945f
Author: Chuck Ebbert <cebbert@redhat.com> Fri, 10 Aug 2007 22:31:11 +0200

which as far as I can tell really *is* after your fix.  I'm quite sure 
that I did not hit any BUG_ON() or anything like that - when patching 
got to memcpy alternative, it entered text_poke(), and instead of 
returning to caller it returned to BIOS :-(

> (although 
> 
> Linus, I would prefer if you reverted 
> b8d3f2448b8f4ba24f301e23585547ba1acc1f04
> again -- it should really not be needed with 
> ab144f5ec64c42218a555ec1dbde6b60cf2982d6
> 
> And I really dislike Petr's patch because while it might work
> today (I'm not 100% sure it actually works to only replace
> 2 bytes) if we change memcpy ever it'll likely cause strange 
> problems again.

It does not actually change two bytes - it changes two bytes now because 
alternative is two bytes long - it makes no sense to replace whole 
function with NOPs - it is necessary when you fall through that 
function, but for this (and other x86-64 alternatives) it makes no sense 
to replace whole function with nops if first instruction in alternative 
is jump - then you need to only put that jump in place.
							Petr


