Return-Path: <linux-kernel-owner+w=401wt.eu-S1756371AbZD2HCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371AbZD2HCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 03:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbZD2HCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 03:02:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52163 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbZD2HCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 03:02:38 -0400
Date: Wed, 29 Apr 2009 08:58:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: James Morris <jmorris@namei.org>
Cc: David Howells <dhowells@redhat.com>, Eric Paris <eparis@parisplace.org>,
       Roland McGrath <roland@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       linux-kernel@vger.kernel.org
Subject: Re: Q: selinux_bprm_committed_creds() && signals/do_wait
Message-ID: <20090429065809.GA477@redhat.com>
References: <20090428223025.GA11997@redhat.com> <alpine.LRH.2.00.0904291024001.5246@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0904291024001.5246@tundra.namei.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29, James Morris wrote:
>
> On Wed, 29 Apr 2009, Oleg Nesterov wrote:
>
> > selinux_bprm_committed_creds:
> >
> > 	rc = avc_has_perm()
> > 	if (rc) {
> > 		flush_signals(current);
> >
> > This doesn't look right. If the task was SIGKILL'ed we must not proceed,
> > the task should die. The fix is simple, we should check SIGNAL_GROUP_EXIT
> > and do nothing in this case, the task will exit before return to user
> > space. If SIGNAL_GROUP_EXIT is set, it is just wrong to drop SIGKILL and
> > continue.
>
> I'm not quite sure what you're asking.  This is a permission check to see
> if the new task can inherit the signal state of the parent,

we can flush the signal which was sent after we changed SID/cred and passed
the new permission checks,

> and if not,
> the new task's signal state is flushed.
>
> Where does a consideration of SIGKILL arise?

It is not possible to flush SIGKILL. Once SIGKILL (or another fatal signal)
is queued, it sets SIGNAL_GROUP_EXIT which can't be and must not be cleared.

But, there is no need to flush SIGKILL. The task will exit. If it was sent
before we changed SID, we can pretend the task has died before exec().

> > But, before fixing, I'd like to understand why we are doing
> >
> > 		flush_signal_handlers(current, 1);
> > 		sigemptyset(&current->blocked);
> >
> > later. Could someone explain ? This looks unneeded.
>
> This is part of clearing all the signal state in the child.

This doesn't explain why we are doing this ;)

Why do we need to s/IGN/DFL/ and why do we clear ->blocked ? How this can
help from the security pov?

In fact this looks a bit wrong. The only way to ensure we can't lose the
signal during exec() is to block it beforehand, then install the handler
after exec(). s/IGN/DFL/ doesn't look good too.

But, if we really need this for security (selinux is a black magic to me),
then the above doesn't matter. Please help to understand.

Oleg.

