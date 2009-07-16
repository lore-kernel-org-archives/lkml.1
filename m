Return-Path: <linux-kernel-owner+w=401wt.eu-S1755539AbZGPMLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbZGPMLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 08:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755404AbZGPMLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 08:11:12 -0400
Received: from smtp.nokia.com ([192.100.122.233]:49758 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060AbZGPMLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 08:11:11 -0400
Subject: Re: [PATCH 02/06] Fix compilation warning for fs/ubifs/commit.c
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Subrata Modak <subrata@linux.vnet.ibm.com>, linux-mtd@lists.infradead.org,
       Adrian Hunter <adrian.hunter@nokia.com>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       David Howells <dhowells@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A5F0F03.5080507@s5r6.in-berlin.de>
References: <20090715021901.4112.45973.sendpatchset@subratamodak.linux.ibm.com>
	 <1247640750.11353.6.camel@localhost.localdomain>
	 <4A5E1D1A.3090705@s5r6.in-berlin.de>
	 <1247738232.11353.90.camel@localhost.localdomain>
	 <4A5F0F03.5080507@s5r6.in-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Jul 2009 15:09:15 +0300
Message-Id: <1247746155.11353.143.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 16 Jul 2009 12:09:21.0193 (UTC) FILETIME=[40526190:01CA060E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-16 at 13:29 +0200, Stefan Richter wrote:
> my comment was more directed to Subrata rather than you, as a pointer 
> for future changes of this kind.
> 
> By '"Fix compilation warning" is not correct' I mean:
> 
> This subject would be strictly correct if there was a warning message 
> which contained a factual or formal mistake, and the patch would make 
> the warning show up as a factual and formal correct message.
> 
> Yet the patch does nothing else than _suppress a message_.

I agree, so I amended the changelog.

>      3.) Reason:  The compiler wrongly interprets a variable as
>          occasionally unused, even though this is nicely organized,
>          obvious code where the assertion of the compiler is not only
>          wrong, but everybody also can see immediately from the code that
>          there will never be a.
> 
>          Aside from improving the compiler itself to properly handle
>          this, in this case the appropriate action is to use the
>          uninitialized_var() macro --- /unless/ there is a non-intrusive
>          way to refactor the code to be compilable without warning but
>          keep it still nice to read.
> 
>          Why is the latter still better than uninitialized_var()?  Easy:
>          If anybody later changes the code such that he introduces an
>          actual use-without-initialization bug, nobody will notice the
>          bug because it's hidden by the macro.
> 
>          And there are more downsides to the macro:  The readability of
>          code which makes use of it suffers somewhat.  Also, the macro
>          works with gcc (i.e. shuts gcc up), but apparently not with the
>          Intel compiler.
> 
> So, in the majority of types of cases, uninitialized_var() is the wrong 
> course of action.  (Though maybe not in the majority of occurrences of 
> cases.)

I see what you mean. May be in this UBIFS case the code could be
amended indeed. But there is infinite room for nicifications, and I'm
not sure touching this function is worth it. It works and was tested a
lot.

> OK.  Rant over.  It's now time for me to actually have look at the code 
> which is being patched here. :-)  (Sorry, I commented before only on the 
> basis of Subrata's diff and changelog.)
> 
>  From fs/ubifs/commit.c in mainline 2.6.31-rc3:
> 
> Before lower_key, there was obviously already an issue with last_sqnum 
> which received the same treatment as lower_key receives now.  Both of 
> these are provided with a value in a conditional block:
> 
> 	int first = 1;
> 
> 	if (first) {
> 		first = 0;
> 		...
> 	}
> 
> block and first used after this block.  From the looks of the whole 
> function, these two variables indeed don't appear in danger to ever be 
> accessed uninitialized.

Right, this is why I thought this is fake alarm and we can just shyt
gcc up using 'uninitialized_var()'.

> So, is uninitialized_var() a good fix here?  I'd say it's not a 
> particular good one.  Count the lines of code of dbg_check_old_index() 
> and the maximum indentation level of it.  Then remember the teachings of 
> CodingStyle. :-)  See?  dbg_check_old_index() clearly isn't a prime 
> example of best kernel coding practice.  /Perhaps/ a little bit of 
> refactoring would make it easier to read, and as a bonus side effect, 
> make it unnecessary to use the slightly dangerous and 
> uninitialized_var() macro here.

Yes, the function is large and could be split on smaller ones. But I
do not think it is too bad, and still feel like just using
'uninitialized_var()' is just fine. But if someone re-factors the code
I will not object, of course, especially if he also tests it :-)

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

