Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809AbXISUAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbXISUAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 16:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750943AbXISUAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 16:00:41 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:34573 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbXISUAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 16:00:40 -0400
Message-ID: <46F17FDC.6030903@nortel.com>
Date: Wed, 19 Sep 2007 14:00:28 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Chuck Ebbert <cebbert@redhat.com>, Antoine Martin <antoine@nagafix.co.uk>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: CFS: some bad numbers with Java/database threading [FIXED]
References: <46E871FE.9010908@nagafix.co.uk> <20070913112427.GA20686@elte.hu> <20070914083246.GA20514@elte.hu> <a781481a0709140306k3faf3585haae26853fe81381c@mail.gmail.com> <46EAA7E4.8020700@nagafix.co.uk> <20070914153216.GA27213@elte.hu> <46F00417.7080301@redhat.com> <20070918224656.GA26719@elte.hu> <46F058EE.1080408@redhat.com> <20070919191837.GA19500@elte.hu>
In-Reply-To: <20070919191837.GA19500@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Sep 2007 20:00:32.0403 (UTC) FILETIME=[BC292E30:01C7FAF7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> > The correct way to tell the kernel that the task is blocked is to use 
> futexes for example, or any kernel-based locking or wait object - there 
> are myriads of APIs for these. (The only well-defined behavior of yield 
> is for SCHED_FIFO/RR tasks - and that is fully preserved in CFS.)

Certainly this is reasonable for applications for which the source is 
available and readily recompilable.  However, there are legacy 
closed-source apps out there expecting sched_yield() to result in a 
reasonable amount of time passing before the task is scheduled again.

Also, there are installed bases of people that may have older versions 
of code that may wish to upgrade to newer kernels without upgrading the 
rest of the system.  It seems odd to force them to update userspace apps 
just because we don't like the undefined semantics.

> To avoid the reoccuring problems of applications mistakenly relying on 
> sched_yield(), we now context-switch on yield very weakly for 
> SCHED_OTHER tasks...

<snip>

> My patch below adds a sysctl flag that triggers a context-switch when 
> yield is called... <snip>    I think the patch 
> cannot hurt (it does not change anything by default) - but we should not 
> turn the workaround flag on by default. If you agree that we should do 
> this, then please pull this single patch from the sched.git tree:

I've always understood one of the kernel's basic tenets to be that we 
don't break userspace without a good reason.  If there are apps out 
there that expect sched_yield() to give up the cpu, it seems 
counter-intuitive to ignore that expectation.

Personally, I'd be in favour of making the context-switch be the default 
behaviour, but at the very least it should be possible to enable a 
"backwards-compatibility mode" for sched_yield().

Chris
