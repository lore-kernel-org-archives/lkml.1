Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbZAMQRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbZAMQRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 11:17:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbZAMQR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 11:17:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38295 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752124AbZAMQRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 11:17:25 -0500
Date: Tue, 13 Jan 2009 08:16:19 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>,
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
In-Reply-To: <1231859742.442.128.camel@twins>
Message-ID: <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain>
References: <1231774622.4371.96.camel@laptop> <1231859742.442.128.camel@twins>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Jan 2009, Peter Zijlstra wrote:
> 
> Change mutex contention behaviour such that it will sometimes busy wait on
> acquisition - moving its behaviour closer to that of spinlocks.

Okey, dokey. Looks reasonable, but I wonder if this part came from v8 and 
wasn't intentional:

> +		if (atomic_xchg(&lock->count, -1) == 1) {
> +			lock_acquired(&lock->dep_map, ip);
> +			mutex_set_owner(lock);
> +			preempt_enable();
> +			return 0;
> +		}

Now you're forcing the slow-path on unlock. Maybe it was intentional, 
maybe it wasn't. Did you perhaps mean

	if (atomic_cmpxchg(&lock->count, 1, 0) == 1) {

here? I thought we agreed it was safe, if only because it should be 
equivalent to just having done "mutex_trylock()" instead of a "real" lock 
sequence.

			Linus
