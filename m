Return-Path: <linux-kernel-owner+w=401wt.eu-S1757463AbZBJXnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463AbZBJXnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 18:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754860AbZBJXmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 18:42:49 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48198 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017AbZBJXms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 18:42:48 -0500
Date: Wed, 11 Feb 2009 00:40:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] forget_original_parent: cleanup ptrace pathes
Message-ID: <20090210234014.GA15411@redhat.com>
References: <20090129080603.GA26882@redhat.com> <20090205024021.04DDDFC381@magilla.sf.frob.com> <20090205153301.GC20953@redhat.com> <20090209023626.03C7DFC330@magilla.sf.frob.com> <20090210224751.GA9478@redhat.com> <20090210232324.399ADFC3DB@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090210232324.399ADFC3DB@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10, Roland McGrath wrote:
>
> > How about below? Modulo comments and some other cleanups. For example,
> > I think it is better to move the changing of ->real_parent into
> > reparent_thread().
>
> The exact split between reparent_thread and forget_original_parent (and
> their names) never made much sense to me.
>
> If ptrace_exit does its own lock/unlock, then it could move much earlier.
> I'd be inclined to do it right before exit_signals().

Yes. But since I am paranoid, can we move the callsite later? I mean,
I'd prefer to make a separate (trivial) patch which moves it.

> But it should at
> least short-circuit and not lock for list_empty(->ptraced), so we're not
> adding a whole lock_irq/unlock_irq to the common case of no ptrace use.

Agreed, and probably forget_original_parent() can check empty(->children)
too.

> > 			xxx = &p->real_parent->children;
> > 			if (reparent_thread(father, p))
> > 				xxx = &child_dead;
> > 			list_move_tail(&p->sibling, xxx);;
>
> I'd thought of this before.  But I didn't mention it because I was afraid
> to wonder what might care about the use of ->sibling.  It really looks like
> nothing does.

Yes, nobody should at least. Nobody can find this task on its own list.

> This is clearly the clean and nice way to go if there is no
> problem with it.

OK, will try to send the patches soon.

> This change and moving ptrace_exit around should probably be separate patches.

Yes, yes, sure.


If you don't mind, I'd prefer to make these changes on top of [PATCH 3/4],
reparent_thread-fix-a-zombie-leak-if-sbin-init-ignores-sigchld.patch
(and this one should be dropped).

Because that patch fixes the bug and changes the behaviour, while the
discussed changes are cleanups.

Oleg.

