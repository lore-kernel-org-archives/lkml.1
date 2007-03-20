Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbXCTUu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbXCTUu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 16:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbXCTUu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 16:50:27 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:44408 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbXCTUuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 16:50:25 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Ian Kent <raven@themaw.net>, Cedric Le Goater <clg@fr.ibm.com>,
       sukadev@us.ibm.com, Andrew Morton <akpm@osdl.org>,
       Dave Hansen <haveblue@us.ibm.com>,
       Herbert Poetzl <herbert@13thfloor.at>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Replace pid_t in autofs with struct pid reference
References: <20070313045100.GC8993@us.ibm.com>
	<Pine.LNX.4.64.0703161300520.4188@raven.themaw.net>
	<m1ird1o243.fsf@ebiederm.dsl.xmission.com>
	<1174055467.3397.17.camel@raven.themaw.net>
	<45FAAD4F.4000204@fr.ibm.com>
	<1174063618.3397.58.camel@raven.themaw.net>
	<m1hcslm1tc.fsf@ebiederm.dsl.xmission.com>
	<20070319200839.GB19449@sergelap.austin.ibm.com>
	<m1odmpvuft.fsf@ebiederm.dsl.xmission.com>
	<20070320201548.GA21312@sergelap.austin.ibm.com>
Date: Tue, 20 Mar 2007 14:45:03 -0600
In-Reply-To: <20070320201548.GA21312@sergelap.austin.ibm.com> (Serge
	E. Hallyn's message of "Tue, 20 Mar 2007 15:15:48 -0500")
Message-ID: <m17itbmypc.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

> So how about the following on top of the patch Cedric sent out?
>
> Subject: [PATCH] autofs4: store struct pids in autofs_waitqs
> From: Serge Hallyn <serue@us.ibm.com>
> Date: 1174412305 -0500
>
> Store struct pids in autofs_waitqs in place of pidnrs to prevent
> pid overflow problems.

At first skip it doesn't looks ok.

> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
>
> ---
>
>  fs/autofs4/autofs_i.h |   13 +++++++++++--
>  fs/autofs4/waitq.c    |   15 ++++++++-------
>  2 files changed, 19 insertions(+), 9 deletions(-)
>
> 86a5866c7672b88d48380504977496d5637642ab
> diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
> index 3ccec0a..5d119e3 100644
> --- a/fs/autofs4/autofs_i.h
> +++ b/fs/autofs4/autofs_i.h
> @@ -79,8 +79,8 @@ struct autofs_wait_queue {
>  	u64 ino;
>  	uid_t uid;
>  	gid_t gid;
> -	pid_t pid;
> -	pid_t tgid;
> +	struct pid *pid;
> +	struct pid *tgid;
>  	/* This is for status reporting upon return */
>  	int status;
>  	atomic_t wait_ctr;
> @@ -228,5 +228,14 @@ out:
>  	return ret;
>  }
>  
> +static void autofs_free_wait_queue(struct autofs_wait_queue *wq)
> +{
> +	if (wq->pid)
> +		put_pid(wq->pid);
> +	if (wq->tgid)
> +		put_pid(wq->tgid);
> +	kfree(wq);
> +}
> +
>  void autofs4_dentry_release(struct dentry *);
>  extern void autofs4_kill_sb(struct super_block *);
> diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
> index 9857543..4a9ad9b 100644
> --- a/fs/autofs4/waitq.c
> +++ b/fs/autofs4/waitq.c
> @@ -141,8 +141,8 @@ static void autofs4_notify_daemon(struct
>  		packet->ino = wq->ino;
>  		packet->uid = wq->uid;
>  		packet->gid = wq->gid;
> -		packet->pid = wq->pid;
> -		packet->tgid = wq->tgid;
> +		packet->pid = pid_nr(wq->pid);
> +		packet->tgid = pid_nr(wq->tgid);
>  		break;

I'm assuming we build the packet in the process context of the
daemon we are sending it to.  If not we have a problem here.

>  	}
>  	default:
> @@ -292,8 +292,8 @@ int autofs4_wait(struct autofs_sb_info *
>  		wq->ino = autofs4_get_ino(sbi);
>  		wq->uid = current->uid;
>  		wq->gid = current->gid;
> -		wq->pid = pid_nr(task_pid(current));
> -		wq->tgid = pid_nr(task_tgid(current));
> +		wq->pid = get_pid(task_pid(current));
> +		wq->tgid = get_pid(task_tgid(current));
>  		wq->status = -EINTR; /* Status return if interrupted */
>  		atomic_set(&wq->wait_ctr, 2);
>  		mutex_unlock(&sbi->wq_mutex);
> @@ -360,8 +360,9 @@ int autofs4_wait(struct autofs_sb_info *
>  	status = wq->status;
>  
>  	/* Are we the last process to need status? */
> -	if (atomic_dec_and_test(&wq->wait_ctr))
> -		kfree(wq);
> +	if (atomic_dec_and_test(&wq->wait_ctr)) {
> +		autofs_free_wait_queue(wq);
> +	}

Unnecessary braces....
  
>  	return status;
>  }
> @@ -390,7 +391,7 @@ int autofs4_wait_release(struct autofs_s
>  	wq->status = status;
>  
>  	if (atomic_dec_and_test(&wq->wait_ctr)) /* Is anyone still waiting for
> this guy? */
> -		kfree(wq);
> +		autofs_free_wait_queue(wq);
>  	else
>  		wake_up_interruptible(&wq->queue);
>  
> -- 
> 1.1.6


Eric
