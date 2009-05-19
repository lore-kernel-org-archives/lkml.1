Return-Path: <linux-kernel-owner+w=401wt.eu-S1755688AbZESSKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688AbZESSKD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 14:10:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbZESSJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 14:09:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753470AbZESSJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 14:09:55 -0400
Date: Tue, 19 May 2009 11:08:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Martin Knoblauch <spamtrap@knobisoft.de>
cc: Matt Mackall <mpm@selenic.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Rgeression: 2.6.30-rc6-git3 build error - ICE from
 drivers/char/random.c
In-Reply-To: <950448.6018.qm@web32607.mail.mud.yahoo.com>
Message-ID: <alpine.LFD.2.01.0905191055410.3301@localhost.localdomain>
References: <688406.16641.qm@web32603.mail.mud.yahoo.com> <20090518203420.GF2658@calx> <alpine.LFD.2.01.0905181506550.3301@localhost.localdomain> <231530.33013.qm@web32601.mail.mud.yahoo.com> <alpine.LFD.2.01.0905190745230.3301@localhost.localdomain>
 <950448.6018.qm@web32607.mail.mud.yahoo.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 19 May 2009, Martin Knoblauch wrote:
> > 
> > Ok, so can you do two other simple tests:
> > 
> > - just remove the  "+ (long)&ret" entirely.
> > 
> >    Now, usually gcc doesn't have issues with non-asm things, but that's an 
> >    odd way of getting the current stack address by lookin gat the address 
> >    of a variable that hasn't even been used, so maybe it triggers some 
> >    untested codepath in gcc (and thus the bug).
> > 
> 
>  Removing above fixes the ICE. It does so in both the original and the patched version. 
> 
>  Removing get_cycles() has no effect wrt. the ICE.

Oh wow. Ok, I suggested it, but I have to admit that I didn't really think 
that it would be the &ret thing.

Very interesting fragility in your gcc version.

Anyway, that part of the garbage is much less interesting than the cycle 
counter (the stack pointer will be the same for the same process and 
callchain anyway - and 'current->pid' is already gives difference answers 
for different processes), so I'll just remove it.

We could replace it with something like __builtin_frame_address(0) or 
whatever, but I don't know which gcc version _that_ was introduced in, so 
I suspect I should just get rid of it as not being worth it.

I guess getting rid of 'jiffies' is also worth it. Even at its very worst, 
'get_cycles()' should return jiffy-level information, so adding in jiffies 
doesn't add anything to it.

So I'll just commit this. But I'd like to have a final "tested-by" from 
you, since I don't have access to your version of gcc on any of my 
machines.

		Linus
---
 drivers/char/random.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index b2ced39..b361f45 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1673,7 +1673,7 @@ unsigned int get_random_int(void)
 	int ret;
 
 	keyptr = get_keyptr();
-	hash[0] += current->pid + jiffies + get_cycles() + (int)(long)&ret;
+	hash[0] += current->pid + get_cycles();
 
 	ret = half_md4_transform(hash, keyptr->secret);
 	put_cpu_var(get_random_int_hash);
