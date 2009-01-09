Return-Path: <linux-kernel-owner+w=401wt.eu-S1754361AbZAITte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361AbZAITte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 14:49:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbZAITtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 14:49:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55214 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751583AbZAITtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 14:49:22 -0500
Date: Fri, 9 Jan 2009 11:48:41 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Matthew Wilcox <matthew@wil.cx>
cc: Andi Kleen <andi@firstfloor.org>, Dirk Hohndel <hohndel@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       jim owens <jowens@hp.com>, Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>, jh@suse.cz
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y
 impact
In-Reply-To: <20090109192918.GE6936@parisc-linux.org>
Message-ID: <alpine.LFD.2.00.0901091145110.6528@localhost.localdomain>
References: <20090109084620.3c711aad@infradead.org> <20090109172011.GD26290@one.firstfloor.org> <20090109172801.GC6936@parisc-linux.org> <20090109174719.GG26290@one.firstfloor.org> <20090109094142.367012b6@infradead.org> <20090109180213.GH26290@one.firstfloor.org>
 <alpine.LFD.2.00.0901090954410.6528@localhost.localdomain> <20090109185509.GJ26290@one.firstfloor.org> <alpine.LFD.2.00.0901091045090.6528@localhost.localdomain> <20090109193506.GL26290@one.firstfloor.org> <20090109192918.GE6936@parisc-linux.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Jan 2009, Matthew Wilcox wrote:
> 
> Now, I'm not going to argue the directIO code is a shining example of
> how we want things to look, but we don't really want ten arguments
> being marshalled into a function call; we want gcc to inline the
> direct_io_worker() and do its best to optimise the whole thing.

Well, except we quite probably would be happier with gcc not doing that, 
than with gcc doing that too often.

There are exceptions. If the caller is really small (ie a pure wrapper 
that perhaps just does some locking around the call), then sure, inlining 
a large function that only gets called from one place does make sense.

But if both the caller and the callee is large, like in your example, then 
no. DON'T INLINE IT. Unless we _tell_ you, of course, which we probably 
shouldn't do.

Why? Becuase debugging is more important. And deciding to inline that, you 
probably decided to inline something _else_ too. And now you've quite 
possibly blown your stackspace.

		Linus
