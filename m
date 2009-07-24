Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbZGXRra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbZGXRra (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 13:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbZGXRr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 13:47:29 -0400
Received: from smtp-out.google.com ([216.239.33.17]:32130 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbZGXRr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 13:47:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=wQXUHZJgp9pLB24FpMxR901T/PHSof/bw74qazeXChPwjEcq4n4wayQ5Juceeb20W
	Oh/2uVHAsdTUs/dec5HWQ==
MIME-Version: 1.0
In-Reply-To: <20090724172320.GH5878@count0.beaverton.ibm.com>
References: <20090724032033.2463.79256.stgit@hastromil.mtv.corp.google.com>
	 <20090724032200.2463.82408.stgit@hastromil.mtv.corp.google.com>
	 <20090724155041.GF5878@count0.beaverton.ibm.com>
	 <6599ad830907240901w4fc02097k83d0c1012708e6ee@mail.gmail.com>
	 <20090724172320.GH5878@count0.beaverton.ibm.com>
Date: Fri, 24 Jul 2009 10:47:21 -0700
Message-ID: <6599ad830907241047w9a9fff9q4dc68f26a9544398@mail.gmail.com>
Subject: Re: [PATCH 5/6] Makes procs file writable to move all threads by tgid 
	at once
From: Paul Menage <menage@google.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Ben Blum <bblum@google.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       serue@us.ibm.com, lizf@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24, 2009 at 10:23 AM, Matt Helsley<matthltc@us.ibm.com> wrote:
>
> Well, I imagine holding tasklist_lock is worse than cgroup_mutex in some
> ways since it's used even more widely. Makes sense not to use it here..

Just to clarify - the new "procs" code doesn't use cgroup_mutex for
its critical section, it uses a new cgroup_fork_mutex, which is only
taken for write during cgroup_proc_attach() (after all setup has been
done, to ensure that no new threads are created while we're updating
all the existing threads). So in general there'll be zero contention
on this lock - the cost will be the cache misses due to the rwlock
bouncing between the different CPUs that are taking it in read mode.

What happened to the big-reader lock concept from 2.4.x? That would be
applicable here - minimizing the overhead on the critical path when
the write operation is expected to be very rare.

Paul
