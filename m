Return-Path: <linux-kernel-owner+w=401wt.eu-S964953AbXHJQnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964953AbXHJQnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 12:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933797AbXHJQnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 12:43:32 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:34507 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932531AbXHJQna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 12:43:30 -0400
Date: Fri, 10 Aug 2007 20:45:46 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, devel@openvz.org
Subject: Re: [PATCH] Make access to task's nsproxy liter
Message-ID: <20070810164546.GA273@tv-sign.ru>
References: <46BAE3A3.7030608@openvz.org> <20070810134003.GA22368@sergelap.austin.ibm.com> <20070810140545.GA74@tv-sign.ru> <46BC7FAC.2080208@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46BC7FAC.2080208@openvz.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10, Pavel Emelyanov wrote:
>
> Oleg Nesterov wrote:
> >On 08/10, Serge E. Hallyn wrote:
> >>Quoting Pavel Emelyanov (xemul@openvz.org):
> >>>+/*
> >>>+ * the namespaces access rules are:
> >>>+ *
> >>>+ *  1. only current task is allowed to change tsk->nsproxy pointer or
> >>>+ *     any pointer on the nsproxy itself
> >>>+ *
> >>>+ *  2. when accessing (i.e. reading) current task's namespaces - no
> >>>+ *     precautions should be taken - just dereference the pointers
> >>>+ *
> >>>+ *  3. the access to other task namespaces is performed like this
> >>>+ *     rcu_read_lock();
> >>>+ *     nsproxy = task_nsproxy(tsk);
> >>>+ *     if (nsproxy != NULL) {
> >>>+ *             / *
> >>>+ *               * work with the namespaces here
> >>>+ *               * e.g. get the reference on one of them
> >>>+ *               * /
> >>>+ *     } / *
> >>>+ *         * NULL task_nsproxy() means that this task is
> >>>+ *         * almost dead (zombie)
> >>>+ *         * /
> >>>+ *     rcu_read_unlock();
> >>And lastly, I guess that the caller to switch_task_namespaces() has
> >>to ensure that new_nsproxy either (1) is the init namespace, (2) is a
> >>brand-new namespace to which noone else has a reference, or (3) the
> >>caller has to hold a reference to the new_nsproxy across the call to
> >>switch_task_namespaces().
> >>
> >>As it happens the current calls fit (1) or (2).  Again if we happen to
> >>jump into the game of switching a task into another task's nsproxy,
> >>we'll need to be mindful of (3) so that new_nsproxy can't be tossed into
> >>the bin between
> >>
> >>	if (new)
> >>		get_nsproxy(new);
> >
> >4) Unless tsk == current, get_task_namespaces(tsk) and get_nsproxy(tsk)
> >   are racy even if done under rcu_read_lock().
> 
> Yup :)
> 
> It is already written in comment that only the current is allowed
> to change its nsproxy. I.e. when switch_task_nsproxy() is called
> for tsk other than current it's a BUG

Yes, but what I meant is that this code

        rcu_read_lock();
        nsproxy = task_nsproxy(tsk);
        if (nsproxy != NULL)
                get_nsproxy(nsproxy);
        rcu_read_unlock();

	if (nsproxy) {
		use_it(nsproxy);
		put_nsproxy(nsproxy);
	}

is not safe despite the fact we are _not_ changing tsk->nsproxy.

The patch itself is correct because we don't do that, and the comment
is right. Just it is not immediately obvious.

Oleg.

