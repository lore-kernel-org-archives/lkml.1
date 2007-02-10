Return-Path: <linux-kernel-owner+w=401wt.eu-S1751761AbXBJSpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbXBJSpc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 13:45:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbXBJSpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 13:45:31 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:2862 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbXBJSpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 13:45:31 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 10 Feb 2007 10:45:28 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
In-Reply-To: <Pine.LNX.4.64.0702091519330.8424@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702101034220.11630@alien.or.mcafeemobile.com>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
 <Pine.LNX.4.64.0702091419470.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702091458180.2786@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0702091519330.8424@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Feb 2007, Linus Torvalds wrote:

> > Another, even simpler way IMO, is to just have a plain per-task kthread 
> > pool, and a queue.
> 
> Yes, that is actually quite doable with basically the same interface. It's 
> literally a "small decision" inside of "schedule_async()" on how it 
> actually would want to handle the case of "hey, we now have concurrent 
> work to be done".

For the queue approach, I meant the async_submit() to simply add the 
request (cookie, syscall number and params) inside queue, and not trying 
to execute the syscall. Once you're inside schedule, "stuff" has already 
partially happened, and you cannot have the same request re-initiated by a 
different thread.



> But I actually don't think a per-task kthread pool is necessarily a good 
> idea. If a thread pool works for this, then it should have worked for 
> regular thread create/destroy loads too - ie there really is little reason 
> to special-case the "async system call" case.

A per-process thread pool already has things correctly inherited, so we 
don't need to add special "adopt" routines for things like "files" and such.



> NOTE! I'm also not at all sure that we actually want to waste real threads 
> on this. My patch is in no way meant to be an "exclusive alternative" to 
> fibrils. Quite the reverse, actually: I _like_ those synchronous fibrils, 
> but I didn't like how Zach did the overhead of creating them up-front, 
> because I really would like the cached case to be totally *synchronous*.

I'm not advocating threads against fibrils. The use of threads may make 
things easier under certain POVs (less ad-hoc changes into mainline). The 
ideal would be to have a look at both and see Pros&Cons under different 
POVs (performance, code impact, etc..).



- Davide


