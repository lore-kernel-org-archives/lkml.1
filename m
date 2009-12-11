Return-Path: <linux-kernel-owner+w=401wt.eu-S932146AbZLKN7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146AbZLKN7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 08:59:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758228AbZLKN7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 08:59:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758222AbZLKN7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 08:59:42 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0912101545000.3089@localhost.localdomain>
References: <alpine.LFD.2.00.0912101545000.3089@localhost.localdomain> <20091210001308.247025548@linutronix.de> <20091210004703.269843657@linutronix.de> <20091210143435.GC8226@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: dhowells@redhat.com, Oleg Nesterov <oleg@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 7/9] signals: Fix more rcu assumptions
Date: Fri, 11 Dec 2009 13:59:04 +0000
Message-ID: <13656.1260539944@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> wrote:

> > Perhaps it is better to modify __sigqueue_alloc() instead? It can take
> > rcu_lock() around cred->user itself.
> 
> Indeed. Was too tired to see the obvious :)

Ah, but...  If __sigqueue_alloc() is called from sigqueue_alloc(), then you
don't need the RCU read lock as the target task is current.

So perhaps the callsite for __sigqueue_alloc() in __send_signal()?  That at
least puts the rcu_read_lock() call in proximity to the function that actually
needs it.

David
