Return-Path: <linux-kernel-owner+w=401wt.eu-S1758036AbZAXPwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036AbZAXPwb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 10:52:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbZAXPwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 10:52:22 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:11369 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbZAXPwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 10:52:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=XtEirPbGGca1hoTwiDeJC+PiooCPCtJXZEbJS5ma9dz3/vDyxD0ACpHdBvqRnpxC4s
         k1Pacb48lQbJnQTFNAeU2L0As4qvBYUiKhXFoW8zr8iBMmLbrzQ9OKmZdcs6H7cCmNfk
         lVlFSAdxdoJtYp47HFJ7/xGRZMx/yCVXNztG0=
Date: Sat, 24 Jan 2009 16:52:15 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mandeep Singh Baines <msb@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       rientjes@google.com, mbligh@google.com, thockin@google.com
Subject: Re: [PATCH v3] softlockup: remove hung_task_check_count
Message-ID: <20090124155212.GA5773@nowhere>
References: <20090122083457.GC7438@elte.hu> <20090122195513.GA22146@google.com> <1fe6c7900901221921m586b129dwf8c3446f897b57f0@mail.gmail.com> <20090123092306.GB29820@elte.hu> <c62985530901230204i3880c3f8xbebdb6844f35addf@mail.gmail.com> <20090124015513.GA31189@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090124015513.GA31189@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2009 at 05:55:14PM -0800, Mandeep Singh Baines wrote:
> Frédéric Weisbecker (fweisbec@gmail.com) wrote:
> > 2009/1/23 Ingo Molnar <mingo@elte.hu>:
> > >
> > > not sure i like the whole idea of removing the max iterations check. In
> > > theory if there's a _ton_ of tasks, we could spend a lot of time looping
> > > there. So it always looked prudent to limit it somewhat.
> > >
> > 
> > Which means we can loose several of them. Would it hurt to iterate as
> > much as possible along the task list,
> > keeping some care about writers starvation and latency?
> > BTW I thought about the slow work framework, but I can't retrieve
> > it....  But this thread has already a slow priority.
> > 
> > Would it be interesting to provide a way for rwlocks to know if there
> > is writer waiting for the lock?
> 
> Would be cool if that API existed. You could release the CPU and/or lock as
> soon as either was contended for. You'd have the benefits of fine-grained
> locking without the overhead of locking and unlocking multiple time.
> 
> Currently, there is no bit that can tell you there is a writer waiting. You'd
> probably need to change the write_lock() implementation at a minimum. Maybe
> if the first writer left the RW_LOCK_BIAS bit clear and then waited for the
> readers to leave instead of re-trying? That would actually make write_lock()
> more efficient for the 1-writer case since you'd only need to spin doing
> a read in the failure case instead of an atomic_dec and atomic_inc.
> 


This is already what is done in the slow path (in x86):

/* rdi:	pointer to rwlock_t */
ENTRY(__write_lock_failed)
	CFI_STARTPROC
	LOCK_PREFIX
	addl $RW_LOCK_BIAS,(%rdi)
1:	rep
	nop
	cmpl $RW_LOCK_BIAS,(%rdi)
	jne 1b
	LOCK_PREFIX
	subl $RW_LOCK_BIAS,(%rdi)
	jnz  __write_lock_failed
	ret
	CFI_ENDPROC
END(__write_lock_failed)

It spins lurking at the lock value and only if there are no writers nor readers that
own the lock, it restarts its atomic_sub (and then atomic_add in fail case).

And if an implementation of writers_waiting_for_lock() is needed, I guess this
is the perfect place. One atomic_add on a "waiters_count" on entry and an atomic_sub
on it on exit.

Since this is the slow_path, I guess that wouldn't really impact the performances....

