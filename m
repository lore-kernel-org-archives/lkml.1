Return-Path: <linux-kernel-owner+w=401wt.eu-S933003AbZHDQYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003AbZHDQYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 12:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932931AbZHDQYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 12:24:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58283 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932913AbZHDQYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 12:24:47 -0400
Date: Tue, 4 Aug 2009 18:20:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, eranian@gmail.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       robert.richter@amd.com, paulus@samba.org, andi@firstfloor.org,
       mpjohn@us.ibm.com, cel@us.ibm.com, cjashfor@us.ibm.com,
       mucci@eecs.utk.edu, terpstra@eecs.utk.edu,
       perfmon2-devel@lists.sourceforge.net, mtk.manpages@googlemail.com,
       roland@redhat.com
Subject: Re: [PATCH 3/2 -v3] fcntl: F_[SG]ETOWN_EX
Message-ID: <20090804162033.GB5211@redhat.com>
References: <1249029320.6391.72.camel@twins> <20090731141122.a1939712.akpm@linux-foundation.org> <20090801012736.GA30259@redhat.com> <1249314498.7924.133.camel@twins> <20090803171619.GA17876@redhat.com> <1249321637.7924.163.camel@twins> <20090803180602.GA19719@redhat.com> <1249324619.4842.1.camel@laptop> <20090803190231.GA22313@redhat.com> <1249385966.7924.204.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249385966.7924.204.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04, Peter Zijlstra wrote:
>
> +static int f_setown_ex(struct file *filp, unsigned long arg)
> +{
> +	struct f_owner_ex * __user owner_p = (void * __user)arg;
> +	struct f_owner_ex owner;
> +	struct pid *pid;
> +	int type;
> +	int ret;
> +
> +	ret = copy_from_user(&owner, owner_p, sizeof(owner));
> +	if (ret)
> +		return ret;
> +
> +	switch (owner.type) {
> +	case F_OWNER_TID:
> +		type = PIDTYPE_MAX;
> +		break;
> +
> +	case F_OWNER_PID:
> +		type = PIDTYPE_PID;
> +		break;
> +
> +	case F_OWNER_GID:
> +		type = PIDTYPE_PGID;
> +		break;
> +	}

Note that send_sigio()->do_each_pid_task(type) must use the valid
type < PIDTYPE_MAX, or we can crash/etc.

This means f_setown_ex() should be careful with the wrong owner->type,
the switch() above needs

	default:
		return -EINVAL;

> +	rcu_read_lock();
> +	pid = find_vpid(owner.pid);
> +	ret = __f_setown(filp, pid, type, 1);
> +	rcu_read_unlock();
> +
> +	return ret;

Perhaps it makes sense to return -ESRCH if owner.pid && !pid, not
sure.

> @@ -474,16 +540,23 @@ void send_sigio(struct fown_struct *fown
>  	struct task_struct *p;
>  	enum pid_type type;
>  	struct pid *pid;
> +	int group = 1;
>  	
>  	read_lock(&fown->lock);
> +
>  	type = fown->pid_type;
> +	if (type == PIDTYPE_MAX) {
> +		group = 0;
> +		type = PIDTYPE_PID;
> +	}

And send_sigurg() needs the same change. I am not sure we should teach
send_sigurg_to_task() to handle the F_OWNER_TID, but we must ensure
send_sigurg()->do_each_pid_task() won't be called with PIDTYPE_MAX.


Otherwise, personally I think this is what we need to solve the problem.

Oleg.

