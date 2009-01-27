Return-Path: <linux-kernel-owner+w=401wt.eu-S1755428AbZA0Vve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbZA0Vve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 16:51:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbZA0VvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 16:51:25 -0500
Received: from corega.com.ru ([195.178.208.66]:38215 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbZA0VvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 16:51:25 -0500
Date: Wed, 28 Jan 2009 00:51:18 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, balbir@linux.vnet.ibm.com,
       Nikanth Karthikesan <knikanth@suse.de>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Torvalds <torvalds@linux-foundation.org>,
       Arve Hj?nnev?g <arve@android.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, Paul Menage <menage@google.com>
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
Message-ID: <20090127215118.GA12431@ioremap.net>
References: <20090127155825.D476.KOSAKI.MOTOHIRO@jp.fujitsu.com> <alpine.DEB.2.00.0901262325320.13157@chino.kir.corp.google.com> <20090127164238.D479.KOSAKI.MOTOHIRO@jp.fujitsu.com> <alpine.DEB.2.00.0901262350110.14525@chino.kir.corp.google.com> <20090127093105.GB2646@ioremap.net> <alpine.DEB.2.00.0901270134360.20070@chino.kir.corp.google.com> <20090127134038.GA18119@ioremap.net> <alpine.DEB.2.00.0901271230140.21124@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0901271230140.21124@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 12:37:21PM -0800, David Rientjes (rientjes@google.com) wrote:
> > Well, oom-killer can, since it drops unkillable state from the process
> > mask, that may be not enough though, but it tries more than userspace.
> > 
> 
> The only thing it does is send a SIGKILL and gives the thread access to 
> memory reserves with TIF_MEMDIE, it doesn't drop any unkillable state.  If 

There is a small difference between force_sig_info() and usual
send_sinal() used by kill.

> its victim is hung in D state and the memory reserves do not allow it to 
> return to being runnable, this task will not die and the oom killer would 
> livelock unless given another target.

D-states are different. In the current tree we even have
page_lock_killable(), so it depends.

> > My main point was to haev a way to monitor memory usage and that any
> > process could tune own behaviour according to that information. Which is
> > not realated to the system oom-killer at all. Thus /dev/mem_notify is
> > interested first (and only the first) as a memory usage notification
> > interface and not a way to invoke any kind of 'soft' oom-killer.
> 
> It's a way to prevent invoking the kernel oom killer by allowing userspace 
> notification of events where methods such as droping caches, elevating 
> limits, adding nodes, sending signals, etc, can prevent such a problem.  
> When the system (or cgroup) is completely oom, it can also issue SIGKILLs 
> that will free some memory and preempt the oom killer from acting.
> 
> I think there might be some confusion about my proposal for extending 
> /dev/mem_notify.  Not only should it notify of certain low memory events, 
> but it should also allow userspace notification of oom events, just like 
> the cgroup oom notifier patch allowed.  Instead of attaching a task to a 
> cgroup file in that case, however, this would simply be the responsibility 
> of a task that has set up a poll() on the cgroup's mem_notify file.  A 
> configurable delay could be imposed so page allocation attempts simply 
> loop while the userspace handler responds and then only invoke the oom 
> killer when absolutely necessary.

I have really no objections against this and extending oom-killer to
allow to wait a bit in the allocation path before userspace makes some
progress. But do not drop existing oom-killer (i.e. its ability to kill
processes) in favour of this new feature. Let's have both and if
extension failed for some reason, old oom-killer will do the things.

-- 
	Evgeniy Polyakov
