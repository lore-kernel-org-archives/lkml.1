Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbZAHHvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbZAHHvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 02:51:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbZAHHuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 02:50:55 -0500
Received: from viefep15-int.chello.at ([62.179.121.35]:59211 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751638AbZAHHuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 02:50:54 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [git pull] scheduler fix
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0901071543550.3057@localhost.localdomain>
References: <20090107222641.GA27541@elte.hu>
	 <alpine.LFD.2.00.0901071543550.3057@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 08 Jan 2009 08:50:53 +0100
Message-Id: <1231401053.11687.386.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-07 at 15:47 -0800, Linus Torvalds wrote:
> 
> On Wed, 7 Jan 2009, Ingo Molnar wrote:
> > +		/*
> > +		 * Should not call ttwu while holding a rq->lock
> > +		 */
> > +		spin_unlock(&this_rq->lock);
> >  		if (active_balance)
> >  			wake_up_process(busiest->migration_thread);
> > +		spin_lock(&this_rq->lock);
> 
> Btw, this isn't the first time we've wanted to do a wakeup while 
> potentially locked.
> 
> Is there any way to perhaps go a "wake_up_gentle()" that doesn't need the 
> lock, and just basically does a potentially delayed wakeup by just 
> scheduling it asynchronously.
> 
> That would have solved all those nasty printk issues too. These kinds of 
> things don't need the strict "wake up NOW" behaviour - they are more of a 
> "kick the dang thing and make sure it wakes up in some timely manner".

Right -- so the printk thing was solved by polling some state from the
timer tick, we could make that into a list, but then you'd have to worry
about memory allocation for list elements failing etc.

Same story as generic smp function call, we could do this using a self
(or remote) IPI, but you'd still have the memory allocation issue -- and
would need to make self-IPI work on !SMP.

I'll ponder the issue a bit more, but I'm not directly seeing anything
(of course, if it were easy, we'd have done it ages ago ;-)

