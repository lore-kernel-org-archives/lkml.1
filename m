Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255Ab0BKVRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 16:17:38 -0500
Received: from smtp-out.google.com ([216.239.33.17]:32778 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757111Ab0BKVRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 16:17:37 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=JmkCOF9uT2moFzN497xM9WzrDN2Cm8xg3AyA+f26Sqe2k7s9PorigznU6ouSOqzKX
	UrZS2aYRy/i3Eq14J1MSg==
Date: Thu, 11 Feb 2010 13:17:29 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Lubos Lunak <l.lunak@suse.cz>
cc: Balbir Singh <balbir@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: Improving OOM killer
In-Reply-To: <201002111116.07211.l.lunak@suse.cz>
Message-ID: <alpine.DEB.2.00.1002111303570.1461@chino.kir.corp.google.com>
References: <201002012302.37380.l.lunak@suse.cz> <201002102154.39771.l.lunak@suse.cz> <alpine.DEB.2.00.1002101405530.29007@chino.kir.corp.google.com> <201002111116.07211.l.lunak@suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Feb 2010, Lubos Lunak wrote:

>  I believe that with the algorithm no longer using VmSize and being careful 
> not to count shared memory more than once this would not be an issue and 
> kdeinit would be reasonably safe. KDE does not use _that_ much memory to 
> score higher than something that caused OOM :).
> 

Your suggestion of summing up the memory of the parent and its children 
would clearly bias kdeinit if it forks most of kde's threads as you 
mentioned earlier in the thread.  Imagine it, or another server 
application that Rik mentioned, if all children are first generation: then 
it would always be selected if that it is the only task operating on the 
system.  For a web server, for instance, where each query is handled by a 
seperate thread, we'd obviously prefer to kill a child thread instead of 
making the entire server unresponsive.  That type of algorithm in the oom 
killer and to kill the parent instead is just a non-starter.

>  Our definitions of 'forkbomb' then perhaps differ a bit. I 
> consider 'make -j100' a kind of a forkbomb too, it will very likely overload 
> the machine too as soon as the gcc instances use up all the memory. For that 
> reason also using CPU time <1second will not work here, while using real time 
> <1minute would.
> 

1 minute?  Unless you've got one of SGI's 4K cpu machines where these 1000 
threads would actually get any runtime _at_all_ in such circumstances, 
that threshold is unreasonable.

A valid point that wasn't raised is although we can't always detect out of 
control forking applications, we certainly should do some due diligence in 
making sure other applications aren't unfairly penalized when you do 
make -j100, for example.  That's not the job of the forkbomb detector in 
my heuristic, however, it's the job of the baseline itself.  In such 
scenarios (and when we can't allocate or free any memory), the baseline is 
responsible for identifying these tasks and killing them itself because 
they are using an excessive amount of memory.

>  Your protection seems to cover only "for(;;) if(fork() == 0) break;" , while 
> I believe mine could handle also "make -j100" or the bash forkbomb ":()
> { :|:& };:" (i.e. "for(;;) fork();").
> 

Again, it's not protection against forkbombs: the oom killer is not the 
place where you want to enforce any policy that prohibits that.  

>  Why? It repeatedly causes OOM here (and in fact it is the only common OOM or 
> forkbomb I ever encounter). If OOM killer is the right place to protect 
> against a forkbomb that spawns a large number of 1st level children, then I 
> don't see how this is different.
> 

We're not protecting against a large number of first-generation children, 
we're simply penalizing them because the oom killer chooses to kill a 
large memory-hogging task instead of the parent first.  This shouldn't be 
described as "forkbomb detection" because thats outside the scope of the 
oom killer or VM, for that matter.
