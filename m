Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbYCPXTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbYCPXTG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 19:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbYCPXSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 19:18:54 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:37297 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476AbYCPXSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 19:18:53 -0400
Date: Mon, 17 Mar 2008 02:17:51 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Laurent Riffard <laurent.riffard@free.fr>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] ptrace: it is fun to strace /sbin/init
Message-ID: <20080316231751.GB379@tv-sign.ru>
References: <20080316155455.GA20848@tv-sign.ru> <20080316223138.1029D26F995@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080316223138.1029D26F995@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16, Roland McGrath wrote:
>
> > Ptracing of /sbin/init is not allowed. Of course, this is very dangerous, but
> > may be useful. Introduce the kernel boot parameter to allow this.
> 
> Personally I wouldn't mind losing all the ptrace/signals special cases for
> init.  (Just don't have a buggy init and expect not to crash, don't be root
> and kill init, etc.)  So this is fine by me.  The conservative route of
> changing it only with a boot option is the wise thing to do.

Great.

> > Unless I missed something, ptrace_get_task_struct() is pointless. It does not
> > need to check "pid == 1", ptrace_attach() does this. It doesn't need tasklist.
> 
> Agreed.  It's a hold-over from when there was more hair in there.
> 
> > It should be replaced with the generic find_get_task_by_vpid() which does not
> > exist yet.
> 
> I didn't see enough other uses to really warrant it.  Most
> find_task_by_vpid calls don't actually do get_task_struct.
> Those that do want to do some other check inside rcu_read_lock
> before deciding to bother with get_task_struct anyway.
> So there is nothing wrong with ptrace just open-coding:
> 
> 	rcu_read_lock();
> 	child = find_task_by_vpid(pid);
> 	if (child)
> 		get_task_struct(child);
> 	rcu_read_unlock();

proc_task_lookup(), fill_pid(), attach_task_by_pid(), can use the new helper.

But yes sure, we can open-code this.

Oleg.

