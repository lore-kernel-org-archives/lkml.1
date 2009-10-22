Return-Path: <linux-kernel-owner+w=401wt.eu-S1753773AbZJVCDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbZJVCDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 22:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbZJVCDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 22:03:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35664 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753485AbZJVCDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 22:03:30 -0400
Date: Wed, 21 Oct 2009 19:00:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: john stultz <johnstul@us.ibm.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       lkml <linux-kernel@vger.kernel.org>, Mike Fulton <fultonm@ca.ibm.com>,
       Sean Foley <Sean_Foley@ca.ibm.com>, Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [RFC][PATCH] Add prctl to set sibling thread names
Message-Id: <20091021190028.623a7f6e.akpm@linux-foundation.org>
In-Reply-To: <1256172744.4768.22.camel@localhost.localdomain>
References: <1256167297.4768.14.camel@localhost.localdomain>
	<20091021174804.3885db37@infradead.org>
	<1256172744.4768.22.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Oct 2009 17:52:24 -0700 john stultz <johnstul@us.ibm.com> wrote:

> On Wed, 2009-10-21 at 17:48 -0700, Arjan van de Ven wrote:
> > On Wed, 21 Oct 2009 16:21:37 -0700
> > john stultz <johnstul@us.ibm.com> wrote:
> > 
> > > 
> > > Taking a very raw attempt at this, I scratched out the following
> > > simple implementation. I'd appreciate any review or suggestions for
> > > improvements. I'm not at all certain the passing of the thread pid_t
> > > through the unsigned long is valid, for instance, or if
> > > same_thread_group() is the right check to make sure we only change
> > > siblings and not tid from other processes. So any advice on better
> > > approaches would be great.
> > > 
> > > +				return -EINVAL;
> > > +
> > > +			set_task_comm(tsk, comm);
> > 
> > 
> > you're pretty much the first now who touches ->comm from
> > not-the-thread-itself.... are you sure that is safe?
> 
> No, I'm not sure at all :)
> 
> Thanks for pointing this out. I'll see whats needed in set_task_comm().
> 

set_task_comm() is OK.  The problem will be the unwritten rule that
processes can read *their own* ->comm without task_lock(), because nobody
ever alters ->comm apart from tack which owns it.

You've changed that, so all the open-coded accesses to current->comm are
now racy.

Also, you appear to be running set_task_comm() against a task_struct
without holding a reference on that task.  Will a well-timed exit() cause a
modify-after-free?


