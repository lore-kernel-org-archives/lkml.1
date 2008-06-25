Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775AbYFYTqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbYFYTqv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 15:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754566AbYFYTql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 15:46:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50481 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856AbYFYTqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 15:46:40 -0400
Date: Wed, 25 Jun 2008 15:46:37 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: hrtimers: simplify lockdep handling
Message-ID: <Pine.LNX.4.58.0806251539180.405@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Oleg,

I'm currently porting -rt to 26-rc7 and I came across this change:

Commit:     8e60e05fdc7344415fa69a3883b11f65db967b47

With the

-	double_spin_lock(&new_base->lock, &old_base->lock,
-			 smp_processor_id() < cpu);
+	spin_lock(&new_base->lock);
+	spin_lock_nested(&old_base->lock, SINGLE_DEPTH_NESTING);


What's the reason that this is possible?  Is it because the migration
happens only on CPU hotplugging and that the CPU hotplugging code has
locks that would prevent a reversal of the lock taking?

I'm not arguing that the code is incorrect, but this looks like a subtlety
that can bite us later.

In other words, we really need comments around this code to explain to
casual viewers why this code is not deadlock prone. The change log here
and for 0d180406f2914aea3a78ddb880e2fe9ac78a9372 does not explain why the
straight forward taking of the locks is OK.

Thanks,

-- Steve
