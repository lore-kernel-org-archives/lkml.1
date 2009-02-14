Return-Path: <linux-kernel-owner+w=401wt.eu-S1759241AbZBNE77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241AbZBNE77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 23:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbZBNE7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 23:59:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:35245 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbZBNE7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 23:59:51 -0500
Date: Fri, 13 Feb 2009 20:59:49 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 1/7] async: Asynchronous function calls to speed up
 kernel boot
Message-ID: <20090213205949.1ebb441d@infradead.org>
In-Reply-To: <20090213162200.8fea7e0c.akpm@linux-foundation.org>
References: <20090107151151.458333c1@infradead.org>
	<20090107151226.58264d07@infradead.org>
	<20090213162200.8fea7e0c.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Feb 2009 16:22:00 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> It means that sometimes, very rarely, the callback function will be
> called within the caller's context.

for the cases that use it right now it is ok.

> 
> Hence this interface cannot be used to call might-sleep functions from
> within atomic contexts.  Which should be a major application of this
> code!

That is not what this was originally designed for. The original design
goal was to offload existing function calls out of the synchronous
execution path.

Now I understand that it would be nice to do what you propose, but it
needs a little different interface for that; specifically, the caller
will need to pass in the memory for the administration.

> 

> 
> Furthermore:
> 
> - If the callback function can sleep then the caller must be able to
>   sleep, so the GFP_ATOMIC is unneeded and undesirable, and the
> comment is wrong.

And if the callback function does not sleep it can be used in atomic
context just fine. Hence the GFP_ATOMIC.
.

> 
> I can't immediately think of a fix, apart from overhauling the
> implementation and doing it in the proper way: caller-provided storage
> rather than callee-provided (which always goes wrong).
> schedule_work() got this right.

schedule_work() got it part right. Pushing the administration to the
caller means the caller needs to allocate the memory or use static
memory and then make sure it doesn't get reused for a 2nd piece of work.
(schedule_work doesn't care, it will just execute it once in that case.
Here we do absolutely care).

The caller only rarely can deal better with the memory allocation and
lifetime rules than the implementation can. In fact, for the scenario of
"I want to take this bit of code out of the synchronous path
normally".. it is just fine and most easy this way; moving this to the
caller just makes things more fragile.

So yes based on the discussions on lkml in the last week I was going to
add an interface where you can pass in your own memory, but I want to
get the interface right such that it is low complexity for the caller,
and really hard to get wrong.. and that does involve dealing with the
"how to do static allocation while doing multiple parallel calls"
problem.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
