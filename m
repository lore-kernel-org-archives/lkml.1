Return-Path: <linux-kernel-owner+w=401wt.eu-S1161510AbXDXCnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161510AbXDXCnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 22:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754560AbXDXCnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 22:43:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:33829 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562AbXDXCno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 22:43:44 -0400
Subject: Re: [PATCH] powerpc pseries eeh: Convert to kthread API
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linas Vepstas <linas@austin.ibm.com>,
       Christoph Hellwig <hch@infradead.org>, "<Andrew Morton" <akpm@osdl.org>,
       containers@lists.osdl.org, Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       linux-s390@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <m1ejmav80l.fsf@ebiederm.dsl.xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	 <11769695763104-git-send-email-ebiederm@xmission.com>
	 <20070422123155.GF20763@infradead.org>
	 <20070423205020.GR31947@austin.ibm.com>
	 <1177378733.14873.52.camel@localhost.localdomain>
	 <m1ejmav80l.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Tue, 24 Apr 2007 12:42:24 +1000
Message-Id: <1177382544.14873.57.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-23 at 20:08 -0600, Eric W. Biederman wrote:
> Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:
> 
> >> The only reason for using threads here is to get the error recovery
> >> out of an interrupt context (where errors may be detected), and then,
> >> an hour later, decrement a counter (which is how we limit these to 
> >> 6 per hour). Thread reaping is "trivial", the thread just exits
> >> after an hour.
> >
> > In addition, it should be a thread and not done from within keventd
> > because :
> >
> >  - It can take a long time (well, relatively but still too long for a
> > work queue)
> >
> >  - The driver callbacks might need to use keventd or do flush_workqueue
> > to synchronize with their own workqueues when doing an internal
> > recovery.
> >
> >> Since these are events rare, I've no particular concern about
> >> performance or resource consumption. The current code seems 
> >> to work just fine. :-)
> >
> > I think moving to kthread's is cleaner (just a wrapper around kernel
> > threads that simplify dealing with reaping them out mostly) and I agree
> > with Christoph that it would be nice to be able to "fire off" kthreads
> > from interrupt context.. in many cases, we abuse work queues for things
> > that should really done from kthreads instead (basically anything that
> > takes more than a couple hundred microsecs or so).
> 
> On that note does anyone have a problem is we manage the irq spawning
> safe kthreads the same way that we manage the work queue entries.
> 
> i.e. by a structure allocated by the caller?

Not sure... I can see places where I might want to spawn an arbitrary
number of these without having to preallocate structures... and if I
allocate on the fly, then I need a way to free that structure when the
kthread is reaped which I don't think we have currently, do we ? (In
fact, I could use that for other things too now that I'm thinking of
it ... I might have a go at providing optional kthread destructors).

Ben.


