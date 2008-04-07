Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbYDGTEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbYDGTEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 15:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbYDGTD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 15:03:56 -0400
Received: from gw.goop.org ([64.81.55.164]:49040 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244AbYDGTDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 15:03:55 -0400
Message-ID: <47FA6FDD.9060605@goop.org>
Date: Mon, 07 Apr 2008 12:02:53 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080315)
MIME-Version: 1.0
To: Andrea Arcangeli <andrea@qumranet.com>
CC: Christoph Lameter <clameter@sgi.com>, Robin Holt <holt@sgi.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 01/10] emm: mm_lock: Lock a process against reclaim
References: <20080404223048.374852899@sgi.com> <20080404223131.271668133@sgi.com> <47F6B5EA.6060106@goop.org> <20080405004127.GG14784@duo.random>
In-Reply-To: <20080405004127.GG14784@duo.random>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli wrote:
> On Fri, Apr 04, 2008 at 04:12:42PM -0700, Jeremy Fitzhardinge wrote:
>   
>> I think you can break this if() down a bit:
>>
>> 			if (!(vma->vm_file && vma->vm_file->f_mapping))
>> 				continue;
>>     
>
> It makes no difference at runtime, coding style preferences are quite
> subjective.
>   

Well, overall the formatting of that if statement is very hard to read.  
Separating out the logically distinct pieces in to different ifs at 
least shows the reader that they are distinct.
Aside from that, doing some manual CSE to remove all the casts and 
expose the actual thing you're testing for would help a lot (are the 
casts even necessary?).

>> So this is an O(n^2) algorithm to take the i_mmap_locks from low to high 
>> order?  A comment would be nice.  And O(n^2)?  Ouch.  How often is it 
>> called?
>>     
>
> It's called a single time when the mmu notifier is registered. It's a
> very slow path of course. Any other approach to reduce the complexity
> would require memory allocations and it would require
> mmu_notifier_register to return -ENOMEM failure. It didn't seem worth
> it.
>   

It's per-mm though.  How many processes would need to have notifiers?


>> And is it necessary to mush lock and unlock together?  Unlock ordering 
>> doesn't matter, so you should just be able to have a much simpler loop, no?
>>     
>
> That avoids duplicating .text. Originally they were separated. unlock
> can't be a simpler loop because I didn't reserve vm_flags bitflags to
> do a single O(N) loop for unlock. If you do malloc+fork+munmap two
> vmas will point to the same anon-vma lock, that's why the unlock isn't
> simpler unless I mark what I locked with a vm_flags bitflag.

Well, its definitely going to need more comments then.  I assumed it 
would end up locking everything, so unlocking everything would be 
sufficient.

    J
