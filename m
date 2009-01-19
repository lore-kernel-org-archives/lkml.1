Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbZASOdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbZASOdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:33:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbZASOdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:33:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52714 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245AbZASOdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:33:31 -0500
Date: Mon, 19 Jan 2009 15:30:46 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ian Kent <raven@themaw.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, "SergeE.Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH] autofs: fix the wrong usage of the deprecated
	task_pgrp_nr()
Message-ID: <20090119143046.GA8284@redhat.com>
References: <20090118073441.GA699@redhat.com> <1232331602.3136.19.camel@zeus.themaw.net> <20090119070801.GA21686@redhat.com> <1232352677.3136.103.camel@zeus.themaw.net> <20090119083208.GA25297@redhat.com> <1232363717.3136.134.camel@zeus.themaw.net> <20090119124253.GA3268@redhat.com> <1232372016.3136.155.camel@zeus.themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232372016.3136.155.camel@zeus.themaw.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19, Ian Kent wrote:
>
> On Mon, 2009-01-19 at 13:42 +0100, Oleg Nesterov wrote:
> >
> > Before the patch
> >
> > 	sbi->oz_pgrp != task_pgrp(automount)
> >
> > After the patch
> >
> > 	sbi->oz_pgrp == task_pgrp(automount)
> >
> > And please note that these "!="/"==" apply to any namespace. I mean,
> > when we call autofs_oz_mode() it does not matter in which namespace
> > autofs_oz_mode() is executed, we compare "struct pid*", not pid_t.
>
> I think your saying that the option pgrp= is broken and should be
> deprecated

No, no, sorry if I confused you.

If the "pgrp=" option was specified, the patch has no effect, and the
code is correct with or without the patch.

> It's interesting that your description appears to assume the the same
> process may appear in different pid namespaces (am I right?)

Yes. It is visible in its own namespace, in the ->parent namespace,
->parent->parent, and so on until the global init_pid_ns.

> whereas in
> the descriptions I have been writing I'm thinking of pid namspeces as
> having there own set of proceses and not being able to see processes
> outside the space.

Yes, we can not see the tasks outside the space (but of course we can
see the tasks from the child namespaces).

IOW. Let's suppose we are in the global namespace, and some task
forks the child C via clone(CLONE_NEWPID).

Now, in the global namespace it has, say, pid == 100. But when
C does sys_getpid() it gets 1.

C can not see the tasks from the global namespace, but any task
from the global ns can see C with pid == 100.

And please note that C has the single "struct pid" wchich represents
all pid_t's. The same for pgrp/session. task_pgrp() returns the same
pid (pointer to the struct, not pid_t), no matter in which namespace
the code runs. But the result of pid_vnr(pid) or find_pid(pid_nr) do
differ depending on current->nsproxy->pid_ns.

Oleg.

