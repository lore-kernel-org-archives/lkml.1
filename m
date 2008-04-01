Return-Path: <linux-kernel-owner+w=401wt.eu-S1759627AbYDAVrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627AbYDAVrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759340AbYDAVra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:47:30 -0400
Received: from smtp-out.google.com ([216.239.33.17]:41391 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759154AbYDAVr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:47:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:subject:from:to:cc:in-reply-to:references:
	content-type:organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=EJ4vOx2EJWzyhcm2Nu3BZZofK3OHlom7C6+s6szQp10oXgpXjYFgTsg/f1RlmhXx5
	LtuFf2AfWGnc9W3GaQBLA==
Subject: Re: [PATCH 2.6.25-rc7 resubmit] Fix itimer/many thread hang.
From: Frank Mayhar <fmayhar@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080401114546.5a222cc0.akpm@linux-foundation.org>
References: <bug-9906-10286@http.bugzilla.kernel.org/>
	 <20080207165455.04ec490b@Varda>
	 <alpine.LRH.1.00.0802071100230.29369@mini.warudkars.net>
	 <alpine.LRH.1.00.0802071153130.15220@mini.warudkars.net>
	 <1204314904.4850.23.camel@peace.smo.corp.google.com>
	 <20080304070016.903E127010A@magilla.localdomain>
	 <1204660376.9768.1.camel@bobble.smo.corp.google.com>
	 <20080305040826.D0E6127010A@magilla.localdomain>
	 <1204830243.20004.31.camel@bobble.smo.corp.google.com>
	 <20080311075020.A93DB26F991@magilla.localdomain>
	 <1205269507.23124.57.camel@bobble.smo.corp.google.com>
	 <20080311213507.5BCDF26F991@magilla.localdomain>
	 <1205455050.19551.16.camel@bobble.smo.corp.google.com>
	 <20080321071846.1B22B26F9A7@magilla.localdomain>
	 <1206122240.14638.31.camel@bobble.smo.corp.google.com>
	 <20080322215829.D69D026F9A7@magilla.localdomain>
	 <1206665568.426.24.camel@bobble.smo.corp.google.com>
	 <1206744400.19691.31.camel@bobble.smo.corp.google.com>
	 <20080401114546.5a222cc0.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Google, Inc.
Date: Tue, 01 Apr 2008 14:46:37 -0700
Message-Id: <1207086397.20789.9.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-01 at 11:45 -0700, Andrew Morton wrote:
> On Fri, 28 Mar 2008 15:46:40 -0700
> Frank Mayhar <fmayhar@google.com> wrote:
> 
> >  asmlinkage long sys_times(struct tms __user * tbuf)
> >  {
> > +	struct thread_group_cputime thread_group_times;
> > +
> >  	/*
> >  	 *	In the SMP world we might just be unlucky and have one of
> >  	 *	the times increment as we use it. Since the value is an
> > @@ -873,19 +875,28 @@ asmlinkage long sys_times(struct tms __user * tbuf)
> >  	if (tbuf) {
> >  		struct tms tmp;
> >  		struct task_struct *tsk = current;
> > -		struct task_struct *t;
> >  		cputime_t utime, stime, cutime, cstime;
> >  
> >  		spin_lock_irq(&tsk->sighand->siglock);
> > -		utime = tsk->signal->utime;
> > -		stime = tsk->signal->stime;
> > -		t = tsk;
> > -		do {
> > -			utime = cputime_add(utime, t->utime);
> > -			stime = cputime_add(stime, t->stime);
> > -			t = next_thread(t);
> > -		} while (t != tsk);
> > -
> > +		/*
> > +		 * If a POSIX interval timer is running use the process-wide
> > +		 * fields, else fall back to brute force.
> > +		 */
> > +		if (sig->thread_group_times) {
> 
> kernel/sys.c: In function 'sys_times':
> kernel/sys.c:885: error: 'sig' undeclared (first use in this function)

Thanks.  As I said privately, I don't know how this snuck in but it's
certainly time to blow away my build tree and reapply the next patch
from scratch.

Speaking of which, expect that next patch in a day or two.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

