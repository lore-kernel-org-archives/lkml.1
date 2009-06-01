Return-Path: <linux-kernel-owner+w=401wt.eu-S1755038AbZFAQcC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbZFAQcC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 12:32:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753713AbZFAQbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 12:31:53 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:43644 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbZFAQbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 12:31:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IVoOx3olP11rPU7y66LGAuFXAbItHWN7SjeIMKozGRKW9XPfwUxrRHz8WXXSCmF4Wp
         E5Qfc5BXluRGFLqs7OHOujPaeF5Go+ruuIGDPGr+9Ep5xfKxYnFzrduyrTJ/HPKH/SqF
         1gGVN/dulsmmNBttL0NhPiSfTM34cC0y6aR7Q=
Date: Mon, 1 Jun 2009 18:31:50 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>
Subject: Re: [RFC PATCH 1/2] tracing/stat: introduce new hashlist mode
Message-ID: <20090601163149.GA5988@nowhere>
References: <1243834679-19132-1-git-send-email-fweisbec@gmail.com> <1243834679-19132-2-git-send-email-fweisbec@gmail.com> <4A2370E5.6000407@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2370E5.6000407@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 02:10:45PM +0800, Li Zefan wrote:
> Frederic Weisbecker wrote:
> > Until now, the stat tracing was only able to gather the pointers
> > to entries from a tracer, sort them and eventually pass these
> > pointers to the tracer output handler.
> > 
> > It has two drawbacks:
> > 
> > - if the tracer concurrently releases a pointer, this one may be
> >   dereference later in the output callback. There are ways to keep
> >   track of these pointers but it ends up with extra code from the
> >   tracers.
> > 
> > - the tracer has to handle its entries itself, through its own
> >   hashlist, list or whatever.
> > 
> 
> indeed
> 
> > This patch introduces a new mode for the stat tracers. Those can now
> > ask the tracing stat Api to handle their entries, which includes the
> > memory allocation, the access, the synchronization, the lookup, etc...
> > 
> > This is done through an internal hashlist that is built according
> > to the number and size of entries provided by the tracer.
> > 
> 
> But hashlist may not be suitable for all stat tracers?


Almost all of them.
More explanations below.


 
> > A tracer can choose between this new mode and the old one by using
> > the HASH_NODES flag in struct tracer_stat.
> > 
> 
> What's the advantages of the old mode towards this new mode?
> I think it's better to move all existing stat tracers to
> this new mode, and remove the old mode totally, if we want
> this new mode.



As an example the old mode should be kept for branch tracing
because it uses static variables access, which is totally
immediate access, necessary to trace each "if" :-)

There, the stat tracer only services the sorting feature.

But for most other stat tracers, the new hashlist is more suitable
instead of having multiple versions of hashlist or list...
So yes, the others should be converted to use this new mode.

Thanks.

> > Instead of providing a pair of iterator callbacks, they just need
> > to fill up the hlist_size and node_size fields.
> > 
> > Then using a unique id for each stat entries (usually a simple address
> > to a traced thing), they can access to an entry using the two new pairs:
> > 
> > - get_stat_entry() which retrieve the entry and locks it against
> >   concurrent updates
> > - put_stat_entry() which unlocks the entry
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  kernel/trace/trace_stat.c |  329 ++++++++++++++++++++++++++++++++++++++++++++-
> >  kernel/trace/trace_stat.h |   27 ++++-
> >  2 files changed, 353 insertions(+), 3 deletions(-)

