Return-Path: <linux-kernel-owner+w=401wt.eu-S1756581AbYFOAm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbYFOAm3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 20:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755867AbYFOAmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 20:42:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54030 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755815AbYFOAmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 20:42:20 -0400
Date: Sat, 14 Jun 2008 17:41:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, bunk@kernel.org,
       akpm@linux-foundation.org, protasnb@gmail.com
Subject: Re: 2.6.26-rc6-git2: Reported regressions from 2.6.25
In-Reply-To: <20080614.163129.80352314.davem@davemloft.net>
Message-ID: <alpine.LFD.1.10.0806141727390.2949@woody.linux-foundation.org>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik> <alpine.LFD.1.10.0806141423500.2949@woody.linux-foundation.org> <20080614.163129.80352314.davem@davemloft.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 14 Jun 2008, David Miller wrote:

> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Sat, 14 Jun 2008 14:42:05 -0700 (PDT)
> 
> > On Sat, 14 Jun 2008, Rafael J. Wysocki wrote:
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10908
> > > Subject		: IPF Montvale machine panic when running a network-relevent testing
> > > Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> > > Date		: 2008-06-13 8:19 (2 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=121334523711437&w=4
> > 
> > I think this got fixed by ec0a196626bd12e0ba108d7daa6d95a4fb25c2c5: "tcp: 
> > Revert 'process defer accept as established' changes".
> 
> No, this is looking like a different bug.

Are you sure? Because that revert seems to basically revert all changes 
since 2.6.25 in tcp_rcv_established(), which is the function that oopses. 
After that revert, the function is back to exactly what it used to be.

Of course, inlining makes it less obvious what other changes end up doing, 
but even the offset in the function (not quite at the very end of it, but 
not that far off that end either) matches where you'd expect that that 
'tcp_defer_accept_check()' thing used to be before the revert.

Also: see the report saying

  "As a matter of fact, kernel paniced at statement
   "queue->rskq_accept_tail->dl_next = req" in function reqsk_queue_add,
   because queue->rskq_accept_tail is NULL.  The call chain is:
   tcp_rcv_established => inet_csk_reqsk_queue_add => reqsk_queue_add."

and realize that that whole inet_csk_reqsk_queue_add() call only exists
in that tcp_defer_accept_check() thing that no longer exists.

IOW, I'm pretty damn sure that the bug entry above is very much a result
of the tcp_defer_accept_check() thing, and that commit ec0a196626 fixed
it by reverting it. 

> The behavior of that bug would not usually be a crash, but
> rather stuck connections, and I severely doubt anything in
> that specweb test setup is using the deferred-accept option
> which is a requirement for hitting those problems.

Hey, I might be wrong. But see above. I don't think I am. I think the 
deferred-accept was just even buggier than you believed.

But who knows. 

		Linus
