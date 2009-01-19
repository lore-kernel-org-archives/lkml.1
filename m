Return-Path: <linux-kernel-owner+w=401wt.eu-S1759893AbZASMpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759893AbZASMpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 07:45:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758776AbZASMpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 07:45:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:54419 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758772AbZASMpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 07:45:07 -0500
Date: Mon, 19 Jan 2009 13:42:53 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ian Kent <raven@themaw.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, "SergeE.Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH] autofs: fix the wrong usage of the deprecated
	task_pgrp_nr()
Message-ID: <20090119124253.GA3268@redhat.com>
References: <20090118073441.GA699@redhat.com> <1232331602.3136.19.camel@zeus.themaw.net> <20090119070801.GA21686@redhat.com> <1232352677.3136.103.camel@zeus.themaw.net> <20090119083208.GA25297@redhat.com> <1232363717.3136.134.camel@zeus.themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232363717.3136.134.camel@zeus.themaw.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19, Ian Kent wrote:
>
> On Mon, 2009-01-19 at 09:32 +0100, Oleg Nesterov wrote:
> >
> > No, I am trying to say that the current code is wrong ;)
> >
> > > > task_pgrp_vnr() reporst the pid_t in the global namespace, but
> > > > find_get_pid() searches "struct pid" in the current namespace.
> > > > We can get the wrong pid. I tried to document this in changelog.
> > >
> > > We don't know whether it's the wrong pid because the environments were
> > > this is used haven't been defined. Depending on expected usage of pid
> > > namespaces the global pid may or may not be the correct one. This was
> > > not determined the last time this came up.
> >
> > Confused. The current code can't be right.
> >
> > Lets consider the simplest case, there is no "pgrp=" option during mount.
>
> No, the pgrp is required at mount time and must be the pid of the
> process group leader. But it isn't enforced in the code so that "is" a
> bug.

I see, but I didn't mean _this_ is bug. Please see below.

> > In that case the current code does:
> >
> > 	pid_t pgrp = task_pgrp_nr(current);
> > 	sbi->oz_pgrp = find_get_pid(pgid);
> >
> > But this means that sbi->oz_pgrp != task_prgp(current), unless of
> > course we are from the global namespace. ->oz_pgrp is a "random"
> > pid or NULL.
> >
> > What I am missed?
>
> What your missing is that all I'm asking for is a little background
> information on what the change is about so that I can understand it.
>
> I think you are making assumptions that just aren't true about my
> understanding of the pid namespace work.
>
> The current situation is that pgrp corresponds to the session leader of
> the automount(8) process and that process is started at boot so I guess
> it is within the global namespace.

In that case the patch doesn't make the difference, because if the
task runs in the global namespace then

	task_pgrp_nr(current) == task_pgrp_vnr(current);

> All we need to do now (since the
> issue will be much more complex if we consider multiple instances of
> automount(8) started within pid namespaces) is verify that changes we
> make to obtain the pgrp will correspond to the pid of automount(8) in
> the global namespace.

And now we have a problem afaics, because without this patch ->oz_pgrp
does not necessary match the pid of automount.

Let's look at

	static inline int autofs_oz_mode(struct autofs_sb_info *sbi) {
		return sbi->catatonic || task_pgrp(current) == sbi->oz_pgrp;
	}

Please note that task_pgrp(current) is "struct pid *", not pid_t.
It does not belong to any particular namespace, it "represents" all
namespaces this task is visible in, up to global.

Let's suppose automount starts in the level 2 namespace.
It's pgrp == 10 in the global namespace, and at the same time
it is == 20 from automount->nsproxy->pid_ns pov.

We need sbi->oz_pgrp == task_pgrp(automount).

But, by default parse_options() sets pgrp == 10, this is what
task_pgrp_nr(current) == task_pgrp_nr_ns(current, init_pid_ns)
returns.

Now autofs_fill_super() does sbi->oz_pgrp = find_get_pid(10).
This means: find the pid which has the numeric value == 10
in our namespace == automount->nsproxy->pid_ns.

But we should use 20, not 10. Otherwise we get the wrong pid or
NULL.

In short. Let's suppose automount(8) startes within the
pid namespace, and there is no "pgrp=" parameter. Then,

Before the patch

	sbi->oz_pgrp != task_pgrp(automount)

After the patch

	sbi->oz_pgrp == task_pgrp(automount)

And please note that these "!="/"==" apply to any namespace. I mean,
when we call autofs_oz_mode() it does not matter in which namespace
autofs_oz_mode() is executed, we compare "struct pid*", not pid_t.


Ian, please let me know if I am answering the wrong question,
I am not sure I understand you.

Oleg.

