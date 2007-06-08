Return-Path: <linux-kernel-owner+w=401wt.eu-S938655AbXFHTTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938655AbXFHTTb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 15:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750926AbXFHTTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 15:19:24 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:32806 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbXFHTTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 15:19:23 -0400
Subject: Re: [PATCH 1/3] [PATCH i386] during VM oom condition, kill all
	threads in process group
From: Will Schmidt <will_schmidt@vnet.ibm.com>
Reply-To: will_schmidt@vnet.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Blanchard <anton@samba.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
In-Reply-To: <20070607171018.d51fc5da.akpm@linux-foundation.org>
References: <20070605174831.21740.33119.stgit@farscape.rchland.ibm.com>
	 <20070607153459.2a1b3230.akpm@linux-foundation.org>
	 <20070607231621.GB32549@kryten>
	 <20070607171018.d51fc5da.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: IBM
Date: Fri, 08 Jun 2007 14:19:18 -0500
Message-Id: <1181330358.21409.31.camel@farscape.rchland.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-07 at 17:10 -0700, Andrew Morton wrote:
> On Thu, 7 Jun 2007 18:16:21 -0500
> Anton Blanchard <anton@samba.org> wrote:
> 
> >  
> > Hi,
> > 
> > > zap_other_threads() requires tasklist_lock.

Yup, I missed that.   Thanks for pointing it out.

> > > 
> > > If we're going to do this then we should probably create some new function
> > > (with a better name) which takes tasklsit_lock and then calls
> > > zap_other_threads().

I expect this will be a write_lock_irq() since zap_other_threads will be
doing a bit more than just reading the task info.

This will be down in a do-page-fault failure path (see
arch/*/mm/fault.c).  I wonder if calling write_lock is going to be safe,
or if its possible to get into a deadlock?  i.e. should I branch back up
to the survive: label if I can't take the lock?  Would that even be
sufficient? or is it not an issue here? 

> > > 
> > > Does this patch fix any observed-in-the-real-world problem?  If so, please
> > > describe it.
> > 
> > Yeah we have had complaints where threaded apps have only one thread
> > shot down instead of the entire process. This leaves the application in
> > a bad state, whereas if it had been killed cleanly the application could
> > have restarted.
> > 
> > My understanding is that fatal signals should kill all threads in the
> > group.
> > 
> 
> OK, well could we please get all that info appropriatelt captured in #2's
> changelog?
Yup, next spin I'll add more to the changelog. 

> 
> Other architectures will probably need to implement this.

-Will

