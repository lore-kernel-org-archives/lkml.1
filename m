Return-Path: <linux-kernel-owner+w=401wt.eu-S1758442AbZFBDfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758442AbZFBDfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 23:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755077AbZFBDfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 23:35:40 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44895 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754754AbZFBDfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 23:35:39 -0400
Date: Mon, 1 Jun 2009 20:35:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: serge@hallyn.com, serue@us.ibm.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TOMOYO: Add garbage collector support. (v2)
Message-ID: <20090602033539.GA6846@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LRH.2.00.0905151146320.5937@tundra.namei.org> <200905162107.HCE17153.HLSFMtOOFVFOJQ@I-love.SAKURA.ne.jp> <200905250037.n4P0bFwe057503@www262.sakura.ne.jp> <200905250039.n4P0dSIE058041@www262.sakura.ne.jp> <200905250041.n4P0fVCT058575@www262.sakura.ne.jp> <200906012227.FDE64040.MVQLOStOHFOFFJ@I-love.SAKURA.ne.jp> <20090602001137.GA20880@hallyn.com> <200906020030.n520UU1D087893@www262.sakura.ne.jp> <20090602010349.GB20977@hallyn.com> <200906020116.n521GsHk097628@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906020116.n521GsHk097628@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 10:16:54AM +0900, Tetsuo Handa wrote:
> Serge E. Hallyn wrote:
> > All readers should walk the list under rcu_read_lock, so if the manage
> > to reach ->entry, then entry.list->next will be a valid entry on the live
> > list until the next rcu cycle.
> 
> I have to tell you one thing.
> Reader traverses the list via read(2) system call.
> It means that reader can't read all elements in the list within a single
> read(2) system call.
> Thus, reader grabs a reference on an element (i.e. p->entry.users) before
> leaving reader section and drops that reference after entering reader section.
> 
> Yes, it would be possible for readers to walk the list under rcu_read_lock(),
> but it is not sufficient for GC to simply call synchronize_rcu(). GC has to
> wait for p->entry.users to become 0 before modifying p->entry.list.next .

The usual approach would be for the code that causes p->entry.users
to become zero to do the list_del_rcu() and then pass the entry to
call_rcu().  Or execute synchronize_rcu() if blocking is permissible.

Of course, it is necessary to handle the race where one task decrements
the counter to zero while another increments it back up to 1.  One way to
handle this is to use atomic_inc_not_zero() when acquiring a reference,
thus refusing to acquire the reference if the count is already zero.
But your GC would need to handle this same race condition, so whatever
you were doing in that case should work here as well.

							Thanx, Paul

> > BTW I'm not telling you have to do this, so if you just don't want to, then
> > just say so.  But so long as you come back to me with technical reasons
> > why you can't, then I take it you're interested in a technical solution :)
> > and can't help but respond...
> 
> I see. I'll post only (1) and (2).
> 
> Thank you for your suggestion and time.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
