Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbYGWVpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbYGWVpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 17:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754555AbYGWVpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 17:45:34 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:31960 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854AbYGWVpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 17:45:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WFwi1gxphZs9hhTIN/MOFlkUojbBf8rX/lFaJmwCGywUs5xdyej0zbXyRLIA6FxGqb
         PBR+8IIiq/PoCn8Coqe6eZYPiiU2NnzJCzku2VnTk+VdtxTg0CMzvZjVWWeA+0YIbqW/
         uk1a945QDoDVqw6z3/pZuuElgyVF3FmYoU5O8=
Message-ID: <19f34abd0807231445h79fac5cbwecd0563b74bc18ad@mail.gmail.com>
Date: Wed, 23 Jul 2008 23:45:32 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Subject: Re: recent -git: BUG in free_thread_xstate
Cc: "Suresh Siddha" <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <b647ffbd0807231435h73740808p76143d3d4457b597@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807231307y191c0ad7tfab4cda57ee88eb@mail.gmail.com>
	 <20080723203109.GH14380@linux-os.sc.intel.com>
	 <19f34abd0807231352j1ba1414am84ee9683df9b5657@mail.gmail.com>
	 <b647ffbd0807231422w546e59e9p8362ee798b169a25@mail.gmail.com>
	 <b647ffbd0807231435h73740808p76143d3d4457b597@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 11:35 PM, Dmitry Adamushko
<dmitry.adamushko@gmail.com> wrote:
> 2008/7/23 Dmitry Adamushko <dmitry.adamushko@gmail.com>:
>> 2008/7/23 Vegard Nossum <vegard.nossum@gmail.com>:
>>> ------------[ cut here ]------------
>>> WARNING: at kernel/sched_fair.c:815 hrtick_start_fair+0x158/0x170()
>>
>> that's interesting. As a first step and if it's easily reproducible,
>> would you try something like below?
>
> If not, maybe object files are still in-tact? Just to see where
> exactly in schedule() it crashed so maybe we may get an idea on what
> was a result of next = pick_next_task(rq, prev);

Yes, indeed. You mean this part?

BUG: unable to handle kernel paging request at c0804358
IP: [<c057e38d>] schedule+0x1ed/0x850
*pde = 3780e163 *pte = 00804162
Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Pid: 5575, comm: migration/1 Tainted: G        W (2.6.26 #1)
EIP: 0060:[<c057e38d>] EFLAGS: 00010086 CPU: 1
EIP is at schedule+0x1ed/0x850
EAX: c0803f00 EBX: 00000001 ECX: f4d10000 EDX: 00450008
ESI: f4c91fe0 EDI: c0803f00 EBP: f4c85fa0 ESP: f4c85f3c

$ addr2line -e vmlinux -i c057e38d
kernel/sched_stats.h:164
kernel/sched_stats.h:236
kernel/sched_stats.h:242
kernel/sched.c:4191

(Keep in mind that the line numbers are for v2.6.26.)

Looks to be this line (kernel/sched.c):

                sched_info_switch(prev, next);

or for kernel/sched_stats.h:164:

        unsigned long long now = task_rq(t)->clock, delta = 0;

..I'm not sure how much information this is?

Most likely the task_struct just got corrupted, like for the xstate
crashes... Should I still try the patch? :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
