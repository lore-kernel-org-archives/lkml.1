Return-Path: <linux-kernel-owner+w=401wt.eu-S1752600AbZHCRre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbZHCRre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 13:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbZHCRrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 13:47:33 -0400
Received: from viefep16-int.chello.at ([62.179.121.36]:21749 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbZHCRrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 13:47:33 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 3/2] fcntl: F_[SG]ETOWN_TID
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, eranian@gmail.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       robert.richter@amd.com, paulus@samba.org, andi@firstfloor.org,
       mpjohn@us.ibm.com, cel@us.ibm.com, cjashfor@us.ibm.com,
       mucci@eecs.utk.edu, terpstra@eecs.utk.edu,
       perfmon2-devel@lists.sourceforge.net, mtk.manpages@googlemail.com,
       roland@redhat.com
In-Reply-To: <20090803171619.GA17876@redhat.com>
References: <1248869948.6987.3083.camel@twins>
	 <20090729221703.GA25368@redhat.com> <1248953485.6391.41.camel@twins>
	 <20090730192040.GA9503@redhat.com> <1248984003.4164.0.camel@laptop>
	 <20090730202804.GA13675@redhat.com> <1249029320.6391.72.camel@twins>
	 <20090731141122.a1939712.akpm@linux-foundation.org>
	 <20090801012736.GA30259@redhat.com> <1249314498.7924.133.camel@twins>
	 <20090803171619.GA17876@redhat.com>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 19:47:17 +0200
Message-Id: <1249321637.7924.163.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-03 at 19:16 +0200, Oleg Nesterov wrote:

> > +		filp->f_owner.task_only =
> > +			(type == PIDTYPE_PID && (flags & FF_SETOWN_TID));
> 
> Do we need type == PIDTYPE_PID check? FF_SETOWN_TID must imply
> PIDTYPE_PID, it is only used by f_setown_tid().

Paranoia I guess.

> > +static int f_setown_tid(struct file *filp, unsigned long arg)
> > +{
> > +	int flags = FF_SETOWN_FORCE;
> > +	struct pid *pid;
> > +	int who = arg;
> > +	int ret = 0;
> > +
> > +	if (who < 0)
> > +		who = -who;
> > +	else
> > +		flags |= FF_SETOWN_TID;
> 
> Hmm, OK. so fcntl(F_SETOWN_TID, -666) <=> fcntl(F_SETOWN, +666).
> 
> Not that I disagree, but I think this should be discussed. Perhaps
> F_SETOWN_TID can just reject who < 0.

Yeah, I considered that. Opinions?

> > +static pid_t f_getown_tid(struct file *filp)
> > +{
> > +	pid_t tid;
> > +
> > +	read_lock(&filp->f_owner.lock);
> > +	tid = pid_vnr(filp->f_owner.pid);
> > +	if (filp->f_owner.pid_type == PIDTYPE_PGID)
> > +		tid = 0;
> > +	if (!filp->f_owner.task_only)
> > +		tid = -tid;
> 
> I didn't think about this before... What should F_GETOWN_TID return
> if we did F_GETOWN ? (and vice versa). f_getown_tid() returns < 0
> if !task_only and ->piD != 0, this helps.
> 
> but the caller of F_GETOWN can't know what the returned value actually
> means if F_GETOWN_TID was used.

Ah, I made GETOWN_TID deal with !PID but forgot the TID case in GETOWN.
Yeah, icky, esp since there is no room for errors in the return value :/
I guess I could make it return 0.

> Do we really need fown->task_only? Not only this enlarges fown_struct,
> we have to modify f_modown() and f_setown().
> 
> Perhaps we can just add
> 
> 	#define F_PIDTYPE_THREAD	PIDTYPE_MAX
> 
> into fcntl.c ? Then,
> 
> 	static int f_setown_xxx(struct file *filp, unsigned long arg, int force, bool group)
> 	{
> 		enum pid_type type;
> 		struct pid *pid;
> 		int who = arg;
> 		int result;
> 
> 		type = PIDTYPE_PID;
> 		if (!group)
> 			type = F_PIDTYPE_THREAD
> 		else if (who < 0) {
> 			type = PIDTYPE_PGID;
> 			who = -who;
> 		}
> 
> 		rcu_read_lock();
> 		pid = find_vpid(who);
> 		result = __f_setown(filp, pid, type, force);
> 		rcu_read_unlock();
> 		return result;
> 	}
> 
> 	int f_setown(struct file *filp, unsigned long arg, int force)
> 	{
> 		return f_setown_xxx(..., true);
> 	}
> 
> Now we should also change send_sigio/send_sigurg, but this is trivial
> 
> 		type = fown->pid_type;
> 	+	if (type == F_PIDTYPE_THREAD)
> 			type = PIDTYPE_PID;
> 
> send_sigio_to_task() is trivial too.
> 
> What do you think? I agree, this is a bit hackish, but otoh this lessens
> the changes outside of fcntl.h.

Right, I considered adding PIDTYPE_TID, but then I'd have to go through
the kernel and make everything consistent, which is where I gave up ;-)

You hack above makes sense, dunno if people will go for it though..

