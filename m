Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512AbYILJNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbYILJNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 05:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbYILJNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 05:13:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36304 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbYILJNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 05:13:22 -0400
Date: Fri, 12 Sep 2008 11:13:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       bugme-daemon@bugzilla.kernel.org, j_kernel@hoblitt.com
Subject: Re: [Bugme-new] [Bug 11543] New: kernel panic: softlockup in
	tick_periodic() ???
Message-ID: <20080912091308.GA10305@elte.hu>
References: <bug-11543-10286@http.bugzilla.kernel.org/> <20080911170258.aa0bea0d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080911170258.aa0bea0d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> I can't work out who called panic(), nor why.
> 
> The panic code called the kexec code which called mutex_trylock() 
> which called spin_lock_mutex() which then stupidly went and blurted a 
> load of debug stuff because of in_interrupt().

agreed - applied your fix in the form below to tip/master - thanks 
Andrew.

J, you might want to try tip/master, it includes all known fixes for 
this area and this debug improvement as well. You can pick it up via:

  http://people.redhat.com/mingo/tip.git/README

	Ingo

---------->
>From 53b9d87f41a3d8838210ad7cdef02d814817ce85 Mon Sep 17 00:00:00 2001
From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 11 Sep 2008 17:02:58 -0700
Subject: [PATCH] lock debug: sit tight when we are already in a panic

in:

  > http://bugzilla.kernel.org/show_bug.cgi?id=11543

The panic code called the kexec code which called mutex_trylock() which
called spin_lock_mutex() which then stupidly went and blurted a load of
debug stuff because of in_interrupt().

Keep the lock debug code from escallating an already crappy situation.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/debug_locks.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/debug_locks.h b/include/linux/debug_locks.h
index 4aaa4af..096476f 100644
--- a/include/linux/debug_locks.h
+++ b/include/linux/debug_locks.h
@@ -17,7 +17,7 @@ extern int debug_locks_off(void);
 ({									\
 	int __ret = 0;							\
 									\
-	if (unlikely(c)) {						\
+	if (!oops_in_progress && unlikely(c)) {				\
 		if (debug_locks_off() && !debug_locks_silent)		\
 			WARN_ON(1);					\
 		__ret = 1;						\
