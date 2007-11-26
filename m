Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbXKZUMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbXKZUMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 15:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbXKZUMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 15:12:41 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:57201 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163AbXKZUMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 15:12:40 -0500
Date: Mon, 26 Nov 2007 23:11:39 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] fix setsid() for sub-namespace /sbin/init
Message-ID: <20071126201139.GA84@tv-sign.ru>
References: <20071126142553.GA16525@tv-sign.ru> <m1zlx0n7ga.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1zlx0n7ga.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@tv-sign.ru> writes:
> 
> > sys_setsid() still deals with pid_t's from the global namespace. This means
> > that the "session > 1" check can't help for sub-namespace init, setsid() can't
> > succeed because copy_process(CLONE_NEWPID) populates PIDTYPE_PGID/SID links.
> 
> We can do even better.  We can remove the misguided code from
> copy_process(CLONE_NEWPID) that populates the PIDTYPE_PGID/SID links
> and generally does set setsid by hand,

Yes you are right. IIRC there was a patch from you, but I didn't follow the
discussion, sorry, so I don't know what was the verdict.

If we remove that "almost setsid" from copy_process(), we can remove the fat
comment and the "session != 1" chunk from setsid().

> and the code from kernel_init
> that call set_special_pid(), allowing us to remove the special case
> entirely.

This is different, perhaps we can keep this call. kernel_thread(kernel_init)
attaches /sbin/init to init_struct_pid. Nothing bad, and a "good" init should
do setsid() anyway. But who knows? Some special environment may expect that
getpgrp() != 0. Not that I really disagree on this issue though.

Oleg.

