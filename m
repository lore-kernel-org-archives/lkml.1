Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbZLJA4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbZLJA4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 19:56:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbZLJAz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 19:55:57 -0500
Received: from www.tglx.de ([62.245.132.106]:54072 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755164AbZLJAyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 19:54:16 -0500
Message-Id: <20091210001308.247025548@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 10 Dec 2009 00:52:46 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch 0/9] Fix various __task_cred related invalid RCU assumptions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While auditing the read_lock(&tasklist_lock) sites for a possible
conversion to rcu-read_lock() I stumbled over an unprotected user of
__task_cred in kernel/sys.c

That caused me to audit all the __task_cred usage sites except in
kernel/exit.c.

Most of the usage sites are correct, but some of them trip over
invalid assumptions about the protection which is given by RCU.

- spinlocked/preempt_disabled regions are equivalent to rcu_read_lock():

   That's wrong. RCU does not guarantee that. 

   It has been that way due to implementation details and it still is
   valid for CONFIG_TREE_PREEMPT_RCU=n, but there is no guarantee that
   this will be the case forever.

- interrupt disabled regions are equivalent to rcu_read_lock():

  Wrong again. RCU does not guarantee that.

  It's true for current mainline, but again this is an implementation
  detail and there is no guarantee by the RCU semantics.

  Indeed we want to get rid of that to avoid scalability issues on
  large systems and preempt-rt got already rid of it to a certain
  extent.

I'm sure we are lucky that CONFIG_TREE_PREEMPT_RCU=y is not yet wide
spread and the code pathes are esoteric enough not to trigger that
subtle races (some of them might just error out silently).

Nevertheless we need to fix all invalid assumptions about RCU
protection.

The following patch series fixes all yet known affected __task_cred()
sites, but there is more auditing of all other rcu users necessary.

Thanks,

	tglx

