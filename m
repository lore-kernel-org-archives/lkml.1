Return-Path: <linux-kernel-owner+w=401wt.eu-S933039AbXAaRsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039AbXAaRsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 12:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932955AbXAaRsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 12:48:19 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:48659 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933039AbXAaRsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 12:48:19 -0500
In-Reply-To: <Pine.LNX.4.64.0701301838110.3611@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <1170209044.26655.364.camel@localhost.localdomain> <Pine.LNX.4.64.0701301838110.3611@woody.linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <1FB0094B-4B45-4749-8855-5AFD1A26085D@oracle.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>, Ingo Molnar <mingo@elte.hu>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
Date: Wed, 31 Jan 2007 09:47:42 -0800
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Does that mean that we might not have some cases where we'd need to  
> make
> sure we do things differently? Of course not. Something migt show up.

Might, and has.  For a good time, take journal_info out of  
per_call_chain() in the patch set and watch it helpfully and loudly  
wet itself.  There really really are bits of thread_struct which are  
strictly thread-local-storage, of a sort, for a kernel call path.    
Sharing them, even only through cooperate scheduling, is fatal.   
link_count is another obvious one.

They're also the only ones I've bothered to discover so far :).

> But
> this actually makes it very clear what the difference between "struct
> thread_struct" and "struct task_struct" are. One is shared between
> fibrils, the other isn't.

Indeed.

Right now the per-fibril uses of task_struct members are left inline  
in task_struct and are copied on fibril switches.

We *could* put them in thread_info, at the cost of stack pressure, or  
hang them off task_struct in their own struct to avoid the copies, at  
the cost of indirection.  I didn't like imposing a cost on paths that  
don't use fibrils, though, so I left them inline.

(I think you know all this.  I'm clarifying for the peanut gallery, I  
hope.)

- z
