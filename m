Return-Path: <linux-kernel-owner+w=401wt.eu-S1422777AbXDXRYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422777AbXDXRYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 13:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422780AbXDXRYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 13:24:52 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:38182 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422777AbXDXRYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 13:24:50 -0400
Date: Tue, 24 Apr 2007 12:24:48 -0500
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "<Andrew Morton" <akpm@osdl.org>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>, linux-s390@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] powerpc pseries eeh: Convert to kthread API
Message-ID: <20070424172448.GX31947@austin.ibm.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com> <11769695763104-git-send-email-ebiederm@xmission.com> <20070422123155.GF20763@infradead.org> <20070423205020.GR31947@austin.ibm.com> <1177378733.14873.52.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177378733.14873.52.camel@localhost.localdomain>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 11:38:53AM +1000, Benjamin Herrenschmidt wrote:
> > The only reason for using threads here is to get the error recovery
> > out of an interrupt context (where errors may be detected), and then,
> > an hour later, decrement a counter (which is how we limit these to 
> > 6 per hour). Thread reaping is "trivial", the thread just exits
> > after an hour.
> 
> In addition, it should be a thread and not done from within keventd
> because :
> 
>  - It can take a long time (well, relatively but still too long for a
> work queue)

Uhh, 15 or 20 seconds even. That's a long time by any kernel standard.

>  - The driver callbacks might need to use keventd or do flush_workqueue
> to synchronize with their own workqueues when doing an internal
> recovery.
> 
> > Since these are events rare, I've no particular concern about
> > performance or resource consumption. The current code seems 
> > to work just fine. :-)
> 
> I think moving to kthread's is cleaner (just a wrapper around kernel
> threads that simplify dealing with reaping them out mostly) and I agree
> with Christoph that it would be nice to be able to "fire off" kthreads
> from interrupt context.. in many cases, we abuse work queues for things
> that should really done from kthreads instead (basically anything that
> takes more than a couple hundred microsecs or so).

It would be nice to have threads that can be "fired off" from an
interrupt context.  That would simplify the EEH code slightly 
(removing a few dozen lines of code that do this bounce).

I presume that various device drivers might find this useful as well.

--linas

