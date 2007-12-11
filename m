Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbXLKOxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbXLKOxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 09:53:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbXLKOx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 09:53:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35519 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbXLKOx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 09:53:27 -0500
Date: Tue, 11 Dec 2007 15:53:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: ak@suse.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, markut.t.metzger@intel.com,
       markus.t.metzger@gmail.com,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, roland@redhat.com,
       akpm@linux-foundation.org, mtk.manpages@gmail.com,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: x86, ptrace: support for branch trace store(BTS)
Message-ID: <20071211145301.GA19427@elte.hu>
References: <20071210123809.A14251@sedona.ch.intel.com> <20071210202052.GA26002@elte.hu> <029E5BE7F699594398CA44E3DDF5544401130A1E@swsmsx413.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <029E5BE7F699594398CA44E3DDF5544401130A1E@swsmsx413.ger.corp.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Metzger, Markus T <markus.t.metzger@intel.com> wrote:

> That would be a variation on Andi's zero-copy proposal, wouldn't it?
> 
> The user supplies the BTS buffer and the kernel manages DS.
> 
> Andi further suggested a vDSO to interpret the data and translate the 
> hardware format into a higher level user format.
> 
> I take it that you would leave that inside ptrace.

yeah - i think both zero-copy and vdso are probably overkill for this. 

On the highest level, there are two main usecases of BTS that i can 
think of: debugging [a user-space task crashes and developer would like 
to see the last few branches taken - possibly extended to kernel space 
crashes as well], and instrumentation.

In the first use-case (debugging) zero-copy is just an unnecessary 
complication.

In the second use-case (tracing, profiling, call coverage metrics), we 
could live without zero-copy, as long as the buffer could be made "large 
enough". The current 4000 records limit seems rather low (and arbitrary) 
and probably makes the mechanism unsuitable for say call coverage 
profiling purposes. There's also no real mechanism that i can see to 
create a guaranteed flow of this information between the debugger and 
debuggee (unless i missed something), the code appears to overflow the 
array, and destroy earlier entries, right? That's "by design" for 
debugging, but quite a limitation for instrumentation which might want 
to have a reliable stream of the data (and would like the originating 
task to block until the debugger had an opportunity to siphoon out the 
data).

> I need to look more into mlock. So far, I found a system call in 
> /usr/include/sys/mman.h and two functions sys_mlock() and 
> user_shm_lock() in the kernel. Is there a memory expert around who 
> could point me to some interesting places to look at?

sys_mlock() is what i meant - you could just call it internally from 
ptrace and fail the call if sys_mlock() returns -EPERM. This keeps all 
the "there's too much memory pinned down" details out of the ptrace 
code.

> Can we distinguish kernel-locked memory from user-locked memory? I 
> could imagine a malicious user to munlock() the buffer he provided to 
> ptrace.

yeah. Once mlock()-ed, you need to "pin it" via get_user_pages(). That 
gives a permanent reference count to those pages.

> Is there a real difference between mlock()ing user memory and 
> allocating kernel memory? There would be if we could page out 
> mlock()ed memory when the user thread is not running. We would need to 
> disable DS before paging out, and page in before enabling it. If we 
> cannot, then kernel allocated memory would require less space in 
> physical memory.

mlock() would in essence just give you an easy "does this user have 
enough privilege to lock this many pages" API. The real pinning would be 
done by get_user_pages(). Once you have those pages, they wont be 
swapped out.

	Ingo
