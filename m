Return-Path: <linux-kernel-owner+w=401wt.eu-S1756855AbZJ3TYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855AbZJ3TYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 15:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755786AbZJ3TYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 15:24:15 -0400
Received: from smtp-out.google.com ([216.239.33.17]:10751 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587AbZJ3TYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 15:24:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=tCof2UdK/ioIgvSQa+91XC9n/iAsWpMN7oPtakRyRJ2nutLi5LWMhJAZ//dhrekwh
	FVDecXSBnga+alccp5uEw==
Date: Fri, 30 Oct 2009 12:24:08 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: vedran.furac@gmail.com
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, minchan.kim@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Memory overcommit
In-Reply-To: <4AEAF145.3010801@gmail.com>
Message-ID: <alpine.DEB.2.00.0910301218410.31986@chino.kir.corp.google.com>
References: <hav57c$rso$1@ger.gmane.org> <20091026105509.f08eb6a3.kamezawa.hiroyu@jp.fujitsu.com> <4AE5CB4E.4090504@gmail.com> <20091027122213.f3d582b2.kamezawa.hiroyu@jp.fujitsu.com> <Pine.LNX.4.64.0910271843510.11372@sister.anvils>
 <alpine.DEB.2.00.0910271351140.9183@chino.kir.corp.google.com> <4AE78B8F.9050201@gmail.com> <alpine.DEB.2.00.0910271723180.17615@chino.kir.corp.google.com> <4AE792B8.5020806@gmail.com> <alpine.DEB.2.00.0910272047430.8988@chino.kir.corp.google.com>
 <20091028135519.805c4789.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0910272205200.7507@chino.kir.corp.google.com> <20091028150536.674abe68.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0910272311001.15462@chino.kir.corp.google.com>
 <20091028152015.3d383cd6.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0910290136000.11476@chino.kir.corp.google.com> <4AE97861.1070902@gmail.com> <alpine.DEB.2.00.0910291248480.2276@chino.kir.corp.google.com> <4AEAF145.3010801@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Oct 2009, Vedran Furac wrote:

> > The problem you identified in http://pastebin.com/f3f9674a0, however, is a 
> > forkbomb issue where the badness score should never have been so high for 
> > kdeinit4 compared to "test".  That's directly proportional to adding the 
> > scores of all disjoint child total_vm values into the badness score for 
> > the parent and then killing the children instead.
> 
> Could you explain me why ntpd invoked oom killer? Its parent is init. Or
> syslog-ng?
> 

Because it attempted an order-0 GFP_USER allocation and direct reclaim 
could not free any pages.

The task that invoked the oom killer is simply the unlucky task that tried 
an allocation that couldn't be satisified through direct reclaim.  It's 
usually unrelated to the task chosen for kill unless 
/proc/sys/vm/oom_kill_allocating_task is enabled (which SGI requested to 
avoid excessively long tasklist scans).

> > That's the problem, not using total_vm as a baseline.  Replacing that with 
> > rss is not going to solve the issue and reducing the user's ability to 
> > specify a rough oom priority from userspace is simply not an option.
> 
> OK then, if you have a solution, I would be glad to test your patch. I
> won't care much if you don't change total_vm as a baseline. Just make
> random killing history.
> 

The only randomness is in selecting a task that has a different mm from 
the parent in the order of its child list.  Yes, that can be addressed by 
doing a smarter iteration through the children before killing one of them.

Keep in mind that a heuristic as simple as this:

 - kill the task that was started most recently by the same uid, or

 - kill the task that was started most recently on the system if a root
   task calls the oom killer,

would have yielded perfect results for your testcase but isn't necessarily 
something that we'd ever want to see.
