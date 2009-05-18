Return-Path: <linux-kernel-owner+w=401wt.eu-S1759063AbZERQSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759063AbZERQSb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758134AbZERQOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:14:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758221AbZERQOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:14:37 -0400
Date: Mon, 18 May 2009 09:13:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] scheduler fixes
In-Reply-To: <20090518142707.GA24142@elte.hu>
Message-ID: <alpine.LFD.2.01.0905180850110.3301@localhost.localdomain>
References: <20090518142707.GA24142@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 18 May 2009, Ingo Molnar wrote:
> 
> Rusty Russell (1):
>       sched: avoid flexible array member inside struct (gcc extension)

I'm not pulling this one either.

It makes no sense what-so-ever. It's uglier code, so calling it a cleanup 
is just wrong.

Now apart from being ugly and pointless, it is also FUNDAMENTALLY 
INCORRECT.

It is in no way true that "a union is the Right Way to do this", 
especially not the way THAT PIECE OF UTTER CRAP does it.

This is the original data structure:

	struct static_sched_group {
		struct sched_group sg;
		DECLARE_BITMAP(cpus, CONFIG_NR_CPUS);
	};

and it is fine (the fact that "sg" isn't fine is a totally different 
issue).

The new one:

	union static_sched_group {
		struct sched_group sg;
		char _sg_and_cpus[sizeof(struct sched_group) +
				  BITS_TO_LONGS(CONFIG_NR_CPUS) * sizeof(long)];
	};

claimed to be a "cleanup" (hah - what a f*cking joke! Anybody looking at 
it for half a second would see that that is a clear lie) is just a 
horrible bug waiting to happen.

You can't do that. Doing a character array with "sizeof" IS NOT VALID. It 
doesn't take things like different alignment into account. It might 
_work_, but it is still UTTER SH*T.

Yes, I'm upset. It's -rc6 and now two "please pull" requests have been 
totally unacceptable in very fundamental and obvious forms. 

I'm also upset becasue that obvious PIECE OF CRAP got two Acked-by's from 
people who should know better. 

If you wan tto fix this up, then just fix "struct sched_group sg" instead. 
Here's a suggested better fix, but I'd suggest somebody also write a 
honking big COMMENT in addition to this.

But note how simple this attached patch is? Note how it's not adding 
totally ugly and horrible code? THIS is a fix (and yes, zero-sized arrays 
are a gcc extensiontoo, but we've used them a lot)

I'm sure there are other ways to fix it too, and I'm open to them, but 
that union with character arrays etc I'm not open to.

			Linus
---
 include/linux/sched.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b4c38bc..e0c9733 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -838,7 +838,7 @@ struct sched_group {
 	 */
 	u32 reciprocal_cpu_power;
 
-	unsigned long cpumask[];
+	unsigned long cpumask[0];
 };
 
 static inline struct cpumask *sched_group_cpus(struct sched_group *sg)
