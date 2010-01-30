Return-Path: <linux-kernel-owner+w=401wt.eu-S1753267Ab0A3VOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab0A3VOs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 16:14:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924Ab0A3VOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 16:14:47 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:36938 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab0A3VOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 16:14:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Hrm1Gne9kfM3K5StT5Lj3GoF2MND7XaB+sJAlnh5KKJS/s7KLTTtZAw5+a3wCKQQ1Z
         uqp/+QO5VBuOUB0s1o84bDUJCHXPb2rY6svxTGBT+iJeFfVjnBx3/Hg/EYhjyayVMawm
         2GBu6MlwZ3+3V28FteXu/q56ksG8bFfOClJmE=
Date: Sat, 30 Jan 2010 22:14:43 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [RFC PATCH 06/10] ftrace: Release the function hlist if we
	don't need it anymore
Message-ID: <20100130211442.GG5675@nowhere>
References: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com> <1264122982-1553-7-git-send-regression-fweisbec@gmail.com> <4B5D3D37.4090107@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5D3D37.4090107@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 02:41:59PM +0800, Lai Jiangshan wrote:
> Frederic Weisbecker wrote:
> > After we disable the function profiler, the function hashlist
> > stays in memory. This is wasteful as nobody needs it anymore,
> > until the next use if any.
> > 
> > Release it when we disable the function profiler instead of
> > resetting it in the next use.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Li Zefan <lizf@cn.fujitsu.com>
> > Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> > ---
> >  kernel/trace/ftrace.c          |    1 +
> >  kernel/trace/functions_hlist.c |   61 +++++++++++++++++-----------------------
> >  kernel/trace/functions_hlist.h |    1 +
> >  3 files changed, 28 insertions(+), 35 deletions(-)
> > 
> > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> > index dfd8f7c..0ded01c 100644
> > --- a/kernel/trace/ftrace.c
> > +++ b/kernel/trace/ftrace.c
> > @@ -509,6 +509,7 @@ ftrace_profile_write(struct file *filp, const char __user *ubuf,
> 
> >			/*
> >			 * unregister_ftrace_profiler calls stop_machine
> >			 * so this acts like an synchronize_sched.
> >			 */
> >  			unregister_ftrace_profiler();
> 
> unluckily, when !CONFIG_DYNAMIC_FTRACE, it does not call stop_machine()
> nor synchronize_sched(), bug here?



Yeah. I guess the synchronize_sched() is here to ensure
that if a user reenables the profiler, there is no
pending tracing callback that touches the hlist
that can become reset.

We indeed may need an explicit synchronize_sched() for
!CONFIG_DYNAMIC_FTRACE.

