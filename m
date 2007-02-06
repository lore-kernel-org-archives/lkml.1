Return-Path: <linux-kernel-owner+w=401wt.eu-S1030195AbXBFW3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030195AbXBFW3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 17:29:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030200AbXBFW3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 17:29:25 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:17375 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030195AbXBFW3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 17:29:24 -0500
In-Reply-To: <Pine.LNX.4.64.0702061348160.8424@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702061238300.8424@woody.linux-foundation.org> <20070206.131631.82049180.davem@davemloft.net> <Pine.LNX.4.64.0702061325380.8424@woody.linux-foundation.org> <20070206.133140.91442326.davem@davemloft.net> <Pine.LNX.4.64.0702061348160.8424@woody.linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <9BE4FD9B-5829-46D1-B9BA-B475261A4116@oracle.com>
Cc: David Miller <davem@davemloft.net>, kent.overstreet@gmail.com,
       davidel@xmailserver.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux-aio@kvack.org, suparna@in.ibm.com, bcrl@kvack.org
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Date: Tue, 6 Feb 2007 17:28:31 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> That's not how the patches work right now, but yes, I at least  
> personally
> think that it's something we should aim for (ie the interface  
> shouldn't
> _require_ us to always wait for things even if perhaps an early
> implementation might make everything be delayed at first)

I agree that we shouldn't require a seperate syscall just to get the  
return code from ops that didn't block.

It doesn't seem like much of a stretch to imagine a setup where we  
can specify completion context as part of the submission itself.

	declare_empty_ring(ring);
	struct submission sub;

	sub.ring = &ring;
	sub.nr = SYS_fstat64;
	sub.args == ...

	ret = submit(&sub, 1);
	if (ret == 0) {
		wait_for_elements(&ring, 1);
		printf("stat gave %d\n", ring[ring->head].rc);
	}

You get the idea, it's just an outline.

wait_for_elements() could obviously check the ring before falling  
back to kernel sync.  I'm pretty keen on the notion of producer/ 
consumer rings where userspace writes the head as it plucks  
completions and the kernel writes the tail as it adds them.

We might want per-call ring pointers, instead of per submission, to  
help submitters wait for a group of ops to complete without having to  
do their own tracking on event completion.  That only makes sense if  
we have the waiting mechanics let you only be woken as the number of  
events in the ring crosses some threshold.  Which I think we want  
anyway.

We'd be trading building up a specific completion state with syscalls  
for some complexity during submission that pins (and kmaps on  
completion) the user pages.  Submission could return failure if  
pinning these new pages would push us over some rlimit.  We'd have to  
be *awfully* careful not to let userspace corrupt (munmap?) the ring  
and confuse the hell out of the kernel.

Maybe not worth it, but if we *really* cared about making the non- 
blocking case almost identical to the sync case and wanted to use the  
same interface for batch submission and async completion then this  
seems like a possibility.

- z
