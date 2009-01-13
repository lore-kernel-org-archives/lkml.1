Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbZAMVqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbZAMVqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 16:46:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbZAMVqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 16:46:30 -0500
Received: from tservice.net.ru ([195.178.208.66]:45710 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381AbZAMVq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 16:46:29 -0500
Date: Wed, 14 Jan 2009 00:46:27 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: David Rientjes <rientjes@google.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090113214627.GC27227@ioremap.net>
References: <20090112162938.GA22647@ioremap.net> <496BCB7A.2010804@tmr.com> <20090112231728.GA23803@ioremap.net> <alpine.DEB.2.00.0901121746220.20329@chino.kir.corp.google.com> <20090113085244.GA13796@ioremap.net> <alpine.DEB.2.00.0901130134090.25386@chino.kir.corp.google.com> <20090113115408.GA22289@ioremap.net> <20090113121510.68a55fe9@lxorguk.ukuu.org.uk> <20090113122904.GC25011@ioremap.net> <alpine.DEB.2.00.0901131116220.8522@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0901131116220.8522@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 11:36:04AM -0800, David Rientjes (rientjes@google.com) wrote:
> The goal of the oom killer is to kill a rogue memory hogging task, which 
> will lead to future memory freeing once the task dies, and allow the 
> system or container to resume normal operation.
> 
> You're not realizing the power of /proc/pid/oom_adj: it allows you to tune 
> the badness scoring so that YOU, the user, may determine what the 
> definition of 'rogue' is on a task-by-task basis.
> 
> Your patch simply allows users to specify a task by name that will always 
> be killed first when the oom killer is invoked.  That's terribly 
> insufficient if another task uses an excessive amount of memory that you 
> didn't expect; a rogue task may be leaking memory and the task you've 
> identified by name with your patch is repeatedly forked and killed when 
> the rogue task goes untouched.

It is up to user to decide, exactly the same will happen if you tune the
oom_adj for the task.

> With oom_adj scores, you can easily specify at what point each task should 
> be considered rogue.  You can elevate the oom_adj score for those you have 
> a preference to kill and reduce the oom_adj score for those that you'd 
> prefer being deferred _unless_ they get sufficiently out of hand.

No, you can not. Did you try that? The only sane way to use oom_adj is
to disable oom killer for the task or make its score very small or very
big, there is really no way to make a finegrained tuning, since score
changes and userspace does not know the algorithm.

> Your patch presents a shortcut where the entire badness scoring (and, 
> thus, all oom_adj scores) is ignored if the named task exists.  That not 
> only has syncronization issues, but also can cause the kernel to loop 
> forever in killing a task by the same name without ever freeing memory for 
> anything else.

No, that's not what it does. Patch allows to select process with the
highest score among those who have appropriate name. Please check it
twice.

> Additionally, your patch completely breaks cpuset oom killing since 
> candidacy is determined in badness() because a task may have allocated 
> non-migrated memory elsewhere before being moved to a different cpuset.  
> Your oom_victim_name task may exist globally, but will always be 
> identified for oom kill even when the oom exists exclusively in a disjoint 
> cpuset.  That does _not_ lead to future memory freeing that current can 
> use, and if the parent of the killed task decides to immediately fork 
> another instance, this cpuset will be completely livelocked. 

Please check the patch first. It selects process according to the
badness, check memory group first and fallbacks to scan other processes
if process with the given name was not found or name is null.

User does not work with the some magically calculated scores, he just
starts the processes and knows only their names. User can specify pid,
but in the case of short-living connections it is not possible. Changing
parent oom score opens a huge possibility to kill it, while in case of
some application server (or database) it should never be killed, and
only some of its clients (which work for the users and not for the
calculating backend for example) have to be killed.

There is no way to implement it with short-living pids (they are
unknown, if inotify worked with the /proc it could be doable though,
except that special daemon is needed) and can not change the parent's
score as was suggested.

You claim that existing scheme works, but in practice it does not.
So I created a patch which somehow makes the solution closer. It is not
perfect, but it works compared to what was suggested from the
theoretical point of view.

-- 
	Evgeniy Polyakov
