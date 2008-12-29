Return-Path: <linux-kernel-owner+w=401wt.eu-S1752356AbYL2P77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbYL2P77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 10:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbYL2P7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 10:59:51 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39829 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733AbYL2P7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 10:59:50 -0500
Date: Mon, 29 Dec 2008 16:57:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Scott James Remnant <scott@canonical.com>
Cc: Roland McGrath <roland@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] Notify init when processes are reparented to it
Message-ID: <20081229155735.GA6906@redhat.com>
References: <1230378128.7026.50.camel@quest> <20081227114452.GA2919@zelda.netsplit.com> <20081228092024.GA21673@redhat.com> <20081228220122.62940FC278@magilla.sf.frob.com> <1230551457.4664.0.camel@wing-commander> <20081229132305.GA31210@redhat.com> <1230564071.4664.8.camel@wing-commander>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230564071.4664.8.camel@wing-commander>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29, Scott James Remnant wrote:
>
> On Mon, 2008-12-29 at 14:23 +0100, Oleg Nesterov wrote:
>
> > > We want to be able to supervise daemons.
> >
> > What do you mean?
> >
> > > Later on, 1002 will die and init will receive SIGCHLD for it.
> > >
> > > Unfortunately neither the 1001 or 1002 processes are known to init, even
> > > though they are original children of the process it spawned (1000), for
> > > init to be notified about them - this has been forgotten.
> >
> > Ok, with this patch /sbin/init knows that 1002 is a descendant
> > of apache(1000) which was spwaned by init. What can init do
> > with this info?
> >
> Fundamentally init would now know that the apache service terminated,
> and with what exit code or by what signal.
>
> Right now, all we know is that a process terminated (and why) - we can't
> link that back to a service in any kind of foolproof manner.
>
> With the ability to do that, when the apache service dies, we can log
> that in a more useful manner (including marking the service as down) -
> but most importantly, we can respawn it!

Aha, thanks, I suspected something like this.

But how can we know (in general) that the service has died? We only
know that the process has exited.

IOW. when apache(1001) exits, we don't respawn. How can init know that
the death of apache(1002) means "this is the real exit of service, the
previous exits were due to initialization stage".

The only answer I can see is: because init can figure out that all
descendants of initially spawned apache(1000) have exited. But this
doesn't look very flexible/reliable to me.

And we already have CONFIG_PROC_EVENTS, init can monitor PROC_EVENT_FORK
events, so it can do this without ->adopt_signal ?

Oleg.

