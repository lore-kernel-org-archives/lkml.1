Return-Path: <linux-kernel-owner+w=401wt.eu-S933068AbZHDQxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068AbZHDQxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 12:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932930AbZHDQxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 12:53:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:55010 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932903AbZHDQxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 12:53:22 -0400
Subject: Re: [PATCH 3/2 -v3] fcntl: F_[SG]ETOWN_EX
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, eranian@gmail.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       robert.richter@amd.com, paulus@samba.org, andi@firstfloor.org,
       mpjohn@us.ibm.com, cel@us.ibm.com, cjashfor@us.ibm.com,
       mucci@eecs.utk.edu, terpstra@eecs.utk.edu,
       perfmon2-devel@lists.sourceforge.net, mtk.manpages@googlemail.com,
       roland@redhat.com
In-Reply-To: <20090804162033.GB5211@redhat.com>
References: <1249029320.6391.72.camel@twins>
	 <20090731141122.a1939712.akpm@linux-foundation.org>
	 <20090801012736.GA30259@redhat.com> <1249314498.7924.133.camel@twins>
	 <20090803171619.GA17876@redhat.com> <1249321637.7924.163.camel@twins>
	 <20090803180602.GA19719@redhat.com> <1249324619.4842.1.camel@laptop>
	 <20090803190231.GA22313@redhat.com> <1249385966.7924.204.camel@twins>
	 <20090804162033.GB5211@redhat.com>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 18:52:43 +0200
Message-Id: <1249404763.4762.26.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-04 at 18:20 +0200, Oleg Nesterov wrote:
> On 08/04, Peter Zijlstra wrote:
> >
> > +static int f_setown_ex(struct file *filp, unsigned long arg)
> > +{
> > +	struct f_owner_ex * __user owner_p = (void * __user)arg;
> > +	struct f_owner_ex owner;
> > +	struct pid *pid;
> > +	int type;
> > +	int ret;
> > +
> > +	ret = copy_from_user(&owner, owner_p, sizeof(owner));
> > +	if (ret)
> > +		return ret;
> > +
> > +	switch (owner.type) {
> > +	case F_OWNER_TID:
> > +		type = PIDTYPE_MAX;
> > +		break;
> > +
> > +	case F_OWNER_PID:
> > +		type = PIDTYPE_PID;
> > +		break;
> > +
> > +	case F_OWNER_GID:
> > +		type = PIDTYPE_PGID;
> > +		break;
> > +	}
> 
> Note that send_sigio()->do_each_pid_task(type) must use the valid
> type < PIDTYPE_MAX, or we can crash/etc.
> 
> This means f_setown_ex() should be careful with the wrong owner->type,
> the switch() above needs
> 
> 	default:
> 		return -EINVAL;

D'0h very true.

> > +	rcu_read_lock();
> > +	pid = find_vpid(owner.pid);
> > +	ret = __f_setown(filp, pid, type, 1);
> > +	rcu_read_unlock();
> > +
> > +	return ret;
> 
> Perhaps it makes sense to return -ESRCH if owner.pid && !pid, not
> sure.

We'd need that case to unset/clear the owner, so returning -ESRCH might
confuse users I think.

> > @@ -474,16 +540,23 @@ void send_sigio(struct fown_struct *fown
> >  	struct task_struct *p;
> >  	enum pid_type type;
> >  	struct pid *pid;
> > +	int group = 1;
> >  	
> >  	read_lock(&fown->lock);
> > +
> >  	type = fown->pid_type;
> > +	if (type == PIDTYPE_MAX) {
> > +		group = 0;
> > +		type = PIDTYPE_PID;
> > +	}
> 
> And send_sigurg() needs the same change. I am not sure we should teach
> send_sigurg_to_task() to handle the F_OWNER_TID, but we must ensure
> send_sigurg()->do_each_pid_task() won't be called with PIDTYPE_MAX.

How about the below delta, it changes send_sigurg_to_task() to also use
do_send_sig_info() which looses the check_kill_permission() check, but
your previous changes lost that same thing from SIGIO -- so I'm hoping
that's ok.

> Otherwise, personally I think this is what we need to solve the problem.

yay!

I'll look over the bits again and send out a -v4 later today.

----
Index: linux-2.6/fs/fcntl.c
===================================================================
--- linux-2.6.orig/fs/fcntl.c
+++ linux-2.6/fs/fcntl.c
@@ -287,6 +287,9 @@ static int f_setown_ex(struct file *filp
 	case F_OWNER_GID:
 		type = PIDTYPE_PGID;
 		break;
+
+	default:
+		return -EINVAL;
 	}
 
 	rcu_read_lock();
@@ -564,10 +567,10 @@ void send_sigio(struct fown_struct *fown
 }
 
 static void send_sigurg_to_task(struct task_struct *p,
-                                struct fown_struct *fown)
+                                struct fown_struct *fown, int group)
 {
 	if (sigio_perm(p, fown, SIGURG))
-		group_send_sig_info(SIGURG, SEND_SIG_PRIV, p);
+		do_send_sig_info(SIGURG, SEND_SIG_PRIV, p, group);
 }
 
 int send_sigurg(struct fown_struct *fown)
@@ -575,10 +578,17 @@ int send_sigurg(struct fown_struct *fown
 	struct task_struct *p;
 	enum pid_type type;
 	struct pid *pid;
+	int group = 1;
 	int ret = 0;
 	
 	read_lock(&fown->lock);
+
 	type = fown->pid_type;
+	if (type == PIDTYPE_MAX) {
+		group = 0;
+		type = PIDTYPE_PID;
+	}
+
 	pid = fown->pid;
 	if (!pid)
 		goto out_unlock_fown;
@@ -587,7 +597,7 @@ int send_sigurg(struct fown_struct *fown
 	
 	read_lock(&tasklist_lock);
 	do_each_pid_task(pid, type, p) {
-		send_sigurg_to_task(p, fown);
+		send_sigurg_to_task(p, fown, group);
 	} while_each_pid_task(pid, type, p);
 	read_unlock(&tasklist_lock);
  out_unlock_fown:



