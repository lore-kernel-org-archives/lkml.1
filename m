Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbZA0UbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbZA0UbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 15:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbZA0UbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 15:31:06 -0500
Received: from smtp-out.google.com ([216.239.33.17]:51625 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbZA0UbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 15:31:05 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=OLB2yxZhYCRz6TPn14aJknuY2tpMEwBP7ZyoziYRf31CYRCyG5YPt+Lf3o28P+8vQ
	ltSKd7beS2SjBWx3QW5jg==
Date: Tue, 27 Jan 2009 12:29:20 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nikanth Karthikesan <knikanth@suse.de>
cc: Evgeniy Polyakov <zbr@ioremap.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>,
       =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
In-Reply-To: <200901271707.48770.knikanth@suse.de>
Message-ID: <alpine.DEB.2.00.0901271223280.21124@chino.kir.corp.google.com>
References: <200901211638.23101.knikanth@suse.de> <200901271638.21720.knikanth@suse.de> <alpine.DEB.2.00.0901270316040.25608@chino.kir.corp.google.com> <200901271707.48770.knikanth@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.24.198.69
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009, Nikanth Karthikesan wrote:

> > That's certainly idealistic, but cannot be done in an inexpensive way that
> > would scale with the large systems that clients of cpusets typically use.
> 
> If we kill only the tasks for which cpuset_mems_allowed_intersects() is true 
> on the first pass and even then if we do not get out of oom, we could go over 
> again with this expensive check.

The oom killer has no memory of previous kills, so it's not possible to 
determine if there've been a series of recent needless ones.  Subsequent 
oom conditions should still check for intersection and, since it's only a 
heuristic, a large memory-hogging task will eventually be killed if there 
are no tasks remaining with such an intersection.

I don't know how you're planning on mapping large memory allocations on 
nodes of interest back to specific tasks, however.  Do you have a 
proposal?

> Using this scheme, could kill more no of 
> tasks than required, if a task with lots of memory has moved to a different 
> cpuset.

That's rare, since cpusets are used for NUMA optimizations and a set of 
cpus has a static affinity to certain memory.  It could happen if a 
cpuset's set of allowable nodes is made to be smaller, but that seems like 
it would trigger the oom in the first place and would encourage killing 
tasks with an intersection.
