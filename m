Return-Path: <linux-kernel-owner+w=401wt.eu-S1763531AbZAGXTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763531AbZAGXTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 18:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754699AbZAGXTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 18:19:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751390AbZAGXTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 18:19:39 -0500
Date: Wed, 7 Jan 2009 15:18:34 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Gregory Haskins <ghaskins@novell.com>
cc: Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
       Ingo Molnar <mingo@elte.hu>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH -v5][RFC]: mutex: implement adaptive spinning
In-Reply-To: <alpine.LFD.2.00.0901071510390.3057@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0901071516280.3057@localhost.localdomain>
References: <alpine.LFD.2.00.0901061413310.3057@localhost.localdomain> <1231281801.11687.125.camel@twins> <1231283778.11687.136.camel@twins> <1231329783.11687.287.camel@twins> <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain> <1231347442.11687.344.camel@twins>
 <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain> <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com> <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain> <20090107210923.GV2002@parisc-linux.org> <20090107213924.GP496@one.firstfloor.org>
 <49652C7C.3000909@novell.com> <alpine.LFD.2.00.0901071510390.3057@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Jan 2009, Linus Torvalds wrote:
> > 
> > "Is get_task_struct() really that bad?"
> 
> Yes. It's an atomic access (two, in fact, since you need to release it 
> too), which is a huge deal if we're talking about a timing-critical 
> section of code.

There's another issue: you also need to lock the thing that gives you the 
task pointer in the first place. So it's not sufficient to do 
get_task_struct(), you also need to do it within a context where you know 
that the pointer is not going away _while_ you do it.

And with the mutexes clearing the ->owner field without even holding the 
spinlock, that is not a guarantee we can easily get any way. Maybe we'd 
need to hold the tasklist_lock or something.

		Linus
