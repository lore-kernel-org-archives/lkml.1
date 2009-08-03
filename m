Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbZHCTqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbZHCTqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 15:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754638AbZHCTqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 15:46:11 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:56168 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442AbZHCTqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 15:46:10 -0400
Date: Mon, 3 Aug 2009 14:45:55 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Benjamin Blum <bblum@google.com>
Cc: menage@google.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 6/6] Makes procs file writable to move all threads by
	tgid at once
Message-ID: <20090803194555.GA10158@us.ibm.com>
References: <20090731012908.27908.62208.stgit@hastromil.mtv.corp.google.com> <20090731015154.27908.9639.stgit@hastromil.mtv.corp.google.com> <20090803175452.GA5481@us.ibm.com> <2f86c2480908031113y525b6cbdhe418b8a0364c7760@mail.gmail.com> <20090803185556.GA8469@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090803185556.GA8469@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Serge E. Hallyn (serue@us.ibm.com):
> Quoting Benjamin Blum (bblum@google.com):
> > On Mon, Aug 3, 2009 at 1:54 PM, Serge E. Hallyn<serue@us.ibm.com> wrote:
> > > Quoting Ben Blum (bblum@google.com):
> > > What *exactly* is it we are protecting with cgroup_fork_mutex?
> > > 'fork' (as the name implies) is not a good answer, since we should be
> > > protecting data, not code.  If it is solely tsk->cgroups, then perhaps
> > > we should in fact try switching to (s?)rcu.  Then cgroup_fork() could
> > > just do rcu_read_lock, while cgroup_task_migrate() would make the change
> > > under a spinlock (to protect against concurrent cgroup_task_migrate()s),
> > > and using rcu_assign_pointer to let cgroup_fork() see consistent data
> > > either before or after the update...  That might mean that any checks done
> > > before completing the migrate which involve the # of tasks might become
> > > invalidated before the migration completes?  Seems acceptable (since
> > > it'll be a small overcharge at most and can be quickly remedied).
> > 
> > You'll notice where the rwsem is released - not until cgroup_post_fork
> > or cgroup_fork_failed. It doesn't just protect the tsk->cgroups
> > pointer, but rather guarantees atomicity between adjusting
> > tsk->cgroups and attaching it to the cgroups lists with respect to the
> > critical section in attach_proc. If you've a better name for the lock
> > for such a race condition, do suggest.
> 
> No the name is pretty accurate - it's the lock itself I'm objecting
> to.  Maybe it's the best we can do, though.

This is probably a stupid idea, but...  what about having zero
overhead at clone(), and instead, at cgroup_task_migrate(),
dequeue_task()ing all of the affected threads for the duration of
the migrate?

/me prepares to be hit by blunt objects

-serge
