Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637Ab0BLAWF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 19:22:05 -0500
Received: from smtp-out.google.com ([216.239.33.17]:52686 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757348Ab0BLAWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 19:22:01 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=anMnPOyQ7mostXRTXCxGTLKzZulEXgMe9DUXEK5O6Duxcua/LObDEVygQ+rpeUuNr
	lkqLc3l1c3smHOvN0S/qA==
Date: Thu, 11 Feb 2010 16:21:54 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 7/7 -mm] oom: remove unnecessary code and cleanup
In-Reply-To: <20100212091237.adb94384.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1002111619370.13384@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002100224210.8001@chino.kir.corp.google.com> <alpine.DEB.2.00.1002100230010.8001@chino.kir.corp.google.com> <20100212091237.adb94384.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Feb 2010, KAMEZAWA Hiroyuki wrote:

> > Remove the redundancy in __oom_kill_task() since:
> > 
> >  - init can never be passed to this function: it will never be PF_EXITING
> >    or selectable from select_bad_process(), and
> > 
> >  - it will never be passed a task from oom_kill_task() without an ->mm
> >    and we're unconcerned about detachment from exiting tasks, there's no
> >    reason to protect them against SIGKILL or access to memory reserves.
> > 
> > Also moves the kernel log message to a higher level since the verbosity
> > is not always emitted here; we need not print an error message if an
> > exiting task is given a longer timeslice.
> > 
> > Signed-off-by: David Rientjes <rientjes@google.com>
> 
> If you say "never", it's better to add BUG_ON() rather than 
> if (!p->mm)...
> 

As the description says, oom_kill_task() never passes __oom_kill_task() a 
task, p, where !p->mm, but it doesn't imply that p cannot detach its ->mm 
before __oom_kill_task() gets a chance to run.  The point is that we don't 
really care about giving it access to memory reserves anymore since it's 
exiting and won't be allocating anything.  Warning about that scenario is 
unnecessary and would simply spam the kernel log, a recall to the oom 
killer would no longer select this task in case the oom condition persists 
anyway.

> But yes, this patch seesm to remove unnecessary codes.
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 

Thanks!
