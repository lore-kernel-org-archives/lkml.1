Return-Path: <linux-kernel-owner+w=401wt.eu-S1757488AbZBJXXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488AbZBJXXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 18:23:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbZBJXXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 18:23:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756041AbZBJXXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 18:23:36 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] forget_original_parent: cleanup ptrace pathes
In-Reply-To: Oleg Nesterov's message of  Tuesday, 10 February 2009 23:47:51 +0100 <20090210224751.GA9478@redhat.com>
References: <20090129080603.GA26882@redhat.com>
	<20090205024021.04DDDFC381@magilla.sf.frob.com>
	<20090205153301.GC20953@redhat.com>
	<20090209023626.03C7DFC330@magilla.sf.frob.com>
	<20090210224751.GA9478@redhat.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20090210232324.399ADFC3DB@magilla.sf.frob.com>
Date: Tue, 10 Feb 2009 15:23:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It doesn't really hurt, but a bit ugly. Imho.

Agreed.

> How about below? Modulo comments and some other cleanups. For example,
> I think it is better to move the changing of ->real_parent into
> reparent_thread().

The exact split between reparent_thread and forget_original_parent (and
their names) never made much sense to me.

If ptrace_exit does its own lock/unlock, then it could move much earlier.
I'd be inclined to do it right before exit_signals().  But it should at
least short-circuit and not lock for list_empty(->ptraced), so we're not
adding a whole lock_irq/unlock_irq to the common case of no ptrace use.

> 			xxx = &p->real_parent->children;
> 			if (reparent_thread(father, p))
> 				xxx = &child_dead;
> 			list_move_tail(&p->sibling, xxx);;

I'd thought of this before.  But I didn't mention it because I was afraid
to wonder what might care about the use of ->sibling.  It really looks like
nothing does.  This is clearly the clean and nice way to go if there is no
problem with it.  

This change and moving ptrace_exit around should probably be separate patches.


Thanks,
Roland
