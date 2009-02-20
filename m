Return-Path: <linux-kernel-owner+w=401wt.eu-S1757435AbZBTBHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbZBTBHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 20:07:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbZBTBHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 20:07:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbZBTBHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 20:07:04 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: ebiederm@xmission.com (Eric W. Biederman)
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Andrew Morton <akpm@osdl.org>, daniel@hozac.com,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7][v8] SI_USER: Masquerade si_pid when crossing pid ns boundary
In-Reply-To: Eric W. Biederman's message of  Thursday, 19 February 2009 16:35:58 -0800 <m1bpsyt05t.fsf@fess.ebiederm.org>
References: <20090219030207.GA18783@us.ibm.com>
	<20090219030743.GG18990@us.ibm.com>
	<m1y6w21k6d.fsf@fess.ebiederm.org>
	<20090219185159.GA374@redhat.com>
	<m1fxiayss9.fsf@fess.ebiederm.org>
	<20090219223137.GA10378@redhat.com>
	<m1fxiaxbb5.fsf@fess.ebiederm.org>
	<20090219235159.6A542FC3BE@magilla.sf.frob.com>
	<m1bpsyt05t.fsf@fess.ebiederm.org>
Emacs: a compelling argument for pencil and paper.
Message-Id: <20090220010600.DCEA7FC2F7@magilla.sf.frob.com>
Date: Thu, 19 Feb 2009 17:06:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It is especially useful, and this is a deliberate feature.  

Ok, I thought that might be so.

> In practice I don't care about si_pid and I doubt I care about processes
> sending signals outside of their pid namespace.  But I do care about
> sharing a tty and a session and having job control work.

Understood.

> >> pid 10 should see si_pid 12.
> >> pid 11 should see si_pid 2.
> >
> > We indeed have this problem if we think it's useful to continue to have
> > a concept of pgrp for the sub-init that can see outside its own NS.
> >
> >> Neither should see si_pid 0, as from_ancestor_ns will not be true.
> >
> > Perhaps replace from_ancestor_ns with struct pid_namespace *sender_ns?
> > (I don't know if there was already a can of worms with such an idea before.)
> > Then si_pid could be translated as appropriate for each recipient.
> > (Or perhaps just struct pid *sender and reset si_pid from that.)
> 
> The last was my original line of thinking.  I seem to recall Oleg
> figuring the code gets pretty ugly when you add in the necessary test
> to see if si_pid is actually present.

Well, the existing test to set from_ancestor_ns is in one place and we
think that its logic is OK.  What I had in mind was that when that logic
says "0", we pass NULL and the innards don't touch .si_pid (same as now);
when it says "1", we pass a pointer and the innards do rewrite it.

> There are several other cases where we also signal a process outside
> of our current pid namespace, where we have a pid inside the recipients
> pid namespace.  do_notify_parent is the easiest example.

It's the only example that Oleg has mentioned.  What others are there?

> a) We pass in struct pid *sender and we reset si_pid in send_signal.
> b) We make the rule that send_signal must receive a valid siginfo from
>    the caller and we only do the extra work for process groups.

That's what I said. ;-) The a) option seems cleaner to me regardless, to
the extent that the "from_ancestor_ns" approach is a "clean" one.  But I
think it would be best to fully elucidate what we think about desireable
semantics for the whole spectrum of cross-NS signal-sending cases before
actually choosing the implementation details.


Thanks,
Roland
