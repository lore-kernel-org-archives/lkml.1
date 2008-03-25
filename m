Return-Path: <linux-kernel-owner+w=401wt.eu-S1760960AbYCYWB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760960AbYCYWB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 18:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbYCYWBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 18:01:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754255AbYCYWBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 18:01:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       ebiederm@xmission.com, xemul@openvz.org, pavel@ucw.cz,
       sds@tycho.nsa.gov, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: it is fun to strace /sbin/init
In-Reply-To: Andi Kleen's message of  , 25 March 2008 11:00:39 +0100 <87r6dzi0mw.fsf@basil.nowhere.org>
References: <20080323135110.GA294@tv-sign.ru>
	<20080324152906.dee7b272.akpm@linux-foundation.org>
	<20080324225611.GA157@tv-sign.ru>
	<20080324160819.cea2d921.akpm@linux-foundation.org>
	<87r6dzi0mw.fsf@basil.nowhere.org>
X-Windows: the problem for your problem.
Message-Id: <20080325220042.87CFD26FA0A@magilla.localdomain>
Date: Tue, 25 Mar 2008 15:00:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It would be fine to allow this unconditionally if there was some mechanism
> to make sure someone else takes over reaping childs while init is ptraced.

I don't see why this particular issue is any special case.  The zombie leak
is just one of many ways that the system might become unusable if root does
the wrong thing to an essential system daemon.  Caveat superusor.  Diddling
with init on a system you expect ever to do anything again is dangerous and
requires great care.  The question of allowing an administrator to engage
in dangerous activities is orthogonal to the details of a particular danger.

With today's kernel, init can avoid any reparented zombies collecting if it
doesn't care about its own children either.  That is, it can ignore SIGCHLD
or set SA_NOCLDWAIT to make all its children clean themselves up.  That
doesn't help for a normal init, which does care (for respawn and logging).
(Also it's never been tried, and I'm almost sure it has a bug.  But that's
supposed to be the semantics.)

That said, the orthogonal question of orphan zombies may well be worth
addressing too.  Just let's not conflate it with the ptrace question.
(AFAIK there is no good reason not to make orphans just self-reap, it's
just hysterical raisins inherited from the dawn of Unix.  I'm sure that
Oleg and I can work out the cleanups, but in a separate thread please.)


Thanks,
Roland
