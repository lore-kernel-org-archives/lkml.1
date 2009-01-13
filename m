Return-Path: <linux-kernel-owner+w=401wt.eu-S1758438AbZAMSWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758438AbZAMSWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 13:22:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755492AbZAMSV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 13:21:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49571 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755058AbZAMSVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 13:21:55 -0500
Date: Tue, 13 Jan 2009 10:21:09 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH -v9][RFC] mutex: implement adaptive spinning
In-Reply-To: <20090113181222.GA24910@elte.hu>
Message-ID: <alpine.LFD.2.00.0901131013580.6528@localhost.localdomain>
References: <1231774622.4371.96.camel@laptop> <1231859742.442.128.camel@twins> <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain> <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins> <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain>
 <20090113181222.GA24910@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Jan 2009, Ingo Molnar wrote:
>
> And v8 is rock solid in all my testing - and i'll give v10 a similar 
> workout as well.

The differences between v8 and v10 are very fundamental, since v8 does the 
spinning inside the spinlock'ed loop (the spinning itself is not inside 
the spinlock, but all the "real action" is).  So v8 not showing problems 
doesn't really say much about v10 - totally different algorithms that 
share only some of the support code.

So even if many lines look the same, those code-lines aren't the really 
interesting ones. The only really interesting once is really the 
atomic_cmpxchg (outside spinlock) vs atomic_xchg (inside spinlock), and 
those are almost diametrically opposite.

> Would you prefer a single commit or is this kind of delta development 
> history useful, with all the variants (at least the later, more promising 
> ones) included?

I'm not sure it makes sense to show the history here, especially as there 
really were two different approaches, and while they share many issues, 
they sure aren't equivalent nor are we really talking about any evolution 
of the patch except in the sense of one being the kick-starter for the 
alternative approach.

What _can_ make sense is to commit some of the infrastructure helper code 
separately, ie the lock ownership and preemption changes, since those 
really are independent of the spinning code, and at least the preemption 
thing is interesting and relevant even without it.

			Linus
