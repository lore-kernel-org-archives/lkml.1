Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbZLHP33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbZLHP33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 10:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755882AbZLHP32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 10:29:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:37625 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787AbZLHP32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 10:29:28 -0500
Subject: Re: [RFC,PATCH 14/14] utrace core
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
In-Reply-To: <20091208150417.GA11883@redhat.com>
References: <20091124200220.GA5828@redhat.com>
	 <1259697242.1697.1075.camel@laptop> <20091201220847.GA25400@redhat.com>
	 <1260210877.3935.594.camel@laptop>  <20091208150417.GA11883@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Dec 2009 16:29:23 +0100
Message-ID: <1260286163.3935.1497.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-08 at 16:04 +0100, Oleg Nesterov wrote:
> > > > > +       /*
> > > > > +        * In theory spin_lock() doesn't imply rcu_read_lock().
> > > > > +        * Once we clear ->utrace_flags this task_struct can go away
> > > > > +        * because tracehook_prepare_release_task() path does not take
> > > > > +        * utrace->lock when ->utrace_flags == 0.
> > > > > +        */
> > > > > +       rcu_read_lock();
> > > > > +       task->utrace_flags = flags;
> > > > > +       spin_unlock(&utrace->lock);
> > > > > +       rcu_read_unlock();
> > > >
> > > > yuck!
> > > >
> > > > why not simply keep a task reference over the utrace_reset call?
> > >
> > > Yes, we could use get_task_struct() instead. Not sure this would
> > > be more clean, though.
> >
> > For one it would allow getting rid of that insane assymetric locking.
> 
> Well, this is subjective, but I don't agree that
> 
>         get_task_struct(task);
>         task->utrace_flags = flags;
>         spin_unlock(&utrace->lock);
>         put_task_struct(task);
> 
> looks better. 

No, what I mean by assymetric locking is that utrace_reset() and
utrace_reap() drop the utrace->lock where their caller acquired it,
resulting in non-obvious like:

utrace_control()
{

  ...
  spin_lock(&utrace->lock);

  ...

  if (reset)
    utrace_reset(utrace);
  else
    spin_unlock(&utrace->lock);
}

If you take a task ref you can write the much saner:

utrace_control()
{
  ...
  spin_lock(&utrace->lock);
  ...
  if (reset)
    utrace_reset(utrace);

  spin_unlock(&utrace->lock);
}



