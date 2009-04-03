Return-Path: <linux-kernel-owner+w=401wt.eu-S937264AbZDCUoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937264AbZDCUoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 16:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937099AbZDCUoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 16:44:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937248AbZDCUoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 16:44:24 -0400
Date: Fri, 3 Apr 2009 13:41:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Theodore Ts'o" <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>
cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [GIT PULL] Ext3 latency fixes
In-Reply-To: <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0904031329410.7007@localhost.localdomain>
References: <1238742067-30814-1-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.0904031110420.19690@localhost.localdomain> <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 3 Apr 2009, Linus Torvalds wrote:
> 
> The "overwrite" behavior may well be better, but it was smooth enough 
> beforehand too (never having more than ~8MB dirty). The "create big file 
> and sync" workload causes huge fsync pauses, though. IOW, try with
> 
> 	while :
> 	do
> 		time sh -c "dd if=/dev/zero of=bigfile bs=8M count=256 ; sync"
> 	done
> 
> and even really small fsync's end up being at the end of all that 
> unrelated activity, and you see things like
> 
>     fsync(7)                                = 0 <32.756308>

Hmm. So I decided to try with "data=writeback" to see if it really makes 
that big of a difference. It does help, but I still easily trigger 
multi-second pauses:

   fsync(4)                                = 0 <2.447926>
   fsync(4)                                = 0 <4.275472>
   fsync(4)                                = 0 <3.731948>
   fsync(4)                                = 0 <4.020839>
   fsync(6)                                = 0 <3.482735>
   fsync(6)                                = 0 <5.819923>

even though the system _should_ be able to write back the 'bigfile' 
datablocks without any ordering constraint on the fsync.

So at a guess, it now avoids some nasty journal writing ordering issue 
where it has to wait for the previous transaction, and it's probably now 
purely an IO ordering issue.

This is all with your ext3 work, btw. But I also added "rm bigfile" at the 
end of the loop (so that it shouldn't trigge any "write out bigfile early" 
logic), and that didn't seem to make any difference. 

Are we perhaps ending up doing those regular 'bigfile' writes as 
WRITE_SYNC, just because of the global "sync()" call? That's probably a 
bad idea. A "sync" is about pure throughput. It's not about latency like 
"fsync()" is.

		Linus
