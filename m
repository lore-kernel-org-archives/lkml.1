Return-Path: <linux-kernel-owner+w=401wt.eu-S1752191AbZG1AKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbZG1AKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 20:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbZG1AKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 20:10:39 -0400
Received: from smtp-out.google.com ([216.239.45.13]:27969 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbZG1AKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 20:10:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:content-id:x-system-of-record;
	b=oWth/u/KbyMkV3+qAVw3PDmQLc/s3tkEo0CJp1fao7NmYhsKaPRrz97bz1GHVr/sg
	52HZ3723rJ7KYAhfWEDcw==
Date: Mon, 27 Jul 2009 17:10:26 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Menage <menage@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch -mmotm] mm: introduce oom_adj_child
In-Reply-To: <6599ad830907271648v41b006c0j727fc09665f4f47e@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0907271658550.27881@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0907261446050.12973@chino.kir.corp.google.com> <6599ad830907271648v41b006c0j727fc09665f4f47e@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="497827084-1972524973-1248739587=:27881"
Content-ID: <alpine.DEB.2.00.0907271706540.27881@chino.kir.corp.google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--497827084-1972524973-1248739587=:27881
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.00.0907271706541.27881@chino.kir.corp.google.com>

On Mon, 27 Jul 2009, Paul Menage wrote:

> On Sun, Jul 26, 2009 at 2:50 PM, David Rientjes<rientjes@google.com> wrote:
> > +If oom_adj_child is set to equal oom_adj, then it will mirror oom_adj whenever
> > +it changes.  This avoids having to set both values when simply tuning oom_adj
> > +and that value should be inherited by all children.
> 
> Maybe have a distinct value for oom_adj_child (the default) that means
> "default to mm->oom_adj" ?
> 

That's implicitly what mm->oom_adj == mm->oom_adj_child means.  If they 
are equal at the time oom_adj is changed, oom_adj_child also changes, but 
if oom_adj_child differs then it remains static.

> Shouldn't oom_adj_child be per-task? Otherwise you're theoretically
> allowing races between different threads that try to fork children
> with different oom_adj values at the same time. Not a particularly
> likely problem, but it seems bad to bake the change of races into the
> API.
> 

Good point, the newly initialized mm can get its oom_adj value from 
current rather than current->mm.

> Also, I'm not sure that the requirement that oom_adj_child be >=
> oom_adj is a good restriction. Sure, if a task gives its child a lower
> oom_adj than itself it's potentially playing with fire, but it may
> well be that the new child is expected todaemonize itself in the very
> near future and hence no longer be the child of the current process. I
> don't think that restricting the values that the sysadmin or root
> processes can apply on the grounds that they might not do what they
> want is the right approach.
> 

Ok, we can allow oom_adj_child to be less than oom_adj for 
CAP_SYS_RESOURCE.

> It would also maybe be nicer to use a prctl() rather than introducing
> yet another file in /proc/<pid> - but I guess that's a style argument
> rather than a strict technical issue.
> 

Right, you had mentioned that to me earlier.  I opted to use procfs 
because it puts all the tunables in one place so adjusting it from 
userspace is easier for applications that care about oom_adj.  prctl() 
only affects signals and capabilities at the moment and lacks any other 
tunables that correspond to functionalities of procfs entities.


Andrew, please disregard this version, I'll be sending a v2 based on 
Paul's comments.
--497827084-1972524973-1248739587=:27881--
