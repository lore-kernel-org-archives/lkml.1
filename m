Return-Path: <linux-kernel-owner+w=401wt.eu-S1760360AbXEONCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760360AbXEONCj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 09:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754418AbXEONCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 09:02:32 -0400
Received: from mx10.go2.pl ([193.17.41.74]:52530 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753984AbXEONCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 09:02:32 -0400
Date: Tue, 15 May 2007 15:09:04 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Tejun Heo <htejun@gmail.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       David Chinner <dgc@sgi.com>, David Howells <dhowells@redhat.com>,
       Gautham Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make cancel_rearming_delayed_work() reliable
Message-ID: <20070515130904.GB3050@ff.dom.local>
References: <20070503204226.GA212@tv-sign.ru> <464475EB.3000408@gmail.com> <20070511134714.GA191@tv-sign.ru> <46448965.7070500@gmail.com> <20070511145345.GA240@tv-sign.ru> <4645559D.4050602@gmail.com> <20070513192753.GA3014@tv-sign.ru> <46477239.9030007@gmail.com> <20070514194446.GA159@tv-sign.ru> <46496EC1.3090109@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46496EC1.3090109@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2007 at 10:26:41AM +0200, Tejun Heo wrote:
> Oleg Nesterov wrote:
...
> > So, try_to_grab_pending() should check "VALID && pointers equal" atomically.
> > We can't do "if (VALID && cwq == get_wq_data(work))". We should do something
> > like this
> > 
> > 	(((long)cwq) | VALID | PENDING) == atomic_long_read(&work->data)
> > 
> > Yes? I need to think more about this.
> 
> I don't think the test for PENDING should be atomic too.  cwq pointer
> and VALID is one package.  PENDING lives its own life as a atomic bit
> switch.

Hi,

I've overheared somebody is talking about my favorite 2-nd bit!
Probably I miss many points (your talk isn't the most clear),
but I wonder if this bit couldn't be used otherwise: try_to_grab_
sets the bit - others know cancel is pending, so don't disturb:
e.g. insert_work doesn't queue (at least after works' cpu change,
which seems to be the main problem here). Probably there is
no reason to test this bit in all places - only in the most
problematic; so, in insert_work maybe only after checking
the cpu was changed. If this way is possible, we could avoid
setting the VALID bit when not needed (no cancel pending). Maybe
we could also think about some form of cooperation - e.g. clearing
of this or other bit to ack the work was catched - of course
this last thing could be too much, so not necessarily now.

Regards,
Jarek P.
