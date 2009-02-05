Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbZBEDbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbZBEDbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 22:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbZBEDa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 22:30:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbZBEDa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 22:30:58 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Kaz Kylheku <kkylheku@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: main thread pthread_exit/sys_exit bug!
In-Reply-To: Oleg Nesterov's message of  Monday, 2 February 2009 17:56:06 +0100 <20090202165606.GA13346@redhat.com>
References: <3f43f78b0902011432y354c1b35m8f645640433f7b49@mail.gmail.com>
	<20090201174159.4a52e15c.akpm@linux-foundation.org>
	<20090202064509.GA20237@redhat.com>
	<3f43f78b0902012310p46186417m66873f410b948fd3@mail.gmail.com>
	<20090202165606.GA13346@redhat.com>
X-Shopping-List: (1) E-Z-Grip Seducers
   (2) Groundless resplendent chase dogs
   (3) Civil rooster hay
   (4) Recoilless neglecters
Message-Id: <20090205030553.49650FC381@magilla.sf.frob.com>
Date: Wed,  4 Feb 2009 19:05:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I haven't seen the clear explanation of what specific actual problems there
are here.  But I'm quite sure this is not the right approach to address them.

Kaz has said things that seemed to imply that the behavior is erratic or
the semantics are somehow ill-defined when the group leader has died with
other threads living on.  In fact, this case is perfectly well-specified
and there is no mystery about it.

The group leader dies and becomes a zombie.  The zombie group leader is
kept from reaping and parent notification by the delayed_group_leader()
logic and related code, until the last thread in the group dies.  The tgid
(leader's tid), aka PID in POSIX terms, remains as the PID for the process
as a whole and signals to it work fine, etc.

Quite some time ago, there was some /proc bug wherein /proc/pid/task could
not be listed when the group leader had died.  That prevented strace or gdb
from attaching to the process after its initial thread used pthread_exit.
I don't recall when that was fixed, but it's been fine for a good while.
That is the only problem for debuggability of this case that I recall
knowing about.

Certainly long ago there were many problems with job control signals in
multi-thread groups, and there have been many little corner cases fixed in
that over the 2.6.x period.  I'm not aware of any such problems remaining.
But if there are some, they need to be fixed in the signals code.  It's
certainly clear how it's supposed to work, and that's no different when the
group leader is dead.


Thanks,
Roland
