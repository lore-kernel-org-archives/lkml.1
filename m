Return-Path: <linux-kernel-owner+w=401wt.eu-S1757677AbZLKNxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677AbZLKNxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 08:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757855AbZLKNx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 08:53:28 -0500
Received: from www.tglx.de ([62.245.132.106]:37873 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757747AbZLKNx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 08:53:27 -0500
Date: Fri, 11 Dec 2009 14:52:10 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Howells <dhowells@redhat.com>
cc: Oleg Nesterov <oleg@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-security-module@vger.kernel.org
Subject: Re: [patch 1/9] sys: Fix missing rcu protection for __task_cred()
 access
In-Reply-To: <13183.1260539120@redhat.com>
Message-ID: <alpine.LFD.2.00.0912111449030.3089@localhost.localdomain>
References: <alpine.LFD.2.00.0912101542200.3089@localhost.localdomain> <20091210001308.247025548@linutronix.de> <20091210004703.029784964@linutronix.de> <20091210024324.GH6938@linux.vnet.ibm.com> <20091210142915.GB8226@redhat.com>
 <13183.1260539120@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Dec 2009, David Howells wrote:

> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > > > Or are there updates that are carried out without write-holding
> > > > tasklist_lock that I am missing?
> > > 
> > > Yes, commit_creds() is called lockless.
> > 
> > Right, and that's what the problem is. commit_creds(), which rcu frees
> > the old creds, does not take tasklist lock write lock.
> 
> commit_creds() does not need to hold a write lock, because it is implicitly
> write-locked by only being permitted to run in the thread to which it is
> committing.
> 
> I don't think commit_creds() needs to take the RCU read lock as no-one else
> can alter/delete the creds it is dealing with.

commit_cred() is not required to take anything, but the reader side
needs to take rcu_read_lock() when accessing __task_cred() of another
task as that task could update its own creds right at that point.

The point is that read_lock(tasklist_lock) is not sufficient for the
reader side.

Thanks,

	tglx
