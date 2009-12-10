Return-Path: <linux-kernel-owner+w=401wt.eu-S1760368AbZLJFMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760368AbZLJFMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 00:12:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760343AbZLJFMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 00:12:39 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55510 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760336AbZLJFMh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 00:12:37 -0500
Subject: Re: [patch 0/9] Fix various __task_cred related invalid RCU
 assumptions
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, Al Viro <viro@zeniv.linux.org.uk>,
       James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0912091914540.3560@localhost.localdomain>
References: <20091210001308.247025548@linutronix.de>
	 <20091210022825.GG6938@linux.vnet.ibm.com>
	 <alpine.LFD.2.00.0912091914540.3560@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 10 Dec 2009 06:13:51 +0100
Message-ID: <1260422031.4165.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-09 at 19:15 -0800, Linus Torvalds wrote:
> 
> On Wed, 9 Dec 2009, Paul E. McKenney wrote:
> 
> > On Thu, Dec 10, 2009 at 12:52:46AM -0000, Thomas Gleixner wrote:
> > > While auditing the read_lock(&tasklist_lock) sites for a possible
> > > conversion to rcu-read_lock() I stumbled over an unprotected user of
> > > __task_cred in kernel/sys.c
> > > 
> > > That caused me to audit all the __task_cred usage sites except in
> > > kernel/exit.c.
> > > 
> > > Most of the usage sites are correct, but some of them trip over
> > > invalid assumptions about the protection which is given by RCU.
> > > 
> > > - spinlocked/preempt_disabled regions are equivalent to rcu_read_lock():
> > > 
> > >    That's wrong. RCU does not guarantee that. 
> > > 
> > >    It has been that way due to implementation details and it still is
> > >    valid for CONFIG_TREE_PREEMPT_RCU=n, but there is no guarantee that
> > >    this will be the case forever.
> > 
> > To back this up, item #2 from Documentation/RCU/checklist.txt says:
> 
> Hmm. This seems to be a difference that the tree-RCU things introduced, 
> no? I wonder if we have other areas where we just knew that a spinlock 
> would make an rcu read-lock unnecessary (which used to be true..)

That failed being true when we merged PREEMPT_RCU,.. which was a long
time ago.
