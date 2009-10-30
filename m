Return-Path: <linux-kernel-owner+w=401wt.eu-S1756640AbZJ3JKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640AbZJ3JKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 05:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756545AbZJ3JKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 05:10:45 -0400
Received: from smtp-out.google.com ([216.239.45.13]:5818 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543AbZJ3JKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 05:10:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ZuPCJdLH3MhU2jHVx5syt2hlvHvYkdZMI1oTtcTY1izX4gNs0ie641TkY8dR4uq/p
	CMZp5fJ2OLlUmT3QpUqPA==
Date: Fri, 30 Oct 2009 02:10:37 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: vedran.furac@gmail.com, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, minchan.kim@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Memory overcommit
In-Reply-To: <20091030084836.5428e085.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0910300200170.18076@chino.kir.corp.google.com>
References: <hav57c$rso$1@ger.gmane.org> <4AE5CB4E.4090504@gmail.com> <20091027122213.f3d582b2.kamezawa.hiroyu@jp.fujitsu.com> <Pine.LNX.4.64.0910271843510.11372@sister.anvils> <alpine.DEB.2.00.0910271351140.9183@chino.kir.corp.google.com> <4AE78B8F.9050201@gmail.com>
 <alpine.DEB.2.00.0910271723180.17615@chino.kir.corp.google.com> <4AE792B8.5020806@gmail.com> <alpine.DEB.2.00.0910272047430.8988@chino.kir.corp.google.com> <20091028135519.805c4789.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0910272205200.7507@chino.kir.corp.google.com>
 <20091028150536.674abe68.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0910272311001.15462@chino.kir.corp.google.com> <20091028152015.3d383cd6.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0910290136000.11476@chino.kir.corp.google.com>
 <4AE97861.1070902@gmail.com> <alpine.DEB.2.00.0910291248480.2276@chino.kir.corp.google.com> <20091030084836.5428e085.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Oct 2009, KAMEZAWA Hiroyuki wrote:

> As I wrote repeatedly,
> 
>    - OOM-Killer itselfs is bad thing, bad situation.

Not necessarily, the memory controller and cpusets uses it quite often to 
enforce it's policy and is standard runtime behavior.  We'd like to 
imagine that our cpuset will never be too small to run all the attached 
jobs, but that happens and we can easily recover from it by killing a 
task.

>    - The kernel can't know the program is bad or not. just guess it.

Totally irrelevant, given your fourth point about /proc/pid/oom_adj.  We 
can tell the kernel what we'd like the oom killer behavior should be if 
the situation arises.

>    - Then, there is no "correct" OOM-Killer other than fork-bomb killer.

Well of course there is, you're seeing this is a WAY too simplistic 
manner.  If we are oom, we want to be able to influence how the oom killer 
behaves and respond to that situation.  You are proposing that we change 
the baseline for how the oom killer selects tasks which we use CONSTANTLY 
as part of our normal production environment.  I'd appreciate it if you'd 
take it a little more seriously.

>    - User has a knob as oom_adj. This is very strong.
> 

Agreed.

> Then, there is only "reasonable" or "easy-to-understand" OOM-Kill.
> "Current biggest memory eater is killed" sounds reasonable, easy to
> understand. And if total_vm works well, overcommit_guess should catch it.
> Please improve overcommit_guess if you want to stay on total_vm.
> 

I don't necessarily want to stay on total_vm, but I also don't want to 
move to rss as a baseline, as you would probably agree.

We disagree about a very fundamental principle: you are coming from a 
perspective of always wanting to kill the biggest resident memory eater 
even for a single order-0 allocation that fails and I'm coming from a 
perspective of wanting to ensure that our machines know how the oom killer 
will react when it is used.  Moving to rss reduces the ability of the user 
to specify an expected oom priority other than polarizing it by either 
disabling it completely with an oom_adj value of -17 or choosing the 
definite next victim with +15.  That's my objection to it: the user cannot 
possibly be expected to predict what proportion of each application's 
memory will be resident at the time of oom.

I understand you want to totally rewrite the oom killer for whatever 
reason, but I think you need to spend a lot more time understanding the 
needs that the Linux community has for its behavior instead of insisting 
on your point of view.
