Return-Path: <linux-kernel-owner+w=401wt.eu-S932445AbXAaDC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445AbXAaDC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 22:02:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932500AbXAaDC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 22:02:27 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34927 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932445AbXAaDC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 22:02:26 -0500
Date: Tue, 30 Jan 2007 19:02:04 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
In-Reply-To: <Pine.LNX.4.64.0701301838110.3611@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0701301853190.3611@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
 <1170209044.26655.364.camel@localhost.localdomain>
 <Pine.LNX.4.64.0701301838110.3611@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Jan 2007, Linus Torvalds wrote:
> 
> Does that mean that we might not have some cases where we'd need to make 
> sure we do things differently? Of course not. Something migt show up. But 
> this actually makes it very clear what the difference between "struct 
> thread_struct" and "struct task_struct" are. One is shared between 
> fibrils, the other isn't.

Btw, this is also something where we should just disallow certain system 
calls from being done through the asynchronous method. 

Notably, clone/fork(), execve() and exit() are all things that we probably 
simply shouldn't allow as "AIO" events.

The process handling ones are obvious: they are very much about the shared 
"struct task_struct", so they rather clearly should only done "natively".

More interesting is the question about "close()", though. Currently we 
have an optimization (fget/fput_light) that basically boils down to "we 
know we are the only owners". That optimization becomes more "interesting" 
with AIO - we need to disable it when fibrils are active (because other 
fibrils or the main thread can do it), but we can still keep it for the 
non-fibril case.

So we can certainly allow close() to happen in a fibril, but at the same 
time, this is an area where just the *existence* of fibrils means that 
certain other decisions that were thread-related may be modified to be 
aware of the micro-threads too.

I suspect there are rather few of those, though. The only one I can think 
of is literally the fget/fput_light() case, but there could be others.

			Linus
