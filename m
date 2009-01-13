Return-Path: <linux-kernel-owner+w=401wt.eu-S1754941AbZAMTQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941AbZAMTQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 14:16:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbZAMTQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 14:16:15 -0500
Received: from smtp-out.google.com ([216.239.45.13]:39751 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbZAMTQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 14:16:14 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=yfDFbIw5xFHlN4oo6U3OueInNGnelM+duKLM3GNppVE+dNrDHGITTf4Ez8hpaiiFM
	I0g86h0ia/ogEJ93n84AA==
Date: Tue, 13 Jan 2009 11:15:26 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Evgeniy Polyakov <zbr@ioremap.net>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
In-Reply-To: <20090113115408.GA22289@ioremap.net>
Message-ID: <alpine.DEB.2.00.0901131104420.8522@chino.kir.corp.google.com>
References: <20090112155030.GA21063@ioremap.net> <20090112155239.5f677a17@lxorguk.ukuu.org.uk> <20090112155615.GA21350@ioremap.net> <20090112161931.6203f96e@lxorguk.ukuu.org.uk> <20090112162938.GA22647@ioremap.net> <496BCB7A.2010804@tmr.com>
 <20090112231728.GA23803@ioremap.net> <alpine.DEB.2.00.0901121746220.20329@chino.kir.corp.google.com> <20090113085244.GA13796@ioremap.net> <alpine.DEB.2.00.0901130134090.25386@chino.kir.corp.google.com> <20090113115408.GA22289@ioremap.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.24.198.97
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2009, Evgeniy Polyakov wrote:

> Should this explain why ssh is killed?
> 

If you would like to make sshd immune from the oom killer, use

	echo -17 > /proc/$(pidof sshd)/oom_adj

just like any other task.  This score will be inherited by any task that 
it executes, so you'll probably want to readjust your shell's oom_adj 
score appropriately in your rc file.

> It is very subtle approach. Consider the case when you have a pool of
> threads/processes which are created and released on demand, there are
> several such pools for different servers and you do know which one
> will very likely being guilty.
> 
> Who should adjust the scores for newly created processes? Who should
> check that processes in the first group have negative oom ajustment and
> in the second group a positive value? Who determines when its time to
> ajust the scores?
> 

It is userspace's responsibility to set the policy, the kernel merely 
provides the mechanism.

> > With oom_adj scores, you have the ability to specify oom kill preferences 
> > within a cpuset or memory controller as well, whereas oom_victim_name is 
> > global and very costly when not found in select_bad_process().
> >

You chose not to respond to this, which is a major flaw in your approach.  

Your patch makes cpuset and memory controller oom killing much slower 
because it requires two iterations through the system tasklist when your 
global oom_victim_name task is either not running or in a disjoint cpuset 
or memcg.

> It is not really costly, since most of the time we skip an entry and do
> not lock the task and do not calculate its badness value. No one scares
> that 'ps ax' is costly because it has to run through all the processes.
> 

Talk to SGI about oom killer tasklist scans for their large systems; it 
was a prerequisite for me to provide /proc/sys/vm/oom_kill_allocating_task 
to avoid a single scan when I made cpuset-constrained ooms go through 
select_bad_process().
