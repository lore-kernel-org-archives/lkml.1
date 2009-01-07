Return-Path: <linux-kernel-owner+w=401wt.eu-S1763734AbZAGXSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763734AbZAGXSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 18:18:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763644AbZAGXQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 18:16:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760344AbZAGXQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 18:16:54 -0500
Date: Wed, 7 Jan 2009 15:15:48 -0800 (PST)
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
In-Reply-To: <49652C7C.3000909@novell.com>
Message-ID: <alpine.LFD.2.00.0901071510390.3057@localhost.localdomain>
References: <alpine.LFD.2.00.0901061413310.3057@localhost.localdomain> <1231281801.11687.125.camel@twins> <1231283778.11687.136.camel@twins> <1231329783.11687.287.camel@twins> <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain> <1231347442.11687.344.camel@twins>
 <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain> <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com> <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain> <20090107210923.GV2002@parisc-linux.org> <20090107213924.GP496@one.firstfloor.org>
 <49652C7C.3000909@novell.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Jan 2009, Gregory Haskins wrote:
>
> Can I ask a simple question in light of all this discussion? 
> 
> "Is get_task_struct() really that bad?"

Yes. It's an atomic access (two, in fact, since you need to release it 
too), which is a huge deal if we're talking about a timing-critical 
section of code.

And this is timing-critical, or we wouldn't even care - even in the 
contention case. Admittedly btrfs apparently makes it more so that it 
_should_ be, but Peter had some timings that happened with just regular 
create/unlink that showed a big difference.

So the whole and only point of spinning mutexes is to get rid of the 
scheduler overhead, but to also not replace it with some other thing ;)

			Linus
