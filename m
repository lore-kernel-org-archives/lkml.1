Return-Path: <linux-kernel-owner+w=401wt.eu-S1752019AbZA0Uis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbZA0Uis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 15:38:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbZA0Uii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 15:38:38 -0500
Received: from smtp-out.google.com ([216.239.33.17]:52044 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbZA0Uih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 15:38:37 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=MMVV50iNRQOwn+iNFktkyUVi/l6GHXqBY3KYLKdpoQOAM3yKm/KviVlFEU2k3PMvN
	bJwIv2S2yZQzBMuMp5Vpg==
Date: Tue, 27 Jan 2009 12:37:21 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Evgeniy Polyakov <zbr@ioremap.net>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, balbir@linux.vnet.ibm.com,
       Nikanth Karthikesan <knikanth@suse.de>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Torvalds <torvalds@linux-foundation.org>,
       Arve Hj?nnev?g <arve@android.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, Paul Menage <menage@google.com>
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
In-Reply-To: <20090127134038.GA18119@ioremap.net>
Message-ID: <alpine.DEB.2.00.0901271230140.21124@chino.kir.corp.google.com>
References: <20090127155825.D476.KOSAKI.MOTOHIRO@jp.fujitsu.com> <alpine.DEB.2.00.0901262325320.13157@chino.kir.corp.google.com> <20090127164238.D479.KOSAKI.MOTOHIRO@jp.fujitsu.com> <alpine.DEB.2.00.0901262350110.14525@chino.kir.corp.google.com>
 <20090127093105.GB2646@ioremap.net> <alpine.DEB.2.00.0901270134360.20070@chino.kir.corp.google.com> <20090127134038.GA18119@ioremap.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.28.16.144
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009, Evgeniy Polyakov wrote:

> > There is no additional oom killer limitation imposed here, nor can the oom 
> > killer kill a task hung in D state any better than userspace.
> 
> Well, oom-killer can, since it drops unkillable state from the process
> mask, that may be not enough though, but it tries more than userspace.
> 

The only thing it does is send a SIGKILL and gives the thread access to 
memory reserves with TIF_MEMDIE, it doesn't drop any unkillable state.  If 
its victim is hung in D state and the memory reserves do not allow it to 
return to being runnable, this task will not die and the oom killer would 
livelock unless given another target.

> My main point was to haev a way to monitor memory usage and that any
> process could tune own behaviour according to that information. Which is
> not realated to the system oom-killer at all. Thus /dev/mem_notify is
> interested first (and only the first) as a memory usage notification
> interface and not a way to invoke any kind of 'soft' oom-killer.

It's a way to prevent invoking the kernel oom killer by allowing userspace 
notification of events where methods such as droping caches, elevating 
limits, adding nodes, sending signals, etc, can prevent such a problem.  
When the system (or cgroup) is completely oom, it can also issue SIGKILLs 
that will free some memory and preempt the oom killer from acting.

I think there might be some confusion about my proposal for extending 
/dev/mem_notify.  Not only should it notify of certain low memory events, 
but it should also allow userspace notification of oom events, just like 
the cgroup oom notifier patch allowed.  Instead of attaching a task to a 
cgroup file in that case, however, this would simply be the responsibility 
of a task that has set up a poll() on the cgroup's mem_notify file.  A 
configurable delay could be imposed so page allocation attempts simply 
loop while the userspace handler responds and then only invoke the oom 
killer when absolutely necessary.

> Application can do whatever it wants of course including killing itself
> or the neighbours, but this should not be forced as a usage policy.
> 

If preference killing is your goal, then userspace can do it with the 
/dev/mem_notify functionality.
