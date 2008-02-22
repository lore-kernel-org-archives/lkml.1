Return-Path: <linux-kernel-owner+w=401wt.eu-S932308AbYBVW5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308AbYBVW5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:57:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbYBVW5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:57:25 -0500
Received: from wx-out-0506.google.com ([66.249.82.228]:4251 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947AbYBVW5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:57:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=shwKrfN2chDG6JsXvsTwExgqY0uaBDDC/TjgoXZjj60jJFNIOsn+wJVOOt692K4VM3A7inXJ0RyrJJBrGiB8BavU39c9sEPXv1VevBO+YStTyAqZNZT/cCo0W/F1VKf605Pa4BtTWcXZPfeDR001VD877wuEZpHbSB3Ofoqk+Aw=
Message-ID: <998d0e4a0802221457g5aee11feo1da2f140a02478b8@mail.gmail.com>
Date: Fri, 22 Feb 2008 23:57:22 +0100
From: "J.C. Pizarro" <jcpiza@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Improved idea, to use NR_CPUS task_migrators for SMPs.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kernel/sched.c appears:

static void sched_migrate_task(struct task_struct *p, int dest_cpu)
{
	struct migration_req req;
	unsigned long flags;
	struct rq *rq;

	rq = task_rq_lock(p, &flags);
	if (!cpu_isset(dest_cpu, p->cpus_allowed)
	    || unlikely(cpu_is_offline(dest_cpu)))
		goto out;

	/* force the process onto the specified CPU */
	if (migrate_task(p, dest_cpu, &req)) {
		/* Need to wait for migration thread (might exit: take ref). */
		struct task_struct *mt = rq->migration_thread;

		get_task_struct(mt);
		task_rq_unlock(rq, &flags);  <---- comment #1
		wake_up_process(mt); <---- comment #2
		put_task_struct(mt);
		wait_for_completion(&req.done); <---- comment #3
                                              <---- comment #4
		return;
	}
out:
	task_rq_unlock(rq, &flags);
}

--------------------

* comment #1: why unlock soon this insecure task when it's still incomplete
and preemptible? IMHO, one of the reasons is that this task needs be unlocked
to be manipulated by this code, otherwise it could be deadlocked. But it's not
a good silver bullet.

* comment #2: why wake slowing its migration thread? what is the matter
if the picked task is SUSPENDED, BLOCKED, SIGSTOPed, KILLED or ZOMBIED?
It can ocurr "not running as expected". It's not a good decision.

* comment #3: what ocurrs it if the waiting is eternal as said comment #2
or as be deadlocked preemptibly? Arggghhhh!

I thought that it's better to implement NR_CPUS task_migrators as kernel's
threads-daemons with lockers's mechanisms. For comprension, unlocking
some lockers of the task_migrators and inmediately switching CPU to
migrators is similar to quick awakening of migration_thread.

The being-migrated task "doesn't must know the #cpu that this task is
being runned", and IMHO it's little complicated when the task has
lockers, signals, etc
that depends from #cpu (lockers and more things need be altered when they
are migrated, overall their identifiers).

* comment #4: when sleep the migration thread?

   ;)
