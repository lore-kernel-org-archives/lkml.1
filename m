Return-Path: <linux-kernel-owner+w=401wt.eu-S1753273AbXJGGPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbXJGGPk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 02:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbXJGGPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 02:15:31 -0400
Received: from smtp-out.google.com ([216.239.45.13]:29905 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbXJGGPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 02:15:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=h1g9N9OC+oKwoM1Ua6UGWRksO5dGhA9stuXJD2UTEZlL880CkYmuJlkojGaCPVul4
	WLJusxZdjq7XM8eO+deQA==
Date: Sat, 6 Oct 2007 23:15:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Menage <menage@google.com>
cc: Paul Jackson <pj@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       nickpiggin@yahoo.com.au, a.p.zijlstra@chello.nl, serue@us.ibm.com,
       clg@fr.ibm.com, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
       svaidy@linux.vnet.ibm.com, xemul@openvz.org, containers@lists.osdl.org,
       balbir@linux.vnet.ibm.com
Subject: Re: [PATCH] task containersv11 add tasks file interface fix for
 cpusets
In-Reply-To: <6599ad830710061411l3fb9368al319a80469d54946e@mail.gmail.com>
Message-ID: <alpine.DEB.0.9999.0710062250590.11526@chino.kir.corp.google.com>
References: <20071003084241.24279.62099.sendpatchset@jackhammer.engr.sgi.com>  <6599ad830710030851jb44f00ft9634f9381218b6e9@mail.gmail.com>  <20071003105817.7adf6516.pj@sgi.com>  <6599ad830710031110r1a74eafej56f20cc33e72ac81@mail.gmail.com> 
 <20071003131632.fed4b848.pj@sgi.com>  <6599ad830710031331h15d35e90lc63d845efd2de6f5@mail.gmail.com>  <20071006012437.c0fd3a8a.pj@sgi.com>  <alpine.DEB.0.9999.0710061047400.24311@chino.kir.corp.google.com>
 <6599ad830710061411l3fb9368al319a80469d54946e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Oct 2007, Paul Menage wrote:

> > The getting and putting of the tasks will prevent them from exiting or
> > being deallocated prematurely.  But this is also a critical section that
> > will need to be protected by some mutex so it doesn't race with other
> > set_cpus_allowed().
> 
> Is that necessary? If some other process calls set_cpus_allowed()
> concurrently with a cpuset cpus update, it's not clear that there's
> any defined serialization semantics that have to be achieved, as long
> as the end result is that the task's cpus_allowed are within the
> cpuset's cpus_allowed.
> 

It can race with sched_setaffinity().  It has to give up tasklist_lock as 
well to call set_cpus_allowed() and can race

	cpus_allowed = cpuset_cpus_allowed(p);
	cpus_and(new_mask, new_mask, cpus_allowed);
	retval = set_cpus_allowed(p, new_mask);

and allow a task to have a cpu outside of the cpuset's new cpus_allowed if 
you've taken it away between cpuset_cpus_allowed() and set_cpus_allowed().

		David
