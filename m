Return-Path: <linux-kernel-owner+w=401wt.eu-S1756895AbZJ0XmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbZJ0XmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 19:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756852AbZJ0XmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 19:42:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756830AbZJ0XmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 19:42:19 -0400
Date: Tue, 27 Oct 2009 16:41:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Stephen Hemminger <shemminger@vyatta.com>
cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Stephen Hemminger <stephen.hemminger@vyatta.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Octavian Purdila <opurdila@ixiacom.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] dcache: better name hash function
In-Reply-To: <20091027160822.384dc109@nehalam>
Message-ID: <alpine.LFD.2.01.0910271636100.31845@localhost.localdomain>
References: <19864844.24581256620784317.JavaMail.root@tahiti.vyatta.com> <4AE68E23.20205@gmail.com> <4AE69829.9070207@gmail.com> <4AE6A16F.4020002@gmail.com> <20091027100736.5303f1ab@nehalam> <alpine.LFD.2.01.0910271017170.31845@localhost.localdomain>
 <20091027160822.384dc109@nehalam>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 27 Oct 2009, Stephen Hemminger wrote:
> 
> Going back to basics. Run tests across different input sets.
> Dropping off the slow ones like crc, md5, ...
> Not using jhash because it doesn't have good character at a time
> interface.
> 
> Also, the folding algorithm used matters. Since the kernel
> already uses hash_long() to fold back to N bits, all the
> tests were rerun with that.

Yeah, the 'hash_long()' folding matters for anything that doesn't multiply 
big some big number to spread the bits out, because otherwise the bits 
from the last character hashed will always be in the low bits.

That explains why our current hash looked so bad with your previous code.

>From your numbers, I think we can dismiss 'kr_hash()' as having horrible 
behavior with names like pppXXX (and that isn't just a special case: it's 
also noticeably worse for your /home directory case, which means that the 
bad behavior shows up in practice too, not just in some special cases).

'elf' and 'pjw' don't have quite the same bad case, but the stddev for the 
pppXXX cases are still clearly worse than the other alternatives. They 
also seem to always be slower than what we already have. 

The 'fnv32' algorithm gets fairly good behavior, but seems bad on Itanium. 
Looks like it depends on a fast multiplication unit, and all even your 
"slow" ULV chip seems to be a Core2 one, so all your x86 targets have 
that. And our current name hash still actually seems to do better in all 
cases (maybe I missed some case) even if fnv32 is slightly faster on x86.

>From your list 'string10' seems to get consistently good results and is at 
or near the top of performance too. It seems to be the one that 
consistently beats 'full_name_hash()' both in performance and in behavior 
(string_hash17/31 come close, but aren't as clearly better performing).

But I haven't actually seen the hashes. Maybe there's something that makes 
string10 bad?

Regardless, one thing your new numbers do say is that our current hash 
really isn't that bad.

		Linus
