Return-Path: <linux-kernel-owner+w=401wt.eu-S1753781AbZKDB6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbZKDB6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 20:58:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbZKDB6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 20:58:07 -0500
Received: from smtp-out.google.com ([216.239.45.13]:25917 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbZKDB6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 20:58:06 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=I4Z71Etoy+NQ2biyGlbU7UEeO6zfF1zVlfJQS8yJh2y7O4ybrTYQA/YvbmoqKTvch
	YU2mWylgvPMUnBLky2wZA==
Date: Tue, 3 Nov 2009 17:58:04 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: vedran.furac@gmail.com, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, minchan.kim@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Memory overcommit
In-Reply-To: <20091104095021.5532e913.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0911031752180.1187@chino.kir.corp.google.com>
References: <hav57c$rso$1@ger.gmane.org> <alpine.DEB.2.00.0910271723180.17615@chino.kir.corp.google.com> <4AE792B8.5020806@gmail.com> <alpine.DEB.2.00.0910272047430.8988@chino.kir.corp.google.com> <20091028135519.805c4789.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.DEB.2.00.0910272205200.7507@chino.kir.corp.google.com> <20091028150536.674abe68.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0910272311001.15462@chino.kir.corp.google.com> <20091028152015.3d383cd6.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.DEB.2.00.0910290136000.11476@chino.kir.corp.google.com> <4AE97861.1070902@gmail.com> <alpine.DEB.2.00.0910291248480.2276@chino.kir.corp.google.com> <20091030084836.5428e085.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0910300200170.18076@chino.kir.corp.google.com>
 <20091030183638.1125c987.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0911031240470.29695@chino.kir.corp.google.com> <20091104095021.5532e913.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Nov 2009, KAMEZAWA Hiroyuki wrote:

> > That's a different point.  Today, we can influence the badness score of 
> > any user thread to prioritize oom killing from userspace and that can be 
> > done regardless of whether there's a memory leaker, a fork bomber, etc.  
> > The priority based oom killing is important to production scenarios and 
> > cannot be replaced by a heuristic that works everytime if it cannot be 
> > influenced by userspace.
> > 
> I don't removed oom_adj...
> 

Right, but we must ensure that we have the same ability to influence a 
priority based oom killing scheme from userspace as we currently do with a 
relatively static total_vm.  total_vm may not be the optimal baseline, but 
it does allow users to tune oom_adj specifically to identify tasks that 
are using more memory than expected and to be static enough to not depend 
on rss, for example, that is really hard to predict at the time of oom.

That's actually my main goal in this discussion: to avoid losing any 
ability of userspace to influence to priority of tasks being oom killed 
(if you haven't noticed :).

> > Tweaking on the heuristic will probably make it more convoluted and 
> > overall worse, I agree.  But it's a more stable baseline than rss from 
> > which we can set oom killing priorities from userspace.
> 
> - "rss < total_vm_size" always.

But rss is much more dynamic than total_vm, that's my point.

> - oom_adj culculation is quite strong.
> - total_vm of processes which maps hugetlb is very big ....but killing them
>   is no help for usual oom.
> 
> I recommend you to add "stable baseline" knob for user space, as I wrote.
> My patch 6 adds stable baseline bonus as 50% of vm size if run_time is enough
> large.
> 

There's no clear relationship between VM size and runtime.  The forkbomb 
heuristic itself could easily return a badness of ULONG_MAX if one is 
detected using runtime and number of children, as I earlier proposed, but 
that doesn't seem helpful to factor into the scoring. 
