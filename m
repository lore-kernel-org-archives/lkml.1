Return-Path: <linux-kernel-owner+w=401wt.eu-S1764380AbXJFUyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764380AbXJFUyM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 16:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764409AbXJFUx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 16:53:58 -0400
Received: from smtp-out.google.com ([216.239.45.13]:3023 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764416AbXJFUx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 16:53:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=c4y55e+dj185qkjMdyCMev9eqsrNUZna6X+RzTRfVkq3HpFY9kGIha1vFZJxK9WOy
	LmnB82w4vV3/s1wfnttQg==
Message-ID: <6599ad830710061353k4f596b51qce83b6a7d27e73bc@mail.gmail.com>
Date: Sat, 6 Oct 2007 13:53:53 -0700
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH] task containersv11 add tasks file interface fix for cpusets
Cc: akpm@linux-foundation.org, nickpiggin@yahoo.com.au, a.p.zijlstra@chello.nl,
       serue@us.ibm.com, clg@fr.ibm.com, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com, rientjes@google.com, svaidy@linux.vnet.ibm.com,
       xemul@openvz.org, containers@lists.osdl.org, balbir@linux.vnet.ibm.com
In-Reply-To: <20071006012437.c0fd3a8a.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071003084241.24279.62099.sendpatchset@jackhammer.engr.sgi.com>
	 <6599ad830710030851jb44f00ft9634f9381218b6e9@mail.gmail.com>
	 <20071003105817.7adf6516.pj@sgi.com>
	 <6599ad830710031110r1a74eafej56f20cc33e72ac81@mail.gmail.com>
	 <20071003131632.fed4b848.pj@sgi.com>
	 <6599ad830710031331h15d35e90lc63d845efd2de6f5@mail.gmail.com>
	 <20071006012437.c0fd3a8a.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/6/07, Paul Jackson <pj@sgi.com> wrote:
>
> This isn't working for me.
>
> The key kernel routine for updating a tasks cpus_allowed
> cannot be called while holding a spinlock.
>
> But the above loop holds a spinlock, css_set_lock, between
> the cgroup_iter_start and the cgroup_iter_end.
>
> I end up generating complaints of:
>         BUG: scheduling while atomic
> when I invoke the set_cpus_allowed() above.
>
> Should css_set_lock be a mutex?  Locking changes like that
> can be risky.

css_set_lock is an rwlock currently; I'd rather not turn it into an rw
mutex since there are places that it gets taken where we can't afford
to sleep.

>
> Or perhaps there should be another callback, called only by
> attach() requests back to the same group.  Likely cpusets would
> be the only subsystem interested in plugging that callback.
>
> That, or my original patch, which calls the attach routine
> even if re-attaching to the current cgroup ...

I'd prefer David's solution of grabbing references to tasks during the
iteration and then doing set_cpus_allowed outside the tasklist_lock.

Paul
