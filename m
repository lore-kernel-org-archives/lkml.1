Return-Path: <linux-kernel-owner+w=401wt.eu-S1753792AbZKWOyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbZKWOyF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 09:54:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbZKWOyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 09:54:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54365 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbZKWOyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 09:54:04 -0500
Date: Mon, 23 Nov 2009 15:54:09 +0100
From: Nick Piggin <npiggin@suse.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [rfc] "fair" rw spinlocks
Message-ID: <20091123145409.GA29627@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Last time this issue came up that I could see, I don't think
there were objections to making rwlocks fair, the main
difficulty seemed to be that we allow reentrant read locks
(so a write lock waiting must not block arbitrary read lockers).

Nowadays our rwlock usage is smaller although still quite a
few, so it would make better sense to do a conversion by
introducing a new lock type and move them over I guess.

Anyway, I would like to add some kind of fairness or at least
anti starvation for writers. We have a customer seeing total
livelock on tasklist_lock for write locking on a system as small
as 8 core Opteron.

This was basically reproduced by several cores executing wait
with WNOHANG.

Of course it would always be nice to improve locking so
contention isn't an issue, but so long as we have rwlocks, we
could possibly get into a situation where starvation is
triggered *somehow*. So I'd really like to fix this.

This particular starvation on tasklist lock I guess is a local
DoS vulnerability even if the workload is not particularly
realistic.

Anyway, I don't have a patch yet. I'm sure it can be done
without extra atomics in fastpaths. Comments?

