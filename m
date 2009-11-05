Return-Path: <linux-kernel-owner+w=401wt.eu-S1754963AbZKEC0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963AbZKEC0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 21:26:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbZKEC0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 21:26:14 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59214 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbZKEC0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 21:26:13 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] Add prctl to set sibling thread names
Cc: kosaki.motohiro@jp.fujitsu.com, john stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
       Mike Fulton <fultonm@ca.ibm.com>, Sean Foley <Sean_Foley@ca.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>
In-Reply-To: <20091021190028.623a7f6e.akpm@linux-foundation.org>
References: <1256172744.4768.22.camel@localhost.localdomain> <20091021190028.623a7f6e.akpm@linux-foundation.org>
Message-Id: <20091105112303.208A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  5 Nov 2009 11:26:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 21 Oct 2009 17:52:24 -0700 john stultz <johnstul@us.ibm.com> wrote:
> 
> > On Wed, 2009-10-21 at 17:48 -0700, Arjan van de Ven wrote:
> > > On Wed, 21 Oct 2009 16:21:37 -0700
> > > john stultz <johnstul@us.ibm.com> wrote:
> > > 
> > > > 
> > > > Taking a very raw attempt at this, I scratched out the following
> > > > simple implementation. I'd appreciate any review or suggestions for
> > > > improvements. I'm not at all certain the passing of the thread pid_t
> > > > through the unsigned long is valid, for instance, or if
> > > > same_thread_group() is the right check to make sure we only change
> > > > siblings and not tid from other processes. So any advice on better
> > > > approaches would be great.
> > > > 
> > > > +				return -EINVAL;
> > > > +
> > > > +			set_task_comm(tsk, comm);
> > > 
> > > 
> > > you're pretty much the first now who touches ->comm from
> > > not-the-thread-itself.... are you sure that is safe?
> > 
> > No, I'm not sure at all :)
> > 
> > Thanks for pointing this out. I'll see whats needed in set_task_comm().
> > 
> 
> set_task_comm() is OK.  The problem will be the unwritten rule that
> processes can read *their own* ->comm without task_lock(), because nobody
> ever alters ->comm apart from tack which owns it.
> 
> You've changed that, so all the open-coded accesses to current->comm are
> now racy.
> 
> Also, you appear to be running set_task_comm() against a task_struct
> without holding a reference on that task.  Will a well-timed exit() cause a
> modify-after-free?

John, I'd prefer to suggested another design.
How about this?

1. remove pid argument from prctl
2. cancel pthread_setname_np()
3. instead, create pthread_attr_setname_np()
4. pthread_create() change own thread name by pthread_attr.


It avoid many racy problem automatically.



