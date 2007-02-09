Return-Path: <linux-kernel-owner+w=401wt.eu-S1752516AbXBIXL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbXBIXL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 18:11:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbXBIXL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 18:11:58 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:2011 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbXBIXL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 18:11:57 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 9 Feb 2007 15:11:53 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
In-Reply-To: <Pine.LNX.4.64.0702091419470.8424@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702091458180.2786@alien.or.mcafeemobile.com>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
 <Pine.LNX.4.64.0702091419470.8424@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Feb 2007, Linus Torvalds wrote:

> 
> Ok, here's another entry in this discussion.

That's another way to do it. But you end up creating/destroying a new 
thread for every request. May be performing just fine.
Another, even simpler way IMO, is to just have a plain per-task kthread 
pool, and a queue. An async_submit() drops a request in the queue, and 
wakes the requests queue-head where the kthreads are sleeping. One kthread 
picks up the request, service it, drops a result in the result queue, and 
wakes results queue-head (where async_fetch() are sleeping). Cancellation 
is not problem here (by the mean of sending a signal to the service 
kthread). Also, no problem with arch-dependent code. This is a 1:1 
match of what my userspace implementation does.
Of course, no hot-path optimization are performed here, and you need a few 
context switches more than necessary.
Let's have Zach (Ingo support to Zach would be great) play with the 
optimized version, and then we can maybe bench the three to see if the 
more complex code that the optimized version require, gets a pay-back from 
the performance side.

/me thinks it likely will



- Davide


