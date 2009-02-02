Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbZBBLcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbZBBLcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 06:32:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbZBBLcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 06:32:46 -0500
Received: from mu-out-0910.google.com ([209.85.134.187]:33685 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbZBBLcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 06:32:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nGCgtceoBEbPQUGL2fMA7czDgF2SUkG41DtWWfsumj8OjLKsfMrNhI4EHMyQCbYHdA
         Z5UUMsiksP9c1foSPIN2orWsdEnIrSaP2hqGyOgdqF5azcMgDfkrKiNIUUqy5EZiQ3Pb
         YqU6jW3d/k+rKU/L1DTr83OTCr9NsNmzBKEjg=
Date: Mon, 2 Feb 2009 12:32:36 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC][PATCH] create workqueue threads only when needed
Message-ID: <20090202113235.GB5757@nowhere>
References: <20090127001708.GA4815@nowhere> <20090126163015.7f879b18@infradead.org> <20090131180347.GC5884@nowhere> <20090131101502.7ce8e7af@infradead.org> <20090131182843.GD5884@nowhere> <1233524261.18767.60.camel@pasglop> <20090202022414.GA5006@nowhere> <1233554443.18767.71.camel@pasglop> <4986B205.2040807@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4986B205.2040807@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 02, 2009 at 09:42:45AM +0100, Stefan Richter wrote:
> Benjamin Herrenschmidt wrote:
> > On Mon, 2009-02-02 at 03:24 +0100, Frederic Weisbecker wrote:
> >> On Mon, Feb 02, 2009 at 08:37:41AM +1100, Benjamin Herrenschmidt wrote:
> >> > 
> >> > > I don't know, most of those I've looked on are not documented about the reason
> >> > > for a private workqueue. I guess most of them can use the usual kevent.
> 
> I rather suspect that the majority of private workqueues are there for
> good reasons.
> 
> >> > The main problem with kevent is that it gets clogged up.
> >> 
> >> I don't think so. Here is a snapshot of the workqueue tracer in my
> >> box currently:
> > 
> > That's not quite what I meant ... 
> > 
> > The main problem with keventd I'd say is that it's used in all sort of
> > exeptional code path (ie, driver reset path, error handling, etc...) for
> > things that will msleep happily for tenth milliseconds, that sort of
> > thing.
> > 
> > IE. It will be pretty responsive -in general- but can suffer form
> > horrible latencies every now and then.
> 
> Actually it /should/ be the other way around:
> 
> The shared workqueue should only be used for work that sleeps only
> briefly (perhaps with the exception of very unlikely longer sleeps e.g.
> for allocations that cause paging).
> 
> Work which /may/ sleep longer, for example performs SCSI transactions,
> needs to go into a private workqueue or other kind of context.


Right. But most of the time, these workqueues receive few events.
That's why async looks a good alternative for such cases. The threads
from async core which perform the jobs are created and destroyed on the fly,
depending on the number of jobs queued.

 
> OTOH you are right too; work which must not be deferred too long by work
> from another uncooperative/ unfair subsystem is probably also better off
> in an own workqueue...



Or callsites which use kevent and may sleep for too long could be identified
and fixed...


> Stefan Richter
> -=====-==--= --=- ---=-
> http://arcgraph.de/sr/

