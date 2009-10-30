Return-Path: <linux-kernel-owner+w=401wt.eu-S932347AbZJ3TyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347AbZJ3TyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 15:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757393AbZJ3TyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 15:54:21 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:35810 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417AbZJ3TyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 15:54:21 -0400
Subject: Re: [RFC][PATCH] Add prctl to set sibling thread names (take two)
From: john stultz <johnstul@us.ibm.com>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>, Mike Fulton <fultonm@ca.ibm.com>,
       Sean Foley <Sean_Foley@ca.ibm.com>
In-Reply-To: <4AE2786C.7000400@us.ibm.com>
References: <1256347303.5059.26.camel@localhost.localdomain>
	 <4AE2786C.7000400@us.ibm.com>
Content-Type: text/plain
Date: Fri, 30 Oct 2009 12:54:12 -0700
Message-Id: <1256932452.3634.7.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-23 at 20:45 -0700, Darren Hart wrote:
> Hi John,
> 
> Just a couple nitpics really, looks pretty good to me - other than the 
> need for the wmb()s below.
> 
> john stultz wrote:
> > +	/*
> > +	 * Threads may access current->comm without holding
> > +	 * the task lock, so write the string carefully
> > +	 * to avoid non-terminating reads. Readers without a lock
> > +	 * with get the oldname, the newname or an empty string.
> 
> s/with/will/
> s/oldname/old name/ (it isn't a variable right?)
> s/newname/new name/ (it isn't a variable right?)

Fixed. Thanks

> > +	 */
> > +	tsk->comm[0] = NULL;
> > +	/* XXX - Need an mb() here?*/
> 
> I believe you do, yes. Now, which one... hrm... checking... You only 
> care about ensuring the the comm[0] store occurs BEFORE the strlcpy. 
> But, if no lock is held here, you can be preempted, so this is important 
> for both UP and SMP.  I believe what you need here is:
> 
> 	wmb()
> 
> Memory barrier experts, please enlighten us if I am missing something.
> 
> > +	strlcpy(tsk->comm+1, buf+1, sizeof(tsk->comm)-1);
> 
> And one more here I should think, otherwise that could effectively undo 
> the previous one :-)
> 
> 	wmb()

Cool. Added. If anyone sees anything incorrect here, please let me know.


> > +	tsk->comm[0] = buf[0];
> >  	task_unlock(tsk);
> 
> To be clear, we hold the lock to prevent other threads from changing 
> this at the same time as us - any other thread but the target thread 
> that is?

Right, so in order to change the comm, you have to hold the task_lock
(even if your changing your own).  The issue I'm trying to address is
the threads self-referencing their comm without holding the task_lock.
We don't want to slow them down by adding additional locking around
every current->comm access, but we want to allow other threads to modify
the comm. 


> > +static ssize_t
> > +comm_write(struct file *file, const char __user *buf,
> > +	    size_t count, loff_t *offset)
> > +{
> > +	struct inode *inode = file->f_path.dentry->d_inode;
> > +	struct task_struct *p;
> > +	char buffer[TASK_COMM_LEN];
> > +
> > +	memset(buffer, 0, sizeof(buffer));
> 
> What purpose does zeroing this entire buffer serve?

Just make sure we always terminate with a null. 

> > +	if (count > sizeof(buffer) - 1)
> > +		count = sizeof(buffer) - 1;
> > +	if (copy_from_user(buffer, buf, count))
> > +		return -EFAULT;
> > +
> 
> Extra whitespace

fixed.

Thanks for the review. I'll send a new version out shortly.
-john



