Return-Path: <linux-kernel-owner+w=401wt.eu-S1751444Ab0AGUHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444Ab0AGUHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 15:07:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750996Ab0AGUHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 15:07:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39393 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750887Ab0AGUHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 15:07:51 -0500
Date: Thu, 7 Jan 2010 12:06:48 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Peter Zijlstra <peterz@infradead.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
In-Reply-To: <20100107192035.GO6764@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.00.1001071204490.7821@localhost.localdomain>
References: <20100104182813.753545361@chello.nl> <20100105054536.44bf8002@infradead.org> <alpine.DEB.2.00.1001050916300.1074@router.home> <20100105192243.1d6b2213@infradead.org> <alpine.DEB.2.00.1001071007210.901@router.home> <alpine.LFD.2.00.1001070814080.7821@localhost.localdomain>
 <1262884960.4049.106.camel@laptop> <alpine.LFD.2.00.1001070934060.7821@localhost.localdomain> <alpine.LFD.2.00.1001070937180.7821@localhost.localdomain> <alpine.LFD.2.00.1001071031440.7821@localhost.localdomain> <20100107192035.GO6764@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Jan 2010, Paul E. McKenney wrote:
> > +
> > +	spin_lock(&mm->page_table_lock);
> > +	if (vma->vm_end == cur_brk) {
> > +		vma->vm_end = brk;
> > +		mm->brk = brk;
> > +		cur_brk = brk;
> > +	}
> > +	spin_unlock(&mm->page_table_lock);
> > +
> > +	if (cur_brk != brk)
> 
> Can this be "if (cur_brk < brk)"?  Seems like it should, given the
> earlier tests, but I don't claim to understand the VM code.

It's really just a flag, to test whether the final check (inside the 
spinlock) succeeded, or whether we perhaps raced with _another_ brk() call 
that also had the mm_sem for reading.

We know that cur_brk was different from brk before - because otherwise 
we'd have just returned early (or done the slow case). So testing whether 
it's different afterwards really only tests whether that 

	cur_brk = brk;

statment was executed or not.

I could have used a separate flag called "success" or something. 

		Linus
