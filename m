Return-Path: <linux-kernel-owner+w=401wt.eu-S1755110AbZHCOmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbZHCOmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 10:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932168AbZHCOmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 10:42:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35540 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924AbZHCOmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 10:42:50 -0400
Subject: Re: Tracing thread name (was: ltt comm tracking)
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Matthieu CASTET <matthieu.castet@parrot.com>,
       ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, rostedt@goodmis.org,
       Michael Kerrisk <mtk.manpages@googlemail.com>
In-Reply-To: <20090803134843.GB23455@Krystal>
References: <4A76E42D.7010908@parrot.com>  <20090803134843.GB23455@Krystal>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 03 Aug 2009 16:28:27 +0200
Message-Id: <1249309707.7924.101.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-03 at 09:48 -0400, Mathieu Desnoyers wrote:
> * Matthieu CASTET (matthieu.castet@parrot.com) wrote:
> > Hi,
> > 
> > I use ltt on a 2.6.27 on an arm architecture.
> > It works quite well, but I have a minor problem :
> > 
> > my application sets thread name with prctl PR_SET_NAME. But ltt viewer
> > doesn't seem to saw it.
> >
> 
> Hrm, I guess we might want to instrument set_task_comm as you propose to
> get the correct process name, but if this gets us the thread name, I
> think it's only an implementation side-effect:
> 
> If I look at the man page:
> 
> PRCTL(2)
> 
>        PR_SET_NAME (since Linux 2.6.9)
>               Set the process name for the calling process, using the value in
>               the location pointed to by (char *) arg2.  The name can be up to
>               16  bytes  long,  and  should  be null terminated if it contains
>               fewer bytes.
> 
> It seems to officially set the process name, not thread name.

Then the man page is wrong, it really only sets the task (thread) name.

> The way LTTng handles thread names is by adding a userspace "thread
> branding" event. It should be executed at thread startup. The downside
> of the current LTTng approach is that we cannot know the name of threads
> already executing before we started tracing.
> 
> Ideally, having something like prctl PR_SET/GET_THREAD_NAME would
> probably make sense.

Going by the current behaviour, you'd need to add process name.

fs/exec.c:

        void set_task_comm(struct task_struct *tsk, char *buf)
        {
                task_lock(tsk);
                strlcpy(tsk->comm, buf, sizeof(tsk->comm));
                task_unlock(tsk);
                perf_counter_comm(tsk);
        }

