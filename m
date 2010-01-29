Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480Ab0A2WNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab0A2WNE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 17:13:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338Ab0A2WNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 17:13:00 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:48133 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420Ab0A2WNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 17:13:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FS+UwQsbcOOXD3fSRaaPu/mIkwYXqVGKpAWF4VjhPzgOFSwiuKOW+y+GrtG/Y4V0HW
         +w0U/KsNSA1zMYRxCdu5RBfGKlCD0tyqDlic1F9t81YeXFcbavKPIy1GB5KYos+CBkaz
         kpAZ6RkS53Af/ZCw45yeM156icbeYewrTEhYs=
Date: Fri, 29 Jan 2010 23:12:54 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       tglx@linutronix.de, gregkh@suse.de
Subject: Re: [PATCH] Add type of locks to lock trace events
Message-ID: <20100129221252.GA5052@nowhere>
References: <1263799219.4283.0.camel@laptop> <1264485404-6410-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <1264674113.4283.2086.camel@laptop> <20100129172939.GD5047@nowhere> <1264786865.24455.22.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264786865.24455.22.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 06:41:05PM +0100, Peter Zijlstra wrote:
> Sure, never claimed otherwise, but:
>  1) if you're looking at lock behaviour you should also look at the code
>     otherwise you have no context to place the contention behaviour in.
> 
>  2) exactly because these hold/acquire times differ so much its hard to
>     mistake mistake them for anything else.
> 
> The concern I have is adding the storage (avoided by not doing it at
> init like you suggested) and the event size overhead. Jens' report
> confirms that we need to be very careful here, because lock sites are
> very high frequent.
> 
> So again, _why_? If you're looking at these things its easy (and I'd say
> rather crucial) to look up the code.
> 
> There simply is no point in looking at these stats if you're not also
> going to look at the code. If you're looking at them in a quick
> diagnostic way, then the difference against the baseline is important.



Ok, looking at the code is mandatory if you want to enter into any
detail. But before going into this step, you need a first glance, an
overview, unless you are targeting a very precise lock, in which case
you need to use filters and only trace this one.

Now say you want to find the locks in the kernel that are not fine
grained, taken for too long, in average or punctually, then mixing
up mutexes and spinlocks is not going to be helpful at all, quite
the opposite, you are going to miss very interesting things.

In this latter case you really want to separate by family of locks
so that you can immediately point out which lock is badly set up.

See? This is really a matter of overview, IMO this is required if
you want perf lock to be useful. And this is not going to bring any
overhead if we do that from lock init events.

So we can have one report for mutexes, one for spinlocks, one for
rwlocks (distinguishing read/write locks), etc...

We can even ask to report only spinlocks, mutexes, and that by filters.

