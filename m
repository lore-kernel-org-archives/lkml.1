Return-Path: <linux-kernel-owner+w=401wt.eu-S1759888AbYFXRbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759888AbYFXRbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 13:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbYFXRbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 13:31:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751662AbYFXRbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 13:31:13 -0400
Date: Tue, 24 Jun 2008 10:30:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [rfc patch 3/4] splice: remove confirm from
 pipe_buf_operations
In-Reply-To: <E1KB6p9-0001Gq-Fd@pomaz-ex.szeredi.hu>
Message-ID: <alpine.LFD.1.10.0806241022120.2926@woody.linux-foundation.org>
References: <20080621154607.154640724@szeredi.hu> <20080621154726.494538562@szeredi.hu> <20080624080440.GJ20851@kernel.dk> <E1KB4Id-0000un-PV@pomaz-ex.szeredi.hu> <20080624111913.GP20851@kernel.dk> <E1KB6p9-0001Gq-Fd@pomaz-ex.szeredi.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Jun 2008, Miklos Szeredi wrote:
> 
> OK it could be done, possibly at great pain.  But why is it important?
> What's the use case where it matters that splice-in should not block
> on the read?

If you're splicing from one file to another, the _goal_ you should have is 
that you want to have a mode where you can literally steal the page, and 
never _ever_ be IO-synchronous (well, meta-data accesses will be, you 
can't really avoid that sanely).

IOW, it should be possible to do a

 - splice() file->pipe with SPLICE_STEAL
	don't even wait for the read to finish!

 - splice() pipe->file
	insert the page into the destination page cache, mark it dirty

an no, we probably do not support that yet (for example, I wouldn't be 
surprised if "dirty + !uptodate" is considered an error for the VM even 
though the page should still be locked from the read), but it really was a 
design goal.

Also, asynchronous is important even when you "just" want to overlap IO 
with CPU, so even if it's going to the network, then if you can delay the 
"wait for IO to complete" until the last possible moment (ie the _second_ 
splice, when you end up copying it into an SKB, then both your throughput 
and your latency are likely going to be noticeably better, because you've 
now been able to do a lot of the costly CPU work (system exit + entry at 
the least, but hopefully a noticeable portion of the TCP stack too) 
overlapped with the disk seeking.

So asynchronous ops was really one of the big goals for splice. 

			Linus
