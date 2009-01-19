Return-Path: <linux-kernel-owner+w=401wt.eu-S1758851AbZASLPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851AbZASLPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 06:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbZASLPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 06:15:21 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:47123 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750750AbZASLPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 06:15:20 -0500
X-Sasl-enc: wxT+wtxZJZsk+d9gvH+L8oYjbfSQSOBi/IYav6hfwRPX 1232363717
Subject: Re: [PATCH] autofs: fix the wrong usage of the deprecated
	task_pgrp_nr()
From: Ian Kent <raven@themaw.net>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, "SergeE.Hallyn" <serue@us.ibm.com>
In-Reply-To: <20090119083208.GA25297@redhat.com>
References: <20090118073441.GA699@redhat.com>
	 <1232331602.3136.19.camel@zeus.themaw.net>
	 <20090119070801.GA21686@redhat.com>
	 <1232352677.3136.103.camel@zeus.themaw.net>
	 <20090119083208.GA25297@redhat.com>
Content-Type: text/plain
Date: Mon, 19 Jan 2009 20:15:17 +0900
Message-Id: <1232363717.3136.134.camel@zeus.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-19 at 09:32 +0100, Oleg Nesterov wrote:
> On 01/19, Ian Kent wrote:
> >
> > On Mon, 2009-01-19 at 08:08 +0100, Oleg Nesterov wrote:
> > > On 01/19, Ian Kent wrote:
> > > >
> > > > On Sun, 2009-01-18 at 08:34 +0100, Oleg Nesterov wrote:
> > > > > parse_options(&pgid) sets pgid = task_pgrp_nr() which uses the global
> > > > > namespace. This is wrong, we use this pgid to find "struct pid" in the
> > > > > current's namespace. Change parse_options() to use task_pgrp_vnr().
> > > > >
> > > > > Also do s/task_pgrp_nr/task_pgrp_vnr/ in the debugging printks.
> > > > > checkpatch.pl complains about "line over 80 characters", but it should
> > > > > blame the cuurent code, not the patch.
> > > >
> > > > This changelog entry doesn't really have anything that I can use to work
> > > > out if this change might introduce regressions.
> > > >
> > > > It would be helpful to me if you could include:
> > > > 1) A brief statement about what your trying to achieve and why.
> > >
> > > First of all, I think this patch fixes a bug.
> > >
> > > What we are doing in autofs_fill_super()->parse_options() path
> > > is find_get_pid(task_pgrp_vnr(current)), this is wrong.
> >
> > So your saying that your patch is wrong?
> > I'm not following this at all.
> 
> No, I am trying to say that the current code is wrong ;)
> 
> > > task_pgrp_vnr() reporst the pid_t in the global namespace, but
> > > find_get_pid() searches "struct pid" in the current namespace.
> > > We can get the wrong pid. I tried to document this in changelog.
> >
> > We don't know whether it's the wrong pid because the environments were
> > this is used haven't been defined. Depending on expected usage of pid
> > namespaces the global pid may or may not be the correct one. This was
> > not determined the last time this came up.
> 
> Confused. The current code can't be right.
> 
> Lets consider the simplest case, there is no "pgrp=" option during mount.

No, the pgrp is required at mount time and must be the pid of the
process group leader. But it isn't enforced in the code so that "is" a
bug.

> In that case the current code does:
> 
> 	pid_t pgrp = task_pgrp_nr(current);
> 	sbi->oz_pgrp = find_get_pid(pgid);
> 
> But this means that sbi->oz_pgrp != task_prgp(current), unless of
> course we are from the global namespace. ->oz_pgrp is a "random"
> pid or NULL.
> 
> What I am missed?

What your missing is that all I'm asking for is a little background
information on what the change is about so that I can understand it.

I think you are making assumptions that just aren't true about my
understanding of the pid namespace work.

The current situation is that pgrp corresponds to the session leader of
the automount(8) process and that process is started at boot so I guess
it is within the global namespace. All we need to do now (since the
issue will be much more complex if we consider multiple instances of
automount(8) started within pid namespaces) is verify that changes we
make to obtain the pgrp will correspond to the pid of automount(8) in
the global namespace.

I suspect the main issue that is looming for autofs wrt. pid namespaces
is that file system namespaces are not tied to pid namespaces. That will
probably lead to the situation were don't know whether we want the pgrp
of an automount(8) within the pid namespace or we actually need it for
the process in the global namespace, assuming the file system namespace
might be shared between multiple pid namespaces.

But, I'm not up with this at all so I could be very mistaken.
Hopefully this little rant will clarify what I'm asking, but then maybe
I've just got it all wrong and made the situation worse, so help me out!

Ian

