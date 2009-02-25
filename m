Return-Path: <linux-kernel-owner+w=401wt.eu-S1761436AbZBYWLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761436AbZBYWLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 17:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbZBYWLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 17:11:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49171 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbZBYWLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 17:11:04 -0500
Date: Wed, 25 Feb 2009 16:14:15 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Chris Evans <scarybeasts@gmail.com>,
       David Howells <dhowells@redhat.com>, Don Howard <dhoward@redhat.com>,
       Eugene Teo <eugene@redhat.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Tavis Ormandy <taviso@sdf.lonestar.org>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] exit_notify: kill the wrong capable(CAP_KILL) check
Message-ID: <20090225221415.GA1751@hallyn.com>
References: <20090225190218.GA7453@redhat.com> <20090225194140.D6F6EFC3DA@magilla.sf.frob.com> <20090225215356.GA1442@hallyn.com> <20090225220324.GA14667@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225220324.GA14667@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@redhat.com):
> On 02/25, Serge E. Hallyn wrote:
> >
> > Quoting Roland McGrath (roland@redhat.com):
> > > > I can't understand why exit_notify() checks capable(CAP_KILL), but this
> > > > looks just wrong.
> > >
> > > I don't know either why it's there.  My guess is that it was not actually
> > > thought out specifically, just a "unless capable" exception added when the
> > > security-motivated exclusions (exec_id stuff) were added.
> > >
> > > I can't think of any reason not to drop this check.
> >
> > Because of the following test?
> >
> > #include <stdio.h>
> > #include <sched.h>
> > #include <signal.h>
> > #include <stdlib.h>
> >
> > int childfn(void *data)
> > {
> > 	printf("hi there, i'm the child\n");
> > 	sleep(10);
> > 	exit(0);
> > }
> >
> > int main()
> > {
> > 	int stacksize = 4*getpagesize();
> > 	void *stack, *stacktop;
> >
> > 	stack = malloc(stacksize);
> > 	stacktop = stack + stacksize;
> >
> > 	int p = clone(childfn, stacktop, CLONE_PARENT|SIGSTOP, NULL);
> > 	exit(0);
> > }
> 
> Can't understand... Why do you think CAP_KILL makes things better?
> 
> Actually, how can it make any difference in this case?

Well the check by itself isn't quite right - it seems to me it
should also check whether tsk->euid == parent->uid.  But letting
an unprivileged task send SIGSTOP to a privileged one bc of
some fluke in the task hierarchy doesn't seem right.

-serge
