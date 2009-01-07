Return-Path: <linux-kernel-owner+w=401wt.eu-S1755302AbZAGAHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302AbZAGAHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 19:07:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbZAGAGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 19:06:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750991AbZAGAGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 19:06:54 -0500
Date: Tue, 6 Jan 2009 16:06:07 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Matthew Wilcox <matthew@wil.cx>
cc: Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
In-Reply-To: <20090106230953.GQ2002@parisc-linux.org>
Message-ID: <alpine.LFD.2.00.0901061602150.3057@localhost.localdomain>
References: <20090106131643.GA15228@elte.hu> <1231248041.11687.107.camel@twins> <49636799.1010109@novell.com> <20090106214229.GD6741@linux.vnet.ibm.com> <1231278275.11687.111.camel@twins> <alpine.LFD.2.00.0901061349520.3057@localhost.localdomain>
 <1231279660.11687.121.camel@twins> <alpine.LFD.2.00.0901061413310.3057@localhost.localdomain> <1231281801.11687.125.camel@twins> <alpine.LFD.2.00.0901061456280.3057@localhost.localdomain> <20090106230953.GQ2002@parisc-linux.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Jan 2009, Matthew Wilcox wrote:
> > 
> > This looks ugly. Why doesn't __mutex_lock_common() just set the lock 
> > owner? Hate seeing it done in the caller that has to re-compute common 
> > (yeah, yeah, it's cheap) and just looks ugly.
> 
> Because __mutex_lock_common() is the slow path.  The fast path is a
> couple of assembly instructions in asm/mutex.h.  If the lock isn't
> contended, it will never call __mutex_lock_common().

No, that's not it.

Look at the callers. They are _all_ the slow path. They looked like this:

	might_sleep();
	return __mutex_lock_common(lock, TASK_KILLABLE, subclass, _RET_IP_);

Yes, you _also_ need to set the owner in the fast-path, but that's all 
entirely different. This is the debug case, which _always_ calls the 
slow-path.

So what I'm saying is that the slow-path should just set it. And then yes, 
we _also_ need to set it in the fast-path, but at least we don't need to 
set it in all the debug versions that just call the slow path!

			Linus
