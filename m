Return-Path: <linux-kernel-owner+w=401wt.eu-S1751581AbZL1OX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581AbZL1OX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 09:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbZL1OX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 09:23:57 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50578 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbZL1OX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 09:23:57 -0500
Subject: Re: [RFC 7/12][PATCH] SCHED_DEADLINE: signal delivery when
 overrunning
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       michael trimarchi <michael@evidence.eu.com>,
       Fabio Checconi <fabio@gandalf.sssup.it>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Johan Eker <johan.eker@ericsson.com>, "p.faure" <p.faure@akatech.ch>,
       Chris Friesen <cfriesen@nortel.com>,
       Steven Rostedt <rostedt@goodmis.org>, Henrik Austad <henrik@austad.us>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Darren Hart <darren@dvhart.com>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Bjoern Brandenburg <bbb@cs.unc.edu>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>,
       "giuseppe.lipari" <giuseppe.lipari@sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>
In-Reply-To: <1255707856.6228.461.camel@Palantir>
References: <1255707324.6228.448.camel@Palantir>
	 <1255707856.6228.461.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Dec 2009 15:19:24 +0100
Message-ID: <1262009964.7135.109.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-16 at 17:44 +0200, Raistlin wrote:
> Starting from this commit, the user can ask to receive a SIGXCPU signal
> every time the task runtime is overrun or a scheduling deadline is missed.
> This is done by means of the sched_flags field already present in
> sched_param_ex.
> 
> A runtime overrun will be quite common, e.g. due to coarse execution time
> accounting, wrong parameter assignement, etc.
> A deadline miss --since the deadlines the scheduler sees are ``scheduling
> deadlines'' which have not necessarily to be equal to task's deadlines-- is
> much more unlikely, and should only happen in an overloaded system.

Right, I think its much better to not do this in posix-cpu-timers.c,
that code is shite.

Its probably possible to set SIGXCPU pending and raise TIF_SIGPENDING
from within the scheduler code, and that will be triggered when we
return to userspace.

That also gets rid of that coarse execution time accounting muck, since
the scheduler has ns accurate accounting.

