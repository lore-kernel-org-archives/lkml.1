Return-Path: <linux-kernel-owner+w=401wt.eu-S1760969AbYFQXly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760969AbYFQXly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 19:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759792AbYFQXlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 19:41:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34795 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759599AbYFQXlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 19:41:46 -0400
Date: Tue, 17 Jun 2008 16:41:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: copy_from_user again()
In-Reply-To: <87hcbrwvqg.fsf@basil.nowhere.org>
Message-ID: <alpine.LFD.1.10.0806171632220.2907@woody.linux-foundation.org>
References: <87hcbrwvqg.fsf@basil.nowhere.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Jun 2008, Andi Kleen wrote:
> 
> I thought a little more about your patch. One problem I see (and that is why
> I aborted my version of it too) is that it becomes very inaccurate now in reporting.

Well, it doesn't become any less accurate in reporting, quite the reverse: 
now it *is* accurate in reporting what it actually *did*. Before, it would 
report something that simply wasn't _true_. Being closer to what you might 
_wish_ would happen doesn't make it accurate, if it doesn'y match reality!

However, you're right that the routine has always had (and I didn't change 
that) a 32-byte granularity in what it does and what it doesn't do in the 
unrolled part. 

Before, it _claimed_ to be more precise than it actually was. It claimed 
to be able to detect non-existing pages at a 8-byte granular level, but it 
never actually did the copy at that level, so the claim wasn't backed up 
by what it did. 

Which was why the users were unhappy: the write() system call _thought_ it 
had copied 16 bytes more than it actually had, resulting in a 16-byte hole 
(which happened to be zero-filled, but could actually in theory be leaking 
information) in the page cache. 

Which gets us back to the original bug report by Bron Gondwana: the end 
result was a corrupt page cache (and on-disk, for that matter), because 
__copy_user() claimed to have copied more than it actually did.

And yes, I do agree that it would be nicer to have byte-granular reporting 
and copying - and I even made that very clear in the email that contained 
the patch. But you must never report finer granularity than you actually 
copy, becuase at that point it's not "more accurate" - it's just plain 
WRONG.

So what I would actually prefer (as I outlined earlier) would be that the 
failure case woudl then fall back on trying to do a byte-by-byte slow copy 
until it hits the exact byte that fails.

However, that is a much bigger patch, and it's actually not something 
we've ever done. Even the original old x86-32 routines would fail at that, 
they just did it with a 4-byte granularity (so max 3 bytes of uncopied 
data close to the end of the page, rather than at a 32-byte (max 31 bytes 
of uncopied data close to the end of the page).

And as mentioned, the cases that really care (like mm/filemap.c) actually 
know to always try to do at least _one_ whole iovec entry. So they are ok 
with the lack of accuracy, because if the atomic version fails, they'll 
fall back to doing something slow and careful.

		Linus
