Return-Path: <linux-kernel-owner+w=401wt.eu-S1761902AbZFXTnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761902AbZFXTnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 15:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761864AbZFXTm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 15:42:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761704AbZFXTm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 15:42:56 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Ratan Nalumasu <rnalumasu@gmail.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 2/2] change __wake_up_parent() to use filtered
	wakeup
In-Reply-To: Oleg Nesterov's message of  Wednesday, 24 June 2009 18:11:11 +0200 <20090624161111.GA27890@redhat.com>
References: <20090622170437.GA4906@redhat.com>
	<20090624091316.73D0F4059B@magilla.sf.frob.com>
	<20090624152143.GB23848@redhat.com>
	<20090624185701.AA74C4059B@magilla.sf.frob.com>
	<20090624161111.GA27890@redhat.com>
X-Zippy-Says: Yow!  I want to mail a bronzed artichoke to Nicaragua!
Message-Id: <20090624194239.A29174059B@magilla.sf.frob.com>
Date: Wed, 24 Jun 2009 12:42:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Agreed.  The not-right case I had in mind was do_notify_parent_cldstop
> > where maybe it could be ->real_parent of the untraced group_leader.
> 
> Hmm. Could you explain?
> 
> I feel I missed something, but can't understand.

Sorry, it wasn't very clear.  (I guess I should have said "traced group
leader", though that would not have been much more obvious.)

do_notify_parent_cldstop:

	if (task_ptrace(tsk))
		parent = tsk->parent;
	else {
		tsk = tsk->group_leader;
		parent = tsk->real_parent;
	}
	...
	__wake_up_parent(tsk, parent);

In the "else" case, parent is not necessarily tsk->parent.  That is, if
an untraced thread calls do_notify_parent_cldstop() but its group_leader
is ptrace_reparented().  Then waitee->group_leader->real_parent is who
gets the wakeup, but __wake_up_parent->child_wait_wakeup would check
only waiter == waitee->group_leader->parent.


Thanks,
Roland
