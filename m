Return-Path: <linux-kernel-owner+w=401wt.eu-S1754975AbZASIfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbZASIfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 03:35:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753775AbZASIe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 03:34:57 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53507 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbZASIe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 03:34:56 -0500
Date: Mon, 19 Jan 2009 09:32:08 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ian Kent <raven@themaw.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, "SergeE.Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH] autofs: fix the wrong usage of the deprecated
	task_pgrp_nr()
Message-ID: <20090119083208.GA25297@redhat.com>
References: <20090118073441.GA699@redhat.com> <1232331602.3136.19.camel@zeus.themaw.net> <20090119070801.GA21686@redhat.com> <1232352677.3136.103.camel@zeus.themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232352677.3136.103.camel@zeus.themaw.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19, Ian Kent wrote:
>
> On Mon, 2009-01-19 at 08:08 +0100, Oleg Nesterov wrote:
> > On 01/19, Ian Kent wrote:
> > >
> > > On Sun, 2009-01-18 at 08:34 +0100, Oleg Nesterov wrote:
> > > > parse_options(&pgid) sets pgid = task_pgrp_nr() which uses the global
> > > > namespace. This is wrong, we use this pgid to find "struct pid" in the
> > > > current's namespace. Change parse_options() to use task_pgrp_vnr().
> > > >
> > > > Also do s/task_pgrp_nr/task_pgrp_vnr/ in the debugging printks.
> > > > checkpatch.pl complains about "line over 80 characters", but it should
> > > > blame the cuurent code, not the patch.
> > >
> > > This changelog entry doesn't really have anything that I can use to work
> > > out if this change might introduce regressions.
> > >
> > > It would be helpful to me if you could include:
> > > 1) A brief statement about what your trying to achieve and why.
> >
> > First of all, I think this patch fixes a bug.
> >
> > What we are doing in autofs_fill_super()->parse_options() path
> > is find_get_pid(task_pgrp_vnr(current)), this is wrong.
>
> So your saying that your patch is wrong?
> I'm not following this at all.

No, I am trying to say that the current code is wrong ;)

> > task_pgrp_vnr() reporst the pid_t in the global namespace, but
> > find_get_pid() searches "struct pid" in the current namespace.
> > We can get the wrong pid. I tried to document this in changelog.
>
> We don't know whether it's the wrong pid because the environments were
> this is used haven't been defined. Depending on expected usage of pid
> namespaces the global pid may or may not be the correct one. This was
> not determined the last time this came up.

Confused. The current code can't be right.

Lets consider the simplest case, there is no "pgrp=" option during mount.
In that case the current code does:

	pid_t pgrp = task_pgrp_nr(current);
	sbi->oz_pgrp = find_get_pid(pgid);

But this means that sbi->oz_pgrp != task_prgp(current), unless of
course we are from the global namespace. ->oz_pgrp is a "random"
pid or NULL.

What I am missed?

Oleg.

