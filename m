Return-Path: <linux-kernel-owner+w=401wt.eu-S1752255AbZHCRUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbZHCRUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 13:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751807AbZHCRUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 13:20:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42612 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbZHCRUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 13:20:40 -0400
Date: Mon, 3 Aug 2009 19:16:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, eranian@gmail.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       robert.richter@amd.com, paulus@samba.org, andi@firstfloor.org,
       mpjohn@us.ibm.com, cel@us.ibm.com, cjashfor@us.ibm.com,
       mucci@eecs.utk.edu, terpstra@eecs.utk.edu,
       perfmon2-devel@lists.sourceforge.net, mtk.manpages@googlemail.com,
       roland@redhat.com
Subject: Re: [PATCH 3/2] fcntl: F_[SG]ETOWN_TID
Message-ID: <20090803171619.GA17876@redhat.com>
References: <1248869948.6987.3083.camel@twins> <20090729221703.GA25368@redhat.com> <1248953485.6391.41.camel@twins> <20090730192040.GA9503@redhat.com> <1248984003.4164.0.camel@laptop> <20090730202804.GA13675@redhat.com> <1249029320.6391.72.camel@twins> <20090731141122.a1939712.akpm@linux-foundation.org> <20090801012736.GA30259@redhat.com> <1249314498.7924.133.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249314498.7924.133.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03, Peter Zijlstra wrote:
>
> --- linux-2.6.orig/fs/fcntl.c
> +++ linux-2.6/fs/fcntl.c
> @@ -197,13 +197,15 @@ static int setfl(int fd, struct file * f
>  }
>
>  static void f_modown(struct file *filp, struct pid *pid, enum pid_type type,
> -                     int force)
> +		     int flags)
>  {
>  	write_lock_irq(&filp->f_owner.lock);
> -	if (force || !filp->f_owner.pid) {
> +	if ((flags & FF_SETOWN_FORCE) || !filp->f_owner.pid) {
>  		put_pid(filp->f_owner.pid);
>  		filp->f_owner.pid = get_pid(pid);
>  		filp->f_owner.pid_type = type;
> +		filp->f_owner.task_only =
> +			(type == PIDTYPE_PID && (flags & FF_SETOWN_TID));

Do we need type == PIDTYPE_PID check? FF_SETOWN_TID must imply
PIDTYPE_PID, it is only used by f_setown_tid().

Hmm. Actually I am not sure we should change f_modown() at all. I was
going to suggest this as a subsequent cleanup, but now I am starting
to think it is better to do from the very beginning. Please see below.

> +static int f_setown_tid(struct file *filp, unsigned long arg)
> +{
> +	int flags = FF_SETOWN_FORCE;
> +	struct pid *pid;
> +	int who = arg;
> +	int ret = 0;
> +
> +	if (who < 0)
> +		who = -who;
> +	else
> +		flags |= FF_SETOWN_TID;

Hmm, OK. so fcntl(F_SETOWN_TID, -666) <=> fcntl(F_SETOWN, +666).

Not that I disagree, but I think this should be discussed. Perhaps
F_SETOWN_TID can just reject who < 0.

> +static pid_t f_getown_tid(struct file *filp)
> +{
> +	pid_t tid;
> +
> +	read_lock(&filp->f_owner.lock);
> +	tid = pid_vnr(filp->f_owner.pid);
> +	if (filp->f_owner.pid_type == PIDTYPE_PGID)
> +		tid = 0;
> +	if (!filp->f_owner.task_only)
> +		tid = -tid;

I didn't think about this before... What should F_GETOWN_TID return
if we did F_GETOWN ? (and vice versa). f_getown_tid() returns < 0
if !task_only and ->piD != 0, this helps.

but the caller of F_GETOWN can't know what the returned value actually
means if F_GETOWN_TID was used.


Do we really need fown->task_only? Not only this enlarges fown_struct,
we have to modify f_modown() and f_setown().

Perhaps we can just add

	#define F_PIDTYPE_THREAD	PIDTYPE_MAX

into fcntl.c ? Then,

	static int f_setown_xxx(struct file *filp, unsigned long arg, int force, bool group)
	{
		enum pid_type type;
		struct pid *pid;
		int who = arg;
		int result;

		type = PIDTYPE_PID;
		if (!group)
			type = F_PIDTYPE_THREAD
		else if (who < 0) {
			type = PIDTYPE_PGID;
			who = -who;
		}

		rcu_read_lock();
		pid = find_vpid(who);
		result = __f_setown(filp, pid, type, force);
		rcu_read_unlock();
		return result;
	}

	int f_setown(struct file *filp, unsigned long arg, int force)
	{
		return f_setown_xxx(..., true);
	}

Now we should also change send_sigio/send_sigurg, but this is trivial

		type = fown->pid_type;
	+	if (type == F_PIDTYPE_THREAD)
			type = PIDTYPE_PID;

send_sigio_to_task() is trivial too.

What do you think? I agree, this is a bit hackish, but otoh this lessens
the changes outside of fcntl.h.

Oleg.

