Return-Path: <linux-kernel-owner+w=401wt.eu-S1756567AbYLDRQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbYLDRQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbYLDRQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:16:05 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35376 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231AbYLDRQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:16:03 -0500
Date: Thu, 4 Dec 2008 18:14:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] processes: reparent_thread: don't call
	kill_orphaned_pgrp() if task_detached()
Message-ID: <20081204171430.GA16728@redhat.com>
References: <20081118175901.GA17134@redhat.com> <20081119185148.DC1D31544EB@magilla.localdomain> <m1skpncg2b.fsf@frodo.ebiederm.org> <20081120145234.GA3325@redhat.com> <m13ahm9slb.fsf@frodo.ebiederm.org> <20081120200050.GA24467@redhat.com> <20081120202848.GA27241@redhat.com> <20081204005203.95F6FFC3C0@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204005203.95F6FFC3C0@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26, Roland McGrath wrote:
>
> > @@ -816,6 +816,8 @@ static void reparent_thread(struct task_
> >
> >  	list_move_tail(&p->sibling, &p->real_parent->children);
> >
> > +	if (task_detached(p))
> > +		return;
>
> Seems like it would be cleaner to reorganize the code a little.
> reparent_thread has only one caller.  How about we move:
>
> 	if (p->pdeath_signal)
> 		/* We already hold the tasklist_lock here.  */
> 		group_send_sig_info(p->pdeath_signal, SEND_SIG_NOINFO, p);
>
> 	list_move_tail(&p->sibling, &p->real_parent->children);
>
> into forget_original_parent and rename reparent_thread to something else,
> called only:
>
> 	if (!task_detached(p) && !same_thread_group(p->real_parent, father))
> 		orphaned_process(p);

Not that I think this really matters, but imho this code needs more
little trivial reorganizations.

reparent_thread() (or whatever) needs the "&ptrace_dead" parameter
too, if the new parent (init) ignores SIGCHLD we should release a
zombie. So we should rename "ptrace_dead" and ptrace_exit_finish().
And imho it makes sense to create the new helper which does
"list_for_each_entry_safe(father->children) {}", to make this code
more symmetrical() with ptrace_exit().

Oleg.

