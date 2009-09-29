Return-Path: <linux-kernel-owner+w=401wt.eu-S1753104AbZI2OyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbZI2OyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 10:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbZI2OyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 10:54:11 -0400
Received: from genesysrack.ru ([195.178.208.66]:48761 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921AbZI2OyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 10:54:10 -0400
Date: Tue, 29 Sep 2009 18:54:13 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Evgeny Polyakov <johnpol@2ka.mipt.ru>,
       Scott James Remnant <scott@ubuntu.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Matt Helsley <matthltc@us.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] connector: Fix sid connector (was: Badness at kernel/softirq.c:143...)
Message-ID: <20090929145413.GA26327@ioremap.net>
References: <200909251123.03482.borntraeger@de.ibm.com> <fbbbe0a028fa.4ac1f1c0@2ka.mipt.ru> <20090929132415.GB4538@redhat.com> <200909291547.21528.borntraeger@de.ibm.com> <20090929140718.GA23858@ioremap.net> <20090929142538.GA10180@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090929142538.GA10180@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 04:25:38PM +0200, Oleg Nesterov (oleg@redhat.com) wrote:
> > --- a/kernel/sys.c
> > +++ b/kernel/sys.c
> > @@ -1090,6 +1090,7 @@ SYSCALL_DEFINE0(setsid)
> >  	struct pid *sid = task_pid(group_leader);
> >  	pid_t session = pid_vnr(sid);
> >  	int err = -EPERM;
> > +	int send_cn = 0;
> >
> >  	write_lock_irq(&tasklist_lock);
> >  	/* Fail if I am already a session leader */
> > @@ -1104,12 +1105,18 @@ SYSCALL_DEFINE0(setsid)
> >
> >  	group_leader->signal->leader = 1;
> >  	__set_special_pids(sid);
> > +	if (task_session(group_leader) != sid)
> > +		send_cn = 1;
> 
> This is not right, task_session(group_leader) must be == sid after
> __set_special_pids().

Yeah, that check should be done before __set_special_pids().

> And I don't think "int send_cn" is needed. sys_setsid() must not
> succeed if the caller lived in session == task_pid(group_leader).

Doesn't it only check pgid while patch intention was to send
notification about sid? I.e. setsid() succeeds, although nothing
happens.

-- 
	Evgeniy Polyakov
