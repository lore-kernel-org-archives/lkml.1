Return-Path: <linux-kernel-owner+w=401wt.eu-S1753233Ab0AZHpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab0AZHpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 02:45:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087Ab0AZHpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 02:45:46 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60027 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab0AZHpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 02:45:45 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [2.6.33-rc5] starting emacs makes lockdep warning
Cc: kosaki.motohiro@jp.fujitsu.com, Am??rico Wang <xiyou.wangcong@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Tavis Ormandy <taviso@google.com>, Jeff Dike <jdike@addtoit.com>,
       Julien Tinnes <jln@google.com>, Matt Mackall <mpm@selenic.com>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20100126060705.GF19799@ZenIV.linux.org.uk>
References: <2375c9f91001252201t552022ebvcd44b225eb7f9a95@mail.gmail.com> <20100126060705.GF19799@ZenIV.linux.org.uk>
Message-Id: <20100126164018.1D59.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 26 Jan 2010 16:45:41 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> On Tue, Jan 26, 2010 at 02:01:12PM +0800, Am??rico Wang wrote:
> 
> > I agree, it seems that patch is useless, since we already
> > do lock_kernel() before calling __f_setown()...
> 
> What's to prevent pid from being freed under us?  BKL won't...

I don't understand this issue at all. so, this is stupid dumb question.
Why can't we write following code?


                enum pid_type type;
                struct pid *pid;
                if (!waitqueue_active(&tty->read_wait))
                        tty->minimum_to_wake = 1;
                spin_lock_irqsave(&tty->ctrl_lock, flags);
                if (tty->pgrp) {
                        pid = tty->pgrp;
                        type = PIDTYPE_PGID;
                } else {
                        pid = task_pid(current);
                        type = PIDTYPE_PID;
                }
		get_pid(pid)					// insert here
                spin_unlock_irqrestore(&tty->ctrl_lock, flags);
                retval = __f_setown(filp, pid, type, 0);
		put_pid(pid)					// insert here





