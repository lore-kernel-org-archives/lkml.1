Return-Path: <linux-kernel-owner+w=401wt.eu-S1752508AbZLNObn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbZLNObn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 09:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbZLNObn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 09:31:43 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56204 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbZLNObm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 09:31:42 -0500
Subject: Re: [patch 0/9] Fix various __task_cred related invalid RCU
 assumptions
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, Al Viro <viro@zeniv.linux.org.uk>,
       James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20091214141607.GD7710@linux.vnet.ibm.com>
References: <20091210001308.247025548@linutronix.de>
	 <20091210022825.GG6938@linux.vnet.ibm.com>
	 <alpine.LFD.2.00.0912091914540.3560@localhost.localdomain>
	 <1260422031.4165.1.camel@twins> <20091210053457.GB6720@linux.vnet.ibm.com>
	 <1260730577.4165.7.camel@twins> <20091214015347.GB7710@linux.vnet.ibm.com>
	 <1260785859.4165.136.camel@twins>
	 <20091214141607.GD7710@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 14 Dec 2009 15:30:39 +0100
Message-ID: <1260801039.4165.323.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-14 at 06:16 -0800, Paul E. McKenney wrote:

> > I think you can use lock_is_held(&rcu_lock_map), except you need to deal
> > with the !debug_locks case, because lockdep stops once debug_locks
> > becomes false, which means lock_is_held() will return rubbish.
> 
> OK, so I need to do something like the following, then?
> 
> 	debug_locks ? lock_is_held(&rcu_lock_map) : 1

Depending on what the safe return value is, yeah. If you want an assert
like function, false is usually the safe one.

#define lockdep_assert_held(l)  WARN_ON(debug_locks && !lockdep_is_held(l))

is the one in-tree user of this.
