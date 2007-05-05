Return-Path: <linux-kernel-owner+w=401wt.eu-S934127AbXEERpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934127AbXEERpt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 13:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934139AbXEERpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 13:45:49 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36662 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934127AbXEERps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 13:45:48 -0400
Date: Sat, 5 May 2007 10:44:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Esben Nielsen <nielsen.esben@googlemail.com>
cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v8
In-Reply-To: <Pine.LNX.4.64.0705051016420.12880@frodo.shire>
Message-ID: <alpine.LFD.0.98.0705051040420.3819@woody.linux-foundation.org>
References: <20070501212223.GA29867@elte.hu> <463854F3.3020403@linux.vnet.ibm.com>
 <20070502100545.GA6857@elte.hu> <46386F2B.9050307@linux.vnet.ibm.com>
 <20070502111742.GA18132@elte.hu>
 <Pine.LNX.4.64.0705051016420.12880@frodo.shire>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 5 May 2007, Esben Nielsen wrote:
> 
> I have been wondering why you use usigned for timers anyway. It is also like
> that in hrtimers. Why not use signed and avoid (almost) all worries about wrap
> around issues. The trick is that when all
>   a < b
> is be replaced by
>   a - b < 0
> the code will work on all 2-complement machines even if the (signed!) integers
> a and b wrap around.

No. BOTH of the above are buggy.

The C language definition doesn't allow signed integers to wrap (ie it's 
undefined behaviour), so "a-b < 0" can be rewritten by the compiler as a 
simple signed "a < b".

And the unsigned (or signed) "a < b" is just broken wrt any kind of 
wrap-around (whether wrapping around zero or the sign bit).

So the _only_ valid way to handle timers is to
 - either not allow wrapping at all (in which case "unsigned" is better, 
   since it is bigger)
 - or use wrapping explicitly, and use unsigned arithmetic (which is 
   well-defined in C) and do something like "(long)(a-b) > 0".

Notice? The signed variant is basically _never_ correct.

		Linus
