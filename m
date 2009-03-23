Return-Path: <linux-kernel-owner+w=401wt.eu-S1760927AbZCWVUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760927AbZCWVUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 17:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760831AbZCWVUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 17:20:30 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43158 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758428AbZCWVU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 17:20:29 -0400
Date: Mon, 23 Mar 2009 17:20:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Patch 01/11] Introducing generic hardware breakpoint handler
 interfaces
In-Reply-To: <20090323204220.GA19602@in.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0903231713360.3610-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Mar 2009, K.Prasad wrote:

> > Isn't that exactly the check you need to implement?
> > 
> > 	addr >= TASK_SIZE && (addr + len) >= TASK_SIZE,
> > 
> > or perhaps better,
> > 
> > 	addr >= TASK_SIZE && (addr + len) >= addr.
> > 
> > In this case you _do_ know the length of the breakpoint.
> > 
> > Alan Stern
> >
> 
> Aren't we just checking if len is a positive number through the above
> checks? The validation checks in the patchset should take care of
> negative lengths. Or am I missing something?

Well, 0x60000000 is a positive number, and 0xd0000000 is >= TASK_SIZE.  
But their sum is 0x30000000, which lies in userspace.  In other words, 
you are missing the possibility that the addition might overflow and 
wrap around.

> I thought you wanted the code to check for an upper sane limit for addr
> in kernel-space, say something like this:
> 
> TASK_SIZE <= addr <= (Upper limit for Kernel Virtual Address)

No, the test should be

    TASK_SIZE <= addr <= addr + (len-1) <= (Upper limit for Kernel VA)

By the way, is TASK_SIZE the correct lower bound for kernel virtual
addresses on x86-64?

> When I referred to 'len' in my previous mail, it meant the length
> of the kernel virtual memory area (which can be used to find the upper
> bound).

Oh, sorry, I misunderstood.  Isn't that limit always 0xffffffff on 
x86-32?

Alan Stern

