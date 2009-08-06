Return-Path: <linux-kernel-owner+w=401wt.eu-S1752111AbZHFK2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbZHFK2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 06:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbZHFK2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 06:28:31 -0400
Received: from smtp-out.google.com ([216.239.33.17]:47755 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbZHFK2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 06:28:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	content-type:content-transfer-encoding:x-system-of-record;
	b=mP762EKbHS8aJNL6XZFZlGCvLv1egfc3xfbuDUSZlKzkoAjlvCL++n6jMxwjCx15h
	5bx3Oap+JYOfeb5w6WipQ==
MIME-Version: 1.0
In-Reply-To: <20090806095854.GD26446@hawkmoon.kerlabs.com>
References: <2f86c2480908031113y525b6cbdhe418b8a0364c7760@mail.gmail.com>
	 <20090803194555.GA10158@us.ibm.com>
	 <6599ad830908041148h6d3f3e9bxfef9f3eedec0ab6d@mail.gmail.com>
	 <2f86c2480908041214r1f23c1b7q9a25b04e26c92a1a@mail.gmail.com>
	 <6599ad830908041228w67bc6f7fh57e28f244e1923b3@mail.gmail.com>
	 <20090805102057.GT29252@hawkmoon.kerlabs.com>
	 <6599ad830908050911t6f23f810i65fe8fe17f3ee698@mail.gmail.com>
	 <20090805164218.GB26446@hawkmoon.kerlabs.com>
	 <2f86c2480908051701s57120404q475edbedb58cdca1@mail.gmail.com>
	 <20090806095854.GD26446@hawkmoon.kerlabs.com>
Date: Thu, 6 Aug 2009 03:28:23 -0700
Message-ID: <6599ad830908060328y21a008c1pc5ed5c27e0ec905d@mail.gmail.com>
Subject: Re: [PATCH 6/6] Makes procs file writable to move all threads by tgid 
	at once
From: Paul Menage <menage@google.com>
To: Benjamin Blum <bblum@google.com>, Paul Menage <menage@google.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 6, 2009 at 2:58 AM, Louis Rilling<Louis.Rilling@kerlabs.com> wrote:
>
> mutex_lock_nested is not enough, since this would require putting each thread's
> mutex in a different class. Again, something like mutex_lock_nest_lock() is
> the solution, especially since Peter's recent improvement.
>

OK, well if lockdep can't currently handle the "writer takes a lock on
every thread" model, then maybe we should go with a simpler model
until someone shows a performance issue with it? Ben's original
patches had a per-task_struct lock, and a thread forking with CLONE_VM
would down_read() its group leader's lock. Something that's even
simpler (doesn't have to deal with thread group leader changing due to
an execve()), and avoids the per-task_struct overhead would be to put
the lock in sighand_struct instead (so only one per process). The
procs file writer does a down_write(&tsk->sighand->fork_sem), and
cgroup_fork() can do a down_read(&current->sighand->fork_sem) if
flags&CLONE_SIGHAND.

If you put it as the second member of sighand_struct, there wouldn't
even be any extra cacheline bouncing in the common case, since
copy_sighand() would already have brought that line into cache in
order to do atomic_inc(&current->sighand->count)

Paul
