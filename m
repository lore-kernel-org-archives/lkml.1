Return-Path: <linux-kernel-owner+w=401wt.eu-S1757075AbYLaXIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075AbYLaXIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 18:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbYLaXI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 18:08:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:37691 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbYLaXI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 18:08:26 -0500
Message-ID: <495BFB48.8080506@kernel.org>
Date: Wed, 31 Dec 2008 15:07:52 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: random.c changes for sparse irq_desc are crap
References: <1230748169.19620.132.camel@calx>
In-Reply-To: <1230748169.19620.132.camel@calx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> I just noticed you merged a change that pointlessly converts two
> random.c functions into ugly random.h inlines without going through the
> maintainer.
> 
> I also don't like the look of the newly-introduced sparse variants of
> these functions. Failure to find an irq descriptor in
> get_timer_rand_state is a BUG_ON should-never-happen sort of condition,
> not something to silently ignore. Letting the code try to dereference
> NULL is preferred here: we'll actually be able to find and fix the
> broken driver that's throwing around meaningless irq vectors.
> 
> Throwing away the timer_state pointer in the set_timer_rand_state
> function is similarly bogus in addition to being a memory leak.
> 
> Please fix this up.
> 

want something like this?

---
 include/linux/random.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux-2.6/include/linux/random.h
===================================================================
--- linux-2.6.orig/include/linux/random.h
+++ linux-2.6/include/linux/random.h
@@ -75,8 +75,7 @@ static inline struct timer_rand_state *g
 
 	desc = irq_to_desc(irq);
 
-	if (!desc)
-		return NULL;
+	BUG_ON(!desc);
 
 	return desc->timer_rand_state;
 }
@@ -87,8 +86,7 @@ static inline void set_timer_rand_state(
 
 	desc = irq_to_desc(irq);
 
-	if (!desc)
-		return;
+	BUG_ON(!desc);
 
 	desc->timer_rand_state = state;
 }
