Return-Path: <linux-kernel-owner+w=401wt.eu-S1755718AbZAMTgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbZAMTgx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 14:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbZAMTgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 14:36:43 -0500
Received: from smtp-out.google.com ([216.239.33.17]:7911 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbZAMTgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 14:36:43 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=vHrpnSpCpbFYty9W4XEEFI2kvz8I4cdDeV21y5EIpoktx5tpTiBErO3REOIZP+ojc
	Jos1buSpe/tCOzHGZCsbg==
Date: Tue, 13 Jan 2009 11:36:04 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Evgeniy Polyakov <zbr@ioremap.net>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
In-Reply-To: <20090113122904.GC25011@ioremap.net>
Message-ID: <alpine.DEB.2.00.0901131116220.8522@chino.kir.corp.google.com>
References: <20090112155615.GA21350@ioremap.net> <20090112161931.6203f96e@lxorguk.ukuu.org.uk> <20090112162938.GA22647@ioremap.net> <496BCB7A.2010804@tmr.com> <20090112231728.GA23803@ioremap.net> <alpine.DEB.2.00.0901121746220.20329@chino.kir.corp.google.com>
 <20090113085244.GA13796@ioremap.net> <alpine.DEB.2.00.0901130134090.25386@chino.kir.corp.google.com> <20090113115408.GA22289@ioremap.net> <20090113121510.68a55fe9@lxorguk.ukuu.org.uk> <20090113122904.GC25011@ioremap.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.28.16.146
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2009, Evgeniy Polyakov wrote:

> Don't you notice how many 'who' were placed and only single 'user space'
> answer? Becasue it is not an answer, it is a theoretical POV, which does
> not really work in practice, since it is way too unconvenient and
> error-prone, and actually it does not work when needed, since because of
> its complexity something will be missed. I've just talked with the
> admins who originally requested 'kill-by-name' feature why they did not
> work with /proc/.../oom_adj, and got a nice answer: we tries, but
> likely something went wrong and it did not work the way we wanted.
> 
> There is no way to know that adjustment is correct, that everything was
> uptodate when oom happend, that nothing was forgotten and practice shows
> that there are always such problems and invalid tasks are killed.
> 
> When you put a name you do know that it works, since it is only single
> place to be updated and no need to bother with ugly tools or changes
> especially to handle short-living processes.
> 

The goal of the oom killer is to kill a rogue memory hogging task, which 
will lead to future memory freeing once the task dies, and allow the 
system or container to resume normal operation.

You're not realizing the power of /proc/pid/oom_adj: it allows you to tune 
the badness scoring so that YOU, the user, may determine what the 
definition of 'rogue' is on a task-by-task basis.

Your patch simply allows users to specify a task by name that will always 
be killed first when the oom killer is invoked.  That's terribly 
insufficient if another task uses an excessive amount of memory that you 
didn't expect; a rogue task may be leaking memory and the task you've 
identified by name with your patch is repeatedly forked and killed when 
the rogue task goes untouched.

With oom_adj scores, you can easily specify at what point each task should 
be considered rogue.  You can elevate the oom_adj score for those you have 
a preference to kill and reduce the oom_adj score for those that you'd 
prefer being deferred _unless_ they get sufficiently out of hand.

Your patch presents a shortcut where the entire badness scoring (and, 
thus, all oom_adj scores) is ignored if the named task exists.  That not 
only has syncronization issues, but also can cause the kernel to loop 
forever in killing a task by the same name without ever freeing memory for 
anything else.

Additionally, your patch completely breaks cpuset oom killing since 
candidacy is determined in badness() because a task may have allocated 
non-migrated memory elsewhere before being moved to a different cpuset.  
Your oom_victim_name task may exist globally, but will always be 
identified for oom kill even when the oom exists exclusively in a disjoint 
cpuset.  That does _not_ lead to future memory freeing that current can 
use, and if the parent of the killed task decides to immediately fork 
another instance, this cpuset will be completely livelocked. 
