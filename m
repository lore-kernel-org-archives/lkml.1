Return-Path: <linux-kernel-owner+w=401wt.eu-S1753754Ab0AEEtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab0AEEtO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 23:49:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280Ab0AEEtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 23:49:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55067 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753095Ab0AEEtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 23:49:11 -0500
Date: Mon, 4 Jan 2010 20:48:23 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Minchan Kim <minchan.kim@gmail.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, cl@linux-foundation.org,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
In-Reply-To: <28c262361001042029w4b95f226lf54a3ed6a4291a3b@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1001042038110.3630@localhost.localdomain>
References: <20100104182429.833180340@chello.nl>  <20100104182813.753545361@chello.nl>  <20100105092559.1de8b613.kamezawa.hiroyu@jp.fujitsu.com> <28c262361001042029w4b95f226lf54a3ed6a4291a3b@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 5 Jan 2010, Minchan Kim wrote:
> 
> Isn't it protected by get_file and iget?

When the vma is mapped, yes.

> Am I miss something?

remove_vma() will have done a

	fput(vma->vm_file);

and other house-keeping (removing the executable info, doing 
vm_ops->close() etc). 

And that is _not_ done delayed by RCU, and as outlined in my previous 
email I think that if the code really _does_ delay it, then munmap() (and 
exit) need to wait for the RCU callbacks to have been done, because 
otherwise the file may end up being busy "asynchronously" in ways that 
break existing semantics.

Just as an example: imagine a script that does "fork()+execve()" on a 
temporary file, and then after waiting for it all to finish with wait4() 
does some re-write of the file. It currently works. But what if the 
open-for-writing gets ETXTBUSY because the file is still marked as being 
VM_DENYWRITE, and RCU hasn't done all the callbacks?

Or if you do the i_writecount handling synchronously (which is likely fine 
- it really is just for ETXTBUSY handling, and I don't think speculative 
page faults matter), what about a shutdown sequence (or whatever) that 
wants to unmount the filesystem, but the file is still open - as it has to 
be - because the actual close is delayed by RCU.

So the patch-series as-is is fundamentally buggy - and trying to fix it 
seems painful.

I'm also not entirely clear on how the race with page table tear-down vs 
page-fault got handled, but I didn't read the whole patch-series very 
carefully. I skimmed through it and got rather nervous about it all. It 
doesn't seem too large, but it _does_ seem rather cavalier about all the 
object lifetimes.

		Linus
